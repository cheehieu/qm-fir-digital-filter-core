/*
 * Copyright (c) 2001-2004 Swedish Institute of Computer Science.
 * All rights reserved. 
 * 
 * Redistribution and use in source and binary forms, with or without modification, 
 * are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 *    this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 * 3. The name of the author may not be used to endorse or promote products
 *    derived from this software without specific prior written permission. 
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR IMPLIED 
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF 
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT 
 * SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, 
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT 
 * OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING 
 * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY 
 * OF SUCH DAMAGE.
 *
 * This file is part of the lwIP TCP/IP stack.
 * 
 * Author: Adam Dunkels <adam@sics.se>
 *
 */

/*
 * Copyright (c) 2007, 2008 Xilinx, Inc.  All rights reserved.
 *
 * Xilinx, Inc.
 * XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS" AS A
 * COURTESY TO YOU.  BY PROVIDING THIS DESIGN, CODE, OR INFORMATION AS
 * ONE POSSIBLE   IMPLEMENTATION OF THIS FEATURE, APPLICATION OR
 * STANDARD, XILINX IS MAKING NO REPRESENTATION THAT THIS IMPLEMENTATION
 * IS FREE FROM ANY CLAIMS OF INFRINGEMENT, AND YOU ARE RESPONSIBLE
 * FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE FOR YOUR IMPLEMENTATION.
 * XILINX EXPRESSLY DISCLAIMS ANY WARRANTY WHATSOEVER WITH RESPECT TO
 * THE ADEQUACY OF THE IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO
 * ANY WARRANTIES OR REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE
 * FROM CLAIMS OF INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.
 *
 */

#include "lwipopts.h"

#if !NO_SYS
#include "xmk.h"
#include "sys/intr.h"
#endif

#include <stdio.h>
#include <string.h>

#include "lwip/opt.h"
#include "lwip/def.h"
#include "lwip/mem.h"
#include "lwip/pbuf.h"
#include "lwip/sys.h"
#include "lwip/stats.h"

#include "netif/etharp.h"
#include "netif/xadapter.h"
#include "netif/xemacliteif.h"

#include "netif/xpqueue.h"

#include "xparameters.h"
#include "xintc.h"

/* Define those to better describe your network interface. */
#define IFNAME0 'x'
#define IFNAME1 'e'

/* Forward declarations. */
static err_t xemacliteif_output(struct netif *netif, struct pbuf *p,
		struct ip_addr *ipaddr);

/* The payload from multiple pbufs is assembled into a single contiguous
 * area for transmission. Currently this is a global variable (it should really
 * belong in the per netif structure), but that is ok since this can be used
 * only in a protected context
 */
unsigned char xemac_tx_frame[XEL_MAX_FRAME_SIZE] __attribute__((aligned(64)));

static void
xemacif_recv_handler(void *arg) {
	struct xemac_s *xemac = (struct xemac_s *)(arg);
	xemacliteif_s *xemacliteif = (xemacliteif_s *)(xemac->state);
	XEmacLite *instance = xemacliteif->instance;
	struct pbuf *p;
	int len = 0;
	struct xtopology_t *xtopologyp = &xtopology[xemac->topology_index];

	XIntc_mAckIntr(xtopologyp->intc_baseaddr, 1 << xtopologyp->intc_emac_intr);
	p = pbuf_alloc(PBUF_RAW, XEL_MAX_FRAME_SIZE, PBUF_POOL);
	if (!p) {
#if LINK_STATS
		lwip_stats.link.memerr++;
		lwip_stats.link.drop++;
#endif       
		/* receive and just ignore the frame.
		 * we need to receive the frame because otherwise emaclite will
		 * not generate any other interrupts since it cannot receive, 
		 * and we do not actively poll the emaclite
		 */
		XEmacLite_Recv(instance, xemac_tx_frame);
		return;
	}

	/* receive the packet */
	len = XEmacLite_Recv(instance, p->payload);

	if (len == 0) {
#if LINK_STATS
		lwip_stats.link.drop++;
#endif       
		return;
	}

	/* store it in the receive queue, where it'll be processed by xemacif input thread */
	if (pq_enqueue(xemacliteif->recv_q, (void*)p) < 0) {
#if LINK_STATS
		lwip_stats.link.memerr++;
		lwip_stats.link.drop++;
#endif       
		return;
	}

#if !NO_SYS
	sys_sem_signal(xemac->sem_rx_data_available);
#endif

}

int transmit_packet(XEmacLite *instancep, void *packet, unsigned len)
{
	XStatus result = 0;

	/* there is space for a buffer, so transfer */
	result = XEmacLite_Send(instancep, packet, len);

        if (result != XST_SUCCESS) {
                return -1;
        }

	return 0;
}

/*
 * this function is always called with interrupts off
 * this function also assumes that there is space to send in the Emaclite buffer
 */
static err_t
_unbuffered_low_level_output(XEmacLite *instancep, struct pbuf *p)
{
	struct pbuf *q;
	int total_len = 0;

#if ETH_PAD_SIZE
	pbuf_header(p, -ETH_PAD_SIZE);			/* drop the padding word */
#endif

	for(q = p, total_len = 0; q != NULL; q = q->next) {
		/* Send the data from the pbuf to the interface, one pbuf at a
		   time. The size of the data in each pbuf is kept in the ->len
		   variable. */
		memcpy(xemac_tx_frame + total_len, q->payload, q->len);
		total_len += q->len;
	}

	if (transmit_packet(instancep, xemac_tx_frame, total_len) < 0) {
#if LINK_STATS
		lwip_stats.link.drop++;
#endif      
	}

#if ETH_PAD_SIZE
	pbuf_header(p, ETH_PAD_SIZE);			/* reclaim the padding word */
#endif

#if LINK_STATS
	lwip_stats.link.xmit++;
#endif /* LINK_STATS */      

	return ERR_OK;
}

/*
 * low_level_output():
 *
 * Should do the actual transmission of the packet. The packet is
 * contained in the pbuf that is passed to the function. This pbuf
 * might be chained.
 *
 */
static err_t
low_level_output(struct netif *netif, struct pbuf *p)
{
	SYS_ARCH_DECL_PROTECT(lev);
	struct xemac_s *xemac = (struct xemac_s *)(netif->state);
	xemacliteif_s *xemacliteif = (xemacliteif_s *)(xemac->state);
	XEmacLite *instance = xemacliteif->instance;
	struct pbuf *q;

	SYS_ARCH_PROTECT(lev);

	/* check if space is available to send */
        if (XEmacLite_TxBufferAvailable(instance) == XTRUE) {
		if (pq_qlength(xemacliteif->send_q)) {  	/* send backlog */
			_unbuffered_low_level_output(instance, (struct pbuf *)pq_dequeue(xemacliteif->send_q));
		} else { 				/* send current */
			_unbuffered_low_level_output(instance, p);
			SYS_ARCH_UNPROTECT(lev);
			return ERR_OK;
		}
	}

	/* if we cannot send the packet immediately, then make a copy of the whole packet
	 * into a separate pbuf and store it in send_q. We cannot enqueue the pbuf as is 
	 * since parts of the pbuf may be modified inside lwIP. 
	 */
	q = pbuf_alloc(PBUF_RAW, p->tot_len, PBUF_POOL);
	if (!q) {
#if LINK_STATS
		lwip_stats.link.drop++;
#endif      
		SYS_ARCH_UNPROTECT(lev);
		return ERR_MEM;
	}

	for (q->len = 0; p; p = p->next) {
		memcpy(q->payload + q->len, p->payload, p->len);
		q->len += p->len;
	}
	if (pq_enqueue(xemacliteif->send_q, (void *)q) < 0) {
#if LINK_STATS
		lwip_stats.link.drop++;
#endif      
		SYS_ARCH_UNPROTECT(lev);
		return ERR_MEM;
	}

	SYS_ARCH_UNPROTECT(lev);

	return ERR_OK;
}

static void
xemacif_send_handler(void *arg) {
	struct xemac_s *xemac = (struct xemac_s *)(arg);
	xemacliteif_s *xemacliteif = (xemacliteif_s *)(xemac->state);
	XEmacLite *instance = xemacliteif->instance;
	struct xtopology_t *xtopologyp = &xtopology[xemac->topology_index];

	XIntc_mAckIntr(xtopologyp->intc_baseaddr, 1 << xtopologyp->intc_emac_intr);

	if (pq_qlength(xemacliteif->send_q) && (XEmacLite_TxBufferAvailable(instance) == XTRUE)) {
		struct pbuf *p = pq_dequeue(xemacliteif->send_q);
		_unbuffered_low_level_output(instance, p);
		pbuf_free(p);
	}
}

/*
 * low_level_input():
 *
 * Should allocate a pbuf and transfer the bytes of the incoming
 * packet from the interface into the pbuf.
 *
 */
static struct pbuf *
low_level_input(struct netif *netif)
{
	struct xemac_s *xemac = (struct xemac_s *)(netif->state);
	xemacliteif_s *xemacliteif = (xemacliteif_s *)(xemac->state);

	/* see if there is data to process */
	if (pq_qlength(xemacliteif->recv_q) == 0)
		return NULL;

	/* return one packet from receive q */
	return (struct pbuf *)pq_dequeue(xemacliteif->recv_q);
}

/*
 * xemacliteif_output():
 *
 * This function is called by the TCP/IP stack when an IP packet
 * should be sent. It calls the function called low_level_output() to
 * do the actual transmission of the packet.
 *
 */

err_t
xemacliteif_output(struct netif *netif, struct pbuf *p,
		struct ip_addr *ipaddr)
{
	/* resolve hardware address, then send (or queue) packet */
	return etharp_output(netif, p, ipaddr);
}

/*
 * xemacliteif_input():
 *
 * This function should be called when a packet is ready to be read
 * from the interface. It uses the function low_level_input() that
 * should handle the actual reception of bytes from the network
 * interface.
 *
 * Returns the number of packets read (max 1 packet on success, 
 * 0 if there are no packets)
 *
 */
int
xemacliteif_input(struct netif *netif)
{
	struct eth_hdr *ethhdr;
	struct pbuf *p;
	SYS_ARCH_DECL_PROTECT(lev);

	/* move received packet into a new pbuf */
	SYS_ARCH_PROTECT(lev);
	p = low_level_input(netif);
	SYS_ARCH_UNPROTECT(lev);

	/* no packet could be read, silently ignore this */
	if (p == NULL) 
		return 0;

	/* points to packet payload, which starts with an Ethernet header */
	ethhdr = p->payload;

#if LINK_STATS
	lwip_stats.link.recv++;
#endif /* LINK_STATS */

	switch (htons(ethhdr->type)) {
		/* IP or ARP packet? */
		case ETHTYPE_IP:
		case ETHTYPE_ARP:
#if PPPOE_SUPPORT
			/* PPPoE packet? */
		case ETHTYPE_PPPOEDISC:
		case ETHTYPE_PPPOE:
#endif /* PPPOE_SUPPORT */
			/* full packet send to tcpip_thread to process */
			if (netif->input(p, netif) != ERR_OK) { 
				LWIP_DEBUGF(NETIF_DEBUG, ("xlltemacif_input: IP input error\n"));
				pbuf_free(p);
				p = NULL;
			}
			break;

		default:
			pbuf_free(p);
			p = NULL;
			break;
	}
	
	return 1;
}

#if !NO_SYS
static void
arp_timer(void *arg)
{
	etharp_tmr();
	sys_timeout(ARP_TMR_INTERVAL, arp_timer, NULL);
}
#endif

static XEmacLite_Config *
xemaclite_lookup_config(unsigned base)
{
	XEmacLite_Config *CfgPtr = NULL;
	int i;

	for (i = 0; i < XPAR_XEMACLITE_NUM_INSTANCES; i++)
		if (XEmacLite_ConfigTable[i].BaseAddress == base) {
			CfgPtr = &XEmacLite_ConfigTable[i];
			break;
		}

	return CfgPtr;
}

static err_t
low_level_init(struct netif *netif)
{
	struct xemac_s *xemac;
	XEmacLite_Config *config;
	XEmacLite *xemaclitep;
	struct xtopology_t *xtopologyp;
	xemacliteif_s *xemacliteif;

	xemaclitep = mem_malloc(sizeof *xemaclitep);
	if (xemaclitep == NULL) {
		LWIP_DEBUGF(NETIF_DEBUG, ("xemacliteif_init: out of memory\n"));
		return ERR_MEM;
	}

	xemac = mem_malloc(sizeof *xemac);
	if (xemac == NULL) {
		LWIP_DEBUGF(NETIF_DEBUG, ("xemacliteif_init: out of memory\n"));
		return ERR_MEM;
	}

	xemacliteif = mem_malloc(sizeof *xemacliteif);
	if (xemac == NULL) {
		LWIP_DEBUGF(NETIF_DEBUG, ("xemacliteif_init: out of memory\n"));
		return ERR_MEM;
	}

	/* obtain pointer to topology structure for this emac */
	xemac->topology_index = xtopology_find_index((unsigned)(netif->state));
	xtopologyp = &xtopology[xemac->topology_index];

	/* obtain config of this emaclite */
	config = xemaclite_lookup_config((unsigned)(netif->state));

	/* maximum transfer unit */
	netif->mtu = XEL_MTU_SIZE;

	/* broadcast capability */
	netif->flags = NETIF_FLAG_BROADCAST | NETIF_FLAG_ETHARP | NETIF_FLAG_LINK_UP;

	/* initialize the mac */
	XEmacLite_Initialize(xemaclitep, config->DeviceId);
	xemaclitep->NextRxBufferToUse = 0;

#if NO_SYS
	XIntc_RegisterHandler(xtopologyp->intc_baseaddr,
			xtopologyp->intc_emac_intr,
			(XInterruptHandler)XEmacLite_InterruptHandler,
			xemaclitep);
#else
#include "xmk.h"
	register_int_handler(xtopologyp->intc_emac_intr,
			(XInterruptHandler)XEmacLite_InterruptHandler,
			xemaclitep);
	enable_interrupt(xtopologyp->intc_emac_intr);
#endif

	/* set mac address */
	XEmacLite_SetMacAddress(xemaclitep, (Xuint8*)(netif->hwaddr));

	/* flush any frames already received */
	XEmacLite_FlushReceive(xemaclitep);

	/* set Rx, Tx interrupt handlers */
	XEmacLite_SetRecvHandler(xemaclitep, (void *)(xemac), xemacif_recv_handler);
	XEmacLite_SetSendHandler(xemaclitep, (void *)(xemac), xemacif_send_handler);

	/* enable Rx, Tx interrupts */
    	XEmacLite_EnableInterrupts(xemaclitep);

#if !NO_SYS
	xemac->sem_rx_data_available = sys_sem_new(0);
#endif

	/* replace the state in netif (currently the base address of emaclite) 
	 * with the xemacliteif instance pointer.
	 * this contains a pointer to the config table entry 
	 */
	xemac->type = xemac_type_xps_emaclite;
	xemac->state = (void *)xemacliteif;
	netif->state = (void *)xemac;

	xemacliteif->instance = xemaclitep;
	xemacliteif->recv_q = pq_create_queue();
	if (!xemacliteif->recv_q) 
		return ERR_MEM;

	xemacliteif->send_q = pq_create_queue();
	if (!xemacliteif->send_q) 
		return ERR_MEM;

	return ERR_OK;
}

/*
 * xemacliteif_init():
 *
 * Should be called at the beginning of the program to set up the
 * network interface. It calls the function low_level_init() to do the
 * actual setup of the hardware.
 *
 */

err_t
xemacliteif_init(struct netif *netif)
{
#if LWIP_SNMP
	/* ifType ethernetCsmacd(6) @see RFC1213 */
	netif->link_type = 6;
	/* your link speed here */
	netif->link_speed = ;
	netif->ts = 0;
	netif->ifinoctets = 0;
	netif->ifinucastpkts = 0;
	netif->ifinnucastpkts = 0;
	netif->ifindiscards = 0;
	netif->ifoutoctets = 0;
	netif->ifoutucastpkts = 0;
	netif->ifoutnucastpkts = 0;
	netif->ifoutdiscards = 0;
#endif

	netif->name[0] = IFNAME0;
	netif->name[1] = IFNAME1;
	netif->output = xemacliteif_output;
	netif->linkoutput = low_level_output;

	low_level_init(netif);

#if !NO_SYS
	sys_timeout(ARP_TMR_INTERVAL, arp_timer, NULL);
#endif

	return ERR_OK;
}

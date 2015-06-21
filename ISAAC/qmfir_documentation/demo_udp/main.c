/******************************************************************************
* File: main.c
* $Rev: 5 $
* $Author: dbekker $
* $Date: 2009-02-25 10:14:36 -0800 (Wed, 25 Feb 2009) $
*
* Target: ML507 (based on V5FX70T) when XPAR_CPU_PPC440_CORE_CLOCK_FREQ_HZ
*         ML410 (based on V4FX60) otherwise
*
* Top level QMFIR control source. Performs system setup.
* Derived from Xilinx sample application (see original header below)
*
*******************************************************************************
*
* Copyright (c) 2007 Xilinx, Inc.  All rights reserved.
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
******************************************************************************/

#include "xenv_standalone.h"  /* processor-specific environment definition */
#include "xparameters.h"      /* system-specific environment definition */
#include "int_setup.h"        /* interrupt setup */
#include "qmfir_comm.h"       /* network interface to QMFIR core */
#include "netif/xadapter.h"   /* lwip network interface definition */

/* define the base address of the ethernet core */
#define EMAC_BASEADDR XPAR_LLTEMAC_0_BASEADDR

/* define the cache regions (256 MB) */
#define INSTR_CACHE 0xC0000000
#define DATA_CACHE 0xC0000000

/* local function prototypes */
void print_ip( char *, struct ip_addr * );
void print_ip_settings( struct ip_addr *, struct ip_addr *, struct ip_addr * );
void print_app_header();

/******************************************************************************
* Name:        print_ip
* Description: Prints network address information to standard output
* 
* Arguments:   char *msg           - the message to print
*              struct ip_addr *ip  - the IP address to print
******************************************************************************/
void print_ip( char *msg, struct ip_addr *ip ) {

   xil_printf( msg );
   xil_printf( "%d.%d.%d.%d\n\r", ip4_addr1(ip), ip4_addr2(ip), 
               ip4_addr3(ip), ip4_addr4(ip) );
               
} /* print_ip */

/******************************************************************************
* Name:        print_ip_settings
* Description: Prints network settings information to standard output
* 
* Arguments:   struct ip_addr *ip   - the IP address to print
*              struct ip_addr *mask - the netmask to print
*              struct ip_addr *gw   - the gateway to print
******************************************************************************/
void print_ip_settings( struct ip_addr *ip, struct ip_addr *mask,
                        struct ip_addr *gw ) {

   print_ip("Board IP: ", ip);
   print_ip("Netmask : ", mask);
   print_ip("Gateway : ", gw);
   
} /* print_ip_settings */

/******************************************************************************
* Name:        print_app_header
* Description: Prints application header to standard output
******************************************************************************/
void print_app_header() {
    
   xil_printf("\n\r\n\r------ QMFIR Control Program -------\n\r");
   xil_printf(        "** Host should have IP 192.168.1.104 **\n\r");

} /* print_app_header */

/******************************************************************************
* Name:        main
* Description: Program entry point
* 
* Returns:     int   - returns 0 if no errors
******************************************************************************/
int main() {

   /* declare a network interface and network addresses */
   struct netif *netif, server_netif;  
   struct ip_addr ipaddr, netmask, gw;

   /* specify a unique MAC address for the board */
   #ifdef XPAR_CPU_PPC440_CORE_CLOCK_FREQ_HZ    /* set MAC on ML507 board */
   unsigned char mac_ethernet_address[] = {0x00, 0x0a, 0x35, 0x01, 0xC9, 0x76};
   #else                                        /* set MAC on ML410 board */
   unsigned char mac_ethernet_address[] = {0x00, 0x0a, 0x35, 0x01, 0x9A, 0xFE};
   #endif

   /* set the network interface pointer */
   netif = &server_netif;

   /* enable caches */
   XCache_EnableICache( INSTR_CACHE );
   XCache_EnableDCache( DATA_CACHE );

   /* setup interrupts */
   setup_interrupts();

   /* initliaze network addresses to be used */
   IP4_ADDR( &ipaddr,  192, 168,  1, 15 );
   IP4_ADDR( &netmask, 255, 255, 255, 0 );
   IP4_ADDR( &gw,      192, 168,  1,  1 );

   /* print the application header and IP settings */
   print_app_header();
   print_ip_settings(&ipaddr, &netmask, &gw);

   /* initialize lwip */
   lwip_init();

   /* add network interface to the netif_list, and set it as default */
   if( !xemac_add( netif, &ipaddr, &netmask, &gw,
                   mac_ethernet_address, EMAC_BASEADDR ) ) {
      xil_printf( "Error adding N/W interface\n\r" );
      return -1;
   }
   netif_set_default( netif );

   /* now enable interrupts */
   enable_interrupts();

   /* specify that the network if is up */
   netif_set_up( netif );

   /* start the application */
   start_application();
   
   /* print debug header if debug mode set */
   #ifdef QMFIR_DEBUG
   debug_menu();
	while( 1) {
		qmfir_debug();
	}
   #endif   

   /* receive and process packets */
   while( 1 ) {
      xemacif_input( netif );
   }

   /* disable caches */
   XCache_DisableDCache();
   XCache_DisableICache();

   return 0;

} /* main */

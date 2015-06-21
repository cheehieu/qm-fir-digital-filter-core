/* Id: */
/******************************************************************************
*
*       XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"
*       AS A COURTESY TO YOU, SOLELY FOR USE IN DEVELOPING PROGRAMS AND
*       SOLUTIONS FOR XILINX DEVICES.  BY PROVIDING THIS DESIGN, CODE,
*       OR INFORMATION AS ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,
*       APPLICATION OR STANDARD, XILINX IS MAKING NO REPRESENTATION
*       THAT THIS IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT,
*       AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE
*       FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY DISCLAIMS ANY
*       WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE
*       IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR
*       REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF
*       INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
*       FOR A PARTICULAR PURPOSE.
*
*       (c) Copyright 2004-2008 Xilinx Inc.
*       All rights reserved.
*
******************************************************************************/

/*****************************************************************************/
/**
 *
 * @file xlltemac_hw.h
 *
 * This header file contains identifiers and low-level driver functions (or
 * macros) that can be used to access the Tri-Mode MAC Ethernet (TEMAC) device.
 * High-level driver functions are defined in xlltemac.h.
 *
 * @note
 *
 * Some registers are not accessible when a HW instance is configured for SGDMA.
 *
 * <pre>
 * MODIFICATION HISTORY:
 *
 * Ver   Who  Date     Changes
 * ----- ---- -------- -------------------------------------------------------
 * 1.00a jvb  11/10/06 First release
 * 1.00b drg  02/08/08 Added MGT constant to the interrupt bits
 * 2.00a wsy  08/08/08 Add extended VLAN and multicast features
 * </pre>
 *
 ******************************************************************************/

#ifndef XTEMAC_HW_H		/* prevent circular inclusions */
#define XTEMAC_HW_H		/* by using protection macros */

/***************************** Include Files *********************************/

#include "xbasic_types.h"
#include "xio.h"
#include "xdebug.h"

#ifdef __cplusplus
extern "C" {
#endif

/************************** Constant Definitions *****************************/

#define XTE_RESET_HARD_DELAY_US 4    /**< Us to delay for hard core reset */

/* Register offset definitions. Unless otherwise noted, register access is
 * 32 bit.
 */

/** @name Direct registers
 *  @{
 */
#define XTE_RAF_OFFSET   0x00000000  /**< Reset and address filter */
#define XTE_TPF_OFFSET   0x00000004  /**< Transmit pause frame */
#define XTE_IFGP_OFFSET  0x00000008  /**< Transmit inter-frame gap adjustment */
#define XTE_IS_OFFSET    0x0000000C  /**< Interrupt status */
#define XTE_IP_OFFSET    0x00000010  /**< Interrupt pending */
#define XTE_IE_OFFSET    0x00000014  /**< Interrupt enable */
#define XTE_TTAG_OFFSET  0x00000018  /**< Tx VLAN TAG */
#define XTE_RTAG_OFFSET  0x0000001C  /**< Rx VLAN TAG */
#define XTE_MSW_OFFSET   0x00000020  /**< Most significant word data */
#define XTE_LSW_OFFSET   0x00000024  /**< Least significant word data */
#define XTE_CTL_OFFSET   0x00000028  /**< Control */
#define XTE_RDY_OFFSET   0x0000002C  /**< Ready status */
#define XTE_UAWL_OFFSET  0x00000030  /**< Unicast address, extended/new multicast mode */
#define XTE_UAWU_OFFSET  0x00000034  /**< Unicast address, extended/new multicast mode */
#define XTE_TPID0_OFFSET 0x00000038  /**< TPID0 register */
#define XTE_TPID1_OFFSET 0x0000003C  /**< TPID1 register */

#define XTE_TXBL_OFFSET  0x00000200 /**< Bytes count of transmitted frames, least significant word */
#define XTE_TXBU_OFFSET  0x00000204 /**< Bytes count of transmitted frames, most significant word */
#define XTE_RXBL_OFFSET  0x00000208 /**< Bytes count of received frames, least significant word */
#define XTE_RXBU_OFFSET  0x0000020C /**< Bytes count of received frames, most significant word */
#define XTE_RXUNDRL_OFFSET 0x00000210 /**< Frames count of undersize(less than
					*  64 bytes) frames received, least
					*  significant word */
#define XTE_RXUNDRU_OFFSET 0x00000214 /**< Frames count of undersize(less than
					*  64 bytes) frames received, most
					*  significant word */
#define XTE_RXFRAGL_OFFSET 0x00000218 /**< Frames count of undersized(less than
					*  64 bytes) and bad FCS frames
					*  received, least significant word */
#define XTE_RXFRAGU_OFFSET 0x0000021C /**< Frames count of undersized(less than
					*  64 bytes) and bad FCS frames
					*  received, most significant word */
#define XTE_RX64BL_OFFSET 0x00000220 /**< Frames count of 64 bytes frames
				       * received, least significant word */
#define XTE_RX64BU_OFFSET 0x00000224 /**< Frames count of 64 bytes frames
				       * received, most significant word */
#define XTE_RX65B127L_OFFSET 0x00000228 /**< Frames count of 65-127 bytes
					  *  frames received, least significant
					  *  word */
#define XTE_RX65B127U_OFFSET 0x0000022C /**< Frames count of 65-127 bytes
					  *  frames received, most significant
					  *  word */
#define XTE_RX128B255L_OFFSET 0x00000230 /**< Frames count of 128-255 bytes
					   *  frames received, least
					   *  significant word */
#define XTE_RX128B255U_OFFSET 0x00000234 /**< Frames count of 128-255 bytes
					   *  frames received, most significant
					   *  word */
#define XTE_RX256B511L_OFFSET 0x00000238 /**< Frames count of 256-511 bytes
					   *  frames received, least
					   *  significant word */
#define XTE_RX256B511U_OFFSET 0x0000023C /**< Frames count of 256-511 bytes
					   *  frames received, most significant
					   *  word */
#define XTE_RX512B1023L_OFFSET 0x00000240 /**< Frames count of 512-1023 bytes
					   *   frames received, least
					   *   significant word */
#define XTE_RX512B1023U_OFFSET 0x00000244 /**< Frames count of 512-1023 bytes
					   *   frames received, most
					   *   significant word */
#define XTE_RX1024BL_OFFSET 0x00000248 /**< Frames count of 1024-MAX bytes
					 *  frames received, least significant
					 *  word */
#define XTE_RX1024BU_OFFSET 0x0000024C /**< Frames count of 1024-MAX bytes
					 *  frames received, most significant
					 *  word */
#define XTE_RXOVRL_OFFSET 0x00000250 /**< Frames count of oversize frames
				       *  received, least significant word */
#define XTE_RXOVRU_OFFSET 0x00000254 /**< Frames count of oversize frames
				       *  received, most significant word */
#define XTE_TX64BL_OFFSET 0x00000258 /**< Frames count of 64 bytes frames
				       *  transmitted, least significant word */
#define XTE_TX64BU_OFFSET 0x0000025C /**< Frames count of 64 bytes frames
				       *  transmitted, most significant word */
#define XTE_TX65B127L_OFFSET 0x00000260 /**< Frames count of 65-127 bytes
					  *  frames transmitted, least
					  *  significant word */
#define XTE_TX65B127U_OFFSET 0x00000264 /**< Frames count of 65-127 bytes
					  *  frames transmitted, most
					  *  significant word */
#define XTE_TX128B255L_OFFSET 0x00000268 /**< Frames count of 128-255 bytes
					   *  frames transmitted, least
					   *  significant word */
#define XTE_TX128B255U_OFFSET 0x0000026C /**< Frames count of 128-255 bytes
					   *  frames transmitted, most
					   *  significant word */
#define XTE_TX256B511L_OFFSET 0x00000270 /**< Frames count of 256-511 bytes
					   *  frames transmittereceived, least
					   *  significant word */
#define XTE_TX256B511U_OFFSET 0x00000274 /**< Frames count of 256-511 bytes
					   *  frames transmitted, most
					   *  significant word */
#define XTE_TX512B1023L_OFFSET 0x00000278 /**< Frames count of 512-1023 bytes
					    *  frames transmitted, least
					    *  significant word */
#define XTE_TX512B1023U_OFFSET 0x0000027C /**< Frames count of 512-1023 bytes
					    *  frames transmitted, most
					    *  significant word */
#define XTE_TX1024L_OFFSET 0x00000280 /**< Frames count of 1024-MAX bytes
					*  frames transmitted, least
					*  significant word */
#define XTE_TX1024U_OFFSET 0x00000284 /**< Frames count of 1024-MAX bytes
					*  frames transmitted, most significant
					*  word */
#define XTE_TXOVRL_OFFSET 0x00000288 /**< Frames count of oversize frames
				       *  transmitted, least significant word */
#define XTE_TXOVRU_OFFSET 0x0000028C /**< Frames count of oversize frames
				       *  transmitted, most significant word */
#define XTE_RXFL_OFFSET 0x00000290 /**< Frames count of frames received OK,
				     *  least significant word */
#define XTE_RXFU_OFFSET 0x00000294 /**< Frames count of frames received OK,
				     *  most significant word */
#define XTE_RXFCSERL_OFFSET 0x00000298 /**< Frames count of frames received FCS
					 *  error and at least 64 bytes, least
					 *  significant word */
#define XTE_RXFCSERU_OFFSET 0x0000029C /**< Frames count of frames received FCS
					 *  error and at least 64 bytes, most
					 *  significant word */
#define XTE_RXBCSTFL_OFFSET 0x000002A0 /**< Frames count of broadcast frames
					 *  received, least significant word */
#define XTE_RXBCSTFU_OFFSET 0x000002A4 /**< Frames count of broadcast frames
					 *  received, most significant word */
#define XTE_RXMCSTFL_OFFSET 0x000002A8 /**< Frames count of multicast frames
					 *  received, least significant word */
#define XTE_RXMCSTFU_OFFSET 0x000002AC /**< Frames count of multicast frames
					 *  received, most significant word */
#define XTE_RXCTRFL_OFFSET 0x000002B0 /**< Frames count of control frames
					*  received, least significant word */
#define XTE_RXCTRFU_OFFSET 0x000002B4 /**< Frames count of control frames
					*  received, most significant word */
#define XTE_RXLTERL_OFFSET 0x000002B8 /**< Frames count of frames received with
					*  length error, least significant word */
#define XTE_RXLTERU_OFFSET 0x000002BC /**< Frames count of frames received with
					*  length error, most significant word */
#define XTE_RXVLANFL_OFFSET 0x000002C0 /**< Frames count of VLAN tagged frames
					 *  received, least significant word */
#define XTE_RXVLANFU_OFFSET 0x000002C4 /**< Frames count of VLAN tagged frames
					 *  received, most significant word */
#define XTE_RXPFL_OFFSET 0x000002C8 /**< Frames count of pause frames received,
				      *  least significant word */
#define XTE_RXPFU_OFFSET 0x000002CC /**< Frames count of pause frames received,
				      *  most significant word */
#define XTE_RXUOPFL_OFFSET 0x000002D0 /**< Frames count of control frames
					*  received with unsupported opcode,
					*  least significant word */
#define XTE_RXUOPFU_OFFSET 0x000002D4 /**< Frames count of control frames
					*  received with unsupported opcode,
					*  most significant word */
#define XTE_TXFL_OFFSET 0x000002D8 /**< Frames count of frames transmitted OK,
				     *  least significant word */
#define XTE_TXFU_OFFSET 0x000002DC /**< Frames count of frames transmitted OK,
				     *  most significant word */
#define XTE_TXBCSTFL_OFFSET 0x000002E0 /**< Frames count of broadcast frames
					 *  transmitted, least significant word */
#define XTE_TXBCSTFU_OFFSET 0x000002E4 /**< Frames count of broadcast frames
					 *  transmitted, most significant word */
#define XTE_TXMCSTFL_OFFSET 0x000002E8 /**< Frames count of multicast frames
					 *  transmitted, least significant word */
#define XTE_TXMCSTFU_OFFSET 0x000002EC /**< Frames count of multicast frames
					 *  transmitted, most significant word */
#define XTE_TXUNDRERL_OFFSET 0x000002F0 /**< Frames count of frames transmitted
					  *  underrun error, least significant
					  *  word */
#define XTE_TXUNDRERU_OFFSET 0x000002F4 /**< Frames count of frames transmitted
					  *  underrun error, most significant
					  *  word */
#define XTE_TXCTRFL_OFFSET 0x000002F8 /**< Frames count of control frames
					*  transmitted, least significant word */
#define XTE_TXCTRFU_OFFSET 0x000002FC /**< Frames count of control frames
					*  transmitted, most significant word */
#define XTE_TXVLANFL_OFFSET 0x00000300 /**< Frames count of VLAN tagged frames
					 *  transmitted, least significant word */
#define XTE_TXVLANFU_OFFSET 0x00000304 /**< Frames count of VLAN tagged frames
					 *  transmitted, most significant word */
#define XTE_TXPFL_OFFSET 0x00000308 /**< Frames count of pause frames
				      *  transmitted, least significant word */
#define XTE_TXPFU_OFFSET 0x0000030C /**< Frames count of pause frames
				      *  transmitted, most significant word */

/*@}*/


/** @name HARD_TEMAC Core Registers
 * These are registers defined within the device's hard core located in the
 * processor block. They are accessed indirectly through the registers, MSW,
 * LSW, and CTL.
 *
 * Access to these registers should go through macros XLlTemac_ReadIndirectReg()
 * and XLlTemac_WriteIndirectReg() to guarantee proper access.
 * @{
 */
#define XTE_RCW0_OFFSET         0x00000200  /**< Rx configuration word 0 */
#define XTE_RCW1_OFFSET         0x00000240  /**< Rx configuration word 1 */
#define XTE_TC_OFFSET           0x00000280  /**< Tx configuration */
#define XTE_FCC_OFFSET          0x000002C0  /**< Flow control configuration */
#define XTE_EMMC_OFFSET         0x00000300  /**< EMAC mode configuration */
#define XTE_PHYC_OFFSET         0x00000320  /**< RGMII/SGMII configuration */
#define XTE_MC_OFFSET           0x00000340  /**< Management configuration */
#define XTE_UAW0_OFFSET         0x00000380  /**< Unicast address word 0 */
#define XTE_UAW1_OFFSET         0x00000384  /**< Unicast address word 1 */
#define XTE_MAW0_OFFSET         0x00000388  /**< Multicast address word 0 */
#define XTE_MAW1_OFFSET         0x0000038C  /**< Multicast address word 1 */
#define XTE_AFM_OFFSET          0x00000390  /**< Address Filter (promiscuous) mode */
#define XTE_TIS_OFFSET          0x000003A0  /**< Interrupt status */
#define XTE_TIE_OFFSET          0x000003A4  /**< Interrupt enable */
#define XTE_MIIMWD_OFFSET       0x000003B0  /**< MII management write data */
#define XTE_MIIMAI_OFFSET       0x000003B4  /**< MII management access initiate */
/*@}*/

/** @name Transmit VLAN Data Table
 * This offset defines an offset to table that has provisioned transmit
 * VLAN data. It is stored in BRAM and will be used by hardware to provide
 * transmit VLAN tag, strip, and translation.
 *
 * @{
 */

#define XTE_TX_VLAN_DATA_OFFSET 0x00004000 /**< TX VLAN data table address */
/*@}*/

/** @name Receive VLAN Data Table
 * This offset defines an offset to table that has provisioned receive
 * VLAN data. It is stored in BRAM and will be used by hardware to provide
 * receive VLAN tag, strip, and translation.
 *
 * @{
 */

#define XTE_RX_VLAN_DATA_OFFSET 0x00008000 /**< TX VLAN data table address */
/*@}*/

/** @name Extended Multicast Address Table
 * This offset defines an offset to table that has provisioned multicast
 * addresses. It is stored in BRAM and will be used by hardware to provide
 * first line of address matching when a multicast frame is reveived. It
 * can minimize the use of CPU/software hence minimize performance impact.
 *
 * @{
 */

#define XTE_MCAST_BRAM_OFFSET   0x00020000 /**< multicast table address */
/*@}*/

/* Register masks. The following constants define bit locations of various
 * control bits in the registers. Constants are not defined for those registers
 * that have a single bit field representing all 32 bits. For further
 * information on the meaning of the various bit masks, refer to the HW spec.
 */

/** @name Reset and Address Filter bits
 *  These bits are associated with the XTE_RAF_OFFSET register.
 * @{
 */
#define XTE_RAF_HTRST_MASK       0x00000001 /**< Hard TEMAC Reset */
#define XTE_RAF_MCSTREJ_MASK     0x00000002 /**< Reject receive multicast destination address */
#define XTE_RAF_BCSTREJ_MASK     0x00000004 /**< Reject receive broadcast destination address */
#define XTE_RAF_TXVTAGMODE_MASK  0x00000018 /**< Tx VLAN TAG mode */
#define XTE_RAF_RXVTAGMODE_MASK  0x00000060 /**< Rx VLAN TAG mode */
#define XTE_RAF_TXVSTRPMODE_MASK 0x00000180 /**< Tx VLAN STRIP mode */
#define XTE_RAF_RXVSTRPMODE_MASK 0x00000600 /**< Rx VLAN STRIP mode */
#define XTE_RAF_NEWFNCENBL_MASK  0x00000800 /**< New function mode */
#define XTE_RAF_EMULTIFLTRENBL_MASK 0x00001000 /**< Exteneded Multicast Filtering mode */
#define XTE_RAF_TXVTAGMODE_SHIFT  3         /**< Tx Tag mode shift bits */
#define XTE_RAF_RXVTAGMODE_SHIFT  5         /**< Rx Tag mode shift bits */
#define XTE_RAF_TXVSTRPMODE_SHIFT 7         /**< Tx strip mode shift bits */
#define XTE_RAF_RXVSTRPMODE_SHIFT 9         /**< Rx Strip mode shift bits */
/*@}*/

/** @name Transmit Pause Frame Register (TPF)
 *  @{
 */
#define XTE_TPF_TPFV_MASK        0x0000FFFF   /**< Tx pause frame value */
/*@}*/

/** @name Transmit Inter-Frame Gap Adjustement Register (TFGP)
 *  @{
 */
#define XTE_TFGP_IFGP_MASK       0x0000007F   /**< Transmit inter-frame gap adjustment value */
/*@}*/

/** @name Interrupt bits
 *  These bits are associated with the XTE_IS_OFFSET, XTE_IP_OFFSET, and
 *  XTE_IE_OFFSET registers.
 * @{
 */
#define XTE_INT_HARDACSCMPLT_MASK 0x00000001 /**< Hard register access complete */
#define XTE_INT_AUTONEG_MASK      0x00000002 /**< Auto negotiation complete */
#define XTE_INT_RC_MASK           0x00000004 /**< Receive complete */
#define XTE_INT_RXRJECT_MASK      0x00000008 /**< Receive frame rejected */
#define XTE_INT_RXFIFOOVR_MASK    0x00000010 /**< Receive fifo overrun */
#define XTE_INT_TC_MASK           0x00000020 /**< Transmit complete */
#define XTE_INT_RXDCM_LOCK_MASK   0x00000040 /**< Rx Dcm Lock */
#define XTE_INT_MGT_LOCK_MASK     0x00000080 /**< MGT clock Lock */
#define XTE_INT_ALL_MASK          0x0000003f /**< All the ints */
/*@}*/


#define XTE_INT_RECV_ERROR_MASK \
    (XTE_INT_RXRJECT_MASK | XTE_INT_RXFIFOOVR_MASK) /**< INT bits that indicate receive errors */
/*@}*/


/** @name Control Register (CTL)
 *  @{
 */
#define XTE_CTL_WEN_MASK          0x00008000   /**< Write Enable */
/*@}*/


/** @name TPID Register (TPID)
 *  @{
 */
#define XTE_TPID_0_MASK          0x0000FFFF   /**< TPID 0 */
#define XTE_TPID_1_MASK          0xFFFF0000   /**< TPID 1  */
/*@}*/


/** @name Ready Status, TEMAC Interrupt Status, TEMAC Interrupt Enable Registers
 * (RDY, TIS, TIE)
 *  @{
 */
#define XTE_RSE_FABR_RR_MASK      0x00000001   /**< Fabric read ready */
#define XTE_RSE_MIIM_RR_MASK      0x00000002   /**< MII management read ready */
#define XTE_RSE_MIIM_WR_MASK      0x00000004   /**< MII management write ready */
#define XTE_RSE_AF_RR_MASK        0x00000008   /**< Address filter read ready*/
#define XTE_RSE_AF_WR_MASK        0x00000010   /**< Address filter write ready*/
#define XTE_RSE_CFG_RR_MASK       0x00000020   /**< Configuration register read ready*/
#define XTE_RSE_CFG_WR_MASK       0x00000040   /**< Configuration register write ready*/
#define XTE_RDY_HARD_ACS_RDY_MASK 0x00010000   /**< Hard register access ready */
#define XTE_RDY_ALL               (XTE_RSE_FABR_RR_MASK | \
                                   XTE_RSE_MIIM_RR_MASK | \
                                   XTE_RSE_MIIM_WR_MASK | \
                                   XTE_RSE_AF_RR_MASK | \
                                   XTE_RSE_AF_WR_MASK | \
                                   XTE_RSE_CFG_RR_MASK | \
                                   XTE_RSE_CFG_WR_MASK | \
                                   XTE_RDY_HARD_ACS_RDY_MASK)
/*@}*/


/** @name Receive Configuration Word 1 (RCW1)
 *  @{
 */
#define XTE_RCW1_RST_MASK         0x80000000   /**< Reset */
#define XTE_RCW1_JUM_MASK         0x40000000   /**< Jumbo frame enable */
#define XTE_RCW1_FCS_MASK         0x20000000   /**< In-Band FCS enable (FCS not stripped) */
#define XTE_RCW1_RX_MASK          0x10000000   /**< Receiver enable */
#define XTE_RCW1_VLAN_MASK        0x08000000   /**< VLAN frame enable */
#define XTE_RCW1_HD_MASK          0x04000000   /**< Half duplex mode */
#define XTE_RCW1_LT_DIS_MASK      0x02000000   /**< Length/type field valid check disable */
#define XTE_RCW1_PAUSEADDR_MASK   0x0000FFFF   /**< Pause frame source address
                                                    bits [47:32]. Bits [31:0]
                                                    are stored in register
                                                    RCW0 */
/*@}*/


/** @name Transmitter Configuration (TC)
 *  @{
 */
#define XTE_TC_RST_MASK           0x80000000   /**< reset */
#define XTE_TC_JUM_MASK           0x40000000   /**< Jumbo frame enable */
#define XTE_TC_FCS_MASK           0x20000000   /**< In-Band FCS enable (FCS not generated) */
#define XTE_TC_TX_MASK            0x10000000   /**< Transmitter enable */
#define XTE_TC_VLAN_MASK          0x08000000   /**< VLAN frame enable */
#define XTE_TC_HD_MASK            0x04000000   /**< Half duplex mode */
#define XTE_TC_IFG_MASK           0x02000000   /**< Inter-frame gap adjustment enable */
/*@}*/


/** @name Flow Control Configuration (FCC)
 *  @{
 */
#define XTE_FCC_FCRX_MASK         0x20000000   /**< Rx flow control enable */
#define XTE_FCC_FCTX_MASK         0x40000000   /**< Tx flow control enable */
/*@}*/


/** @name EMAC Configuration (EMMC)
 * @{
 */
#define XTE_EMMC_LINKSPEED_MASK   0xC0000000   /**< Link speed */
#define XTE_EMMC_RGMII_MASK       0x20000000   /**< RGMII mode enable */
#define XTE_EMMC_SGMII_MASK       0x10000000   /**< SGMII mode enable */
#define XTE_EMMC_GPCS_MASK        0x08000000   /**< 1000BaseX mode enable */
#define XTE_EMMC_HOST_MASK        0x04000000   /**< Host interface enable */
#define XTE_EMMC_TX16BIT          0x02000000   /**< 16 bit Tx client enable */
#define XTE_EMMC_RX16BIT          0x01000000   /**< 16 bit Rx client enable */

#define XTE_EMMC_LINKSPD_10       0x00000000   /**< XTE_EMCFG_LINKSPD_MASK for
                                                    10 Mbit */
#define XTE_EMMC_LINKSPD_100      0x40000000   /**< XTE_EMCFG_LINKSPD_MASK for
                                                    100 Mbit */
#define XTE_EMMC_LINKSPD_1000     0x80000000   /**< XTE_EMCFG_LINKSPD_MASK for
                                                    1000 Mbit */
/*@}*/


/** @name EMAC RGMII/SGMII Configuration (PHYC)
 * @{
 */
#define XTE_PHYC_SGMIILINKSPEED_MASK 0xC0000000	  /**< SGMII link speed */
#define XTE_PHYC_RGMIILINKSPEED_MASK 0x0000000C	  /**< RGMII link speed */
#define XTE_PHYC_RGMIIHD_MASK        0x00000002	  /**< RGMII Half-duplex mode */
#define XTE_PHYC_RGMIILINK_MASK      0x00000001	  /**< RGMII link status */

#define XTE_PHYC_RGLINKSPD_10        0x00000000	  /**< XTE_GMIC_RGLINKSPD_MASK
                                                       for 10 Mbit */
#define XTE_PHYC_RGLINKSPD_100       0x00000004	  /**< XTE_GMIC_RGLINKSPD_MASK
                                                       for 100 Mbit */
#define XTE_PHYC_RGLINKSPD_1000      0x00000008	  /**< XTE_GMIC_RGLINKSPD_MASK
                                                       for 1000 Mbit */
#define XTE_PHYC_SGLINKSPD_10        0x00000000	  /**< XTE_SGMIC_RGLINKSPD_MASK
                                                       for 10 Mbit */
#define XTE_PHYC_SGLINKSPD_100       0x40000000	  /**< XTE_SGMIC_RGLINKSPD_MASK
                                                       for 100 Mbit */
#define XTE_PHYC_SGLINKSPD_1000      0x80000000	  /**< XTE_SGMIC_RGLINKSPD_MASK
                                                       for 1000 Mbit */
/*@}*/


/** @name EMAC Management Configuration (MC)
 * @{
 */
#define XTE_MC_MDIOEN_MASK        0x00000040   /**< MII management enable */
#define XTE_MC_CLOCK_DIVIDE_MAX   0x3F	       /**< Maximum MDIO divisor */
/*@}*/


/** @name EMAC Unicast Address Register Word 1 (UAW1)
 * @{
 */
#define XTE_UAW1_UNICASTADDR_MASK 0x0000FFFF   /**< Station address bits [47:32]
                                                    Station address bits [31:0] 
                                                    are stored in register
                                                    UAW0 */
/*@}*/


/** @name EMAC Multicast Address Register Word 1 (MAW1)
 * @{
 */
#define XTE_MAW1_RNW_MASK         0x00800000   /**< Multicast address table register read enable */
#define XTE_MAW1_ADDR_MASK        0x00030000   /**< Multicast address table register address */
#define XTE_MAW1_MULTICADDR_MASK  0x0000FFFF   /**< Multicast address bits [47:32]
                                                    Multicast address bits [31:0] 
                                                    are stored in register
                                                    MAW0 */
#define XTE_MAW1_MATADDR_SHIFT_MASK 16	       /**< Number of bits to shift right
                                                    to align with
                                                    XTE_MAW1_CAMADDR_MASK */
/*@}*/


/** @name EMAC Address Filter Mode (AFM)
 * @{
 */
#define XTE_AFM_PM_MASK           0x80000000   /**< Promiscuous mode enable */
/*@}*/


/** @name Media Independent Interface Management (MIIM)
 * @{
 */
#define XTE_MIIM_REGAD_MASK     0x1F    /**< MII Phy register address (REGAD) */
#define XTE_MIIM_PHYAD_MASK     0x03E0  /**< MII Phy address (PHYAD) */
#define XTE_MIIM_PHYAD_SHIFT    5       /**< MII Shift bits for PHYAD */
/*@}*/


/** @name Checksum offload buffer descriptor extensions
 * @{
 */
/** Byte offset where checksum should begin (16 bit word) */
#define XTE_BD_TX_CSBEGIN_OFFSET  XDMAV3_BD_USR0_OFFSET

/** Offset where checksum should be inserted (16 bit word) */
#define XTE_BD_TX_CSINSERT_OFFSET (XDMAV3_BD_USR0_OFFSET + 2)

/** Checksum offload control for transmit (16 bit word) */
#define XTE_BD_TX_CSCNTRL_OFFSET  XDMAV3_BD_USR1_OFFSET

/** Seed value for checksum calculation (16 bit word) */
#define XTE_BD_TX_CSINIT_OFFSET   (XDMAV3_BD_USR1_OFFSET + 2)

/** Receive frame checksum calculation (16 bit word) */
#define XTE_BD_RX_CSRAW_OFFSET    (XDMAV3_BD_USR5_OFFSET + 2)

/*@}*/

/** @name TX_CSCNTRL bit mask
 * @{
 */
#define XTE_BD_TX_CSCNTRL_CALC_MASK  0x0001  /**< Enable/disable Tx
                                                  checksum */
/*@}*/


/** @name extended multicast buffer descriptor bit mask
 * @{
 */
#define XTE_BD_RX_USR2_BCAST_MASK    0x00000004
#define XTE_BD_RX_USR2_IP_MCAST_MASK 0x00000002
#define XTE_BD_RX_USR2_MCAST_MASK    0x00000001
/*@}*/

/**************************** Type Definitions *******************************/

/***************** Macros (Inline Functions) Definitions *********************/
xdbg_stmnt(extern int indent_on);

#define XLlTemac_indent(RegOffset) \
 ((indent_on && ((RegOffset) >= XTE_RAF_OFFSET) && ((RegOffset) <= XTE_RDY_OFFSET)) ? "\t" : "")

#define XLlTemac_reg_name(RegOffset) \
	(((RegOffset) == XTE_RAF_OFFSET) ? "XTE_RAF_OFFSET": \
	((RegOffset) == XTE_TPF_OFFSET) ? "XTE_TPF_OFFSET": \
	((RegOffset) == XTE_IFGP_OFFSET) ? "XTE_IFGP_OFFSET": \
	((RegOffset) == XTE_IS_OFFSET) ? "XTE_IS_OFFSET": \
	((RegOffset) == XTE_IP_OFFSET) ? "XTE_IP_OFFSET": \
	((RegOffset) == XTE_IE_OFFSET) ? "XTE_IE_OFFSET": \
	((RegOffset) == XTE_TTAG_OFFSET) ? "XTE_TVTAG_OFFSET": \
	((RegOffset) == XTE_RTAG_OFFSET) ? "XTE_RVTAG_OFFSET": \
	((RegOffset) == XTE_MSW_OFFSET) ? "XTE_MSW_OFFSET": \
	((RegOffset) == XTE_LSW_OFFSET) ? "XTE_LSW_OFFSET": \
	((RegOffset) == XTE_CTL_OFFSET) ? "XTE_CTL_OFFSET": \
	((RegOffset) == XTE_RDY_OFFSET) ? "XTE_RDY_OFFSET": \
	((RegOffset) == XTE_UAWL_OFFSET) ? "XTE_UAWL_OFFSET": \
	((RegOffset) == XTE_UAWU_OFFSET) ? "XTE_UAWU_OFFSET": \
	((RegOffset) == XTE_TPID0_OFFSET) ? "XTE_TPID0_OFFSET": \
	((RegOffset) == XTE_TPID1_OFFSET) ? "XTE_TPID1_OFFSET": \
	((RegOffset) == XTE_RCW0_OFFSET) ? "XTE_RCW0_OFFSET": \
	((RegOffset) == XTE_RCW1_OFFSET) ? "XTE_RCW1_OFFSET": \
	((RegOffset) == XTE_TC_OFFSET) ? "XTE_TC_OFFSET": \
	((RegOffset) == XTE_FCC_OFFSET) ? "XTE_FCC_OFFSET": \
	((RegOffset) == XTE_EMMC_OFFSET) ? "XTE_EMMC_OFFSET": \
	((RegOffset) == XTE_PHYC_OFFSET) ? "XTE_PHYC_OFFSET": \
	((RegOffset) == XTE_MC_OFFSET) ? "XTE_MC_OFFSET": \
	((RegOffset) == XTE_UAW0_OFFSET) ? "XTE_UAW0_OFFSET": \
	((RegOffset) == XTE_UAW1_OFFSET) ? "XTE_UAW1_OFFSET": \
	((RegOffset) == XTE_MAW0_OFFSET) ? "XTE_MAW0_OFFSET": \
	((RegOffset) == XTE_MAW1_OFFSET) ? "XTE_MAW1_OFFSET": \
	((RegOffset) == XTE_AFM_OFFSET) ? "XTE_AFM_OFFSET": \
	((RegOffset) == XTE_TIS_OFFSET) ? "XTE_TIS_OFFSET": \
	((RegOffset) == XTE_TIE_OFFSET) ? "XTE_TIE_OFFSET": \
	((RegOffset) == XTE_MIIMWD_OFFSET) ? "XTE_MIIMWD_OFFSET": \
	((RegOffset) == XTE_MIIMAI_OFFSET) ? "XTE_MIIMAI_OFFSET": \
	((RegOffset) == XTE_TXBL_OFFSET) ? "XTE_TXBL_OFFSET": \
	((RegOffset) == XTE_TXBU_OFFSET) ? "XTE_TXBU_OFFSET": \
	((RegOffset) == XTE_RXBL_OFFSET) ? "XTE_RXBL_OFFSET": \
	((RegOffset) == XTE_RXBU_OFFSET) ? "XTE_RXBU_OFFSET": \
	((RegOffset) == XTE_RXUNDRL_OFFSET) ? "XTE_RXUNDRL_OFFSET": \
	((RegOffset) == XTE_RXUNDRU_OFFSET) ? "XTE_RXUNDRU_OFFSET": \
	((RegOffset) == XTE_RXFRAGL_OFFSET) ? "XTE_RXFRAGL_OFFSET": \
	((RegOffset) == XTE_RXFRAGU_OFFSET) ? "XTE_RXFRAGU_OFFSET": \
	((RegOffset) == XTE_RX64BL_OFFSET) ? "XTE_RX64BL_OFFSET": \
	((RegOffset) == XTE_RX64BU_OFFSET) ? "XTE_RX64BU_OFFSET": \
	((RegOffset) == XTE_RX65B127L_OFFSET) ? "XTE_RX65B127L_OFFSET": \
	((RegOffset) == XTE_RX65B127U_OFFSET) ? "XTE_RX65B127U_OFFSET": \
	((RegOffset) == XTE_RX128B255L_OFFSET) ? "XTE_RX128B255L_OFFSET": \
	((RegOffset) == XTE_RX128B255U_OFFSET) ? "XTE_RX128B255U_OFFSET": \
	((RegOffset) == XTE_RX256B511L_OFFSET) ? "XTE_RX256B511L_OFFSET": \
	((RegOffset) == XTE_RX256B511U_OFFSET) ? "XTE_RX256B511U_OFFSET": \
	((RegOffset) == XTE_RX512B1023L_OFFSET) ? "XTE_RX512B1023L_OFFSET": \
	((RegOffset) == XTE_RX512B1023U_OFFSET) ? "XTE_RX512B1023U_OFFSET": \
	((RegOffset) == XTE_RX1024BL_OFFSET) ? "XTE_RX1024L_OFFSET": \
	((RegOffset) == XTE_RX1024BU_OFFSET) ? "XTE_RX1024U_OFFSET": \
	((RegOffset) == XTE_RXOVRL_OFFSET) ? "XTE_RXOVRL_OFFSET": \
	((RegOffset) == XTE_RXOVRU_OFFSET) ? "XTE_RXOVRU_OFFSET": \
	((RegOffset) == XTE_TX64BL_OFFSET) ? "XTE_TX64BL_OFFSET": \
	((RegOffset) == XTE_TX64BU_OFFSET) ? "XTE_TX64BU_OFFSET": \
	((RegOffset) == XTE_TX65B127L_OFFSET) ? "XTE_TX65B127L_OFFSET": \
	((RegOffset) == XTE_TX65B127U_OFFSET) ? "XTE_TX65B127U_OFFSET": \
	((RegOffset) == XTE_TX128B255L_OFFSET) ? "XTE_TX128B255L_OFFSET": \
	((RegOffset) == XTE_TX128B255U_OFFSET) ? "XTE_TX128B255U_OFFSET": \
	((RegOffset) == XTE_TX256B511L_OFFSET) ? "XTE_TX256B511L_OFFSET": \
	((RegOffset) == XTE_TX256B511U_OFFSET) ? "XTE_TX256B511U_OFFSET": \
	((RegOffset) == XTE_TX512B1023L_OFFSET) ? "XTE_TX512B1023L_OFFSET": \
	((RegOffset) == XTE_TX512B1023U_OFFSET) ? "XTE_TX512B1023U_OFFSET": \
	((RegOffset) == XTE_TX1024L_OFFSET) ? "XTE_TX1024L_OFFSET": \
	((RegOffset) == XTE_TX1024U_OFFSET) ? "XTE_TX1024U_OFFSET": \
	((RegOffset) == XTE_TXOVRL_OFFSET) ? "XTE_TXOVRL_OFFSET": \
	((RegOffset) == XTE_TXOVRU_OFFSET) ? "XTE_TXOVRU_OFFSET": \
	((RegOffset) == XTE_RXFL_OFFSET) ? "XTE_RXFL_OFFSET": \
	((RegOffset) == XTE_RXFU_OFFSET) ? "XTE_RXFU_OFFSET": \
	((RegOffset) == XTE_RXFCSERL_OFFSET) ? "XTE_RXFCSERL_OFFSET": \
	((RegOffset) == XTE_RXFCSERU_OFFSET) ? "XTE_RXFCSERU_OFFSET": \
	((RegOffset) == XTE_RXBCSTFL_OFFSET) ? "XTE_RXBCSTFL_OFFSET": \
	((RegOffset) == XTE_RXBCSTFU_OFFSET) ? "XTE_RXBCSTFU_OFFSET": \
	((RegOffset) == XTE_RXMCSTFL_OFFSET) ? "XTE_RXMCSTFL_OFFSET": \
	((RegOffset) == XTE_RXMCSTFU_OFFSET) ? "XTE_RXMCSTFU_OFFSET": \
	((RegOffset) == XTE_RXCTRFL_OFFSET) ? "XTE_RXCTRFL_OFFSET": \
	((RegOffset) == XTE_RXCTRFU_OFFSET) ? "XTE_RXCTRFU_OFFSET": \
	((RegOffset) == XTE_RXLTERL_OFFSET) ? "XTE_RXLTERL_OFFSET": \
	((RegOffset) == XTE_RXLTERU_OFFSET) ? "XTE_RXLTERU_OFFSET": \
	((RegOffset) == XTE_RXVLANFL_OFFSET) ? "XTE_RXVLANFL_OFFSET": \
	((RegOffset) == XTE_RXVLANFU_OFFSET) ? "XTE_RXVLANFU_OFFSET": \
	((RegOffset) == XTE_RXPFL_OFFSET) ? "XTE_RXFL_OFFSET": \
	((RegOffset) == XTE_RXPFU_OFFSET) ? "XTE_RXFU_OFFSET": \
	((RegOffset) == XTE_RXUOPFL_OFFSET) ? "XTE_RXUOPFL_OFFSET": \
	((RegOffset) == XTE_RXUOPFU_OFFSET) ? "XTE_RXUOPFU_OFFSET": \
	((RegOffset) == XTE_TXFL_OFFSET) ? "XTE_TXFL_OFFSET": \
	((RegOffset) == XTE_TXFU_OFFSET) ? "XTE_TXFU_OFFSET": \
	((RegOffset) == XTE_TXBCSTFL_OFFSET) ? "XTE_TXBCSTFL_OFFSET": \
	((RegOffset) == XTE_TXBCSTFU_OFFSET) ? "XTE_TXBCSTFU_OFFSET": \
	((RegOffset) == XTE_TXMCSTFL_OFFSET) ? "XTE_TXMCSTFL_OFFSET": \
	((RegOffset) == XTE_TXMCSTFU_OFFSET) ? "XTE_TXMCSTFU_OFFSET": \
	((RegOffset) == XTE_TXUNDRERL_OFFSET) ? "XTE_TXUNDRERL_OFFSET": \
	((RegOffset) == XTE_TXUNDRERU_OFFSET) ? "XTE_TXUNDRERU_OFFSET": \
	((RegOffset) == XTE_TXCTRFL_OFFSET) ? "XTE_TXCTRFL_OFFSET": \
	((RegOffset) == XTE_TXCTRFU_OFFSET) ? "XTE_TXCTRFU_OFFSET": \
	((RegOffset) == XTE_TXVLANFL_OFFSET) ? "XTE_TXVLANFL_OFFSET": \
	((RegOffset) == XTE_TXVLANFU_OFFSET) ? "XTE_TXVLANFU_OFFSET": \
	((RegOffset) == XTE_TXPFL_OFFSET) ? "XTE_TXPFL_OFFSET": \
	((RegOffset) == XTE_TXPFU_OFFSET) ? "XTE_TXPFU_OFFSET": \
	"unknown")

#define XLlTemac_print_reg_o(BaseAddress, RegOffset, Value) \
	xdbg_printf(XDBG_DEBUG_TEMAC_REG, "%s0x%0x -> %s(0x%0x)\n", \
			XLlTemac_indent(RegOffset), (Value), \
			XLlTemac_reg_name(RegOffset), (RegOffset)) \

#define XLlTemac_print_reg_i(BaseAddress, RegOffset, Value) \
	xdbg_printf(XDBG_DEBUG_TEMAC_REG, "%s%s(0x%0x) -> 0x%0x\n", \
			XLlTemac_indent(RegOffset), XLlTemac_reg_name(RegOffset), \
			(RegOffset), (Value)) \

/****************************************************************************/
/**
 *
 * XLlTemac_ReadReg returns the value read from the register specified by
 * <i>RegOffset</i>.
 *
 * @param    BaseAddress is the base address of the TEMAC channel.
 * @param    RegOffset is the offset of the register to be read.
 *
 * @return   XLlTemac_ReadReg returns the 32-bit value of the register.
 *
 * @note
 * C-style signature:
 *    u32 XLlTemac_mReadReg(u32 BaseAddress, u32 RegOffset)
 *
 *****************************************************************************/
#ifdef DEBUG
#define XLlTemac_ReadReg(BaseAddress, RegOffset) \
({ \
	u32 value; \
	if ((RegOffset) > 0x2c) { \
		printf ("readreg: Woah! wrong reg addr: 0x%0x\n", (RegOffset)); \
	} \
	value = XIo_In32(((BaseAddress) + (RegOffset))); \
	XLlTemac_print_reg_i((BaseAddress), (RegOffset), value); \
	value; \
})
#else
#define XLlTemac_ReadReg(BaseAddress, RegOffset) \
	(XIo_In32(((BaseAddress) + (RegOffset))))
#endif

/****************************************************************************/
/**
 *
 * XLlTemac_WriteReg, writes <i>Data</i> to the register specified by
 * <i>RegOffset</i>.
 *
 * @param    BaseAddress is the base address of the TEMAC channel.
 * @param    RegOffset is the offset of the register to be written.
 * @param    Data is the 32-bit value to write to the register.
 *
 * @return   N/A
 *
 * @note
 * C-style signature:
 *    void XLlTemac_mWriteReg(u32 BaseAddress, u32 RegOffset, u32 Data)
 *
 *****************************************************************************/
#ifdef DEBUG
#define XLlTemac_WriteReg(BaseAddress, RegOffset, Data) \
({ \
	if ((RegOffset) > 0x2c) { \
		printf ("writereg: Woah! wrong reg addr: 0x%0x\n", (RegOffset)); \
	} \
	XLlTemac_print_reg_o((BaseAddress), (RegOffset), (Data)); \
	XIo_Out32(((BaseAddress) + (RegOffset)), (Data)); \
})
#else
#define XLlTemac_WriteReg(BaseAddress, RegOffset, Data) \
	XIo_Out32(((BaseAddress) + (RegOffset)), (Data))
#endif

/****************************************************************************/
/**
 *
 * XLlTemac_ReadIndirectReg returns the value read from the hard TEMAC register
 * specified by <i>RegOffset</i>.
 *
 * @param    BaseAddress is the base address of the TEMAC channel.
 * @param    RegOffset is the offset of the hard TEMAC register to be read.
 *
 * @return   XLlTemac_ReadIndirectReg returns the 32-bit value of the register.
 *
 * @note
 * C-style signature:
 *    u32 XLlTemac_mReadIndirectReg(u32 BaseAddress, u32 RegOffset)
 *
 *****************************************************************************/
#ifdef DEBUG
extern u32 _xlltemac_rir_value;
#define XLlTemac_ReadIndirectReg(BaseAddress, RegOffset) \
( \
	indent_on = 1, \
	(((RegOffset) < 0x200) ? \
		xdbg_printf(XDBG_DEBUG_ERROR, \
			"readindirect: Woah! wrong reg addr: 0x%0x\n", \
			(RegOffset)) : 0), \
	(((RegOffset) > 0x3b4) ? \
		xdbg_printf(XDBG_DEBUG_ERROR, \
			"readindirect: Woah! wrong reg addr: 0x%0x\n", \
			(RegOffset)) : 0), \
	XLlTemac_WriteReg((BaseAddress), XTE_CTL_OFFSET, (RegOffset)), \
	_xlltemac_rir_value = XLlTemac_ReadReg((BaseAddress), XTE_LSW_OFFSET), \
	XLlTemac_print_reg_i((BaseAddress), (RegOffset), _xlltemac_rir_value), \
	indent_on = 0, \
	_xlltemac_rir_value \
)
#else
#define XLlTemac_ReadIndirectReg(BaseAddress, RegOffset) \
( \
	XLlTemac_WriteReg((BaseAddress), XTE_CTL_OFFSET, (RegOffset)), \
	XLlTemac_ReadReg((BaseAddress), XTE_LSW_OFFSET) \
)
#endif

/****************************************************************************/
/**
 *
 * XLlTemac_WriteIndirectReg, writes <i>Data</i> to the hard TEMAC register
 * specified by <i>RegOffset</i>.
 *
 * @param    BaseAddress is the base address of the TEMAC channel.
 * @param    RegOffset is the offset of the hard TEMAC register to be written.
 * @param    Data is the 32-bit value to write to the register.
 *
 * @return   N/A
 *
 * @note
 * C-style signature:
 *    void XLlTemac_WriteIndirectReg(u32 BaseAddress, u32 RegOffset, u32 Data)
 *
 *****************************************************************************/
#ifdef DEBUG
#define XLlTemac_WriteIndirectReg(BaseAddress, RegOffset, Data) \
( \
	indent_on = 1, \
	(((RegOffset) < 0x200) ? \
		xdbg_printf(XDBG_DEBUG_ERROR, \
			"readindirect: Woah! wrong reg addr: 0x%0x\n", \
			(RegOffset)) : 0), \
	(((RegOffset) > 0x3b4) ? \
		xdbg_printf(XDBG_DEBUG_ERROR, \
			"readindirect: Woah! wrong reg addr: 0x%0x\n", \
			(RegOffset)) : 0), \
	XLlTemac_print_reg_o((BaseAddress), (RegOffset), (Data)), \
	XLlTemac_WriteReg((BaseAddress), XTE_LSW_OFFSET, (Data)), \
	XLlTemac_WriteReg((BaseAddress), XTE_CTL_OFFSET, \
		((RegOffset) | XTE_CTL_WEN_MASK)), \
	((XLlTemac_ReadReg((BaseAddress), XTE_RDY_OFFSET) & \
			XTE_RDY_HARD_ACS_RDY_MASK) ? \
		((XLlTemac_ReadIndirectReg((BaseAddress), (RegOffset)) != (Data)) ? \
			xdbg_printf(XDBG_DEBUG_ERROR, \
				"data written is not read back: Reg: 0x%0x\n", \
				(RegOffset)) \
			: 0) \
		: xdbg_printf(XDBG_DEBUG_ERROR, "(temac_wi) RDY reg not initially ready\n")), \
	indent_on = 0 \
)
#else
#define XLlTemac_WriteIndirectReg(BaseAddress, RegOffset, Data) \
	XLlTemac_WriteReg((BaseAddress), XTE_LSW_OFFSET, (Data)), \
	XLlTemac_WriteReg((BaseAddress), XTE_CTL_OFFSET, \
		((RegOffset) | XTE_CTL_WEN_MASK))
#endif

#ifdef __cplusplus
  }
#endif

#endif /* end of protection macro */

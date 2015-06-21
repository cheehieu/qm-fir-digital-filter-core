/* $Id: xio_dcr.h,v 1.1.4.1 2009/03/19 19:16:42 moleres Exp $ */
/******************************************************************************
*
* (c) Copyright 2007-2009 Xilinx, Inc. All rights reserved.
*
* This file contains confidential and proprietary information of Xilinx, Inc.
* and is protected under U.S. and international copyright and other
* intellectual property laws.
*
* DISCLAIMER
* This disclaimer is not a license and does not grant any rights to the
* materials distributed herewith. Except as otherwise provided in a valid
* license issued to you by Xilinx, and to the maximum extent permitted by
* applicable law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND WITH ALL
* FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES AND CONDITIONS, EXPRESS,
* IMPLIED, OR STATUTORY, INCLUDING BUT NOT LIMITED TO WARRANTIES OF
* MERCHANTABILITY, NON-INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE;
* and (2) Xilinx shall not be liable (whether in contract or tort, including
* negligence, or under any other theory of liability) for any loss or damage
* of any kind or nature related to, arising under or in connection with these
* materials, including for any direct, or any indirect, special, incidental,
* or consequential loss or damage (including loss of data, profits, goodwill,
* or any type of loss or damage suffered as a result of any action brought by
* a third party) even if such damage or loss was reasonably foreseeable or
* Xilinx had been advised of the possibility of the same.
*
* CRITICAL APPLICATIONS
* Xilinx products are not designed or intended to be fail-safe, or for use in
* any application requiring fail-safe performance, such as life-support or
* safety devices or systems, Class III medical devices, nuclear facilities,
* applications related to the deployment of airbags, or any other applications
* that could lead to death, personal injury, or severe property or
* environmental damage (individually and collectively, "Critical
* Applications"). Customer assumes the sole risk and liability of any use of
* Xilinx products in Critical Applications, subject only to applicable laws
* and regulations governing limitations on product liability.
*
* THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS PART OF THIS FILE
* AT ALL TIMES.
*
******************************************************************************/
/*****************************************************************************/
/**
*
* @file xio_dcr.h
*
* The DCR I/O access functions.
*
* @note
*
* These access functions are specific to the PPC440 CPU. Changes might be
* necessary for other members of the IBM PPC Family.
*
* <pre>
* MODIFICATION HISTORY:
*
* Ver   Who  Date     Changes
* ----- ---- -------- -----------------------------------------------
* 1.00a ecm  10/18/07 initial release
* </pre>
*
* @internal
*
* This code WILL NOT FUNCTION on the PPC405 based architectures, V2P and V4.
*
******************************************************************************/

#ifndef XDCRIO_H        /* prevent circular inclusions */
#define XDCRIO_H        /* by using protection macros */

#ifdef __cplusplus
extern "C" {
#endif


/***************************** Include Files *********************************/
#include "xbasic_types.h"
#include "xpseudo_asm.h"

#ifdef XENV_VXWORKS
#define inline __inline__
#endif

/************************** Constant Definitions *****************************/
/*
 *   256 internal DCR registers
 *   Base address: 2 most signifcant bits of 10-bit addr taken from
 *                 xparameters.h which, in turn, is read from the
 *         C_DCRBASEADDR parameter of the processor block.
 *   Offset: 8 least significant bits
 */
/* register base addresses */

#define XDCR_APU_BASE   0x04
#define XDCR_MIB_BASE   0x10
#define XDCR_XB_BASE    0x20
#define XDCR_PLBS0_BASE 0x34
#define XDCR_PLBS1_BASE 0x44
#define XDCR_PLBM_BASE  0x54
#define XDCR_DMA0_BASE  0x80
#define XDCR_DMA1_BASE  0x98
#define XDCR_DMA2_BASE  0xB0
#define XDCR_DMA3_BASE  0xC8

/* register offsets */
/* global registers 0x00-0x02 */

#define XDCR_IDA_ADDR     0x00
#define XDCR_IDA_ACC      0x01
#define XDCR_CTRLCFGSTAT  0x02

/* Auxiliary Processor Unit Controller (APU) 0x04-0x05 */

#define XDCR_APU_UDI  (XDCR_APU_BASE+0x00)
#define XDCR_APU_CTRL (XDCR_APU_BASE+0x01)

/* Memory Interface Bridge (MIB) 0x10-0x13 */

#define XDCR_MIB_CTRL (XDCR_MIB_BASE+0x00)
#define XDCR_MIB_RCON (XDCR_MIB_BASE+0x01)
#define XDCR_MIB_BCON (XDCR_MIB_BASE+0x02)

/* Crossbar (XB) 0x20-0x33 */

#define XDCR_XB_IST      (XDCR_XB_BASE+0x00)
#define XDCR_XB_IMASK    (XDCR_XB_BASE+0x01)
#define XDCR_XB_ARBCFGX  (XDCR_XB_BASE+0x03)
#define XDCR_XB_FIFOSTX  (XDCR_XB_BASE+0x04)
#define XDCR_XB_SMSTX    (XDCR_XB_BASE+0x05)
#define XDCR_XB_MISCX    (XDCR_XB_BASE+0x06)
#define XDCR_XB_ARBCFGM  (XDCR_XB_BASE+0x08)
#define XDCR_XB_FIFOSTM  (XDCR_XB_BASE+0x09)
#define XDCR_XB_SMSTM    (XDCR_XB_BASE+0x0A)
#define XDCR_XB_MISCM    (XDCR_XB_BASE+0x0B)
#define XDCR_XB_TMPL0MAP (XDCR_XB_BASE+0x0D)
#define XDCR_XB_TMPL1MAP (XDCR_XB_BASE+0x0E)
#define XDCR_XB_TMPL2MAP (XDCR_XB_BASE+0x0F)
#define XDCR_XB_TMPL3MAP (XDCR_XB_BASE+0x10)
#define XDCR_XB_TMPLSEL  (XDCR_XB_BASE+0x11)

/* PLB Slave DCR offsets only */

#define XDCR_PLBS_CFG        0x00
#define XDCR_PLBS_SEARU      0x02
#define XDCR_PLBS_SEARL      0x03
#define XDCR_PLBS_SESR       0x04
#define XDCR_PLBS_MISCST     0x05
#define XDCR_PLBS_PLBERRST   0x06
#define XDCR_PLBS_SMST       0x07
#define XDCR_PLBS_MISC       0x08
#define XDCR_PLBS_CMDSNIFF   0x09
#define XDCR_PLBS_CMDSNIFFA  0x0A
#define XDCR_PLBS_TMPL0MAP   0x0C
#define XDCR_PLBS_TMPL1MAP   0x0D
#define XDCR_PLBS_TMPL2MAP   0x0E
#define XDCR_PLBS_TMPL3MAP   0x0F

/* PLB Slave 0 (PLBS0) 0x34-0x43 */

#define XDCR_PLBS0_CFG       (XDCR_PLBS0_BASE+0x00)
#define XDCR_PLBS0_CNT       (XDCR_PLBS0_BASE+0x01)
#define XDCR_PLBS0_SEARU     (XDCR_PLBS0_BASE+0x02)
#define XDCR_PLBS0_SEARL     (XDCR_PLBS0_BASE+0x03)
#define XDCR_PLBS0_SESR      (XDCR_PLBS0_BASE+0x04)
#define XDCR_PLBS0_MISCST    (XDCR_PLBS0_BASE+0x05)
#define XDCR_PLBS0_PLBERRST  (XDCR_PLBS0_BASE+0x06)
#define XDCR_PLBS0_SMST      (XDCR_PLBS0_BASE+0x07)
#define XDCR_PLBS0_MISC      (XDCR_PLBS0_BASE+0x08)
#define XDCR_PLBS0_CMDSNIFF  (XDCR_PLBS0_BASE+0x09)
#define XDCR_PLBS0_CMDSNIFFA (XDCR_PLBS0_BASE+0x0A)
#define XDCR_PLBS0_TMPL0MAP  (XDCR_PLBS0_BASE+0x0C)
#define XDCR_PLBS0_TMPL1MAP  (XDCR_PLBS0_BASE+0x0D)
#define XDCR_PLBS0_TMPL2MAP  (XDCR_PLBS0_BASE+0x0E)
#define XDCR_PLBS0_TMPL3MAP  (XDCR_PLBS0_BASE+0x0F)

/* PLB Slave 1 (PLBS1) 0x44-0x53 */

#define XDCR_PLBS1_CFG       (XDCR_PLBS1_BASE+0x00)
#define XDCR_PLBS1_CNT       (XDCR_PLBS1_BASE+0x01)
#define XDCR_PLBS1_SEARU     (XDCR_PLBS1_BASE+0x02)
#define XDCR_PLBS1_SEARL     (XDCR_PLBS1_BASE+0x03)
#define XDCR_PLBS1_SESR      (XDCR_PLBS1_BASE+0x04)
#define XDCR_PLBS1_MISCST    (XDCR_PLBS1_BASE+0x05)
#define XDCR_PLBS1_PLBERRST  (XDCR_PLBS1_BASE+0x06)
#define XDCR_PLBS1_SMST      (XDCR_PLBS1_BASE+0x07)
#define XDCR_PLBS1_MISC      (XDCR_PLBS1_BASE+0x08)
#define XDCR_PLBS1_CMDSNIFF  (XDCR_PLBS1_BASE+0x09)
#define XDCR_PLBS1_CMDSNIFFA (XDCR_PLBS1_BASE+0x0A)
#define XDCR_PLBS1_TMPL0MAP  (XDCR_PLBS1_BASE+0x0C)
#define XDCR_PLBS1_TMPL1MAP  (XDCR_PLBS1_BASE+0x0D)
#define XDCR_PLBS1_TMPL2MAP  (XDCR_PLBS1_BASE+0x0E)
#define XDCR_PLBS1_TMPL3MAP  (XDCR_PLBS1_BASE+0x0F)

/* PLB Master (PLBM) 0x54-0x5F */

#define XDCR_PLBM_CFG       (XDCR_PLBM_BASE+0x00)
#define XDCR_PLBM_CNT       (XDCR_PLBM_BASE+0x01)
#define XDCR_PLBM_FSEARU    (XDCR_PLBM_BASE+0x02)
#define XDCR_PLBM_FSEARL    (XDCR_PLBM_BASE+0x03)
#define XDCR_PLBM_FSESR     (XDCR_PLBM_BASE+0x04)
#define XDCR_PLBM_MISCST    (XDCR_PLBM_BASE+0x05)
#define XDCR_PLBM_PLBERRST  (XDCR_PLBM_BASE+0x06)
#define XDCR_PLBM_SMST      (XDCR_PLBM_BASE+0x07)
#define XDCR_PLBM_MISC      (XDCR_PLBM_BASE+0x08)
#define XDCR_PLBM_CMDSNIFF  (XDCR_PLBM_BASE+0x09)
#define XDCR_PLBM_CMDSNIFFA (XDCR_PLBM_BASE+0x0A)

/* DMA Controller DCR offsets only */
#define XDCR_DMA_TXNXTDESCPTR   0x00
#define XDCR_DMA_TXCURBUFADDR   0x01
#define XDCR_DMA_TXCURBUFLEN    0x02
#define XDCR_DMA_TXCURDESCPTR   0x03
#define XDCR_DMA_TXTAILDESCPTR  0x04
#define XDCR_DMA_TXCHANNELCTRL  0x05
#define XDCR_DMA_TXIRQ          0x06
#define XDCR_DMA_TXSTATUS       0x07
#define XDCR_DMA_RXNXTDESCPTR   0x08
#define XDCR_DMA_RXCURBUFADDR   0x09
#define XDCR_DMA_RXCURBUFLEN    0x0A
#define XDCR_DMA_RXCURDESCPTR   0x0B
#define XDCR_DMA_RXTAILDESCPTR  0x0C
#define XDCR_DMA_RXCHANNELCTRL  0x0D
#define XDCR_DMA_RXIRQ          0x0E
#define XDCR_DMA_RXSTATUS       0x0F
#define XDCR_DMA_CTRL           0x10

/* DMA Controller 0 (DMA0) 0x80-0x90 */

#define XDCR_DMA0_TXNXTDESCPTR  (XDCR_DMA0_BASE+0x00)
#define XDCR_DMA0_TXCURBUFADDR  (XDCR_DMA0_BASE+0x01)
#define XDCR_DMA0_TXCURBUFLEN   (XDCR_DMA0_BASE+0x02)
#define XDCR_DMA0_TXCURDESCPTR  (XDCR_DMA0_BASE+0x03)
#define XDCR_DMA0_TXTAILDESCPTR (XDCR_DMA0_BASE+0x04)
#define XDCR_DMA0_TXCHANNELCTRL (XDCR_DMA0_BASE+0x05)
#define XDCR_DMA0_TXIRQ         (XDCR_DMA0_BASE+0x06)
#define XDCR_DMA0_TXSTATUS      (XDCR_DMA0_BASE+0x07)
#define XDCR_DMA0_RXNXTDESCPTR  (XDCR_DMA0_BASE+0x08)
#define XDCR_DMA0_RXCURBUFADDR  (XDCR_DMA0_BASE+0x09)
#define XDCR_DMA0_RXCURBUFLEN   (XDCR_DMA0_BASE+0x0A)
#define XDCR_DMA0_RXCURDESCPTR  (XDCR_DMA0_BASE+0x0B)
#define XDCR_DMA0_RXTAILDESCPTR (XDCR_DMA0_BASE+0x0C)
#define XDCR_DMA0_RXCHANNELCTRL (XDCR_DMA0_BASE+0x0D)
#define XDCR_DMA0_RXIRQ         (XDCR_DMA0_BASE+0x0E)
#define XDCR_DMA0_RXSTATUS      (XDCR_DMA0_BASE+0x0F)
#define XDCR_DMA0_CTRL          (XDCR_DMA0_BASE+0x10)

/* DMA Controller 1 (DMA1) 0x98-0xA8 */

#define XDCR_DMA1_TXNXTDESCPTR  (XDCR_DMA1_BASE+0x00)
#define XDCR_DMA1_TXCURBUFADDR  (XDCR_DMA1_BASE+0x01)
#define XDCR_DMA1_TXCURBUFLEN   (XDCR_DMA1_BASE+0x02)
#define XDCR_DMA1_TXCURDESCPTR  (XDCR_DMA1_BASE+0x03)
#define XDCR_DMA1_TXTAILDESCPTR (XDCR_DMA1_BASE+0x04)
#define XDCR_DMA1_TXCHANNELCTRL (XDCR_DMA1_BASE+0x05)
#define XDCR_DMA1_TXIRQ         (XDCR_DMA1_BASE+0x06)
#define XDCR_DMA1_TXSTATUS      (XDCR_DMA1_BASE+0x07)
#define XDCR_DMA1_RXNXTDESCPTR  (XDCR_DMA1_BASE+0x08)
#define XDCR_DMA1_RXCURBUFADDR  (XDCR_DMA1_BASE+0x09)
#define XDCR_DMA1_RXCURBUFLEN   (XDCR_DMA1_BASE+0x0A)
#define XDCR_DMA1_RXCURDESCPTR  (XDCR_DMA1_BASE+0x0B)
#define XDCR_DMA1_RXTAILDESCPTR (XDCR_DMA1_BASE+0x0C)
#define XDCR_DMA1_RXCHANNELCTRL (XDCR_DMA1_BASE+0x0D)
#define XDCR_DMA1_RXIRQ         (XDCR_DMA1_BASE+0x0E)
#define XDCR_DMA1_RXSTATUS      (XDCR_DMA1_BASE+0x0F)
#define XDCR_DMA1_CTRL          (XDCR_DMA1_BASE+0x10)

/* DMA Controller 2 (DMA2) 0xB0-0xC0 */

#define XDCR_DMA2_TXNXTDESCPTR  (XDCR_DMA2_BASE+0x00)
#define XDCR_DMA2_TXCURBUFADDR  (XDCR_DMA2_BASE+0x01)
#define XDCR_DMA2_TXCURBUFLEN   (XDCR_DMA2_BASE+0x02)
#define XDCR_DMA2_TXCURDESCPTR  (XDCR_DMA2_BASE+0x03)
#define XDCR_DMA2_TXTAILDESCPTR (XDCR_DMA2_BASE+0x04)
#define XDCR_DMA2_TXCHANNELCTRL (XDCR_DMA2_BASE+0x05)
#define XDCR_DMA2_TXIRQ         (XDCR_DMA2_BASE+0x06)
#define XDCR_DMA2_TXSTATUS      (XDCR_DMA2_BASE+0x07)
#define XDCR_DMA2_RXNXTDESCPTR  (XDCR_DMA2_BASE+0x08)
#define XDCR_DMA2_RXCURBUFADDR  (XDCR_DMA2_BASE+0x09)
#define XDCR_DMA2_RXCURBUFLEN   (XDCR_DMA2_BASE+0x0A)
#define XDCR_DMA2_RXCURDESCPTR  (XDCR_DMA2_BASE+0x0B)
#define XDCR_DMA2_RXTAILDESCPTR (XDCR_DMA2_BASE+0x0C)
#define XDCR_DMA2_RXCHANNELCTRL (XDCR_DMA2_BASE+0x0D)
#define XDCR_DMA2_RXIRQ         (XDCR_DMA2_BASE+0x0E)
#define XDCR_DMA2_RXSTATUS      (XDCR_DMA2_BASE+0x0F)
#define XDCR_DMA2_CTRL          (XDCR_DMA2_BASE+0x10)

/* DMA Controller 3 (DMA3) 0xC8-0xD8 */

#define XDCR_DMA3_TXNXTDESCPTR  (XDCR_DMA3_BASE+0x00)
#define XDCR_DMA3_TXCURBUFADDR  (XDCR_DMA3_BASE+0x01)
#define XDCR_DMA3_TXCURBUFLEN   (XDCR_DMA3_BASE+0x02)
#define XDCR_DMA3_TXCURDESCPTR  (XDCR_DMA3_BASE+0x03)
#define XDCR_DMA3_TXTAILDESCPTR (XDCR_DMA3_BASE+0x04)
#define XDCR_DMA3_TXCHANNELCTRL (XDCR_DMA3_BASE+0x05)
#define XDCR_DMA3_TXIRQ         (XDCR_DMA3_BASE+0x06)
#define XDCR_DMA3_TXSTATUS      (XDCR_DMA3_BASE+0x07)
#define XDCR_DMA3_RXNXTDESCPTR  (XDCR_DMA3_BASE+0x08)
#define XDCR_DMA3_RXCURBUFADDR  (XDCR_DMA3_BASE+0x09)
#define XDCR_DMA3_RXCURBUFLEN   (XDCR_DMA3_BASE+0x0A)
#define XDCR_DMA3_RXCURDESCPTR  (XDCR_DMA3_BASE+0x0B)
#define XDCR_DMA3_RXTAILDESCPTR (XDCR_DMA3_BASE+0x0C)
#define XDCR_DMA3_RXCHANNELCTRL (XDCR_DMA3_BASE+0x0D)
#define XDCR_DMA3_RXIRQ         (XDCR_DMA3_BASE+0x0E)
#define XDCR_DMA3_RXSTATUS      (XDCR_DMA3_BASE+0x0F)
#define XDCR_DMA3_CTRL          (XDCR_DMA3_BASE+0x10)


/**
 * <pre
 * These are the bit defines for the Control, Configuration, and Status
 * register (XDCR_CTRLCFGSTAT)
 * @{
 */
#define XDCR_INT_MSTR_LOCK_MASK        0x80000000   /* Internal Master Bus Lock */
#define XDCR_INT_MSTR_AUTO_LOCK_MASK   0x40000000   /* Internal Master Bus Auto Lock, RO */
#define XDCR_EXT_MSTR_LOCK_MASK        0x20000000   /* External Master Bus Master Lock */
#define XDCR_EXT_MSTR_AUTO_LOCK_MASK   0x10000000   /* External Master Bus Auto Lock, RO */
#define XDCR_ENB_DCR_AUTO_LOCK_MASK    0x08000000   /* Enable Auto Bus Lock */
#define XDCR_ENB_MSTR_ASYNC_MASK       0x04000000   /* External Master in Async Mode */
#define XDCR_ENB_SLV_ASYNC_MASK        0x02000000   /* External Slave in Async Mode */
#define XDCR_ENB_DCR_TIMEOUT_SUPP_MASK 0x01000000   /* Enable Timeout Support */
#define XDCR_INT_MSTR_TIMEOUT_BIT      0x00000002   /* Internal Master Bus Timeout Occurred */
#define XDCR_EXT_MSTR_TIMEOUT_BIT      0x00000001   /* External Master Bus Timeout Occurred */

/*
 * Mask to disable exceptions in PPC440 MSR
 * Bit 14: Critical Interrupt Enable            0x00020000
 * Bit 16: External Interrupt Enable            0x00008000
 * Bit 20: Floating-point Exceptions Mode 0     0x00000800
 * Bit 23: Floating-point Exceptions Mode 1     0x00000100
 */
#define XDCR_DISABLE_EXCEPTIONS 0xFFFD76FF
#define XDCR_ALL_LOCK           (XDCR_INT_MSTR_LOCK_MASK | XDCR_EXT_MSTR_LOCK_MASK)
#define XDCR_ALL_TIMEOUT        (XDCR_INT_MSTR_TIMEOUT_BIT | XDCR_EXT_MSTR_TIMEOUT_BIT)

/**************************** Type Definitions *******************************/

/***************** Macros (Inline Functions) Definitions *********************/

/******************************************************************************/
/**
* Reads the register at the specified DCR address.
*
*
* @param    DcrRegister is the intended source DCR register
*
* @return
*
* Contents of the specified DCR register.
*
* @note
*
* C-style signature:
*    void XIo_mDcrReadReg(u32 DcrRegister)
*
*******************************************************************************/
#define XIo_mDcrReadReg(DcrRegister)  ( mfdcr(DcrRegister) )

/******************************************************************************/
/**
* Writes the register at specified DCR address.
*
*
* @param    DcrRegister is the intended destination DCR register
* @param    Data is the value to be placed into the specified DRC register
*
* @return
*
* None
*
* @note
*
* C-style signature:
*    void XIo_mDcrWriteReg(u32 DcrRegister, u32 Data)
*
*******************************************************************************/
#define XIo_mDcrWriteReg(DcrRegister, Data)  mtdcr((DcrRegister), (Data))

/******************************************************************************/
/**
* Explicitly locks the DCR bus
*
* @param    DcrBase is the base of the block of DCR registers
*
* @return
*
* None
*
* @note
*
* C-style signature:
*   void XIo_mDcrLock(u32 DcrBase)
*
*   Sets either Lock bit. Since a master cannot edit another master's Lock bit,
*   the macro can be simplified.
*   Care must be taken to not write a '1' to either timeout bit because
*   it will be cleared.
*
*******************************************************************************/
#define XIo_mDcrLock(DcrBase) \
{ \
 mtdcr((DcrBase) | XDCR_CTRLCFGSTAT, \
       (mfdcr((DcrBase) | XDCR_CTRLCFGSTAT) | XDCR_ALL_LOCK) & ~XDCR_ALL_TIMEOUT); \
}

/******************************************************************************/
/**
* Explicitly locks the DCR bus
*
* @param    DcrBase is the base of the block of DCR registers
*
* @return
*
* None
*
* @note
*
* C-style signature:
*   void XIo_mDcrUnlock(u32 DcrBase)
*
*   Unsets either Lock bit. Since a master cannot edit another master's Lock bit,
*   the macro can be simplified.
*   Care must be taken to not write a '1' to either timeout bit because
*   it will be cleared.
*
*******************************************************************************/
#define XIo_mDcrUnlock(DcrBase) \
{ \
 mtdcr((DcrBase) | XDCR_CTRLCFGSTAT, \
       (mfdcr((DcrBase) | XDCR_CTRLCFGSTAT) & ~(XDCR_ALL_LOCK | XDCR_ALL_TIMEOUT))); \
}

/*****************************************************************************/
/**
*
* Writes the value to the specified register using the indirect access method.
*
* @param    DcrBase is the base of the block of DCR registers
* @param    DcrRegister is the intended destination DCR register
* @param    Data is the value to be placed into the specified DCR register
*
* @return
*
* None
*
* @note
*
* Uses the indirect addressing method available in V5 with PPC440.
*
****************************************************************************/
#define XIo_DcrWriteReg(DcrBase, DcrRegister, Data) \
    XIo_DcrIndirectAddrWriteReg(DcrBase, DcrRegister, Data)

/************************** Function Prototypes ******************************/
inline void XIo_DcrIndirectAddrReadReg(u32 DcrBase, u32 DcrRegister, u32 *rVal);
inline void XIo_DcrIndirectAddrWriteReg(u32 DcrBase, u32 DcrRegister, u32 Data);

void XIo_DcrOut(u32 DcrRegister, u32 Data);
u32 XIo_DcrIn(u32 DcrRegister);

u32 XIo_DcrReadReg(u32 DcrBase, u32 DcrRegister);
void XIo_DcrWriteReg(u32 DcrBase, u32 DcrRegister, u32 Data);
u32 XIo_DcrLockAndReadReg(u32 DcrBase, u32 DcrRegister);
void XIo_DcrLockAndWriteReg(u32 DcrBase, u32 DcrRegister, u32 Data);

inline u32 XIo_DcrReadAPUUDIReg(u32 DcrBase, u32 UDInum);
inline void XIo_DcrWriteAPUUDIReg(u32 DcrBase, u32 UDInum, u32 Data);

inline u32 XIo_DcrReadAPUIDAUDIReg(u32 DcrBase, u32 UDInum);
inline void XIo_DcrWriteAPUIDAUDIReg(u32 DcrBase, u32 UDInum, u32 Data);

void XIo_DcrLock(u32 DcrBase);
void XIo_DcrUnlock(u32 DcrBase);

#ifdef __cplusplus
}
#endif

#endif /* end of protection macro */

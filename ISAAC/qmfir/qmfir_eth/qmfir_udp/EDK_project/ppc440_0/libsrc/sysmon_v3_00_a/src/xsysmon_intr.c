/* $Id: xsysmon_intr.c,v 1.1.2.1 2009/10/07 11:14:16 sadanan Exp $ */
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
* @file xsysmon_intr.c
*
* This file contains interrupt handling API functions of the System Monitor/ADC
* device.
*
* The device must be configured at hardware build time to support interrupt
* for all the functions in this file to work.
*
* Refer to xsysmon.h header file and device specification for more information.
*
* @note
*
* Calling the interrupt functions without including the interrupt component will
* result in asserts if asserts are enabled, and will result in a unpredictable
* behavior if the asserts are not enabled.
*
* <pre>
*
* MODIFICATION HISTORY:
*
* Ver   Who    Date     Changes
* ----- -----  -------- -----------------------------------------------------
* 1.00a xd/sv  05/22/07 First release
*
* </pre>
*
******************************************************************************/

/***************************** Include Files *********************************/

#include "xsysmon.h"

/************************** Constant Definitions *****************************/

/**************************** Type Definitions *******************************/

/***************** Macros (Inline Functions) Definitions *********************/

/************************** Function Prototypes ******************************/

/************************** Variable Definitions *****************************/

/*****************************************************************************/
/**
* This function enables the global interrupt in the Global Interrupt Enable
* Register (GIER) so that the interrupt output from the System Monitor/ADC
* device is enabled. Interrupts enabled using XSysMon_IntrEnable() will not
* occur until the global interrupt enable bit is set by using this function.
*
* @param	InstancePtr is a pointer to the XSysMon instance.
*
* @return	None.
*
* @note		The device must be configured at hardware build time to include
*		interrupt component for this function to work.
*
******************************************************************************/
void XSysMon_IntrGlobalEnable(XSysMon *InstancePtr)
{
	/*
	 * Assert the arguments.
	 */
	XASSERT_VOID(InstancePtr != NULL);
	XASSERT_VOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);
	XASSERT_VOID(InstancePtr->Config.IncludeInterrupt == TRUE);

	/*
	 * Enable the Global Interrupt.
	 */
	XSysMon_mWriteReg(InstancePtr->Config.BaseAddress, XSM_GIER_OFFSET,
			  XSM_GIER_GIE_MASK);
}

/****************************************************************************/
/**
* This function disables the global interrupt in the Global Interrupt Enable
* Register (GIER) so that the interrupt output from the System Monitor/ADC
* device is disabled.
*
* @param	InstancePtr is a pointer to the XSysMon instance.
*
* @return	None.
*
* @note		The device must be configured at hardware build time to include
*		interrupt component for this function to work.
*
*****************************************************************************/
void XSysMon_IntrGlobalDisable(XSysMon *InstancePtr)
{
	/*
	 * Assert the arguments.
	 */
	XASSERT_VOID(InstancePtr != NULL);
	XASSERT_VOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);
	XASSERT_VOID(InstancePtr->Config.IncludeInterrupt == TRUE);

	/*
	 * Disable the Global Interrupt.
	 */
	XSysMon_mWriteReg(InstancePtr->Config.BaseAddress, XSM_GIER_OFFSET, 0);
}

/****************************************************************************/
/**
*
* This function enables the specified interrupts in the device.
* Interrupts enabled using this function will not occur until the global
* interrupt enable bit is set by using the XSysMon_IntrGlobalEnable()function.
*
* @param	InstancePtr is a pointer to the XSysMon instance.
* @param	Mask is the bit-mask of the interrupts to be enabled.
*		Bit positions of 1 will be enabled. Bit positions of 0 will
*		keep the previous setting. This mask is formed by OR'ing
*		XSM_IPIXR_* bits defined in xsysmon_hw.h.
*
* @return	None.
*
* @note		The device must be configured at hardware build time to include
*		interrupt component for this function to work.
*
*****************************************************************************/
void XSysMon_IntrEnable(XSysMon *InstancePtr, u32 Mask)
{
	u32 RegValue;

	/*
	 * Assert the arguments.
	 */
	XASSERT_VOID(InstancePtr != NULL);
	XASSERT_VOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);
	XASSERT_VOID(InstancePtr->Config.IncludeInterrupt == TRUE);

	/*
	 * Enable the specified interrupts in the IPIER.
	 */
	RegValue = XSysMon_mReadReg(InstancePtr->Config.BaseAddress,
				    XSM_IPIER_OFFSET);
	RegValue |= (Mask & XSM_IPIXR_ALL_MASK);
	XSysMon_mWriteReg(InstancePtr->Config.BaseAddress, XSM_IPIER_OFFSET,
			  RegValue);
}

/****************************************************************************/
/**
*
* This function disables the specified interrupts in the device.
*
* @param	InstancePtr is a pointer to the XSysMon instance.
* @param	Mask is the bit-mask of the interrupts to be disabled.
*		Bit positions of 1 will be disabled. Bit positions of 0 will
*		keep the previous setting. This mask is formed by OR'ing
*		XSM_IPIXR_* bits defined in xsysmon_hw.h.
*
* @return	None.
*
* @note		The device must be configured at hardware build time to include
*		interrupt component for this function to work.
*
*****************************************************************************/
void XSysMon_IntrDisable(XSysMon *InstancePtr, u32 Mask)
{
	u32 RegValue;

	/*
	 * Assert the arguments.
	 */
	XASSERT_VOID(InstancePtr != NULL);
	XASSERT_VOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);
	XASSERT_VOID(InstancePtr->Config.IncludeInterrupt == TRUE);

	/*
	 * Disable the specified interrupts in the IPIER.
	 */
	RegValue = XSysMon_mReadReg(InstancePtr->Config.BaseAddress,
				    XSM_IPIER_OFFSET);
	RegValue &= ~(Mask & XSM_IPIXR_ALL_MASK);
	XSysMon_mWriteReg(InstancePtr->Config.BaseAddress, XSM_IPIER_OFFSET,
			  RegValue);
}

/****************************************************************************/
/**
*
* This function returns the enabled interrupts read from the Interrupt Enable
* Register (IPIER). Use the XSM_IPIXR_* constants defined in xsysmon_hw.h to
* interpret the returned value.
*
* @param	InstancePtr is a pointer to the XSysMon instance.
*
* @return	A 32-bit value representing the contents of the IPIER.
*
* @note		The device must be configured at hardware build time to include
*		interrupt component for this function to work.
*
*****************************************************************************/
u32 XSysMon_IntrGetEnabled(XSysMon *InstancePtr)
{
	/*
	 * Assert the arguments.
	 */
	XASSERT_NONVOID(InstancePtr != NULL);
	XASSERT_NONVOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);
	XASSERT_NONVOID(InstancePtr->Config.IncludeInterrupt == TRUE);

	/*
	 * Return the value read from the Interrupt Enable Register.
	 */
	return XSysMon_mReadReg(InstancePtr->Config.BaseAddress,
				XSM_IPIER_OFFSET) & XSM_IPIXR_ALL_MASK;
}

/****************************************************************************/
/**
*
* This function returns the interrupt status read from Interrupt Status
* Register(IPISR). Use the XSM_IPIXR_* constants defined in xsysmon_hw.h
* to interpret the returned value.
*
* @param	InstancePtr is a pointer to the XSysMon instance.
*
* @return	A 32-bit value representing the contents of the IPISR.
*
* @note		The device must be configured at hardware build time to include
*		interrupt component for this function to work.
*
*****************************************************************************/
u32 XSysMon_IntrGetStatus(XSysMon *InstancePtr)
{
	/*
	 * Assert the arguments.
	 */
	XASSERT_NONVOID(InstancePtr != NULL);
	XASSERT_NONVOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);
	XASSERT_NONVOID(InstancePtr->Config.IncludeInterrupt == TRUE);

	/*
	 * Return the value read from the Interrupt Status register.
	 */
	return XSysMon_mReadReg(InstancePtr->Config.BaseAddress,
				XSM_IPISR_OFFSET) & XSM_IPIXR_ALL_MASK;
}

/****************************************************************************/
/**
*
* This function clears the specified interrupts in the Interrupt Status
* Register (IPISR).
*
* @param	InstancePtr is a pointer to the XSysMon instance.
* @param	Mask is the bit-mask of the interrupts to be cleared.
*		Bit positions of 1 will be cleared. Bit positions of 0 will not
* 		change the previous interrupt status. This mask is formed by
* 		OR'ing XSM_IPIXR_* bits which are defined in xsysmon_hw.h.
*
* @return	None.
*
* @note		The device must be configured at hardware build time to include
*		interrupt component for this function to work.
*
*****************************************************************************/
void XSysMon_IntrClear(XSysMon *InstancePtr, u32 Mask)
{
	u32 RegValue;

	/*
	 * Assert the arguments.
	 */
	XASSERT_VOID(InstancePtr != NULL);
	XASSERT_VOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);
	XASSERT_VOID(InstancePtr->Config.IncludeInterrupt == TRUE);

	/*
	 * Clear the specified interrupts in the Interrupt Status register.
	 */
	RegValue = XSysMon_mReadReg(InstancePtr->Config.BaseAddress,
				    XSM_IPISR_OFFSET);
	RegValue &= (Mask & XSM_IPIXR_ALL_MASK);
	XSysMon_mWriteReg(InstancePtr->Config.BaseAddress, XSM_IPISR_OFFSET,
			  RegValue);

}

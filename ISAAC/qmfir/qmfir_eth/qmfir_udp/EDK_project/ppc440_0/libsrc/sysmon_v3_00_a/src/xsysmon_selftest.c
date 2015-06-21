/* $Id: xsysmon_selftest.c,v 1.1.2.1 2009/10/07 11:14:16 sadanan Exp $ */
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
* @file xsysmon_selftest.c
*
* This file contains a diagnostic self test function for the XSysMon driver.
* The self test function does a simple read/write test of the Alarm Threshold
* Register.
*
* See xsysmon.h for more information.
*
* @note	None.
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
*****************************************************************************/

/***************************** Include Files ********************************/

#include "xsysmon.h"

/************************** Constant Definitions ****************************/

/*
 * The following constant defines the test value to be written
 * to the Alarm Threshold Register
 */
#define XSM_ATR_TEST_VALUE 		0x55

/**************************** Type Definitions ******************************/

/***************** Macros (Inline Functions) Definitions ********************/

/************************** Variable Definitions ****************************/

/************************** Function Prototypes *****************************/

/*****************************************************************************/
/**
*
* Run a self-test on the driver/device. The test
*	- Resets the device,
*	- Writes a value into the Alarm Threshold register and reads it back
*	for comparison.
*	- Resets the device again.
*
*
* @param	InstancePtr is a pointer to the XSysMon instance.
*
* @return
*		- XST_SUCCESS if the value read from the Alarm Threshold
*		register is the same as the value written.
*		- XST_FAILURE Otherwise
*
* @note		This is a destructive test in that resets of the device are
*		performed. Refer to the device specification for the
*		device status after the reset operation.
*
******************************************************************************/
int XSysMon_SelfTest(XSysMon *InstancePtr)
{
	int Status;
	u32 RegValue;

	/*
	 * Assert the argument
	 */
	XASSERT_NONVOID(InstancePtr != NULL);
	XASSERT_NONVOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);


	/*
	 * Reset the device to get it back to its default state
	 */
	XSysMon_Reset(InstancePtr);

	/*
	 * Write a value into the Alarm Threshold registers, read it back, and
	 * do the comparison
	 */
	XSysMon_SetAlarmThreshold(InstancePtr, XSM_ATR_VCCINT_UPPER,
				  XSM_ATR_TEST_VALUE);
	RegValue = XSysMon_GetAlarmThreshold(InstancePtr, XSM_ATR_VCCINT_UPPER);

	if (RegValue == XSM_ATR_TEST_VALUE) {
		Status = XST_SUCCESS;
	} else {
		Status = XST_FAILURE;
	}

	/*
	 * Reset the device again to its default state.
	 */
	XSysMon_Reset(InstancePtr);


	/*
	 * Return the test result.
	 */
	return Status;
}

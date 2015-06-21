/* $Id: xmpmc_stats.c,v 1.1.2.1 2009/07/14 07:56:51 svemula Exp $ */
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
* @file xmpmc_stats.c
*
* The implementation of the XMpmc component's functionality that is related
* to statistics. See xmpmc.h for more information about the component.
*
* @note		None.
*
* <pre>
* MODIFICATION HISTORY:
*
* Ver   Who  Date     Changes
* ----- ---- -------- -----------------------------------------------
* 1.00a mta  02/24/07 First release
* </pre>
*
*****************************************************************************/

/***************************** Include Files ********************************/

#include "xmpmc.h"

/************************** Constant Definitions ****************************/

/**************************** Type Definitions ******************************/

/***************** Macros (Inline Functions) Definitions ********************/

/************************** Variable Definitions ****************************/

/************************** Function Prototypes *****************************/

/****************************************************************************/
/**
* Get the statistics of the MPMC device including the Single Error Count,
* Double Error Count, Parity Field Error Count and the address where the last
* error was detected in the memory. The counts are all contained in registers
* of the MPMC device.
*
* @param	InstancePtr is a pointer to an XMpmc instance to be worked on.
* @param	StatsPtr contains a pointer to a XMpmc_Stats data type.
*		The function puts the statistics of the device into the
*		specified data structure.
*
* @return	The statistics data type pointed to by input StatsPtr is
*		modified.
*
* @note		None.
*
*****************************************************************************/
void XMpmc_GetStatsEcc(XMpmc * InstancePtr, XMpmc_Stats * StatsPtr)
{
	u32 StatusReg;

	/*
	 * Assert arguments.
	 */
	XASSERT_VOID(InstancePtr != NULL);
	XASSERT_VOID(StatsPtr != NULL);
	XASSERT_VOID(InstancePtr->ConfigPtr.EccSupportPresent == TRUE);

	/*
	 * Read all the error count registers and save their values in the
	 * specified statistics area.
	 */
	StatsPtr->SingleErrorCount =
		(u16) XMpmc_mReadReg(InstancePtr->ConfigPtr.BaseAddress,
				     XMPMC_ECCSEC_OFFSET);
	StatsPtr->DoubleErrorCount =
		(u16) XMpmc_mReadReg(InstancePtr->ConfigPtr.BaseAddress,
				     XMPMC_ECCDEC_OFFSET);
	StatsPtr->ParityErrorCount =
		(u16) XMpmc_mReadReg(InstancePtr->ConfigPtr.BaseAddress,
				     XMPMC_ECCPEC_OFFSET);


	StatusReg = XMpmc_mReadReg(InstancePtr->ConfigPtr.BaseAddress,
				   XMPMC_ECCSR_OFFSET);
	if (StatusReg & (XMPMC_ECCSR_SE_MASK | XMPMC_ECCSR_DE_MASK |
			 XMPMC_ECCSR_PE_MASK)) {
		StatsPtr->LastErrorAddress =
			(u32) XMpmc_mReadReg(InstancePtr->ConfigPtr.
					     BaseAddress, XMPMC_ECCADDR_OFFSET);

		StatsPtr->EccErrorSyndrome = ((StatusReg &
					       XMPMC_ECCSR_SE_SYND_MASK) >>
					       XMPMC_ECCSR_SE_SYND_SHIFT);
		StatsPtr->EccErrorTransSize = ((StatusReg &
						XMPMC_ECCSR_ERR_SIZE_MASK) >>
					       XMPMC_ECCSR_ERR_SIZE_SHIFT);
		StatsPtr->ErrorReadWrite =
			((StatusReg & XMPMC_ECCSR_ERR_RNW_MASK) >>
				XMPMC_ECCSR_ERR_RNW_SHIFT);
	}
	else {
		StatsPtr->LastErrorAddress = 0x0;
	}
}

/****************************************************************************/
/**
* Clear the statistics of the MPMC device including the Single Error Count,
* Double Error Count, and Parity Field Error Count. The counts are all
* contained in registers of the MPMC device.
*
* @param	InstancePtr is a pointer to an XMpmc instance to be worked on.
*
* @return	None.
*
* @note		None.
*
*****************************************************************************/
void XMpmc_ClearStatsEcc(XMpmc * InstancePtr)
{
	/*
	 * Assert arguments.
	 */
	XASSERT_VOID(InstancePtr != NULL);
	XASSERT_VOID(InstancePtr->ConfigPtr.EccSupportPresent == TRUE);

	/*
	 * Clear all the error count registers in the device.
	 */
	XMpmc_mWriteReg(InstancePtr->ConfigPtr.BaseAddress,
			XMPMC_ECCSEC_OFFSET, 0);
	XMpmc_mWriteReg(InstancePtr->ConfigPtr.BaseAddress,
			XMPMC_ECCDEC_OFFSET, 0);
	XMpmc_mWriteReg(InstancePtr->ConfigPtr.BaseAddress,
			XMPMC_ECCPEC_OFFSET, 0);
}

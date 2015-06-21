/* $Id: xtmrctr_stats.c,v 1.1 2008/08/27 11:34:06 sadanan Exp $ */
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
*       (c) Copyright 2002-2007 Xilinx Inc.
*       All rights reserved.
*
******************************************************************************/
/*****************************************************************************/
/**
*
* @file xtmrctr_stats.c
*
* Contains function to get and clear statistics for the XTmrCtr component.
*
* <pre>
* MODIFICATION HISTORY:
*
* Ver   Who  Date     Changes
* ----- ---- -------- -----------------------------------------------
* 1.00b jhl  02/06/02 First release
* 1.10b mta  03/21/07 Updated for new coding style.
* </pre>
*
******************************************************************************/

/***************************** Include Files *********************************/

#include "xbasic_types.h"
#include "xtmrctr.h"

/************************** Constant Definitions *****************************/


/**************************** Type Definitions *******************************/


/***************** Macros (Inline Functions) Definitions *********************/


/************************** Function Prototypes ******************************/


/************************** Variable Definitions *****************************/


/*****************************************************************************/
/**
*
* Get a copy of the XTmrCtrStats structure, which contains the current
* statistics for this driver.
*
* @param	InstancePtr is a pointer to the XTmrCtr instance.
* @param	StatsPtr is a pointer to a XTmrCtrStats structure which will get
*		a copy of current statistics.
*
* @return	None.
*
* @note		None.
*
******************************************************************************/
void XTmrCtr_GetStats(XTmrCtr * InstancePtr, XTmrCtrStats * StatsPtr)
{
	XASSERT_VOID(InstancePtr != NULL);
	XASSERT_VOID(StatsPtr != NULL);
	XASSERT_VOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);

	StatsPtr->Interrupts = InstancePtr->Stats.Interrupts;
}

/*****************************************************************************/
/**
*
* Clear the XTmrCtrStats structure for this driver.
*
* @param	InstancePtr is a pointer to the XTmrCtr instance.
*
* @return	None.
*
* @note		None.
*
******************************************************************************/
void XTmrCtr_ClearStats(XTmrCtr * InstancePtr)
{
	XASSERT_VOID(InstancePtr != NULL);
	XASSERT_VOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);

	InstancePtr->Stats.Interrupts = 0;
}

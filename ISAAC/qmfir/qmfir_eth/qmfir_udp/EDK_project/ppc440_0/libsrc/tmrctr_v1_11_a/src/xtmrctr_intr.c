/* $Id: xtmrctr_intr.c,v 1.1 2008/08/27 11:34:06 sadanan Exp $ */
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
* @file xtmrctr_intr.c
*
* Contains interrupt-related functions for the XTmrCtr component.
*
* <pre>
* MODIFICATION HISTORY:
*
* Ver   Who  Date     Changes
* ----- ---- -------- -----------------------------------------------
* 1.00b jhl  02/06/02 First release
* 1.10b mta  03/21/07 Updated to new coding style
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
* Sets the timer callback function, which the driver calls when the specified
* timer times out.
*
* @param	InstancePtr is a pointer to the XTmrCtr instance .
* @param	CallBackRef is the upper layer callback reference passed back
*		when the callback function is invoked.
* @param	FuncPtr is the pointer to the callback function.
*
* @return	None.
*
* @note
*
* The handler is called within interrupt context so the function that is
* called should either be short or pass the more extensive processing off
* to another task to allow the interrupt to return and normal processing
* to continue.
*
******************************************************************************/
void XTmrCtr_SetHandler(XTmrCtr * InstancePtr, XTmrCtr_Handler FuncPtr,
			void *CallBackRef)
{
	XASSERT_VOID(InstancePtr != NULL);
	XASSERT_VOID(FuncPtr != NULL);
	XASSERT_VOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);

	InstancePtr->Handler = FuncPtr;
	InstancePtr->CallBackRef = CallBackRef;
}

/*****************************************************************************/
/**
*
* Interrupt Service Routine (ISR) for the driver.  This function only performs
* processing for the device and does not save and restore the interrupt context.
*
* @param	InstancePtr contains a pointer to the timer/counter instance for
*		the interrupt.
*
* @return	None.
*
* @note		None.
*
******************************************************************************/
void XTmrCtr_InterruptHandler(void *InstancePtr)
{
	XTmrCtr *TmrCtrPtr = NULL;
	u8 TmrCtrNumber;
	u32 ControlStatusReg;

	/*
	 * Verify that each of the inputs are valid.
	 */

	XASSERT_VOID(InstancePtr != NULL);

	/*
	 * Convert the non-typed pointer to an timer/counter instance pointer
	 * such that there is access to the timer/counter
	 */
	TmrCtrPtr = (XTmrCtr *) InstancePtr;

	/*
	 * Loop thru each timer counter in the device and call the callback
	 * function for each timer which has caused an interrupt
	 */
	for (TmrCtrNumber = 0;
	     TmrCtrNumber < XTC_DEVICE_TIMER_COUNT; TmrCtrNumber++) {
		/*
		 * Check if timer is expired
		 */
		ControlStatusReg = XTimerCtr_mReadReg(TmrCtrPtr->BaseAddress,
						      TmrCtrNumber,
						      XTC_TCSR_OFFSET);

		if (ControlStatusReg & XTC_CSR_INT_OCCURED_MASK) {
			/*
			 * Increment statistics for the number of interrupts and
			 * call the callback to handle any application specific
			 * processing
			 */
			TmrCtrPtr->Stats.Interrupts++;
			TmrCtrPtr->Handler(TmrCtrPtr->CallBackRef,
					   TmrCtrNumber);
			/*
			 * Read the new Control/Status Register content.
			 */
			ControlStatusReg = XTimerCtr_mReadReg(TmrCtrPtr->BaseAddress,
						      TmrCtrNumber,
						      XTC_TCSR_OFFSET);
			/*
			 * If in compare mode and a single shot rather than auto
			 * reload mode then disable the timer and reset it such
			 * so that the interrupt can be acknowledged, this
			 * should be only temporary till the hardware is fixed
			 */
			if (((ControlStatusReg & XTC_CSR_AUTO_RELOAD_MASK) == 0)
			    && ((ControlStatusReg & XTC_CSR_CAPTURE_MODE_MASK)
				== 0)) {
				/*
				 * Disable the timer counter and reset it such
				 * that the timer counter is loaded with the
				 * reset value allowing the interrupt to be
				 * acknowledged
				 */
				ControlStatusReg &= ~XTC_CSR_ENABLE_TMR_MASK;

				XTmrCtr_mWriteReg(TmrCtrPtr->BaseAddress,
						  TmrCtrNumber, XTC_TCSR_OFFSET,
						  ControlStatusReg |
						  XTC_CSR_LOAD_MASK);

				/*
				 * Clear the reset condition, the reset bit must
				 * be manually cleared by a 2nd write to the
				 * register
				 */
				XTmrCtr_mWriteReg(TmrCtrPtr->BaseAddress,
						  TmrCtrNumber, XTC_TCSR_OFFSET,
						  ControlStatusReg);
			}

			/*
			 * Acknowledge the interrupt by clearing the interrupt
			 * bit in the timer control status register, this is
			 * done after calling the handler so the application
			 * could call IsExpired, the interrupt
			 * is cleared by writing a 1 to the interrupt bit of the
			 * register without changing any of the other bits
			 */
			XTmrCtr_mWriteReg(TmrCtrPtr->BaseAddress, TmrCtrNumber,
					  XTC_TCSR_OFFSET,
					  ControlStatusReg |
					  XTC_CSR_INT_OCCURED_MASK);
		}
	}
}

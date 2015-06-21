/* $Id: xtmrctr.c,v 1.1 2008/08/27 11:34:06 sadanan Exp $ */
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
* @file xtmrctr.c
*
* Contains required functions for the XTmrCtr driver.
*
* <pre>
* MODIFICATION HISTORY:
*
* Ver   Who  Date     Changes
* ----- ---- -------- -----------------------------------------------
* 1.00a ecm  08/16/01 First release
* 1.00b jhl  02/21/02 Repartitioned the driver for smaller files
* 1.10b mta  03/21/07 Updated to new coding style
* </pre>
*
******************************************************************************/

/***************************** Include Files *********************************/

#include "xbasic_types.h"
#include "xstatus.h"
#include "xparameters.h"
#include "xtmrctr.h"
#include "xtmrctr_i.h"

/************************** Constant Definitions *****************************/


/**************************** Type Definitions *******************************/


/***************** Macros (Inline Functions) Definitions *********************/


/************************** Function Prototypes ******************************/


/************************** Variable Definitions *****************************/


/*****************************************************************************/
/**
*
* Initializes a specific timer/counter instance/driver. Initialize fields of
* the XTmrCtr structure, then reset the timer/counter
*
* @param	InstancePtr is a pointer to the XTmrCtr instance.
* @param	DeviceId is the unique id of the device controlled by this
*		XTmrCtr component.  Passing in a device id associates the
*		generic XTmrCtr component to a specific device, as chosen by
*		the caller or application developer.
*
* @return
*		- XST_SUCCESS if initialization was successful
*		- XST_DEVICE_IS_STARTED if the device has already been started
*		- XST_DEVICE_NOT_FOUND if the device doesn't exist
*
* @note		None.
*
******************************************************************************/
int XTmrCtr_Initialize(XTmrCtr * InstancePtr, u16 DeviceId)
{
	XTmrCtr_Config *TmrCtrConfigPtr;
	int TmrCtrNumber;
	u32 StatusReg;

	XASSERT_NONVOID(InstancePtr != NULL);

	/*
	 * Lookup the device configuration in the temporary CROM table. Use this
	 * configuration info down below when initializing this component.
	 */
	TmrCtrConfigPtr = XTmrCtr_LookupConfig(DeviceId);

	if (TmrCtrConfigPtr == (XTmrCtr_Config *) NULL) {
		return XST_DEVICE_NOT_FOUND;
	}

	/*
	 * Check each of the timer counters of the device, if any are already
	 * running, then the device should not be initialized. This allows the
	 * user to stop the device and reinitialize, but prevents a user from
	 * inadvertently initializing.
	 */
	for (TmrCtrNumber = 0; TmrCtrNumber < XTC_DEVICE_TIMER_COUNT;
	     TmrCtrNumber++) {
		/*
		 * Read the current register contents and check if the timer
		 * counter is started and running, note that the register read
		 * is not using the base address in the instance so this is not
		 * destructive if the timer counter is already started
		 */
		StatusReg = XTimerCtr_mReadReg(TmrCtrConfigPtr->BaseAddress,
					       TmrCtrNumber, XTC_TCSR_OFFSET);
		if (StatusReg & XTC_CSR_ENABLE_TMR_MASK) {
			return XST_DEVICE_IS_STARTED;
		}
	}

	/*
	 * Set some default values, including setting the callback
	 * handlers to stubs.
	 */
	InstancePtr->BaseAddress = TmrCtrConfigPtr->BaseAddress;
	InstancePtr->Handler = NULL;
	InstancePtr->CallBackRef = NULL;

	/*
	 * Clear the statistics for this driver
	 */
	InstancePtr->Stats.Interrupts = 0;

	/* Initialize the registers of each timer/counter in the device */

	for (TmrCtrNumber = 0; TmrCtrNumber < XTC_DEVICE_TIMER_COUNT;
	     TmrCtrNumber++) {
		/*
		 * Set the Compare register to 0
		 */
		XTmrCtr_mWriteReg(InstancePtr->BaseAddress, TmrCtrNumber,
				  XTC_TLR_OFFSET, 0);
		/*
		 * Reset the timer and the interrupt, the reset bit will need to
		 * be cleared after this
		 */
		XTmrCtr_mWriteReg(InstancePtr->BaseAddress, TmrCtrNumber,
				  XTC_TCSR_OFFSET,
				  XTC_CSR_INT_OCCURED_MASK | XTC_CSR_LOAD_MASK);
		/*
		 * Set the control/status register to complete initialization by
		 * clearing the reset bit which was just set
		 */
		XTmrCtr_mWriteReg(InstancePtr->BaseAddress, TmrCtrNumber,
				  XTC_TCSR_OFFSET, 0);
	}

	/*
	 * Indicate the instance is ready to use, successfully initialized
	 */
	InstancePtr->IsReady = XCOMPONENT_IS_READY;

	return XST_SUCCESS;
}

/*****************************************************************************/
/**
*
* Starts the specified timer counter of the device such that it starts running.
* The timer counter is reset before it is started and the reset value is
* loaded into the timer counter.
*
* If interrupt mode is specified in the options, it is necessary for the caller
* to connect the interrupt handler of the timer/counter to the interrupt source,
* typically an interrupt controller, and enable the interrupt within the
* interrupt controller.
*
* @param	InstancePtr is a pointer to the XTmrCtr instance.
* @param	TmrCtrNumber is the timer counter of the device to operate on.
*		Each device may contain multiple timer counters. The timer
*		number is a zero based number with a range of
*		0 - (XTC_DEVICE_TIMER_COUNT - 1).
*
* @return	None.
*
* @note		None.
*
******************************************************************************/
void XTmrCtr_Start(XTmrCtr * InstancePtr, u8 TmrCtrNumber)
{
	u32 ControlStatusReg;

	XASSERT_VOID(InstancePtr != NULL);
	XASSERT_VOID(TmrCtrNumber < XTC_DEVICE_TIMER_COUNT);
	XASSERT_VOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);

	/*
	 * Read the current register contents such that only the necessary bits
	 * of the register are modified in the following operations
	 */
	ControlStatusReg = XTimerCtr_mReadReg(InstancePtr->BaseAddress,
					      TmrCtrNumber, XTC_TCSR_OFFSET);
	/*
	 * Reset the timer counter such that it reloads from the compare
	 * register and the interrupt is cleared simultaneously, the interrupt
	 * can only be cleared after reset such that the interrupt condition is
	 * cleared
	 */
	XTmrCtr_mWriteReg(InstancePtr->BaseAddress, TmrCtrNumber,
			  XTC_TCSR_OFFSET,
			  XTC_CSR_LOAD_MASK);

	/*
	 * Remove the reset condition such that the timer counter starts running
	 * with the value loaded from the compare register
	 */
	XTmrCtr_mWriteReg(InstancePtr->BaseAddress, TmrCtrNumber,
			  XTC_TCSR_OFFSET,
			  ControlStatusReg | XTC_CSR_ENABLE_TMR_MASK);
}

/*****************************************************************************/
/**
*
* Stops the timer counter by disabling it.
*
* It is the callers' responsibility to disconnect the interrupt handler of the
* timer_counter from the interrupt source, typically an interrupt controller,
* and disable the interrupt within the interrupt controller.
*
* @param	InstancePtr is a pointer to the XTmrCtr instance.
* @param	TmrCtrNumber is the timer counter of the device to operate on.
*		Each device may contain multiple timer counters. The timer
*		number is a zero based number with a range of
*		0 - (XTC_DEVICE_TIMER_COUNT - 1).
*
* @return	None.
*
* @note		None.
*
******************************************************************************/
void XTmrCtr_Stop(XTmrCtr * InstancePtr, u8 TmrCtrNumber)
{
	u32 ControlStatusReg;

	XASSERT_VOID(InstancePtr != NULL);
	XASSERT_VOID(TmrCtrNumber < XTC_DEVICE_TIMER_COUNT);
	XASSERT_VOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);

	/*
	 * Read the current register contents
	 */
	ControlStatusReg = XTimerCtr_mReadReg(InstancePtr->BaseAddress,
					      TmrCtrNumber, XTC_TCSR_OFFSET);
	/*
	 * Disable the timer counter such that it's not running
	 */
	ControlStatusReg &= ~(XTC_CSR_ENABLE_TMR_MASK);

	/*
	 * Write out the updated value to the actual register.
	 */
	XTmrCtr_mWriteReg(InstancePtr->BaseAddress, TmrCtrNumber,
			  XTC_TCSR_OFFSET, ControlStatusReg);
}

/*****************************************************************************/
/**
*
* Get the current value of the specified timer counter.  The timer counter
* may be either incrementing or decrementing based upon the current mode of
* operation.
*
* @param	InstancePtr is a pointer to the XTmrCtr instance.
* @param	TmrCtrNumber is the timer counter of the device to operate on.
*		Each device may contain multiple timer counters. The timer
*		number is a zero based number  with a range of
*		0 - (XTC_DEVICE_TIMER_COUNT - 1).
*
* @return	The current value for the timer counter.
*
* @note		None.
*
******************************************************************************/
u32 XTmrCtr_GetValue(XTmrCtr * InstancePtr, u8 TmrCtrNumber)
{

	XASSERT_NONVOID(InstancePtr != NULL);
	XASSERT_NONVOID(TmrCtrNumber < XTC_DEVICE_TIMER_COUNT);
	XASSERT_NONVOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);

	return XTimerCtr_mReadReg(InstancePtr->BaseAddress,
				  TmrCtrNumber, XTC_TCR_OFFSET);
}

/*****************************************************************************/
/**
*
* Set the reset value for the specified timer counter. This is the value
* that is loaded into the timer counter when it is reset. This value is also
* loaded when the timer counter is started.
*
* @param	InstancePtr is a pointer to the XTmrCtr instance.
* @param	TmrCtrNumber is the timer counter of the device to operate on.
*		Each device may contain multiple timer counters. The timer
*		number is a zero based number  with a range of
*		0 - (XTC_DEVICE_TIMER_COUNT - 1).
* @param	ResetValue contains the value to be used to reset the timer
*		counter.
*
* @return	None.
*
* @note		None.
*
******************************************************************************/
void XTmrCtr_SetResetValue(XTmrCtr * InstancePtr, u8 TmrCtrNumber,
			   u32 ResetValue)
{

	XASSERT_VOID(InstancePtr != NULL);
	XASSERT_VOID(TmrCtrNumber < XTC_DEVICE_TIMER_COUNT);
	XASSERT_VOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);

	XTmrCtr_mWriteReg(InstancePtr->BaseAddress, TmrCtrNumber,
			  XTC_TLR_OFFSET, ResetValue);
}

/*****************************************************************************/
/**
*
* Returns the timer counter value that was captured the last time the external
* capture input was asserted.
*
* @param	InstancePtr is a pointer to the XTmrCtr instance.
* @param	TmrCtrNumber is the timer counter of the device to operate on.
*		Each device may contain multiple timer counters. The timer
*		number is a zero based number  with a range of
*		0 - (XTC_DEVICE_TIMER_COUNT - 1).
*
* @return	The current capture value for the indicated timer counter.
*
* @note		None.
*
*******************************************************************************/
u32 XTmrCtr_GetCaptureValue(XTmrCtr * InstancePtr, u8 TmrCtrNumber)
{

	XASSERT_NONVOID(InstancePtr != NULL);
	XASSERT_NONVOID(TmrCtrNumber < XTC_DEVICE_TIMER_COUNT);
	XASSERT_NONVOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);

	return XTimerCtr_mReadReg(InstancePtr->BaseAddress,
				  TmrCtrNumber, XTC_TLR_OFFSET);
}

/*****************************************************************************/
/**
*
* Resets the specified timer counter of the device. A reset causes the timer
* counter to set it's value to the reset value.
*
* @param	InstancePtr is a pointer to the XTmrCtr instance.
* @param	TmrCtrNumber is the timer counter of the device to operate on.
*		Each device may contain multiple timer counters. The timer
*		number is a zero based number  with a range of
*		0 - (XTC_DEVICE_TIMER_COUNT - 1).
*
* @return	None.
*
* @note		None.
*
******************************************************************************/
void XTmrCtr_Reset(XTmrCtr * InstancePtr, u8 TmrCtrNumber)
{
	u32 CounterControlReg;

	XASSERT_VOID(InstancePtr != NULL);
	XASSERT_VOID(TmrCtrNumber < XTC_DEVICE_TIMER_COUNT);
	XASSERT_VOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);

	/*
	 * Read current contents of the register so it won't be destroyed
	 */
	CounterControlReg = XTimerCtr_mReadReg(InstancePtr->BaseAddress,
					       TmrCtrNumber, XTC_TCSR_OFFSET);
	/*
	 * Reset the timer by toggling the reset bit in the register
	 */
	XTmrCtr_mWriteReg(InstancePtr->BaseAddress, TmrCtrNumber,
			  XTC_TCSR_OFFSET,
			  CounterControlReg | XTC_CSR_LOAD_MASK);

	XTmrCtr_mWriteReg(InstancePtr->BaseAddress, TmrCtrNumber,
			  XTC_TCSR_OFFSET, CounterControlReg);
}

/*****************************************************************************/
/**
*
* Checks if the specified timer counter of the device has expired. In capture
* mode, expired is defined as a capture occurred. In compare mode, expired is
* defined as the timer counter rolled over/under for up/down counting.
*
* When interrupts are enabled, the expiration causes an interrupt. This function
* is typically used to poll a timer counter to determine when it has expired.
*
* @param	InstancePtr is a pointer to the XTmrCtr instance.
* @param	TmrCtrNumber is the timer counter of the device to operate on.
*		Each device may contain multiple timer counters. The timer
*		number is a zero based number  with a range of
*		0 - (XTC_DEVICE_TIMER_COUNT - 1).
*
* @return	TRUE if the timer has expired, and FALSE otherwise.
*
* @note		None.
*
******************************************************************************/
int XTmrCtr_IsExpired(XTmrCtr * InstancePtr, u8 TmrCtrNumber)
{
	u32 CounterControlReg;

	XASSERT_NONVOID(InstancePtr != NULL);
	XASSERT_NONVOID(TmrCtrNumber < XTC_DEVICE_TIMER_COUNT);
	XASSERT_NONVOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);

	/*
	 * Check if timer is expired
	 */
	CounterControlReg = XTimerCtr_mReadReg(InstancePtr->BaseAddress,
					       TmrCtrNumber, XTC_TCSR_OFFSET);

	return ((CounterControlReg & XTC_CSR_INT_OCCURED_MASK) ==
		XTC_CSR_INT_OCCURED_MASK);
}

/*****************************************************************************
*
* Looks up the device configuration based on the unique device ID. The table
* TmrCtrConfigTable contains the configuration info for each device in the
* system.
*
* @param	DeviceId is the unique device ID to search for in the config
*		table.
*
* @return	A pointer to the configuration that matches the given device ID,
* 		or NULL if no match is found.
*
* @note		None.
*
******************************************************************************/
XTmrCtr_Config *XTmrCtr_LookupConfig(u16 DeviceId)
{
	XTmrCtr_Config *CfgPtr = NULL;
	int i;

	for (i = 0; i < XPAR_XTMRCTR_NUM_INSTANCES; i++) {
		if (XTmrCtr_ConfigTable[i].DeviceId == DeviceId) {
			CfgPtr = &XTmrCtr_ConfigTable[i];
			break;
		}
	}

	return CfgPtr;
}

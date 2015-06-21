/* $Id: xtmrctr_options.c,v 1.1 2008/08/27 11:34:06 sadanan Exp $ */
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
* @file xtmrctr_options.c
*
* Contains configuration options functions for the XTmrCtr component.
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
#include "xtmrctr_i.h"

/************************** Constant Definitions *****************************/


/**************************** Type Definitions *******************************/


/***************** Macros (Inline Functions) Definitions *********************/


/************************** Function Prototypes ******************************/


/************************** Variable Definitions *****************************/

/*
 * The following data type maps an option to a register mask such that getting
 * and setting the options may be table driven.
 */
typedef struct {
	u32 Option;
	u32 Mask;
} Mapping;

/*
 * Create the table which contains options which are to be processed to get/set
 * the options. These options are table driven to allow easy maintenance and
 * expansion of the options.
 */
static Mapping OptionsTable[] = {
	{XTC_ENABLE_ALL_OPTION, XTC_CSR_ENABLE_ALL_MASK},
	{XTC_DOWN_COUNT_OPTION, XTC_CSR_DOWN_COUNT_MASK},
	{XTC_CAPTURE_MODE_OPTION, XTC_CSR_CAPTURE_MODE_MASK |
	 XTC_CSR_EXT_CAPTURE_MASK},
	{XTC_INT_MODE_OPTION, XTC_CSR_ENABLE_INT_MASK},
	{XTC_AUTO_RELOAD_OPTION, XTC_CSR_AUTO_RELOAD_MASK},
	{XTC_EXT_COMPARE_OPTION, XTC_CSR_EXT_GENERATE_MASK}
};

/* Create a constant for the number of entries in the table */

#define XTC_NUM_OPTIONS   (sizeof(OptionsTable) / sizeof(Mapping))

/*****************************************************************************/
/**
*
* Enables the specified options for the specified timer counter. This function
* sets the options without regard to the current options of the driver. To
* prevent a loss of the current options, the user should call
* XTmrCtr_GetOptions() prior to this function and modify the retrieved options
* to pass into this function to prevent loss of the current options.
*
* @param	InstancePtr is a pointer to the XTmrCtr instance.
* @param	TmrCtrNumber is the timer counter of the device to operate on.
*		Each device may contain multiple timer counters. The timer
*		number is a zero based number with a range of
*		0 - (XTC_DEVICE_TIMER_COUNT - 1).
* @param	Options contains the desired options to be set or cleared.
*		Setting the option to '1' enables the option, clearing the to
*		'0' disables the option. The options are bit masks such that
*		multiple options may be set or cleared. The options are
*		described in xtmrctr.h.
*
* @return	None.
*
* @note		None.
*
******************************************************************************/
void XTmrCtr_SetOptions(XTmrCtr * InstancePtr, u8 TmrCtrNumber, u32 Options)
{
	u32 CounterControlReg = 0;
	u32 Index;

	XASSERT_VOID(InstancePtr != NULL);
	XASSERT_VOID(TmrCtrNumber < XTC_DEVICE_TIMER_COUNT);
	XASSERT_VOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);

	/*
	 * Loop through the Options table, turning the enable on or off
	 * depending on whether the bit is set in the incoming Options flag.
	 */

	for (Index = 0; Index < XTC_NUM_OPTIONS; Index++) {
		if (Options & OptionsTable[Index].Option) {

			/*
			 * Turn the option on
			 */
			CounterControlReg |= OptionsTable[Index].Mask;
		}
		else {
			/*
			 * Turn the option off
			 */
			CounterControlReg &= ~OptionsTable[Index].Mask;
		}
	}

	/*
	 * Write out the updated value to the actual register
	 */
	XTmrCtr_mWriteReg(InstancePtr->BaseAddress, TmrCtrNumber,
			  XTC_TCSR_OFFSET, CounterControlReg);
}

/*****************************************************************************/
/**
*
* Get the options for the specified timer counter.
*
* @param	InstancePtr is a pointer to the XTmrCtr instance.
* @param	TmrCtrNumber is the timer counter of the device to operate on
*		Each device may contain multiple timer counters. The timer
*		number is a zero based number with a range of
*		0 - (XTC_DEVICE_TIMER_COUNT - 1).
*
* @return
*
* The currently set options. An option which is set to a '1' is enabled and
* set to a '0' is disabled. The options are bit masks such that multiple
* options may be set or cleared. The options are described in xtmrctr.h.
*
* @note		None.
*
******************************************************************************/
u32 XTmrCtr_GetOptions(XTmrCtr * InstancePtr, u8 TmrCtrNumber)
{

	u32 Options = 0;
	u32 CounterControlReg;
	u32 Index;

	XASSERT_NONVOID(InstancePtr != NULL);
	XASSERT_NONVOID(TmrCtrNumber < XTC_DEVICE_TIMER_COUNT);
	XASSERT_NONVOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);

	/*
	 * Read the current contents of the control status register to allow
	 * the current options to be determined
	 */
	CounterControlReg = XTimerCtr_mReadReg(InstancePtr->BaseAddress,
					       TmrCtrNumber, XTC_TCSR_OFFSET);
	/*
	 * Loop through the Options table, turning the enable on or off
	 * depending on whether the bit is set in the current register settings.
	 */
	for (Index = 0; Index < XTC_NUM_OPTIONS; Index++) {
		if (CounterControlReg & OptionsTable[Index].Mask) {
			Options |= OptionsTable[Index].Option;	/* turn it on */
		}
		else {
			Options &= ~OptionsTable[Index].Option;	/* turn it off */
		}
	}

	return Options;
}

/* $Id: xtmrctr_l.h,v 1.1 2008/08/27 11:34:06 sadanan Exp $ */
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
* @file xtmrctr_l.h
*
* This header file contains identifiers and low-level driver functions (or
* macros) that can be used to access the device.  The user should refer to the
* hardware device specification for more details of the device operation.
* High-level driver functions are defined in xtmrctr.h.
*
* <pre>
* MODIFICATION HISTORY:
*
* Ver   Who  Date     Changes
* ----- ---- -------- -----------------------------------------------
* 1.00b jhl  04/24/02 First release
* 1.10b mta  03/21/07 Updated to new coding style
* </pre>
*
******************************************************************************/

#ifndef XTMRCTR_L_H		/* prevent circular inclusions */
#define XTMRCTR_L_H		/* by using protection macros */

#ifdef __cplusplus
extern "C" {
#endif

/***************************** Include Files *********************************/

#include "xbasic_types.h"
#include "xio.h"

/************************** Constant Definitions *****************************/

/**
 * Defines the number of timer counters within a single hardware device. This
 * number is not currently parameterized in the hardware but may be in the
 * future.
 */
#define XTC_DEVICE_TIMER_COUNT		2

/* Each timer counter consumes 16 bytes of address space */

#define XTC_TIMER_COUNTER_OFFSET	16

/** @name Register Offset Definitions
 * Register offsets within a timer counter, there are multiple
 * timer counters within a single device
 * @{
 */

#define XTC_TCSR_OFFSET		0	/**< Control/Status register */
#define XTC_TLR_OFFSET		4	/**< Load register */
#define XTC_TCR_OFFSET		8	/**< Timer counter register */

/* @} */

/** @name Control Status Register Bit Definitions
 * Control Status Register bit masks
 * Used to configure the timer counter device.
 * @{
 */

#define XTC_CSR_ENABLE_ALL_MASK		0x00000400 /**< Enables all timer
							counters */
#define XTC_CSR_ENABLE_PWM_MASK		0x00000200 /**< Enables the Pulse Width
							Modulation */
#define XTC_CSR_INT_OCCURED_MASK	0x00000100 /**< If bit is set, an
							interrupt has occured.
							If set and '1' is
							written to this bit
							position, bit is
							cleared. */
#define XTC_CSR_ENABLE_TMR_MASK		0x00000080 /**< Enables only the
							specific timer */
#define XTC_CSR_ENABLE_INT_MASK		0x00000040 /**< Enables the interrupt
							output. */
#define XTC_CSR_LOAD_MASK		0x00000020 /**< Loads the timer using
							the load value provided
							earlier in the Load
							Register,
							XTC_TLR_OFFSET. */
#define XTC_CSR_AUTO_RELOAD_MASK	0x00000010 /**< In compare mode,
							configures
							the timer counter to
							reload  from the
							Load Register. The
							default  mode
							causes the timer counter
							to hold when the compare
							value is hit. In capture
							mode, configures  the
							timer counter to not
							hold the previous
							capture value if a new
							event occurs. The
							default mode cause the
							timer counter to hold
							the capture value until
							recognized. */
#define XTC_CSR_EXT_CAPTURE_MASK	0x00000008 /**< Enables the
							external input
							to the timer counter. */
#define XTC_CSR_EXT_GENERATE_MASK	0x00000004 /**< Enables the
							external generate output
							for the timer. */
#define XTC_CSR_DOWN_COUNT_MASK		0x00000002 /**< Configures the timer
							counter to count down
							from start value, the
							default is to count
							up.*/
#define XTC_CSR_CAPTURE_MODE_MASK	0x00000001 /**< Enables the timer to
							capture the timer
							counter value when the
							external capture line is
							asserted. The default
							mode is compare mode.*/
/* @} */

/**************************** Type Definitions *******************************/

extern u8 XTmrCtr_Offsets[];

/***************** Macros (Inline Functions) Definitions *********************/

/*****************************************************************************/
/**
* Read one of the timer counter registers.
*
* @param	BaseAddress contains the base address of the timer counter
*		device.
* @param	TmrCtrNumber contains the specific timer counter within the
*		device, a zero based number, 0 - (XTC_DEVICE_TIMER_COUNT - 1).
* @param	RegOffset contains the offset from the 1st register of the timer
*		counter to select the specific register of the timer counter.
*
* @return	The value read from the register, a 32 bit value.
*
* @note		C-Style signature:
* 		u32 XTmrCtr_mReadReg(u32 BaseAddress, u8 TimerNumber,
					unsigned RegOffset);
******************************************************************************/
#define XTimerCtr_mReadReg(BaseAddress, TmrCtrNumber, RegOffset)	\
	XIo_In32((BaseAddress) + XTmrCtr_Offsets[(TmrCtrNumber)] + (RegOffset))

/*****************************************************************************/
/**
* Write a specified value to a register of a timer counter.
*
* @param	BaseAddress is the base address of the timer counter device.
* @param	TmrCtrNumber is the specific timer counter within the device, a
*		   zero based number, 0 - (XTC_DEVICE_TIMER_COUNT - 1).
* @param	RegOffset contain the offset from the 1st register of the timer
*		   counter to select the specific register of the timer counter.
* @param	ValueToWrite is the 32 bit value to be written to the register.
*
* @note		C-Style signature:
* 		void XTmrCtr_mWriteReg(u32 BaseAddress, u8 TimerNumber,
*					unsigned RegOffset, u32 ValueToWrite);
******************************************************************************/
#define XTmrCtr_mWriteReg(BaseAddress, TmrCtrNumber, RegOffset, ValueToWrite)\
	XIo_Out32(((BaseAddress) + XTmrCtr_Offsets[(TmrCtrNumber)] +	\
			   (RegOffset)), (ValueToWrite))

/****************************************************************************/
/**
*
* Set the Control Status Register of a timer counter to the specified value.
*
* @param	BaseAddress is the base address of the device.
* @param	TmrCtrNumber is the specific timer counter within the device, a
*		zero based number, 0 - (XTC_DEVICE_TIMER_COUNT - 1).
* @param	RegisterValue is the 32 bit value to be written to the register.
*
* @return	None.
*
* @note		C-Style signature:
* 		void XTmrCtr_mSetControlStatusReg(u32 BaseAddress,
*					u8 TmrCtrNumber,u32 RegisterValue);
*****************************************************************************/
#define XTmrCtr_mSetControlStatusReg(BaseAddress, TmrCtrNumber, RegisterValue)\
	XTmrCtr_mWriteReg((BaseAddress), (TmrCtrNumber), XTC_TCSR_OFFSET,     \
					   (RegisterValue))

/****************************************************************************/
/**
*
* Get the Control Status Register of a timer counter.
*
* @param	BaseAddress is the base address of the device.
* @param	TmrCtrNumber is the specific timer counter within the device, a
*		   zero based number, 0 - (XTC_DEVICE_TIMER_COUNT - 1).
*
* @return	The value read from the register, a 32 bit value.
*
* @note		C-Style signature:
* 		u32 XTmrCtr_mGetControlStatusReg(u32 BaseAddress,
*						u8 TmrCtrNumber);
*****************************************************************************/
#define XTmrCtr_mGetControlStatusReg(BaseAddress, TmrCtrNumber)		\
	XTimerCtr_mReadReg((BaseAddress), (TmrCtrNumber), XTC_TCSR_OFFSET)

/****************************************************************************/
/**
*
* Get the Timer Counter Register of a timer counter.
*
* @param	BaseAddress is the base address of the device.
* @param	TmrCtrNumber is the specific timer counter within the device, a
*		   zero based number, 0 - (XTC_DEVICE_TIMER_COUNT - 1).
*
* @return	The value read from the register, a 32 bit value.
*
* @note		C-Style signature:
* 		u32 XTmrCtr_mGetTimerCounterReg(u32 BaseAddress,
*						u8 TmrCtrNumber);
*****************************************************************************/
#define XTmrCtr_mGetTimerCounterReg(BaseAddress, TmrCtrNumber)		  \
	XTimerCtr_mReadReg((BaseAddress), (TmrCtrNumber), XTC_TCR_OFFSET) \

/****************************************************************************/
/**
*
* Set the Load Register of a timer counter to the specified value.
*
* @param	BaseAddress is the base address of the device.
* @param	TmrCtrNumber is the specific timer counter within the device, a
*		zero based number, 0 - (XTC_DEVICE_TIMER_COUNT - 1).
* @param	RegisterValue is the 32 bit value to be written to the register.
*
* @return	None.
*
* @note		C-Style signature:
* 		void XTmrCtr_mSetLoadReg(u32 BaseAddress, u8 TmrCtrNumber,
*						  u32 RegisterValue);
*****************************************************************************/
#define XTmrCtr_mSetLoadReg(BaseAddress, TmrCtrNumber, RegisterValue)	 \
	XTmrCtr_mWriteReg((BaseAddress), (TmrCtrNumber), XTC_TLR_OFFSET, \
					   (RegisterValue))

/****************************************************************************/
/**
*
* Get the Load Register of a timer counter.
*
* @param	BaseAddress is the base address of the device.
* @param	TmrCtrNumber is the specific timer counter within the device, a
*		zero based number, 0 - (XTC_DEVICE_TIMER_COUNT - 1).
*
* @return	The value read from the register, a 32 bit value.
*
* @note		C-Style signature:
* 		u32 XTmrCtr_mGetLoadReg(u32 BaseAddress, u8 TmrCtrNumber);
*****************************************************************************/
#define XTmrCtr_mGetLoadReg(BaseAddress, TmrCtrNumber)	\
XTimerCtr_mReadReg((BaseAddress), (TmrCtrNumber), XTC_TLR_OFFSET)

/****************************************************************************/
/**
*
* Enable a timer counter such that it starts running.
*
* @param	BaseAddress is the base address of the device.
* @param	TmrCtrNumber is the specific timer counter within the device, a
*		zero based number, 0 - (XTC_DEVICE_TIMER_COUNT - 1).
*
* @return	None.
*
* @note		C-Style signature:
* 		void XTmrCtr_mEnable(u32 BaseAddress, u8 TmrCtrNumber);
*****************************************************************************/
#define XTmrCtr_mEnable(BaseAddress, TmrCtrNumber)			    \
	XTmrCtr_mWriteReg((BaseAddress), (TmrCtrNumber), XTC_TCSR_OFFSET,   \
			(XTimerCtr_mReadReg((BaseAddress), ( TmrCtrNumber), \
			XTC_TCSR_OFFSET) | XTC_CSR_ENABLE_TMR_MASK))
/****************************************************************************/
/**
*
* Disable a timer counter such that it stops running.
*
* @param	BaseAddress is the base address of the device.
* @param	TmrCtrNumber is the specific timer counter within the device,
*		a zero based number, 0 - (XTC_DEVICE_TIMER_COUNT - 1).
*
* @return	None.
*
* @note		C-Style signature:
* 		void XTmrCtr_mDisable(u32 BaseAddress, u8 TmrCtrNumber);
*****************************************************************************/
#define XTmrCtr_mDisable(BaseAddress, TmrCtrNumber)			  \
	XTmrCtr_mWriteReg((BaseAddress), (TmrCtrNumber), XTC_TCSR_OFFSET, \
			(XTimerCtr_mReadReg((BaseAddress), (TmrCtrNumber),\
			XTC_TCSR_OFFSET) & ~ XTC_CSR_ENABLE_TMR_MASK))
/****************************************************************************/
/**
*
* Enable the interrupt for a timer counter.
*
* @param	BaseAddress is the base address of the device.
* @param	TmrCtrNumber is the specific timer counter within the device, a
*		zero based number, 0 - (XTC_DEVICE_TIMER_COUNT - 1).
*
* @return	None.
*
* @note		C-Style signature:
* 		void XTmrCtr_mEnableIntr(u32 BaseAddress, u8 TmrCtrNumber);
*****************************************************************************/
#define XTmrCtr_mEnableIntr(BaseAddress, TmrCtrNumber)			    \
	XTmrCtr_mWriteReg((BaseAddress), (TmrCtrNumber), XTC_TCSR_OFFSET,   \
			(XTimerCtr_mReadReg((BaseAddress), (TmrCtrNumber),  \
			XTC_TCSR_OFFSET) | XTC_CSR_ENABLE_INT_MASK))
/****************************************************************************/
/**
*
* Disable the interrupt for a timer counter.
*
* @param	BaseAddress is the base address of the device.
* @param	TmrCtrNumber is the specific timer counter within the device, a
*		zero based number, 0 - (XTC_DEVICE_TIMER_COUNT - 1).
*
* @return	None.
*
* @note		C-Style signature:
* 		void XTmrCtr_mDisableIntr(u32 BaseAddress, u8 TmrCtrNumber);
*****************************************************************************/
#define XTmrCtr_mDisableIntr(BaseAddress, TmrCtrNumber)			   \
	XTmrCtr_mWriteReg((BaseAddress), (TmrCtrNumber), XTC_TCSR_OFFSET,  \
	(XTimerCtr_mReadReg((BaseAddress), (TmrCtrNumber),		   \
		XTC_TCSR_OFFSET) & ~ XTC_CSR_ENABLE_INT_MASK))
/****************************************************************************/
/**
*
* Cause the timer counter to load it's Timer Counter Register with the value
* in the Load Register.
*
* @param	BaseAddress is the base address of the device.
* @param	TmrCtrNumber is the specific timer counter within the device, a
*		   zero based number, 0 - (XTC_DEVICE_TIMER_COUNT - 1).
*
* @return	None.
*
* @note		C-Style signature:
* 		void XTmrCtr_mLoadTimerCounterReg(u32 BaseAddress,
					u8 TmrCtrNumber);
*****************************************************************************/
#define XTmrCtr_mLoadTimerCounterReg(BaseAddress, TmrCtrNumber)		  \
	XTmrCtr_mWriteReg((BaseAddress), (TmrCtrNumber), XTC_TCSR_OFFSET, \
			(XTimerCtr_mReadReg((BaseAddress), (TmrCtrNumber),\
			XTC_TCSR_OFFSET) | XTC_CSR_LOAD_MASK))
/****************************************************************************/
/**
*
* Determine if a timer counter event has occurred.  Events are defined to be
* when a capture has occurred or the counter has roller over.
*
* @param	BaseAddress is the base address of the device.
* @param	TmrCtrNumber is the specific timer counter within the device, a
*		zero based number, 0 - (XTC_DEVICE_TIMER_COUNT - 1).
*
* @note		C-Style signature:
* 		int XTmrCtr_mHasEventOccurred(u32 BaseAddress, u8 TmrCtrNumber);
*****************************************************************************/
#define XTmrCtr_mHasEventOccurred(BaseAddress, TmrCtrNumber)		\
		((XTimerCtr_mReadReg((BaseAddress), (TmrCtrNumber),	\
		XTC_TCSR_OFFSET) & XTC_CSR_INT_OCCURED_MASK) ==		\
		XTC_CSR_INT_OCCURED_MASK)
/************************** Function Prototypes ******************************/
/************************** Variable Definitions *****************************/
#ifdef __cplusplus
}
#endif
#endif /* end of protection macro */

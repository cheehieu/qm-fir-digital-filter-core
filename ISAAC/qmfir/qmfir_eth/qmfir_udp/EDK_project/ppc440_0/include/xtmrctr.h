/* $Id: xtmrctr.h,v 1.1 2008/08/27 11:34:06 sadanan Exp $ */
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
*       (c) Copyright 2002-2008 Xilinx Inc.
*       All rights reserved.
*
******************************************************************************/
/*****************************************************************************/
/**
*
* @file xtmrctr.h
*
* The Xilinx timer/counter component. This component supports the Xilinx
* timer/counter. More detailed description of the driver operation can
* be found in the xtmrctr.c file.
*
* The Xilinx timer/counter supports the following features:
*   - Polled mode.
*   - Interrupt driven mode
*   - enabling and disabling specific timers
*   - PWM operation
*
* The driver does not currently support the PWM operation of the device.
*
* The timer counter operates in 2 primary modes, compare and capture. In
* either mode, the timer counter may count up or down, with up being the
* default.
*
* Compare mode is typically used for creating a single time period or multiple
* repeating time periods in the auto reload mode, such as a periodic interrupt.
* When started, the timer counter loads an initial value, referred to as the
* compare value, into the timer counter and starts counting down or up. The
* timer counter expires when it rolls over/under depending upon the mode of
* counting. An external compare output signal may be configured such that a
* pulse is generated with this signal when it hits the compare value.
*
* Capture mode is typically used for measuring the time period between
* external events. This mode uses an external capture input signal to cause
* the value of the timer counter to be captured. When started, the timer
* counter loads an initial value, referred to as the compare value,

* The timer can be configured to either cause an interrupt when the count
* reaches the compare value in compare mode or latch the current count
* value in the capture register when an external input is asserted
* in capture mode. The external capture input can be enabled/disabled using the
* XTmrCtr_SetOptions function. While in compare mode, it is also possible to
* drive an external output when the compare value is reached in the count
* register The external compare output can be enabled/disabled using the
* XTmrCtr_SetOptions function.
*
* <b>Interrupts</b>
*
* It is the responsibility of the application to connect the interrupt
* handler of the timer/counter to the interrupt source. The interrupt
* handler function, XTmrCtr_InterruptHandler, is visible such that the user
* can connect it to the interrupt source. Note that this interrupt handler
* does not provide interrupt context save and restore processing, the user
* must perform this processing.
*
* The driver services interrupts and passes timeouts to the upper layer
* software through callback functions. The upper layer software must register
* its callback functions during initialization. The driver requires callback
* functions for timers.
*
* @note
* The default settings for the timers are:
*   - Interrupt generation disabled
*   - Count up mode
*   - Compare mode
*   - Hold counter (will not reload the timer)
*   - External compare output disabled
*   - External capture input disabled
*   - Pulse width modulation disabled
*   - Timer disabled, waits for Start function to be called
* <br><br>
* A timer counter device may contain multiple timer counters. The symbol
* XTC_DEVICE_TIMER_COUNT defines the number of timer counters in the device.
* The device currently contains 2 timer counters.
* <br><br>
* This driver is intended to be RTOS and processor independent. It works with
* physical addresses only. Any needs for dynamic memory management, threads
* or thread mutual exclusion, virtual memory, or cache control must be
* satisfied by the layer above this driver.
*
* <pre>
* MODIFICATION HISTORY:
*
* Ver   Who  Date     Changes
* ----- ---- -------- -----------------------------------------------
* 1.00a ecm  08/16/01 First release
* 1.00b jhl  02/21/02 Repartitioned the driver for smaller files
* 1.10b mta  03/21/07 Updated to new coding style.
* 1.11a sdm  08/22/08 Removed support for static interrupt handlers from the MDD
*		      file
* </pre>
*
******************************************************************************/

#ifndef XTMRCTR_H		/* prevent circular inclusions */
#define XTMRCTR_H		/* by using protection macros */

#ifdef __cplusplus
extern "C" {
#endif

/***************************** Include Files *********************************/

#include "xbasic_types.h"
#include "xstatus.h"
#include "xtmrctr_l.h"

/************************** Constant Definitions *****************************/

/**
 * @name Configuration options
 * These options are used in XTmrCtr_SetOptions() and XTmrCtr_GetOptions()
 * @{
 */
/**
 * Used to configure the timer counter device.
 * <pre>
 * XTC_ENABLE_ALL_OPTION	Enables all timer counters at once.
 * XTC_DOWN_COUNT_OPTION	Configures the timer counter to count down from
 *				start value, the default is to count up.
 * XTC_CAPTURE_MODE_OPTION	Configures the timer to capture the timer
 *				counter value when the external capture line is
 *				asserted. The default mode is compare mode.
 * XTC_INT_MODE_OPTION		Enables the timer counter interrupt output.
 * XTC_AUTO_RELOAD_OPTION	In compare mode, configures the timer counter to
 *				reload from the compare value. The default mode
 *				causes the timer counter to hold when the
 *				compare value is hit.
 *				In capture mode, configures the timer counter to
 *				not hold the previous capture value if a new
 *				event occurs. The default mode cause the timer
 *				counter to hold the capture value until
 *				recognized.
 * XTC_EXT_COMPARE_OPTION	Enables the external compare output signal.
 * </pre>
 */
#define XTC_ENABLE_ALL_OPTION		0x00000040UL
#define XTC_DOWN_COUNT_OPTION		0x00000020UL
#define XTC_CAPTURE_MODE_OPTION		0x00000010UL
#define XTC_INT_MODE_OPTION		0x00000008UL
#define XTC_AUTO_RELOAD_OPTION		0x00000004UL
#define XTC_EXT_COMPARE_OPTION		0x00000002UL
/*@}*/

/**************************** Type Definitions *******************************/

/**
 * This typedef contains configuration information for the device.
 */
typedef struct {
	u16 DeviceId;	/**< Unique ID  of device */
	u32 BaseAddress;/**< Register base address */
} XTmrCtr_Config;

/**
 * Signature for the callback function.
 *
 * @param	CallBackRef is a callback reference passed in by the upper layer
 *		when setting the callback functions, and passed back to the
 *		upper layer when the callback is invoked. Its type is
 *		 unimportant to the driver, so it is a void pointer.
 * @param 	TmrCtrNumber is the number of the timer/counter within the
 *		device. The device typically contains at least two
 *		timer/counters. The timer number is a zero based number with a
 *		range of 0 to (XTC_DEVICE_TIMER_COUNT - 1).
 */
typedef void (*XTmrCtr_Handler) (void *CallBackRef, u8 TmrCtrNumber);


/**
 * Timer/Counter statistics
 */
typedef struct {
	u32 Interrupts;	 /**< The number of interrupts that have occurred */
} XTmrCtrStats;

/**
 * The XTmrCtr driver instance data. The user is required to allocate a
 * variable of this type for every timer/counter device in the system. A
 * pointer to a variable of this type is then passed to the driver API
 * functions.
 */
typedef struct {
	XTmrCtrStats Stats;	 /**< Component Statistics */
	u32 BaseAddress;	 /**< Base address of registers */
	u32 IsReady;		 /**< Device is initialized and ready */

	XTmrCtr_Handler Handler; /**< Callback function */
	void *CallBackRef;	 /**< Callback reference for handler */
} XTmrCtr;


/***************** Macros (Inline Functions) Definitions *********************/


/************************** Function Prototypes ******************************/

/*
 * Required functions, in file xtmrctr.c
 */
int XTmrCtr_Initialize(XTmrCtr * InstancePtr, u16 DeviceId);
void XTmrCtr_Start(XTmrCtr * InstancePtr, u8 TmrCtrNumber);
void XTmrCtr_Stop(XTmrCtr * InstancePtr, u8 TmrCtrNumber);
u32 XTmrCtr_GetValue(XTmrCtr * InstancePtr, u8 TmrCtrNumber);
void XTmrCtr_SetResetValue(XTmrCtr * InstancePtr, u8 TmrCtrNumber,
			   u32 ResetValue);
u32 XTmrCtr_GetCaptureValue(XTmrCtr * InstancePtr, u8 TmrCtrNumber);
int XTmrCtr_IsExpired(XTmrCtr * InstancePtr, u8 TmrCtrNumber);
void XTmrCtr_Reset(XTmrCtr * InstancePtr, u8 TmrCtrNumber);

XTmrCtr_Config *XTmrCtr_LookupConfig(u16 DeviceId);

/*
 * Functions for options, in file xtmrctr_options.c
 */
void XTmrCtr_SetOptions(XTmrCtr * InstancePtr, u8 TmrCtrNumber, u32 Options);
u32 XTmrCtr_GetOptions(XTmrCtr * InstancePtr, u8 TmrCtrNumber);

/*
 * Functions for statistics, in file xtmrctr_stats.c
 */
void XTmrCtr_GetStats(XTmrCtr * InstancePtr, XTmrCtrStats * StatsPtr);
void XTmrCtr_ClearStats(XTmrCtr * InstancePtr);

/*
 * Functions for self-test, in file xtmrctr_selftest.c
 */
int XTmrCtr_SelfTest(XTmrCtr * InstancePtr, u8 TmrCtrNumber);

/*
 * Functions for interrupts, in file xtmrctr_intr.c
 */
void XTmrCtr_SetHandler(XTmrCtr * InstancePtr, XTmrCtr_Handler FuncPtr,
			void *CallBackRef);
void XTmrCtr_InterruptHandler(void *InstancePtr);

#ifdef __cplusplus
}
#endif

#endif /* end of protection macro */

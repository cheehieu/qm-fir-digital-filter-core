/* $Id: xsysmon.h,v 1.1.2.1 2009/10/07 11:14:16 sadanan Exp $ */
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
/****************************************************************************/
/**
*
* @file xsysmon.h
*
* The XSysMon driver supports the Xilinx System Monitor/ADC device.
*
* The System Monitor/ADC device has the following features:
*	- 10-bit, 200-KSPS (kilo samples per second)
*		Analog-to-Digital Converter (ADC)
*	- Monitoring of on-chip supply voltages and temperature
*	- 1 dedicated differential analog-input pair and
*	  16 auxiliary differential analog-input pairs
*	- Automatic alarms based on user defined limits for the on-chip
*	  supply voltages and temperature
*	- Automatic Channel Sequencer, programmable averaging, programmable
*	  acquisition time for the external inputs, unipolar or differential
*	  input selection for the external inputs
*	- Inbuilt Calibration
*	- Optional interrupt request generation
*
*
* The user should refer to the hardware device specification for detailed
* information about the device.
*
* This header file contains the prototypes of driver functions that can
* be used to access the System Monitor/ADC device.
*
*
* <b> System Monitor Channel Sequencer Modes </b>
*
* The  System Monitor Channel Sequencer supports the following operating modes:
*
*   - <b> Default </b>: This is the default mode after power up.
*		In this mode of operation the System Monitor operates in
*		a sequence mode, monitoring the on chip sensors:
*		Temperature, VCCINT, and VCCAUX.
*   - <b> One pass through sequence </b>: In this mode the System Monitor
*		converts the channels enabled in the Sequencer Channel Enable
*		registers for a single pass and then stops.
*   - <b> Continuous cycling of sequence </b>: In this mode the System Monitor
*		converts the channels enabled in the Sequencer Channel Enable
*		registers continuously.
*   - <b> Single channel mode</b>: In this mode the System Monitor Channel
*		Sequencer is disabled and the System Monitor operates in a
*		Single Channel Mode.
*		The System Monitor can operate either in a Continuous or Event
*		driven sampling mode in the single channel mode.
*
* <b> Initialization and Configuration </b>
*
* The device driver enables higher layer software (e.g., an application) to
* communicate to the System Monitor/ADC device.
*
* XSysMon_CfgInitialize() API is used to initialize the System Monitor/ADC
* device. The user needs to first call the XSysMon_LookupConfig() API which
* returns the Configuration structure pointer which is passed as a parameter to
* the XSysMon_CfgInitialize() API.
*
*
* <b>Interrupts</b>
*
* The System Monitor/ADC device supports interrupt driven mode and the default
* operation mode is polling mode.
*
* The interrupt mode is available only if hardware is configured to support
* interrupts.
*
* This driver does not provide a Interrupt Service Routine (ISR) for the device.
* It is the responsibility of the application to provide one if needed. Refer to
* the interrupt example provided with this driver for details on using the
* device in interrupt mode.
*
*
* <b> Virtual Memory </b>
*
* This driver supports Virtual Memory. The RTOS is responsible for calculating
* the correct device base address in Virtual Memory space.
*
*
* <b> Threads </b>
*
* This driver is not thread safe. Any needs for threads or thread mutual
* exclusion must be satisfied by the layer above this driver.
*
*
* <b> Asserts </b>
*
* Asserts are used within all Xilinx drivers to enforce constraints on argument
* values. Asserts can be turned off on a system-wide basis by defining, at
* compile time, the NDEBUG identifier. By default, asserts are turned on and it
* is recommended that users leave asserts on during development.
*
*
* <b> Building the driver </b>
*
* The XSysMon driver is composed of several source files. This allows the user
* to build and link only those parts of the driver that are necessary.
*
* <b> Limitations of the driver </b>
*
* System Monitor/ADC device can be accessed through the JTAG port and the PLB
* interface. The driver implementation does not support the simultaneous access
* of the device by both these interfaces. The user has to care of this situation
* in the user application code.
*
* <br><br>
*
* <pre>
*
* MODIFICATION HISTORY:
*
* Ver   Who    Date     Changes
* ----- -----  -------- -----------------------------------------------------
* 1.00a xd/sv  05/22/07 First release
* 2.00a sv     07/07/08 Added bit definitions for new Alarm Interrupts in the
*			Interrupt Registers. Changed the ADC data functions
*			to return 16 bits of data. Added macros for conversion
*			from Raw Data to Temperature/Voltage and vice-versa.
* 3.00a sdm    02/09/09 Added APIs and bit definitions for V6 SysMon.
*
* </pre>
*
*****************************************************************************/

#ifndef XSYSMON_H /* Prevent circular inclusions */
#define XSYSMON_H /* by using protection macros  */

#ifdef __cplusplus
extern "C" {
#endif

/***************************** Include Files ********************************/

#include "xbasic_types.h"
#include "xstatus.h"
#include "xsysmon_hw.h"

/************************** Constant Definitions ****************************/


/**
 * @name Indexes for the different channels.
 * @{
 */
#define XSM_CH_TEMP		0  /**< On Chip Temperature */
#define XSM_CH_VCCINT		1  /**< VCCINT */
#define XSM_CH_VCCAUX		2  /**< VCCAUX */
#define XSM_CH_VPVN		3  /**< VP/VN Dedicated analog inputs */
#define XSM_CH_VREFP		4  /**< VREFP */
#define XSM_CH_VREFN		5  /**< VREFN */
#define XSM_CH_CALIBRATION	8  /**< Calibration */
#define XSM_CH_AUX_MIN		16 /**< Channel number for 1st Aux Channel */
#define XSM_CH_AUX_MAX		31 /**< Channel number for Last Aux channel */

/*@}*/


/**
 * @name Indexes for reading the Calibration Coefficient Data.
 * @{
 */
#define XSM_CALIB_SUPPLY_OFFSET_COEFF 0 /**< Supply Offset Calib Coefficient */
#define XSM_CALIB_ADC_OFFSET_COEFF    1 /**< ADC Offset Calib Coefficient */
#define XSM_CALIB_GAIN_ERROR_COEFF    2 /**< Gain Error Calib Coefficient*/

/*@}*/


/**
 * @name Indexes for reading the Minimum/Maximum Measurement Data.
 * @{
 */
#define XSM_MAX_TEMP	  0 /**< Maximum Temperature Data */
#define XSM_MAX_VCCINT	  1 /**< Maximum VCCINT Data */
#define XSM_MAX_VCCAUX	  2 /**< Maximum VCCAUX Data */
#define XSM_MIN_TEMP	  4 /**< Minimum Temperature Data */
#define XSM_MIN_VCCINT	  5 /**< Minimum VCCINT Data */
#define XSM_MIN_VCCAUX	  6 /**< Minimum VCCAUX Data */

/*@}*/


/**
 * @name Alarm Threshold(Limit) Register (ATR) indexes.
 * @{
 */
#define XSM_ATR_TEMP_UPPER	0 /**< High user Temperature */
#define XSM_ATR_VCCINT_UPPER	1 /**< VCCINT high voltage limit register */
#define XSM_ATR_VCCAUX_UPPER	2 /**< VCCAUX high voltage limit register */
#define XSM_ATR_TEMP_LOWER	4 /**< Low user Temperature */
#define XSM_ATR_VCCINT_LOWER	5 /**< VCCINT high voltage limit register */
#define XSM_ATR_VCCAUX_LOWER	6 /**< VCCAUX low voltage limit register  */
#define XSM_ATR_OT_LOWER	7 /**< Lower Over Temperature limit */

/*@}*/


/**
 * @name Averaging to be done for the channels.
 * @{
 */
#define XSM_AVG_0_SAMPLES	0  /**< No Averaging */
#define XSM_AVG_16_SAMPLES	1  /**< Average 16 samples */
#define XSM_AVG_64_SAMPLES	2  /**< Average 64 samples */
#define XSM_AVG_256_SAMPLES	3  /**< Average 256 samples */

/*@}*/


/**
 * @name Channel Sequencer Modes of operation
 * @{
 */
#define XSM_SEQ_MODE_SAFE	0  /**< Default Safe Mode */
#define XSM_SEQ_MODE_ONEPASS	1  /**< Onepass through Sequencer */
#define XSM_SEQ_MODE_CONTINPASS	2  /**< Continuous Cycling Seqquencer */
#define XSM_SEQ_MODE_SINGCHAN	3  /**< Single channel - No Sequencing */

/*@}*/

/**************************** Type Definitions ******************************/

/**
 * This typedef contains configuration information for the System Monitor/ADC
 * device.
 */
typedef struct {
	u16  DeviceId;		/**< Unique ID of device */
	u32  BaseAddress;	/**< Device base address */
	int  IncludeInterrupt; 	/**< Supports Interrupt driven mode */

} XSysMon_Config;


/**
 * The driver's instance data. The user is required to allocate a variable
 * of this type for every System Monitor/ADC device in the system. A pointer to
 * a variable of this type is then passed to the driver API functions.
 */
typedef struct {
	XSysMon_Config Config;	/**< XSysMon_Config of current device */
	u32  IsReady;		/**< Device is initialized and ready  */

} XSysMon;

/***************** Macros (Inline Functions) Definitions ********************/

/****************************************************************************/
/**
*
* This macro checks if the SysMonitor/ADC device is in Event Sampling mode.
*
* @param	InstancePtr is a pointer to the XSysMon instance.
*
* @return
*		- TRUE if the device is in Event Sampling Mode.
*		- FALSE if the device is in Continuous Sampling Mode.
*
* @note		C-Style signature:
*		int XSysMon_mIsEventSamplingMode(XSysMon *InstancePtr);
*
*****************************************************************************/
#define XSysMon_mIsEventSamplingModeSet(InstancePtr)			\
	(((XSysMon_mReadReg((InstancePtr)->Config.BaseAddress, 		\
				XSM_CFR0_OFFSET) & XSM_CFR0_EC_MASK) ?	\
				TRUE : FALSE))

/****************************************************************************/
/**
*
* This macro checks if the Dynamic Reconfiguration Port (DRP) transaction from
* the JTAG is in progress.
*
* @param	InstancePtr is a pointer to the XSysMon instance.
*
* @return
*		- TRUE if the DRP transaction from JTAG is in Progress.
*		- FALSE if there is no DRP transaction from the JTAG.
*
* @note		C-Style signature:
*		int XSysMon_mIsDrpBusy(XSysMon *InstancePtr);
*
*****************************************************************************/
#define XSysMon_mIsDrpBusy(InstancePtr)					  \
	((XSysMon_mReadReg((InstancePtr)->Config.BaseAddress, 		  \
				XSM_SR_OFFSET) & XSM_SR_JTAG_BUSY_MASK) ? \
				TRUE : FALSE)

/****************************************************************************/
/**
*
* This macro checks if the Dynamic Reconfiguration Port (DRP) is locked by the
* JTAG.
*
* @param	InstancePtr is a pointer to the XSysMon instance.
*
* @return
*		- TRUE if the DRP is locked by the JTAG.
*		- FALSE if the DRP is not locked by the JTAG.
*
* @note		C-Style signature:
*		int XSysMon_mIsDrpLocked(XSysMon *InstancePtr);
*
*****************************************************************************/
#define XSysMon_mIsDrpLocked(InstancePtr)				    \
	(((XSysMon_mReadReg((InstancePtr)->Config.BaseAddress, 		    \
				XSM_SR_OFFSET) & XSM_SR_JTAG_LOCKED_MASK) ? \
				TRUE : FALSE))

/****************************************************************************/
/**
*
* This macro converts System Monitor/ADC Raw Data to Temperature(centigrades).
*
* @param	AdcData is the SysMon Raw ADC Data.
*
* @return 	The Temperature in centigrades.
*
* @note		C-Style signature:
*		float XSysMon_mRawToTemperature(u32 AdcData);
*
*****************************************************************************/
#define XSysMon_mRawToTemperature(AdcData)				\
	((((float)(AdcData)/65536.0f)/0.00198421639f ) - 273.15f)

/****************************************************************************/
/**
*
* This macro converts System Monitor/ADC Raw Data to Voltage(volts).
*
* @param	AdcData is the System Monitor/ADC Raw Data.
*
* @return 	The Voltage in volts.
*
* @note		C-Style signature:
*		float XSysMon_mRawToVoltage(u32 AdcData);
*
*****************************************************************************/
#define XSysMon_mRawToVoltage(AdcData) 					\
	((((float)(AdcData))* (3.0f))/65536.0f)

/****************************************************************************/
/**
*
* This macro converts Temperature in centigrades to System Monitor/ADC Raw Data.
*
* @param	Temperature is the Temperature in centigrades to be
*		converted to System Monitor/ADC Raw Data.
*
* @return 	The System Monitor/ADC Raw Data.
*
* @note		C-Style signature:
*		int XSysMon_mTemperatureToRaw(float Temperature);
*
*****************************************************************************/
#define XSysMon_mTemperatureToRaw(Temperature)				\
	((int)(((Temperature) + 273.15f)*65536.0f*0.00198421639f))

/****************************************************************************/
/**
*
* This macro converts Voltage in Volts to System Monitor/ADC Raw Data.
*
* @param	Voltage is the Voltage in volts to be converted to
*		System Monitor/ADC Raw Data.
*
* @return 	The System Monitor/ADC Raw Data.
*
* @note		C-Style signature:
*		int XSysMon_mVoltageToRaw(float Voltage);
*
*****************************************************************************/
#define XSysMon_mVoltageToRaw(Voltage)			 		\
	((int)((Voltage)*65536.0f/3.0f))

/************************** Function Prototypes *****************************/

/**
 * Functions in xsysmon_sinit.c
 */
XSysMon_Config *XSysMon_LookupConfig(u16 DeviceId);

/**
 * Functions in xsysmon.c
 */
int XSysMon_CfgInitialize(XSysMon *InstancePtr,
				XSysMon_Config *ConfigPtr,
				u32 EffectiveAddr);

void XSysMon_Reset(XSysMon *InstancePtr);

u32 XSysMon_GetStatus(XSysMon *InstancePtr);

u32 XSysMon_GetAlarmOutputStatus(XSysMon *InstancePtr);

void XSysMon_StartAdcConversion(XSysMon *InstancePtr);

void XSysMon_ResetAdc(XSysMon *InstancePtr);

u16 XSysMon_GetAdcData(XSysMon *InstancePtr, u8 Channel);

u16 XSysMon_GetCalibCoefficient(XSysMon *InstancePtr, u8 CoeffType);

u16 XSysMon_GetMinMaxMeasurement(XSysMon *InstancePtr, u8 MeasurementType);

void XSysMon_SetAvg(XSysMon *InstancePtr, u8 Average);
u8 XSysMon_GetAvg(XSysMon *InstancePtr);

int XSysMon_SetSingleChParams(XSysMon *InstancePtr,
				u8 Channel,
				int IncreaseAcqCycles,
				int IsEventMode,
				int IsDifferentialMode);

void XSysMon_SetAlarmEnables(XSysMon *InstancePtr, u16 AlmEnableMask);
u16 XSysMon_GetAlarmEnables(XSysMon *InstancePtr);

void XSysMon_SetCalibEnables(XSysMon *InstancePtr, u16 Calibration);
u16 XSysMon_GetCalibEnables(XSysMon *InstancePtr);

void XSysMon_SetSequencerMode(XSysMon *InstancePtr, u8 SequencerMode);
u8 XSysMon_GetSequencerMode(XSysMon *InstancePtr);

void XSysMon_SetAdcClkDivisor(XSysMon *InstancePtr, u8 Divisor);
u8 XSysMon_GetAdcClkDivisor(XSysMon *InstancePtr);

int XSysMon_SetSeqChEnables(XSysMon *InstancePtr, u32 ChEnableMask);
u32 XSysMon_GetSeqChEnables(XSysMon *InstancePtr);

int XSysMon_SetSeqAvgEnables(XSysMon *InstancePtr, u32 AvgEnableChMask);
u32 XSysMon_GetSeqAvgEnables(XSysMon *InstancePtr);

int XSysMon_SetSeqInputMode(XSysMon *InstancePtr, u32 InputModeChMask);
u32 XSysMon_GetSeqInputMode(XSysMon *InstancePtr);

int XSysMon_SetSeqAcqTime(XSysMon *InstancePtr, u32 AcqCyclesChMask);
u32 XSysMon_GetSeqAcqTime(XSysMon *InstancePtr);

void XSysMon_SetAlarmThreshold(XSysMon *InstancePtr, u8 AlarmThrReg, u16 Value);
u16 XSysMon_GetAlarmThreshold(XSysMon *InstancePtr, u8 AlarmThrReg);

void XSysMon_SetOverTemp(XSysMon *InstancePtr, u16 Value);
u16 XSysMon_GetOverTemp(XSysMon *InstancePtr);

void XSysMon_EnableUserOverTemp(XSysMon *InstancePtr);
void XSysMon_DisableUserOverTemp(XSysMon *InstancePtr);

/**
 * Functions in xsysmon_selftest.c
 */
int XSysMon_SelfTest(XSysMon *InstancePtr);

/**
 * Functions in xsysmon_intr.c
 */
void XSysMon_IntrGlobalEnable(XSysMon *InstancePtr);
void XSysMon_IntrGlobalDisable(XSysMon *InstancePtr);

void XSysMon_IntrEnable(XSysMon *InstancePtr, u32 Mask);
void XSysMon_IntrDisable(XSysMon *InstancePtr, u32 Mask);
u32 XSysMon_IntrGetEnabled(XSysMon *InstancePtr);

u32 XSysMon_IntrGetStatus(XSysMon *InstancePtr);
void XSysMon_IntrClear(XSysMon *InstancePtr, u32 Mask);


#ifdef __cplusplus
}
#endif

#endif  /* End of protection macro. */

/* $Id: xsysmon.c,v 1.1.2.1 2009/10/07 11:14:16 sadanan Exp $ */
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
* @file xsysmon.c
*
* This file contains the driver API functions that can be used to access
* the System Monitor/ADC device.
*
* Refer to the xsysmon.h header file for more information about this driver.
*
* @note 	None.
*
* <pre>
*
* MODIFICATION HISTORY:
*
* Ver   Who    Date     Changes
* ----- -----  -------- -----------------------------------------------------
* 1.00a xd/sv  05/22/07 First release
* 2.00a sv     07/07/08 Modified the ADC data functions to return 16 bits of
*			data.
* 3.00a sdm    09/02/09 Added APIs for V6 SysMon.
*
* </pre>
*
*****************************************************************************/

/***************************** Include Files ********************************/

#include "xsysmon.h"

/************************** Constant Definitions ****************************/

/**************************** Type Definitions ******************************/

/***************** Macros (Inline Functions) Definitions ********************/

/************************** Function Prototypes *****************************/

/************************** Variable Definitions ****************************/


/*****************************************************************************/
/**
*
* This function initializes a specific XSysMon device/instance. This function
* must be called prior to using the System Monitor/ADC device.
*
* @param	InstancePtr is a pointer to the XSysMon instance.
* @param	ConfigPtr points to the XSysMon device configuration structure.
* @param	EffectiveAddr is the device base address in the virtual memory
*		address space. If the address translation is not used then the
*		physical address is passed.
*		Unexpected errors may occur if the address mapping is changed
*		after this function is invoked.
*
* @return
*		- XST_SUCCESS if successful.
*
* @note		The user needs to first call the XSysMon_LookupConfig() API
*		which returns the Configuration structure pointer which is
*		passed as a parameter to the XSysMon_CfgInitialize() API.
*
******************************************************************************/
int XSysMon_CfgInitialize(XSysMon *InstancePtr, XSysMon_Config *ConfigPtr,
				u32 EffectiveAddr)
{
	/*
	 * Assert the input arguments.
	 */
	XASSERT_NONVOID(InstancePtr != NULL);
	XASSERT_NONVOID(ConfigPtr != NULL);


    	/*
	 * Set the values read from the device config and the base address.
	 */
	InstancePtr->Config.DeviceId = ConfigPtr->DeviceId;
	InstancePtr->Config.BaseAddress = EffectiveAddr;
	InstancePtr->Config.IncludeInterrupt = ConfigPtr->IncludeInterrupt;

	/*
	 * Indicate the instance is now ready to use, initialized without error.
	 */
	InstancePtr->IsReady = XCOMPONENT_IS_READY;

	/*
	 * Reset the device such that it is in a known state.
	 */
	XSysMon_Reset(InstancePtr);


	return XST_SUCCESS;
}


/*****************************************************************************/
/**
*
* This function forces the software reset of the complete SystemMonitor/ADC
* Hard Macro and the SYSMON ADC Core Logic.
*
*
* @param	InstancePtr is a pointer to the XSysMon instance.
*
* @return	None.
*
* @note		The Control registers in the SystemMonitor/ADC Hard Macro
*		are not affected by this reset, only the Status registers
*		are reset.
*		Refer to the device data sheet for the device status and
*		register values after the reset.
*		Use the XSysMon_ResetAdc() to reset only the SystemMonitor/ADC
*		Hard Macro.
*
******************************************************************************/
void XSysMon_Reset(XSysMon *InstancePtr)
{
	/*
	 * Assert the arguments.
	 */
	XASSERT_VOID(InstancePtr != NULL);
	XASSERT_VOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);

	/*
	 * Write the reset value to the Software Reset Register (SRR) to
	 * Reset the device.
	 */
	XSysMon_mWriteReg(InstancePtr->Config.BaseAddress, XSM_SRR_OFFSET,
			  XSM_SRR_IPRST_MASK);
}

/****************************************************************************/
/**
*
* The functions reads the contents of the Status Register.
*
* @param	InstancePtr is a pointer to the XSysMon instance.
*
* @return	A 32-bit value representing the contents of the Status Register.
*		Use the XSM_SR_*_MASK constants defined in xsysmon_hw.h to
*		interpret the returned value.
*
* @note		None.
*
*****************************************************************************/
u32 XSysMon_GetStatus(XSysMon *InstancePtr)
{
	/*
	 * Assert the arguments.
	 */
	XASSERT_NONVOID(InstancePtr != NULL);
	XASSERT_NONVOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);

	/*
	 * Read the Status Register and return the value.
	 */
	return XSysMon_mReadReg(InstancePtr->Config.BaseAddress, XSM_SR_OFFSET);
}

/****************************************************************************/
/**
*
* This function reads the contents of Alarm Output Register.
*
* @param	InstancePtr is a pointer to the XSysMon instance.
*
* @return	A 32-bit value read from the Alarm Output Register.
*		Use the XSM_AOR_*_MASK constants defined in xsysmon_hw.h to
*		interpret the value.
*
* @note		None.
*
*****************************************************************************/
u32 XSysMon_GetAlarmOutputStatus(XSysMon *InstancePtr)
{
	/*
	 * Assert the arguments.
	 */
	XASSERT_NONVOID(InstancePtr != NULL);
	XASSERT_NONVOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);

	/*
	 * Read the Alarm Output Register and return the value.
	 */
	return (XSysMon_mReadReg(InstancePtr->Config.BaseAddress,
		XSM_AOR_OFFSET) & XSM_AOR_ALARM_ALL_MASK);
}

/****************************************************************************/
/**
*
* This function starts the ADC conversion in the Single Channel event driven
* sampling mode. The EOC bit in Status Register will be set once the conversion
* is finished. Refer to the device specification for more details.
*
* @param	InstancePtr is a pointer to the XSysMon instance.
*
* @return	None.
*
* @note		The default state of the CONVST bit is a logic 0. The conversion
*		is started when the CONVST bit is set to 1 from 0.
*		This bit is cleared in this function so that the next conversion
*		can be started by setting this bit.
*
*****************************************************************************/
void XSysMon_StartAdcConversion(XSysMon *InstancePtr)
{
	/*
	 * Assert the arguments.
	 */
	XASSERT_VOID(InstancePtr != NULL);
	XASSERT_VOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);


	/*
	 * Start the conversion by setting the CONVST bit.
	 */
	XSysMon_mWriteReg(InstancePtr->Config.BaseAddress,
			  XSM_CONVST_OFFSET, XSM_CONVST_CONVST_MASK);

	XSysMon_mWriteReg(InstancePtr->Config.BaseAddress,
			  XSM_CONVST_OFFSET, 0x0);

}

/*****************************************************************************/
/**
*
* This function resets the SystemMonitor/ADC Hard Macro in the device.
*
* @param	InstancePtr is a pointer to the XSysMon instance.
*
* @return	None.
*
* @note		The Control registers in the SystemMonitor/ADC Hard Macro
*		are not affected by this reset, only the Status registers
*		are reset.
*		This reset causes the ADC to begin with a new conversion.
* 		Refer to the device data sheet for the device status and
*		register values after the reset.
* 		Use the XSysMon_Reset() API to reset both the SystemMonitor/ADC
* 		Hard Macro and the SYSMON ADC Core Logic.
*
******************************************************************************/
void XSysMon_ResetAdc(XSysMon *InstancePtr)
{
	/*
	 * Assert the arguments.
	 */
	XASSERT_VOID(InstancePtr != NULL);
	XASSERT_VOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);

	/*
	 * Set the reset bit to the ADC Reset Register (ARR) to
	 * put the SystemMonitor/ADC Hard Macro in Reset.
	 */
	XSysMon_mWriteReg(InstancePtr->Config.BaseAddress, XSM_ARR_OFFSET,
			  XSM_ARR_RST_MASK);
	/*
	 * Clear the reset bit to the ADC Reset Register (ARR) to
	 * release the reset of SystemMonitor/ADC Hard Macro.
	 */
	XSysMon_mWriteReg(InstancePtr->Config.BaseAddress, XSM_ARR_OFFSET, 0x0);

}

/****************************************************************************/
/**
*
* Get the ADC converted data for the specified channel.
*
* @param	InstancePtr is a pointer to the XSysMon instance.
* @param	Channel is the channel number. Use the XSM_CH_* defined in
*		the file xsysmon.h. The valid channels are 0 to 5 and 16 to 31.
*
* @return	A 16-bit value representing the ADC converted data for the
*		specified channel. The System Monitor/ADC device guarantees
* 		a 10 bit resolution for the ADC converted data and data is the
*		10 MSB bits of the 16 data read from the device.
*
* @note		The channel 8 is used for calibration of the device and hence
*		there is no associated data with this channel.
*
*****************************************************************************/
u16 XSysMon_GetAdcData(XSysMon *InstancePtr, u8 Channel)
{

	u16 AdcData;
	/*
	 * Assert the arguments.
	 */
	XASSERT_NONVOID(InstancePtr != NULL);
	XASSERT_NONVOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);
	XASSERT_NONVOID((Channel <= XSM_CH_VREFN) ||
			 ((Channel >= XSM_CH_AUX_MIN) &&
			 (Channel <= XSM_CH_AUX_MAX)));

	/*
	 * Read the selected ADC converted data for the specified channel
	 * and return the value.
	 */
	AdcData = (u16) (XSysMon_mReadReg(InstancePtr->Config.BaseAddress,
			 XSM_TEMP_OFFSET + (Channel << 2)));

	return AdcData;
}

/****************************************************************************/
/**
*
* This function gets the calibration coefficient data for the specified
* parameter.
*
* @param	InstancePtr is a pointer to the XSysMon instance.
* @param	CoeffType specifies the calibration coefficient
*		to be read. Use XSM_CALIB_* constants defined in xsysmon.h to
*		specify the calibration coefficient to be read.
*
* @return	A 16-bit value representing the calibration coefficient.
*		The System Monitor/ADC device guarantees a 10 bit resolution for
*		the ADC converted data and data is the 10 MSB bits of the 16
*		data read from the device.
*
* @note		None.
*
*****************************************************************************/
u16 XSysMon_GetCalibCoefficient(XSysMon *InstancePtr, u8 CoeffType)
{
	u16 CalibData;

	/*
	 * Assert the arguments.
	 */
	XASSERT_NONVOID(InstancePtr != NULL);
	XASSERT_NONVOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);
	XASSERT_NONVOID(CoeffType <= XSM_CALIB_GAIN_ERROR_COEFF);

	/*
	 * Read the selected calibration coefficient.
	 */
	CalibData = (u16) XSysMon_mReadReg(InstancePtr->Config.BaseAddress,
			XSM_SUPPLY_CALIB_OFFSET + (CoeffType << 2));

	return CalibData;
}

/****************************************************************************/
/**
*
* This function reads the Minimum/Maximum measurement for one of the
* following parameters :
*		- Minimum Temperature (XSM_MIN_TEMP)
*		- Minimum VCCINT (XSM_MIN_VCCINT)
*		- Minimum VCCAUX (XSM_MIN_VCCAUX)
*		- Maximum Temperature (XSM_MAX_TEMP)
*		- Maximum VCCINT (XSM_MAX_VCCINT)
*		- Maximum VCCAUX (XSM_MAX_VCCAUX)
*
* @param	InstancePtr is a pointer to the XSysMon instance.
* @param	MeasurementType specifies the parameter for which the
*		Minimum/Maximum measurement has to be read.
*		Use XSM_MAX_* and XSM_MIN_* constants defined in xsysmon.h to
*		specify the data to be read.
*
* @return	A 16-bit value representing the maximum/minimum measurement for
*		specified parameter.
*		The System Monitor/ADC device guarantees a 10 bit resolution for
*		the ADC converted data and data is the 10 MSB bits of the 16
*		data read from the device.
*
* @note		None.
*
*****************************************************************************/
u16 XSysMon_GetMinMaxMeasurement(XSysMon *InstancePtr, u8 MeasurementType)
{
	u16 MinMaxData;
	/*
	 * Assert the arguments.
	 */
	XASSERT_NONVOID(InstancePtr != NULL);
	XASSERT_NONVOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);
	XASSERT_NONVOID((MeasurementType <= XSM_MAX_VCCAUX) ||
			((MeasurementType >= XSM_MIN_TEMP) &&
			(MeasurementType <= XSM_MIN_VCCAUX)))

	/*
	 * Read and return the specified Minimum/Maximum measurement.
	 */
	MinMaxData = (u16) (XSysMon_mReadReg(InstancePtr->Config.BaseAddress,
		XSM_MAX_TEMP_OFFSET + (MeasurementType << 2)));
	return MinMaxData;
}

/****************************************************************************/
/**
*
* This function sets the number of samples of averaging that is to be done for
* all the channels in both the single channel mode and sequence mode of
* operations.
*
* @param	InstancePtr is a pointer to the XSysMon instance.
* @param	Average is the number of samples of averaging programmed to the
*		Configuration Register 0. Use the XSM_AVG_* definitions defined
*		in xsysmon.h file :
*		- XSM_AVG_0_SAMPLES for no averaging
*		- XSM_AVG_16_SAMPLES for 16 samples of averaging
*		- XSM_AVG_64_SAMPLES for 64 samples of averaging
*		- XSM_AVG_256_SAMPLES for 256 samples of averaging
*
* @return	None.
*
* @note		None.
*
*****************************************************************************/
void XSysMon_SetAvg(XSysMon *InstancePtr, u8 Average)
{
	u32 RegValue;

	/*
	 * Assert the arguments.
	 */
	XASSERT_VOID(InstancePtr != NULL);
	XASSERT_VOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);
	XASSERT_VOID(Average <= XSM_AVG_256_SAMPLES);

	/*
	 * Write the averaging value into the Configuration Register 0.
	 */
	RegValue = XSysMon_mReadReg(InstancePtr->Config.BaseAddress,
					XSM_CFR0_OFFSET) &
					(~XSM_CFR0_AVG_VALID_MASK);
	RegValue |=  (((u32) Average << XSM_CFR0_AVG_SHIFT));
	XSysMon_mWriteReg(InstancePtr->Config.BaseAddress, XSM_CFR0_OFFSET,
					RegValue);

}

/****************************************************************************/
/**
*
* This function returns the number of samples of averaging configured for all
* the channels in the Configuration Register 0.
*
* @param	InstancePtr is a pointer to the XSysMon instance.
*
* @return	The averaging read from the Configuration Register 0 is
*		returned. Use the XSM_AVG_* bit definitions defined in xsysmon.h
*		file to interpret the returned value :
*		- XSM_AVG_0_SAMPLES means no averaging
*		- XSM_AVG_16_SAMPLES means 16 samples of averaging
*		- XSM_AVG_64_SAMPLES means 64 samples of averaging
*		- XSM_AVG_256_SAMPLES means 256 samples of averaging
*
* @note		None.
*
*****************************************************************************/
u8 XSysMon_GetAvg(XSysMon *InstancePtr)
{
	u32 Average;

	/*
	 * Assert the arguments.
	 */
	XASSERT_NONVOID(InstancePtr != NULL);
	XASSERT_NONVOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);

	/*
	 * Read the averaging value from the Configuration Register 0.
	 */
	Average = XSysMon_mReadReg(InstancePtr->Config.BaseAddress,
				   XSM_CFR0_OFFSET) & XSM_CFR0_AVG_VALID_MASK;

	return ((u8) (Average >> XSM_CFR0_AVG_SHIFT));
}

/****************************************************************************/
/**
*
* The function sets the given parameters in the Configuration Register 0 in
* the single channel mode.
*
* @param	InstancePtr is a pointer to the XSysMon instance.
* @param	Channel is the channel number for which averaging is to be set.
*		The valid channels are 0 to 5, 8, and 16 to 31.
* @param 	IncreaseAcqCycles is a boolean parameter which specifies whether
*		the Acquisition time for the external channels has to be
*		increased to 10 ADCCLK cycles (specify TRUE) or remain at the
*		default 4 ADCCLK cycles (specify FALSE). This parameter is
*		only valid for the external channels.
* @param 	IsEventMode is a boolean parameter that specifies continuous
*		sampling (specify FALSE) or event driven sampling mode (specify
*		TRUE) for the given channel.
* @param 	IsDifferentialMode is a boolean parameter which specifies
*		unipolar(specify FALSE) or differential mode (specify TRUE) for
*		the analog inputs. The 	input mode is only valid for the
*		external channels.
* @return
*		- XST_SUCCESS if the given values were written successfully to
*		the Configuration Register 0.
*		- XST_FAILURE if the channel sequencer is enabled or the input
*		parameters are not valid for the selected channel.
*
* @note
*		- The number of samples for the averaging for all the channels
*		is set by using the function XSysMon_SetAvg.
*		- The calibration of the device is done by doing a ADC
*		conversion on the calibration channel(channel 8). The input
*		parameters IncreaseAcqCycles, IsDifferentialMode and
*		IsEventMode are not valid for this channel.
*
*****************************************************************************/
int XSysMon_SetSingleChParams(XSysMon *InstancePtr,
				u8 Channel,
				int IncreaseAcqCycles,
				int IsEventMode,
				int IsDifferentialMode)
{
	u32 RegValue;

	/*
	 * Assert the arguments.
	 */
	XASSERT_NONVOID(InstancePtr != NULL);
	XASSERT_NONVOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);
	XASSERT_NONVOID((Channel <= XSM_CH_VREFN) ||
			(Channel == XSM_CH_CALIBRATION) ||
			((Channel >= XSM_CH_AUX_MIN) &&
			(Channel <= XSM_CH_AUX_MAX)));
	XASSERT_NONVOID((IncreaseAcqCycles == TRUE) ||
			(IncreaseAcqCycles == FALSE));
	XASSERT_NONVOID((IsEventMode == TRUE) || (IsEventMode == FALSE));
	XASSERT_NONVOID((IsDifferentialMode == TRUE) ||
			(IsDifferentialMode == FALSE));

	/*
	 * Check if the device is in single channel mode else return failure
	 */
	if ((XSysMon_GetSequencerMode(InstancePtr) != XSM_SEQ_MODE_SINGCHAN)) {
		return XST_FAILURE;
	}

	/*
	 * Read the Configuration Register 0.
	 */
	RegValue = XSysMon_mReadReg(InstancePtr->Config.BaseAddress,
					XSM_CFR0_OFFSET) &
					XSM_CFR0_AVG_VALID_MASK;

	/*
	 * Select the number of acquisition cycles. The acquisition cycles is
	 * only valid for the external channels.
	 */
	if (IncreaseAcqCycles == TRUE) {
		if (((Channel >= XSM_CH_AUX_MIN) && (Channel <= XSM_CH_AUX_MAX))
		||
			(Channel == XSM_CH_VPVN)){
			RegValue |= XSM_CFR0_ACQ_MASK;
		} else {
			return XST_FAILURE;
		}

	}

	/*
	 * Select the input mode. The input mode is only valid for the
	 * external channels.
	 */
	if (IsDifferentialMode == TRUE) {

		if (((Channel >= XSM_CH_AUX_MIN) && (Channel <= XSM_CH_AUX_MAX))
		||
			(Channel == XSM_CH_VPVN)){
			RegValue |= XSM_CFR0_DU_MASK;
		} else {

			return XST_FAILURE;

		}
	}

	/*
	 * Select the ADC mode.
	 */
	if (IsEventMode == TRUE) {

		RegValue |= XSM_CFR0_EC_MASK;
	}

	/*
	 * Write the given values into the Configuration Register 0.
	 */
	RegValue |= (Channel & XSM_CFR0_CHANNEL_MASK);
	XSysMon_mWriteReg(InstancePtr->Config.BaseAddress, XSM_CFR0_OFFSET,
				RegValue);

	return XST_SUCCESS;
}

/****************************************************************************/
/**
*
* This function enables the alarm outputs for the specified alarms in the
* Configuration Register 1 :
*		- ALM2 for VCCAUX (XSM_CFR1_ALM_VCCAUX_MASK)
*		- ALM1 for VCCINT (XSM_CFR1_ALM_VCCINT_MASK)
*		- ALM0 for On board Temperature (XSM_CFR1_ALM_TEMP_MASK)
*		- OT for Over Temperature (XSM_CFR1_OT_MASK)
*
* @param	InstancePtr is a pointer to the XSysMon instance.
* @param	AlmEnableMask is the bit-mask of the alarm outputs to be enabled
*		in the Configuration Register 1.
*		Bit positions of 1 will be enabled. Bit positions of 0 will be
*		disabled. This mask is formed by OR'ing XSM_CFR1_ALM_*_MASK and
*		XSM_CFR1_OT_MASK masks defined in xsysmon_hw.h.
*
* @return	None.
*
* @note		The implementation of the alarm enables in the Configuration
*		register 1 is such that the alarms for bit positions of 1 will
*		be disabled and alarms for bit positions of 0 will be enabled.
*		The alarm outputs specified by the AlmEnableMask are negated
*		before writing to the Configuration Register 1.
*
*****************************************************************************/
void XSysMon_SetAlarmEnables(XSysMon *InstancePtr, u16 AlmEnableMask)
{
	u32 RegValue;

	/*
	 * Assert the arguments.
	 */
	XASSERT_VOID(InstancePtr != NULL);
	XASSERT_VOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);
	XASSERT_VOID(AlmEnableMask <= XSM_CFR1_ALM_ALL_MASK);

	RegValue = XSysMon_mReadReg(InstancePtr->Config.BaseAddress,
					XSM_CFR1_OFFSET);
	RegValue &= (u32)~XSM_CFR1_ALM_ALL_MASK;
	RegValue |= (~AlmEnableMask & XSM_CFR1_ALM_ALL_MASK);

	/*
	 * Enable/disables the alarm enables for the specified alarm bits in the
	 * Configuration Register 1.
	 */
	XSysMon_mWriteReg(InstancePtr->Config.BaseAddress, XSM_CFR1_OFFSET,
				RegValue);
}

/****************************************************************************/
/**
*
* This function gets the status of the alarm output enables in the
* Configuration Register 1.
*
* @param	InstancePtr is a pointer to the XSysMon instance.
*
* @return	This is the bit-mask of the enabled alarm outputs in the
*		Configuration Register 1. Use the masks XSM_CFR1_ALM*_* and
*		XSM_CFR1_OT_MASK defined in xsysmon_hw.h to interpret the
*		returned value.
*		Bit positions of 1 indicate that the alarm output is enabled.
*		Bit positions of 0 indicate that the alarm output is disabled.
*
*
* @note		The implementation of the alarm enables in the Configuration
*		register 1 is such that alarms for the bit positions of 1 will
*		be disabled and alarms for bit positions of 0 will be enabled.
*		The enabled alarm outputs returned by this function is the
*		negated value of the the data read from the Configuration
*		Register 1.
*
*****************************************************************************/
u16 XSysMon_GetAlarmEnables(XSysMon *InstancePtr)
{
	u32 RegValue;

	/*
	 * Assert the arguments
	 */
	XASSERT_NONVOID(InstancePtr != NULL);
	XASSERT_NONVOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);

	/*
	 * Read the status of alarm output enables from the Configuration
	 * Register 1.
	 */
	RegValue = XSysMon_mReadReg(InstancePtr->Config.BaseAddress,
			XSM_CFR1_OFFSET) & XSM_CFR1_ALM_ALL_MASK;
	return (u16) (~RegValue & XSM_CFR1_ALM_ALL_MASK);
}

/****************************************************************************/
/**
*
* This function enables the specified calibration in the Configuration
* Register 1 :
*
*	- XSM_CFR1_CAL_ADC_OFFSET_MASK : Calibration 0 -ADC offset correction
*	- XSM_CFR1_CAL_ADC_GAIN_OFFSET_MASK : Calibration 1 -ADC gain and offset
*						correction
*	- XSM_CFR1_CAL_PS_OFFSET_MASK : Calibration 2 -Power Supply sensor
*					offset correction
*	- XSM_CFR1_CAL_PS_GAIN_OFFSET_MASK : Calibration 3 -Power Supply sensor
*						gain and offset correction
*	- XSM_CFR1_CAL_DISABLE_MASK : No Calibration
*
* @param	InstancePtr is a pointer to the XSysMon instance.
* @param	Calibration is the Calibration to be applied.
*		Use XSM_CFR1_CAL*_* bits defined in xsysmon_hw.h.
*		Multiple calibrations can be enabled at a time by oring the
*		XSM_CFR1_CAL_ADC_* and XSM_CFR1_CAL_PS_* bits.
*		Calibration can be disabled by specifying
		XSM_CFR1_CAL_DISABLE_MASK;
*
* @return	None.
*
* @note		None.
*
*****************************************************************************/
void XSysMon_SetCalibEnables(XSysMon *InstancePtr, u16 Calibration)
{
	u32 RegValue;

	/*
	 * Assert the arguments.
	 */
	XASSERT_VOID(InstancePtr != NULL);
	XASSERT_VOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);
	XASSERT_VOID(((Calibration >= XSM_CFR1_CAL_ADC_OFFSET_MASK) &&
			(Calibration <= XSM_CFR1_CAL_VALID_MASK)) ||
			(Calibration == XSM_CFR1_CAL_DISABLE_MASK));

	/*
	 * Set the specified calibration in the Configuration Register 1.
	 */
	RegValue = XSysMon_mReadReg(InstancePtr->Config.BaseAddress,
					XSM_CFR1_OFFSET);

	RegValue &= (~ XSM_CFR1_CAL_VALID_MASK);
	RegValue |= (Calibration & XSM_CFR1_CAL_VALID_MASK);
	XSysMon_mWriteReg(InstancePtr->Config.BaseAddress, XSM_CFR1_OFFSET,
				RegValue);

}

/****************************************************************************/
/**
*
* This function reads the value of the calibration enables from the
* Configuration Register 1.
*
* @param	InstancePtr is a pointer to the XSysMon instance.
*
* @return	The value of the calibration enables in the Configuration
*		Register 1 :
*		- XSM_CFR1_CAL_ADC_OFFSET_MASK : ADC offset correction
*		- XSM_CFR1_CAL_ADC_GAIN_OFFSET_MASK : ADC gain and offset
*				correction
*		- XSM_CFR1_CAL_PS_OFFSET_MASK : Power Supply sensor offset
*				correction
*		- XSM_CFR1_CAL_PS_GAIN_OFFSET_MASK : Power Supply sensor gain
*				and offset correction
*		- XSM_CFR1_CAL_DISABLE_MASK : No Calibration
*
* @note		None.
*
*****************************************************************************/
u16 XSysMon_GetCalibEnables(XSysMon *InstancePtr)
{
	/*
	 * Assert the arguments.
	 */
	XASSERT_NONVOID(InstancePtr != NULL);
	XASSERT_NONVOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);

	/*
	 * Read the calibration enables from the Configuration Register 1.
	 */
	return (u16) XSysMon_mReadReg(InstancePtr->Config.BaseAddress,
			XSM_CFR1_OFFSET) & XSM_CFR1_CAL_VALID_MASK;

}

/****************************************************************************/
/**
*
* This function sets the specified Channel Sequencer Mode in the Configuration
* Register 1 :
*		- Default safe mode (XSM_SEQ_MODE_SAFE)
*		- One pass through sequence (XSM_SEQ_MODE_ONEPASS)
*		- Continuous channel sequencing (XSM_SEQ_MODE_CONTINPASS)
*		- Single Channel/Sequencer off (XSM_SEQ_MODE_SINGCHAN)
*
* @param	InstancePtr is a pointer to the XSysMon instance.
* @param	SequencerMode is the sequencer mode to be set.
*		Use XSM_SEQ_MODE_* bits defined in xsysmon.h.
*
* @return	None.
*
* @note		Only one of the modes can be enabled at a time.
*
*****************************************************************************/
void XSysMon_SetSequencerMode(XSysMon *InstancePtr, u8 SequencerMode)
{
	u32 RegValue;

	/*
	 * Assert the arguments.
	 */
	XASSERT_VOID(InstancePtr != NULL);
	XASSERT_VOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);
	XASSERT_VOID(SequencerMode <= XSM_SEQ_MODE_SINGCHAN);

	/*
	 * Set the specified sequencer mode in the Configuration Register 1.
	 */
	RegValue = XSysMon_mReadReg(InstancePtr->Config.BaseAddress,
					XSM_CFR1_OFFSET);
	RegValue &= (~ XSM_CFR1_SEQ_VALID_MASK);
	RegValue |= ((SequencerMode  << XSM_CFR1_SEQ_SHIFT) &
					XSM_CFR1_SEQ_VALID_MASK);
	XSysMon_mWriteReg(InstancePtr->Config.BaseAddress, XSM_CFR1_OFFSET,
				RegValue);

}

/****************************************************************************/
/**
*
* This function gets the channel sequencer mode from the Configuration
* Register 1.
*
* @param	InstancePtr is a pointer to the XSysMon instance.
*
* @return	The channel sequencer mode :
*		- XSM_SEQ_MODE_SAFE : Default safe mode
*		- XSM_SEQ_MODE_ONEPASS : One pass through sequence
*		- XSM_SEQ_MODE_CONTINPASS : Continuous channel sequencing
*		- XSM_SEQ_MODE_SINGCHAN : Single channel/Sequencer off
*
*
* @note		None.
*
*****************************************************************************/
u8 XSysMon_GetSequencerMode(XSysMon *InstancePtr)
{
	/*
	 * Assert the arguments.
	 */
	XASSERT_NONVOID(InstancePtr != NULL);
	XASSERT_NONVOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);

	/*
	 * Read the channel sequencer mode from the Configuration Register 1.
	 */
	return ((u8) ((XSysMon_mReadReg(InstancePtr->Config.BaseAddress,
			XSM_CFR1_OFFSET) & XSM_CFR1_SEQ_VALID_MASK) >>
			XSM_CFR1_SEQ_SHIFT));

}

/****************************************************************************/
/**
*
* The function sets the frequency of the ADCCLK by configuring the DCLK to
* ADCCLK ratio in the Configuration Register #2
*
* @param	InstancePtr is a pointer to the XSysMon instance.
* @param	Divisor is clock divisor used to derive ADCCLK from DCLK.
*		Valid values of the divisor are
*		 - 8 to 255 for V5 SysMon.
*		 - 0 to 255 for V6 Sysmon. Values 0, 1, 2 are all mapped to 2.
*		Refer to the device specification for more details
*
* @return	None.
*
* @note		- The ADCCLK is an internal clock used by the ADC and is
*		  synchronized to the DCLK clock. The ADCCLK is equal to DCLK
*		  divided by the user selection in the Configuration Register 2.
*		- There is no Assert on the minimum value of the Divisor. Users
*		  must take care such that the minimum value of Divisor used is
*		  8, in case of V5 SysMon
*
*****************************************************************************/
void XSysMon_SetAdcClkDivisor(XSysMon *InstancePtr, u8 Divisor)
{
	/*
	 * Assert the arguments.
	 */
	XASSERT_VOID(InstancePtr != NULL);
	XASSERT_VOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);

	/*
	 * Write the divisor value into the Configuration Register #2.
	 */
	XSysMon_mWriteReg(InstancePtr->Config.BaseAddress, XSM_CFR2_OFFSET,
			  Divisor << XSM_CFR2_CD_SHIFT);

}

/****************************************************************************/
/**
*
* The function gets the ADCCLK divisor from the Configuration Register 2.
*
* @param	InstancePtr is a pointer to the XSysMon instance.
*
* @return	The divisor read from the Configuration Register 2.
*
* @note		The ADCCLK is an internal clock used by the ADC and is
*		synchronized to the DCLK clock. The ADCCLK is equal to DCLK
*		divided by the user selection in the Configuration Register 2.
*
*****************************************************************************/
u8 XSysMon_GetAdcClkDivisor(XSysMon *InstancePtr)
{
	u16 Divisor;

	/*
	 * Assert the arguments.
	 */
	XASSERT_NONVOID(InstancePtr != NULL);
	XASSERT_NONVOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);

	/*
	 * Read the divisor value from the Configuration Register 2.
	 */
	Divisor = (u16) XSysMon_mReadReg(InstancePtr->Config.BaseAddress,
					 XSM_CFR2_OFFSET);

	return (u8) (Divisor >> XSM_CFR2_CD_SHIFT);
}

/****************************************************************************/
/**
*
* This function enables the specified channels in the ADC Channel Selection
* Sequencer Registers. The sequencer must be disabled before writing to these
* regsiters.
*
* @param	InstancePtr is a pointer to the XSysMon instance.
* @param	ChEnableMask is the bit mask of all the channels to be enabled.
*		Use XSM_SEQ_CH__* defined in xsysmon_hw.h to specify the Channel
*		numbers. Bit masks of 1 will be enabled and bit mask of 0 will
*		be disabled.
*		The ChEnableMask is a 32 bit mask that is written to the two
*		16 bit ADC Channel Selection Sequencer Registers.
*
* @return
*		- XST_SUCCESS if the given values were written successfully to
*		the ADC Channel Selection Sequencer Registers.
*		- XST_FAILURE if the channel sequencer is enabled.
*
* @note		None
*
*****************************************************************************/
int XSysMon_SetSeqChEnables(XSysMon *InstancePtr, u32 ChEnableMask)
{
	/*
	 * Assert the arguments.
	 */
	XASSERT_NONVOID(InstancePtr != NULL);
	XASSERT_NONVOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);

	/*
	 * The sequencer must be disabled for writing any of these registers
	 * Return XST_FAILURE if the channel sequencer is enabled.
	 */
	if ((XSysMon_GetSequencerMode(InstancePtr) != XSM_SEQ_MODE_SINGCHAN)) {
		return XST_FAILURE;
	}

	/*
	 * Enable the specified channels in the ADC Channel Selection Sequencer
	 * Registers.
	 */
	XSysMon_mWriteReg(InstancePtr->Config.BaseAddress,
				XSM_SEQ00_OFFSET,
				(ChEnableMask & XSM_SEQ00_CH_VALID_MASK));

	XSysMon_mWriteReg(InstancePtr->Config.BaseAddress,
				XSM_SEQ01_OFFSET,
				(ChEnableMask >> XSM_SEQ_CH_AUX_SHIFT) &
				XSM_SEQ01_CH_VALID_MASK);

	return XST_SUCCESS;
}

/****************************************************************************/
/**
*
* This function gets the channel enable bits status from the ADC Channel
* Selection Sequencer Registers.
*
* @param	InstancePtr is a pointer to the XSysMon instance.
*
* @return	Gets the channel enable bits. Use XSM_SEQ_CH__* defined in
*		xsysmon_hw.h to interpret the Channel numbers. Bit masks of 1
*		are the channels that are enabled and bit mask of 0 are
*		the channels that are disabled.
*
* @return	None
*
* @note		None
*
*****************************************************************************/
u32 XSysMon_GetSeqChEnables(XSysMon *InstancePtr)
{
	u32 RegValEnable;

	/*
	 * Assert the arguments.
	 */
	XASSERT_NONVOID(InstancePtr != NULL);
	XASSERT_NONVOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);

	/*
	 *  Read the channel enable bits for all the channels from the ADC
	 *  Channel Selection Register.
	 */
	RegValEnable = XSysMon_mReadReg(InstancePtr->Config.BaseAddress,
				XSM_SEQ00_OFFSET) & XSM_SEQ00_CH_VALID_MASK;
	RegValEnable |= (XSysMon_mReadReg(InstancePtr->Config.BaseAddress,
				XSM_SEQ01_OFFSET) & XSM_SEQ01_CH_VALID_MASK) <<
				XSM_SEQ_CH_AUX_SHIFT;


	return RegValEnable;
}

/****************************************************************************/
/**
*
* This function enables the averaging for the specified channels in the ADC
* Channel Averaging Enable Sequencer Registers. The sequencer must be disabled
* before writing to these regsiters.
*
* @param	InstancePtr is a pointer to the XSysMon instance.
* @param	AvgEnableChMask is the bit mask of all the channels for which
*		averaging is to be enabled. Use XSM_SEQ_CH__* defined in
*		xsysmon_hw.h to specify the Channel numbers. Averaging will be
*		enabled for bit masks of 1 and disabled for bit mask of 0.
*		The AvgEnableChMask is a 32 bit mask that is written to the two
*		16 bit ADC Channel Averaging Enable Sequencer Registers.
*
* @return
*		- XST_SUCCESS if the given values were written successfully to
*		the ADC Channel Averaging Enables Sequencer Registers.
*		- XST_FAILURE if the channel sequencer is enabled.
*
* @note		None
*
*****************************************************************************/
int XSysMon_SetSeqAvgEnables(XSysMon *InstancePtr, u32 AvgEnableChMask)
{
	/*
	 * Assert the arguments.
	 */
	XASSERT_NONVOID(InstancePtr != NULL);
	XASSERT_NONVOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);

	/*
	 * The sequencer must be disabled for writing any of these registers
	 * Return XST_FAILURE if the channel sequencer is enabled.
	 */
	if ((XSysMon_GetSequencerMode(InstancePtr) != XSM_SEQ_MODE_SINGCHAN)) {
		return XST_FAILURE;
	}

	/*
	 * Enable/disable the averaging for the specified channels in the
	 * ADC Channel Averaging Enables Sequencer Registers.
	 */
	XSysMon_mWriteReg(InstancePtr->Config.BaseAddress,
				XSM_SEQ02_OFFSET,
				(AvgEnableChMask & XSM_SEQ02_CH_VALID_MASK));

	XSysMon_mWriteReg(InstancePtr->Config.BaseAddress,
				XSM_SEQ03_OFFSET,
				(AvgEnableChMask >> XSM_SEQ_CH_AUX_SHIFT) &
				XSM_SEQ03_CH_VALID_MASK);

	return XST_SUCCESS;
}

/****************************************************************************/
/**
*
* This function returns the channels for which the averaging has been enabled
* in the ADC Channel Averaging Enables Sequencer Registers.
*
* @param	InstancePtr is a pointer to the XSysMon instance.
*
* @returns 	The status of averaging (enabled/disabled) for all the channels.
*		Use XSM_SEQ_CH__* defined in xsysmon_hw.h to interpret the
*		Channel numbers. Bit masks of 1 are the channels for which
*		averaging is enabled and bit mask of 0 are the channels for
*		averaging is disabled
*
* @note		None
*
*****************************************************************************/
u32 XSysMon_GetSeqAvgEnables(XSysMon *InstancePtr)
{
	u32 RegValAvg;

	/*
	 * Assert the arguments.
	 */
	XASSERT_NONVOID(InstancePtr != NULL);
	XASSERT_NONVOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);

	/*
	 * Read the averaging enable status for all the channels from the
	 * ADC Channel Averaging Enables Sequencer Registers.
	 */
	RegValAvg = XSysMon_mReadReg(InstancePtr->Config.BaseAddress,
				XSM_SEQ02_OFFSET) & XSM_SEQ02_CH_VALID_MASK;
	RegValAvg |= (XSysMon_mReadReg(InstancePtr->Config.BaseAddress,
			XSM_SEQ03_OFFSET) & XSM_SEQ03_CH_VALID_MASK) <<
			XSM_SEQ_CH_AUX_SHIFT;

	return RegValAvg;
}

/****************************************************************************/
/**
*
* This function sets the Analog input mode for the specified channels in the ADC
* Channel Analog-Input Mode Sequencer Registers. The sequencer must be disabled
* before writing to these regsiters.
*
* @param	InstancePtr is a pointer to the XSysMon instance.
* @param	InputModeChMask is the bit mask of all the channels for which
*		the input mode is differential mode. Use XSM_SEQ_CH__* defined
*		in xsysmon_hw.h to specify the channel numbers. Differential
*		input mode will be set for bit masks of 1 and unipolar input
*		mode for bit masks of 0.
*		The InputModeChMask is a 32 bit mask that is written to the two
*		16 bit ADC Channel Analog-Input Mode Sequencer Registers.
*
* @return
*		- XST_SUCCESS if the given values were written successfully to
*		the ADC Channel Analog-Input Mode Sequencer Registers.
*		- XST_FAILURE if the channel sequencer is enabled.
*
* @note		None
*
*****************************************************************************/
int XSysMon_SetSeqInputMode(XSysMon *InstancePtr, u32 InputModeChMask)
{
	/*
	 * Assert the arguments.
	 */
	XASSERT_NONVOID(InstancePtr != NULL);
	XASSERT_NONVOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);

	/*
	 * The sequencer must be disabled for writing any of these registers
	 * Return XST_FAILURE if the channel sequencer is enabled.
	 */
	if ((XSysMon_GetSequencerMode(InstancePtr) != XSM_SEQ_MODE_SINGCHAN)) {
		return XST_FAILURE;
	}

	/*
	 * Set the input mode for the specified channels in the ADC Channel
	 * Analog-Input Mode Sequencer Registers.
	 */
	XSysMon_mWriteReg(InstancePtr->Config.BaseAddress,
				XSM_SEQ04_OFFSET,
				(InputModeChMask & XSM_SEQ04_CH_VALID_MASK));

	XSysMon_mWriteReg(InstancePtr->Config.BaseAddress,
				XSM_SEQ05_OFFSET,
				(InputModeChMask >> XSM_SEQ_CH_AUX_SHIFT) &
				XSM_SEQ05_CH_VALID_MASK);

	return XST_SUCCESS;
}

/****************************************************************************/
/**
*
* This function gets the Analog input mode for all the channels from
* the ADC Channel Analog-Input Mode Sequencer Registers.
*
* @param	InstancePtr is a pointer to the XSysMon instance.
*
* @returns 	The input mode for all the channels.
*		Use XSM_SEQ_CH_* defined in xsysmon_hw.h to interpret the
*		Channel numbers. Bit masks of 1 are the channels for which
*		input mode is differential and bit mask of 0 are the channels
*		for which input mode is unipolar.
*
* @note		None.
*
*****************************************************************************/
u32 XSysMon_GetSeqInputMode(XSysMon *InstancePtr)
{
	u32 InputMode;

	/*
	 * Assert the arguments.
	 */
	XASSERT_NONVOID(InstancePtr != NULL);
	XASSERT_NONVOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);

	/*
	 *  Get the input mode for all the channels from the ADC Channel
	 * Analog-Input Mode Sequencer Registers.
	 */
	InputMode = XSysMon_mReadReg(InstancePtr->Config.BaseAddress,
				XSM_SEQ04_OFFSET) & XSM_SEQ04_CH_VALID_MASK;
	InputMode |= (XSysMon_mReadReg(InstancePtr->Config.BaseAddress,
				XSM_SEQ05_OFFSET) & XSM_SEQ05_CH_VALID_MASK) <<
				XSM_SEQ_CH_AUX_SHIFT;

	return InputMode;
}

/****************************************************************************/
/**
*
* This function sets the number of Acquisition cycles in the ADC Channel
* Acquisition Time Sequencer Registers. The sequencer must be disabled
* before writing to these regsiters.
*
* @param	InstancePtr is a pointer to the XSysMon instance.
* @param	AcqCyclesChMask is the bit mask of all the channels for which
*		the number of acquisition cycles is to be extended.
*		Use XSM_SEQ_CH__* defined in xsysmon_hw.h to specify the Channel
*		numbers. Acquisition cycles will be extended to 10 ADCCLK cycles
*		for bit masks of 1 and will be the default 4 ADCCLK cycles for
*		bit masks of 0.
*		The AcqCyclesChMask is a 32 bit mask that is written to the two
*		16 bit ADC Channel Acquisition Time Sequencer Registers.
*
* @return
*		- XST_SUCCESS if the given values were written successfully to
*		the Channel Sequencer Registers.
*		- XST_FAILURE if the channel sequencer is enabled.
*
* @note		None.
*
*****************************************************************************/
int XSysMon_SetSeqAcqTime(XSysMon *InstancePtr, u32 AcqCyclesChMask)
{
	/*
	 * Assert the arguments.
	 */
	XASSERT_NONVOID(InstancePtr != NULL);
	XASSERT_NONVOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);

	/*
	 * The sequencer must be disabled for writing any of these registers
	 * Return XST_FAILURE if the channel sequencer is enabled.
	 */
	if ((XSysMon_GetSequencerMode(InstancePtr) != XSM_SEQ_MODE_SINGCHAN)) {
		return XST_FAILURE;
	}

	/*
	 * Set the Acquisition time for the specified channels in the
	 * ADC Channel Acquisition Time Sequencer Registers.
	 */
	XSysMon_mWriteReg(InstancePtr->Config.BaseAddress,
				XSM_SEQ06_OFFSET,
				(AcqCyclesChMask & XSM_SEQ06_CH_VALID_MASK));

	XSysMon_mWriteReg(InstancePtr->Config.BaseAddress,
				XSM_SEQ07_OFFSET,
				(AcqCyclesChMask >> XSM_SEQ_CH_AUX_SHIFT) &
				XSM_SEQ07_CH_VALID_MASK);

	return XST_SUCCESS;
}

/****************************************************************************/
/**
*
* This function gets the status of acquisition from the ADC Channel Acquisition
* Time Sequencer Registers.
*
* @param	InstancePtr is a pointer to the XSysMon instance.
*
* @returns 	The acquisition time for all the channels.
*		Use XSM_SEQ_CH__* defined in xsysmon_hw.h to interpret the
*		Channel numbers. Bit masks of 1 are the channels for which
*		acquisition cycles are extended and bit mask of 0 are the
*		channels for which acquisition cycles are not extended.
*
* @note		None
*
*****************************************************************************/
u32 XSysMon_GetSeqAcqTime(XSysMon *InstancePtr)
{
	u32 RegValAcq;

	/*
	 * Assert the arguments.
	 */
	XASSERT_NONVOID(InstancePtr != NULL);
	XASSERT_NONVOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);

	/*
	 * Get the Acquisition cycles for the specified channels from the ADC
	 * Channel Acquisition Time Sequencer Registers.
	 */
	RegValAcq = XSysMon_mReadReg(InstancePtr->Config.BaseAddress,
				XSM_SEQ06_OFFSET) & XSM_SEQ06_CH_VALID_MASK;
	RegValAcq |= (XSysMon_mReadReg(InstancePtr->Config.BaseAddress,
				XSM_SEQ07_OFFSET) & XSM_SEQ07_CH_VALID_MASK) <<
				XSM_SEQ_CH_AUX_SHIFT;

	return RegValAcq;
}

/****************************************************************************/
/**
*
* This functions sets the contents of the given Alarm Threshold Register.
*
* @param	InstancePtr is a pointer to the XSysMon instance.
* @param	AlarmThrReg is the index of an Alarm Threshold Register to
*		be set. Use XSM_ATR_* constants defined in xsysmon.h to
*		specify the index.
* @param	Value is the 16-bit threshold value to write into the register.
*
* @return	None.
*
* @note		Use XSysMon_SetOverTemp() to set the Over Temperature upper
*		threshold value.
*
*****************************************************************************/
void XSysMon_SetAlarmThreshold(XSysMon *InstancePtr, u8 AlarmThrReg, u16 Value)
{
	/*
	 * Assert the arguments.
	 */
	XASSERT_VOID(InstancePtr != NULL);
	XASSERT_VOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);
	XASSERT_VOID((AlarmThrReg <= XSM_ATR_VCCAUX_UPPER) ||
		     ((AlarmThrReg >= XSM_ATR_TEMP_LOWER) &&
		      (AlarmThrReg <= XSM_ATR_OT_LOWER)));

	/*
	 * Write the value into the specified Alarm Threshold Register.
	 */
	XSysMon_mWriteReg(InstancePtr->Config.BaseAddress,
			  XSM_ATR_TEMP_UPPER_OFFSET + (AlarmThrReg << 2),
			  Value);
}

/****************************************************************************/
/**
*
* This function returns the contents of the specified Alarm Threshold Register.
*
* @param	InstancePtr is a pointer to the XSysMon instance.
* @param	AlarmThrReg is the index of an Alarm Threshold Register
*		to be read. Use XSM_ATR_* constants defined in 	xsysmon_hw.h
*		to specify the index.
*
* @return	A 16-bit value representing the contents of the selected Alarm
*		Threshold Register.
*
* @note		Use XSysMon_GetOverTemp() to read the Over Temperature upper
*		threshold value.
*
*****************************************************************************/
u16 XSysMon_GetAlarmThreshold(XSysMon *InstancePtr, u8 AlarmThrReg)
{
	u16 AlarmThreshold;
	/*
	 * Assert the arguments.
	 */
	XASSERT_NONVOID(InstancePtr != NULL);
	XASSERT_NONVOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);
	XASSERT_NONVOID( (AlarmThrReg <= XSM_ATR_VCCAUX_UPPER) ||
			 ((AlarmThrReg >= XSM_ATR_TEMP_LOWER) &&
			 (AlarmThrReg <= XSM_ATR_OT_LOWER)));

	/*
	 * Read the specified Alarm Threshold Register and return
	 * the value
	 */
	AlarmThreshold = (u16) XSysMon_mReadReg(InstancePtr->Config.BaseAddress,
			XSM_ATR_TEMP_UPPER_OFFSET + (AlarmThrReg << 2));

	return AlarmThreshold;
}

/****************************************************************************/
/**
*
* This function sets the powerdown temperature for the OverTemp signal in the
* OT Powerdown register.
*
* @param	InstancePtr is a pointer to the XSysMon instance.
* @param	Value is the 16-bit OT Upper Alarm Register powerdown value.
*		Valid values are 0 to 0x0FFF.
*
* @return	None.
*
* @note		This API should be used only with V6 SysMon since the upper
*		threshold of OverTemp is programmable in only V6 SysMon.
*
*****************************************************************************/
void XSysMon_SetOverTemp(XSysMon *InstancePtr, u16 Value)
{
	u16 OtUpper;

	/*
	 * Assert the arguments.
	 */
	XASSERT_VOID(InstancePtr != NULL);
	XASSERT_VOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);
	XASSERT_VOID(Value <= XSM_ATR_OT_UPPER_VAL_MAX);

	/*
	 * Read the OT Upper Alarm Threshold Register.
	 */
	OtUpper = (u16) XSysMon_mReadReg(InstancePtr->Config.BaseAddress,
					 XSM_ATR_OT_UPPER_OFFSET);
	OtUpper &= ~(XSM_ATR_OT_UPPER_VAL_MASK);

	/*
	 * Preserve the OT enable value and write the powerdown value into the
	 * OT Upper Alarm Threshold Register.
	 */
	Value = (Value << XSM_ATR_OT_UPPER_VAL_SHIFT) | OtUpper;
	XSysMon_mWriteReg(InstancePtr->Config.BaseAddress,
			  XSM_ATR_OT_UPPER_OFFSET, Value);
}

/****************************************************************************/
/**
*
* This function returns the powerdown temperature of the OverTemp signal in
* the OT Powerdown register.
*
* @param	InstancePtr is a pointer to the XSysMon instance.
*
* @return	A 12-bit OT Upper Alarm Register powerdown value.
*
* @note		This API should be used only with V6 SysMon since the upper
*		threshold of OverTemp is programmable in only V6 SysMon.
*
*****************************************************************************/
u16 XSysMon_GetOverTemp(XSysMon *InstancePtr)
{
	u16 OtUpper;

	/*
	 * Assert the arguments.
	 */
	XASSERT_NONVOID(InstancePtr != NULL);
	XASSERT_NONVOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);

	/*
	 * Read the OT upper Alarm Threshold Register and return
	 * the value.
	 */
	OtUpper = (u16) XSysMon_mReadReg(InstancePtr->Config.BaseAddress,
					 XSM_ATR_OT_UPPER_OFFSET);
	OtUpper >>= XSM_ATR_OT_UPPER_VAL_SHIFT;

	return OtUpper;
}

/****************************************************************************/
/**
*
* This function enables programming of the powerdown temperature for the
* OverTemp signal in the OT Powerdown register.
*
* @param	InstancePtr is a pointer to the XSysMon instance.
*
* @return	None.
*
* @note		This API should be used only with V6 SysMon since the upper
*		threshold of OverTemp is programmable in only V6 SysMon.
*
*****************************************************************************/
void XSysMon_EnableUserOverTemp(XSysMon *InstancePtr)
{
	u16 OtUpper;

	/*
	 * Assert the arguments.
	 */
	XASSERT_VOID(InstancePtr != NULL);
	XASSERT_VOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);

	/*
	 * Read the OT upper Alarm Threshold Register.
	 */
	OtUpper = XSysMon_mReadReg(InstancePtr->Config.BaseAddress,
				   XSM_ATR_OT_UPPER_OFFSET);
	OtUpper &= ~(XSM_ATR_OT_UPPER_ENB_MASK);

	/*
	 * Preserve the powerdown value and write OT enable value the into the
	 * OT Upper Alarm Threshold Register.
	 */
	OtUpper |= XSM_ATR_OT_UPPER_ENB_VAL;
	XSysMon_mWriteReg(InstancePtr->Config.BaseAddress,
			  XSM_ATR_OT_UPPER_OFFSET, OtUpper);
}

/****************************************************************************/
/**
*
* This function disables programming of the powerdown temperature for the
* OverTemp signal in the OT Powerdown register.
*
* @param	InstancePtr is a pointer to the XSysMon instance.
*
* @return	None.
*
* @note		This API should be used only with V6 SysMon since the upper
*		threshold of OverTemp is programmable in only V6 SysMon.
*
*****************************************************************************/
void XSysMon_DisableUserOverTemp(XSysMon *InstancePtr)
{
	u16 OtUpper;

	/*
	 * Assert the arguments.
	 */
	XASSERT_VOID(InstancePtr != NULL);
	XASSERT_VOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);

	/*
	 * Read the OT Upper Alarm Threshold Register.
	 */
	OtUpper = XSysMon_mReadReg(InstancePtr->Config.BaseAddress,
					 XSM_ATR_OT_UPPER_OFFSET);
	OtUpper &= ~(XSM_ATR_OT_UPPER_ENB_MASK);

	XSysMon_mWriteReg(InstancePtr->Config.BaseAddress,
			  XSM_ATR_OT_UPPER_OFFSET, OtUpper);
}

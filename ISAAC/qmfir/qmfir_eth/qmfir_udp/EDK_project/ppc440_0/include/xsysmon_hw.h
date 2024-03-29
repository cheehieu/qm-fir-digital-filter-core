/* $Id: xsysmon_hw.h,v 1.1.2.1 2009/10/07 11:14:16 sadanan Exp $ */
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
* @file xsysmon_hw.h
*
* This header file contains identifiers and basic driver functions (or
* macros) that can be used to access the System Monitor/ADC device.
*
*
* Refer to the device specification for more information about this driver.
*
* @note	 None.
*
*
* <pre>
*
* MODIFICATION HISTORY:
*
* Ver   Who    Date     Changes
* ----- -----  -------- -----------------------------------------------------
* 1.00a xd/sv  05/22/07 First release
* 2.00a sv     07/07/08 Added bit definitions for new Alarm Interrupts in the
*			Interrupt Registers.
* 3.00a sdm    02/09/09 Added register and bit definitions for V6 SysMon.
*
* </pre>
*
*****************************************************************************/

#ifndef XSYSMON_HW_H /* Prevent circular inclusions */
#define XSYSMON_HW_H /* by using protection macros  */

#ifdef __cplusplus
extern "C" {
#endif

/***************************** Include Files ********************************/

#include "xbasic_types.h"
#include "xio.h"

/************************** Constant Definitions ****************************/

/**@name Register offsets
 *
 * The following constants provide access to each of the registers of the
 * System Monitor/ADC device.
 * @{
 */

/*
 * System Monitor/ADC Local Registers
 */
#define XSM_SRR_OFFSET		0x00  /**< Software Reset Register */
#define XSM_SR_OFFSET		0x04  /**< Status Register */
#define XSM_AOR_OFFSET		0x08  /**< Alarm Output Register */
#define XSM_CONVST_OFFSET	0x0C  /**< ADC Convert Start Register */
#define XSM_ARR_OFFSET		0x10  /**< ADC Reset Register */

/*
 * System Monitor/ADC Interrupt Registers
 */
#define XSM_GIER_OFFSET		0x5C  /**< Global Interrupt Enable */
#define XSM_IPISR_OFFSET	0x60  /**< Interrupt Status Register  */
#define XSM_IPIER_OFFSET	0x68  /**< Interrupt Enable register  */

/*
 * System Monitor/ADC Internal Channel Registers
 */
#define XSM_TEMP_OFFSET		 0x200 /**< On-chip Temperature Reg */
#define XSM_VCCINT_OFFSET	 0x204 /**< On-chip VCCINT Data Reg */
#define XSM_VCCAUX_OFFSET	 0x208 /**< On-chip VCCAUX Data Reg */
#define XSM_VPVN_OFFSET		 0x20C /**< ADC out of VP/VN	   */
#define XSM_VREFP_OFFSET	 0x210 /**< On-chip VREFP Data Reg */
#define XSM_VREFN_OFFSET	 0x214 /**< On-chip VREFN Data Reg */
#define XSM_SUPPLY_CALIB_OFFSET	 0x220 /**< Supply Offset Data Reg */
#define XSM_ADC_CALIB_OFFSET	 0x224 /**< ADC Offset Data Reg */
#define XSM_GAINERR_CALIB_OFFSET 0x228 /**< Gain Error Data Reg  */

/*
 * System Monitor/ADC External Channel Registers
 */
#define XSM_AUX00_OFFSET	0x240 /**< ADC out of VAUXP0/VAUXN0 */
#define XSM_AUX01_OFFSET	0x244 /**< ADC out of VAUXP1/VAUXN1 */
#define XSM_AUX02_OFFSET	0x248 /**< ADC out of VAUXP2/VAUXN2 */
#define XSM_AUX03_OFFSET	0x24C /**< ADC out of VAUXP3/VAUXN3 */
#define XSM_AUX04_OFFSET	0x250 /**< ADC out of VAUXP4/VAUXN4 */
#define XSM_AUX05_OFFSET	0x254 /**< ADC out of VAUXP5/VAUXN5 */
#define XSM_AUX06_OFFSET	0x258 /**< ADC out of VAUXP6/VAUXN6 */
#define XSM_AUX07_OFFSET	0x25C /**< ADC out of VAUXP7/VAUXN7 */
#define XSM_AUX08_OFFSET	0x260 /**< ADC out of VAUXP8/VAUXN8 */
#define XSM_AUX09_OFFSET	0x264 /**< ADC out of VAUXP9/VAUXN9 */
#define XSM_AUX10_OFFSET	0x268 /**< ADC out of VAUXP10/VAUXN10 */
#define XSM_AUX11_OFFSET	0x26C /**< ADC out of VAUXP11/VAUXN11 */
#define XSM_AUX12_OFFSET	0x270 /**< ADC out of VAUXP12/VAUXN12 */
#define XSM_AUX13_OFFSET	0x274 /**< ADC out of VAUXP13/VAUXN13 */
#define XSM_AUX14_OFFSET	0x278 /**< ADC out of VAUXP14/VAUXN14 */
#define XSM_AUX15_OFFSET	0x27C /**< ADC out of VAUXP15/VAUXN15 */

/*
 * System Monitor/ADC Registers for Maximum/Minimum data captured for the
 * on chip Temperature/VCCINT/VCCAUX data.
 */
#define XSM_MAX_TEMP_OFFSET	0x280 /**< Maximum Temperature Reg */
#define XSM_MAX_VCCINT_OFFSET	0x284 /**< Maximum VCCINT Register */
#define XSM_MAX_VCCAUX_OFFSET	0x288 /**< Maximum VCCAUX Register */
#define XSM_MIN_TEMP_OFFSET	0x290 /**< Minimum Temperature Reg */
#define XSM_MIN_VCCINT_OFFSET	0x294 /**< Minimum VCCINT Register */
#define XSM_MIN_VCCAUX_OFFSET	0x298 /**< Minimum VCCAUX Register */

/*
 * System Monitor/ADC Configuration Registers
 */
#define XSM_CFR0_OFFSET		0x300	/**< Configuration Register 0 */
#define XSM_CFR1_OFFSET		0x304	/**< Configuration Register 1 */
#define XSM_CFR2_OFFSET		0x308	/**< Configuration Register 2 */

/*
 * System Monitor/ADC Sequence Registers
 */
#define XSM_SEQ00_OFFSET	0x320 /**< Seq Reg 00 Adc Channel Selection */
#define XSM_SEQ01_OFFSET	0x324 /**< Seq Reg 01 Adc Channel Selection */
#define XSM_SEQ02_OFFSET	0x328 /**< Seq Reg 02 Adc Average Enable */
#define XSM_SEQ03_OFFSET	0x32C /**< Seq Reg 03 Adc Average Enable */
#define XSM_SEQ04_OFFSET	0x330 /**< Seq Reg 04 Adc Input Mode Select */
#define XSM_SEQ05_OFFSET	0x334 /**< Seq Reg 05 Adc Input Mode Select */
#define XSM_SEQ06_OFFSET	0x338 /**< Seq Reg 06 Adc Acquisition Select */
#define XSM_SEQ07_OFFSET	0x33C /**< Seq Reg 07 Adc Acquisition Select */

/*
 * System Monitor/ADC Alarm Threshold/Limit Registers (ATR)
 */
#define XSM_ATR_TEMP_UPPER_OFFSET	0x340 /**< Temp Upper Alarm Register */
#define XSM_ATR_VCCINT_UPPER_OFFSET	0x344 /**< VCCINT Upper Alarm Reg */
#define XSM_ATR_VCCAUX_UPPER_OFFSET	0x348 /**< VCCAUX Upper Alarm Reg */
#define XSM_ATR_OT_UPPER_OFFSET		0x34C /**< Over Temp Upper Alarm Reg */
#define XSM_ATR_TEMP_LOWER_OFFSET	0x350 /**< Temp Lower Alarm Register */
#define XSM_ATR_VCCINT_LOWER_OFFSET	0x354 /**< VCCINT Lower Alarm Reg */
#define XSM_ATR_VCCAUX_LOWER_OFFSET	0x358 /**< VCCAUX Lower Alarm Reg */
#define XSM_ATR_OT_LOWER_OFFSET		0x35C /**< Over Temp Lower Alarm Reg */

/*@}*/

/**
 * @name System Monitor/ADC Software Reset Register (SRR) mask(s)
 * @{
 */
#define XSM_SRR_IPRST_MASK	0x0000000A   /**< Device Reset Mask */

/*@}*/

/**
 * @name System Monitor/ADC Status Register (SR) mask(s)
 * @{
 */
#define XSM_SR_JTAG_BUSY_MASK	  0x00000400 /**< JTAG is busy */
#define XSM_SR_JTAG_MODIFIED_MASK 0x00000200 /**< JTAG Write has occurred */
#define XSM_SR_JTAG_LOCKED_MASK	  0x00000100 /**< JTAG is locked */
#define XSM_SR_BUSY_MASK	  0x00000080 /**< ADC is busy in conversion */
#define XSM_SR_EOS_MASK		  0x00000040 /**< End of Sequence */
#define XSM_SR_EOC_MASK		  0x00000020 /**< End of Conversion */
#define XSM_SR_CH_MASK		  0x0000001F /**< Input ADC channel */

/*@}*/

/**
 * @name System Monitor/ADC Alarm Output Register (AOR) mask(s)
 * @{
 */
#define XSM_AOR_ALARM_ALL_MASK	0x0000000F /**< Mask for all Alarms */
#define XSM_AOR_VCCAUX_MASK	0x00000008 /**< ALM2 - VCCAUX Output Mask  */
#define XSM_AOR_VCCINT_MASK	0x00000004 /**< ALM1 - VCCINT Alarm Mask */
#define XSM_AOR_TEMP_MASK	0x00000002 /**< ALM0 - Temp sensor Alarm Mask */
#define XSM_AOR_OT_MASK		0x00000001 /**< Over Temp Alarm Output */

/*@}*/

/**
 * @name System Monitor/ADC CONVST Register (CONVST) mask(s)
 * @{
 */
#define XSM_CONVST_CONVST_MASK	0x00000001/**< Conversion Start Mask */

/*@}*/

/**
 * @name System Monitor/ADC Reset Register (ARR) mask(s)
 * @{
 */
#define XSM_ARR_RST_MASK	0x00000001 /**< ADC Reset bit mask */

/*@}*/

/**
 * @name Global Interrupt Enable Register (GIER) mask(s)
 * @{
 */
#define XSM_GIER_GIE_MASK	0x80000000 /**< Global interrupt enable */
/*@}*/

/**
 * @name System Monitor/ADC device Interrupt Status/Enable Registers
 *
 * <b> Interrupt Status Register (IPISR) </b>
 *
 * This register holds the interrupt status flags for the device.
 *
 * <b> Interrupt Enable Register (IPIER) </b>
 *
 * This register is used to enable interrupt sources for the device.
 * Writing a '1' to a bit in this register enables the corresponding Interrupt.
 * Writing a '0' to a bit in this register disables the corresponding Interrupt.
 *
 * IPISR/IPIER registers have the same bit definitions and are only defined
 * once.
 * @{
 */
#define XSM_IPIXR_TEMP_DEACTIVE_MASK  0x00000200 /**< Alarm 0 DEACTIVE */
#define XSM_IPIXR_OT_DEACTIVE_MASK    0x00000100 /**< Over Temp DEACTIVE */
#define XSM_IPIXR_JTAG_MODIFIED_MASK  0x00000080 /**< JTAG Modified */
#define XSM_IPIXR_JTAG_LOCKED_MASK    0x00000040 /**< JTAG Locked */
#define XSM_IPIXR_EOC_MASK	      0x00000020 /**< End Of Conversion */
#define XSM_IPIXR_EOS_MASK	      0x00000010 /**< End Of Sequence */
#define XSM_IPIXR_VCCAUX_MASK	      0x00000008 /**< Alarm 2 - VCCAUX */
#define XSM_IPIXR_VCCINT_MASK	      0x00000004 /**< Alarm 1 - VCCINT */
#define XSM_IPIXR_TEMP_MASK	      0x00000002 /**< Alarm 0 - Temp ACTIVE */
#define XSM_IPIXR_OT_MASK	      0x00000001 /**< Over Temperature ACTIVE */
#define XSM_IPIXR_ALL_MASK	      0x000003FF /**< Mask of all interrupts */

/*@}*/

/**
 * @name Mask for all ADC converted data including Minimum/Maximum Measurements
 *	 and Threshold data.
 * @{
 */
#define XSM_ADCDATA_MAX_MASK	0x03FF

/*@}*/

/**
 * @name Configuration Register 0 (CFR0) mask(s)
 * @{
 */
#define XSM_CFR0_CAL_AVG_MASK	0x8000  /**< Averaging enable Mask */
#define XSM_CFR0_AVG_VALID_MASK	0x3000  /**< Averaging bit Mask */
#define XSM_CFR0_AVG1_MASK	0x0000  /**< No Averaging */
#define XSM_CFR0_AVG16_MASK	0x1000  /**< Average 16 samples */
#define XSM_CFR0_AVG64_MASK	0x2000  /**< Average 64 samples */
#define XSM_CFR0_AVG256_MASK	0x3000  /**< Average 256 samples */
#define XSM_CFR0_AVG_SHIFT	12	/**< Shift for the Averaging bits  */
#define XSM_CFR0_DU_MASK	0x0400  /**< Bipolar/Unipolar mode */
#define XSM_CFR0_EC_MASK	0x0200  /**< Event driven/Continuous mode */
#define XSM_CFR0_ACQ_MASK	0x0100  /**< Add acquisition by 6 ADCCLK  */
#define XSM_CFR0_CHANNEL_MASK	0x001F  /**< Channel number bit Mask */

/*@}*/

/**
 * @name Configuration Register 1 (CFR1) mask(s)
 * @{
 */
#define XSM_CFR1_SEQ_VALID_MASK		  0x3000 /**< Sequence bit Mask */
#define XSM_CFR1_SEQ_SAFEMODE_MASK	  0x0000 /**< Default Safe Mode */
#define XSM_CFR1_SEQ_ONEPASS_MASK	  0x1000 /**< Onepass through Seq */
#define XSM_CFR1_SEQ_CONTINPASS_MASK	  0x2000 /**< Continuous Cycling Seq */
#define XSM_CFR1_SEQ_SINGCHAN_MASK	  0x3000 /**< Single channel - No Seq */
#define XSM_CFR1_SEQ_SHIFT		  12     /**< Sequence bit shift */
#define XSM_CFR1_CAL_VALID_MASK		  0x00F0 /**< Valid Calibration Mask */
#define XSM_CFR1_CAL_PS_GAIN_OFFSET_MASK  0x0080 /**< Calibration 3 -Power
							Supply Gain/Offset
							Enable */
#define XSM_CFR1_CAL_PS_OFFSET_MASK	  0x0040 /**< Calibration 2 -Power
							Supply Offset Enable */
#define XSM_CFR1_CAL_ADC_GAIN_OFFSET_MASK 0x0020 /**< Calibration 1 -ADC Gain
							Offset Enable */
#define XSM_CFR1_CAL_ADC_OFFSET_MASK	  0x0010 /**< Calibration 0 -ADC Offset
							Enable */
#define XSM_CFR1_CAL_DISABLE_MASK	  0x0000 /**< No Calibration */
#define XSM_CFR1_ALM_ALL_MASK		  0x000F /**< Mask for all alarms */
#define XSM_CFR1_ALM_VCCAUX_MASK	  0x0008 /**< Alarm 2 -VCCAUX Enable */
#define XSM_CFR1_ALM_VCCINT_MASK	  0x0004 /**< Alarm 1 -VCCINT Enable */
#define XSM_CFR1_ALM_TEMP_MASK		  0x0002 /**< Alarm 0 -Temperature */
#define XSM_CFR1_OT_MASK		  0x0001 /**< Over Temperature Enable */

/*@}*/

/**
 * @name Configuration Register 2 (CFR2) mask(s)
 * @{
 */
#define XSM_CFR2_CD_VALID_MASK	0xFF00  /**<Clock Divisor bit Mask   */
#define XSM_CFR2_CD_SHIFT	8	/**<Num of shift on division */
#define XSM_CFR2_CD_MIN		8	/**<Minimum value of divisor */
#define XSM_CFR2_CD_MAX		255	/**<Maximum value of divisor */

/*@}*/

/**
 * @name Sequence Register (SEQ) Bit Definitions
 * @{
 */
#define XSM_SEQ_CH_CALIB	0x00000001 /**< ADC Calibration Channel */
#define XSM_SEQ_CH_TEMP		0x00000100 /**< On Chip Temperature Channel */
#define XSM_SEQ_CH_VCCINT	0x00000200 /**< VCCINT Channel */
#define XSM_SEQ_CH_VCCAUX	0x00000400 /**< VCCAUX Channel */
#define XSM_SEQ_CH_VPVN		0x00000800 /**< VP/VN analog inputs Channel */
#define XSM_SEQ_CH_VREFP	0x00001000 /**< VREFP Channel */
#define XSM_SEQ_CH_VREFN	0x00002000 /**< VREFN Channel */
#define XSM_SEQ_CH_AUX00	0x00010000 /**< 1st Aux Channel */
#define XSM_SEQ_CH_AUX01	0x00020000 /**< 2nd Aux Channel */
#define XSM_SEQ_CH_AUX02	0x00040000 /**< 3rd Aux Channel */
#define XSM_SEQ_CH_AUX03	0x00080000 /**< 4th Aux Channel */
#define XSM_SEQ_CH_AUX04	0x00100000 /**< 5th Aux Channel */
#define XSM_SEQ_CH_AUX05	0x00200000 /**< 6th Aux Channel */
#define XSM_SEQ_CH_AUX06	0x00400000 /**< 7th Aux Channel */
#define XSM_SEQ_CH_AUX07	0x00800000 /**< 8th Aux Channel */
#define XSM_SEQ_CH_AUX08	0x01000000 /**< 9th Aux Channel */
#define XSM_SEQ_CH_AUX09	0x02000000 /**< 10th Aux Channel */
#define XSM_SEQ_CH_AUX10	0x04000000 /**< 11th Aux Channel */
#define XSM_SEQ_CH_AUX11	0x08000000 /**< 12th Aux Channel */
#define XSM_SEQ_CH_AUX12	0x10000000 /**< 13th Aux Channel */
#define XSM_SEQ_CH_AUX13	0x20000000 /**< 14th Aux Channel */
#define XSM_SEQ_CH_AUX14	0x40000000 /**< 15th Aux Channel */
#define XSM_SEQ_CH_AUX15	0x80000000 /**< 16th Aux Channel */

#define XSM_SEQ00_CH_VALID_MASK	0x3F01 /**< Mask for the valid channels */
#define XSM_SEQ01_CH_VALID_MASK	0xFFFF /**< Mask for the valid channels */

#define XSM_SEQ02_CH_VALID_MASK	0x3F00 /**< Mask for the valid channels */
#define XSM_SEQ03_CH_VALID_MASK	0xFFFF /**< Mask for the valid channels */

#define XSM_SEQ04_CH_VALID_MASK	0x0800 /**< Mask for the valid channels */
#define XSM_SEQ05_CH_VALID_MASK	0xFFFF /**< Mask for the valid channels */

#define XSM_SEQ06_CH_VALID_MASK	0x0800 /**< Mask for the valid channels */
#define XSM_SEQ07_CH_VALID_MASK	0xFFFF /**< Mask for the valid channels */


#define XSM_SEQ_CH_AUX_SHIFT	16 /**< Shift for the Aux Channel */

/*@}*/

/**
 * @name OT Upper Alarm Threshold Register Bit Definitions
 * @{
 */

#define XSM_ATR_OT_UPPER_ENB_MASK	0x000F /**< Mask for OT enable */
#define XSM_ATR_OT_UPPER_VAL_MASK	0xFFF0 /**< Mask for OT value */
#define XSM_ATR_OT_UPPER_VAL_SHIFT	4      /**< Shift for OT value */
#define XSM_ATR_OT_UPPER_ENB_VAL	0x0003 /**< Value for OT enable */
#define XSM_ATR_OT_UPPER_VAL_MAX	0x0FFF /**< Max OT value */

/*@}*/


/**************************** Type Definitions *******************************/

/***************** Macros (Inline Functions) Definitions *********************/

/*****************************************************************************/
/**
*
* Read a register of the System Monitor/ADC device. This macro provides register
* access to all registers using the register offsets defined above.
*
* @param	BaseAddress contains the base address of the device.
* @param	RegOffset is the offset of the register to read.
*
* @return	The contents of the register.
*
* @note		C-style Signature:
*		u32 XSysMon_mReadReg(u32 BaseAddress, u32 RegOffset);
*
******************************************************************************/
#define XSysMon_mReadReg(BaseAddress, RegOffset) \
			(XIo_In32((BaseAddress) + (RegOffset)))

/*****************************************************************************/
/**
*
* Write a register of the System Monitor/ADC device. This macro provides
* register access to all registers using the register offsets defined above.
*
* @param	BaseAddress contains the base address of the device.
* @param	RegOffset is the offset of the register to write.
* @param	Data is the value to write to the register.
*
* @return	None.
*
* @note 	C-style Signature:
*		void XSysMon_mWriteReg(u32 BaseAddress,
*					u32 RegOffset,u32 Data)
*
******************************************************************************/
#define XSysMon_mWriteReg(BaseAddress, RegOffset, Data) \
		(XIo_Out32((BaseAddress) + (RegOffset), (Data)))

/************************** Function Prototypes ******************************/

#ifdef __cplusplus
}
#endif

#endif  /* End of protection macro. */

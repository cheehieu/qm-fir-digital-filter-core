/*****************************************************************************
* Filename:          /proj/users/hmnguyen/EDKproject/qmfir_2new/drivers/qmfir_v1_00_a/src/qmfir.h
* Version:           1.00.a
* Description:       qmfir Driver Header File
* Date:              Fri Feb 25 13:30:20 2011 (by Create and Import Peripheral Wizard)
*****************************************************************************/

#ifndef QMFIR_H
#define QMFIR_H

/***************************** Include Files *******************************/

#include "xbasic_types.h"
#include "xstatus.h"
#include "xio.h"

/************************** Constant Definitions ***************************/


/**
 * User Logic Slave Space Offsets
 * -- SLV_REG0 : user logic slave module register 0
 * -- SLV_REG1 : user logic slave module register 1
 * -- SLV_REG2 : user logic slave module register 2
 * -- SLV_REG3 : user logic slave module register 3
 */
#define QMFIR_USER_SLV_SPACE_OFFSET (0x00000000)
#define QMFIR_SLV_REG0_OFFSET (QMFIR_USER_SLV_SPACE_OFFSET + 0x00000000)
#define QMFIR_SLV_REG1_OFFSET (QMFIR_USER_SLV_SPACE_OFFSET + 0x00000004)
#define QMFIR_SLV_REG2_OFFSET (QMFIR_USER_SLV_SPACE_OFFSET + 0x00000008)
#define QMFIR_SLV_REG3_OFFSET (QMFIR_USER_SLV_SPACE_OFFSET + 0x0000000C)

/**
 * Interrupt Controller Space Offsets
 * -- INTR_DISR  : device (peripheral) interrupt status register
 * -- INTR_DIPR  : device (peripheral) interrupt pending register
 * -- INTR_DIER  : device (peripheral) interrupt enable register
 * -- INTR_DIIR  : device (peripheral) interrupt id (priority encoder) register
 * -- INTR_DGIER : device (peripheral) global interrupt enable register
 * -- INTR_ISR   : ip (user logic) interrupt status register
 * -- INTR_IER   : ip (user logic) interrupt enable register
 */
#define QMFIR_INTR_CNTRL_SPACE_OFFSET (0x00000100)
#define QMFIR_INTR_DISR_OFFSET (QMFIR_INTR_CNTRL_SPACE_OFFSET + 0x00000000)
#define QMFIR_INTR_DIPR_OFFSET (QMFIR_INTR_CNTRL_SPACE_OFFSET + 0x00000004)
#define QMFIR_INTR_DIER_OFFSET (QMFIR_INTR_CNTRL_SPACE_OFFSET + 0x00000008)
#define QMFIR_INTR_DIIR_OFFSET (QMFIR_INTR_CNTRL_SPACE_OFFSET + 0x00000018)
#define QMFIR_INTR_DGIER_OFFSET (QMFIR_INTR_CNTRL_SPACE_OFFSET + 0x0000001C)
#define QMFIR_INTR_IPISR_OFFSET (QMFIR_INTR_CNTRL_SPACE_OFFSET + 0x00000020)
#define QMFIR_INTR_IPIER_OFFSET (QMFIR_INTR_CNTRL_SPACE_OFFSET + 0x00000028)

/**
 * Interrupt Controller Masks
 * -- INTR_TERR_MASK : transaction error
 * -- INTR_DPTO_MASK : data phase time-out
 * -- INTR_IPIR_MASK : ip interrupt requeset
 * -- INTR_RFDL_MASK : read packet fifo deadlock interrupt request
 * -- INTR_WFDL_MASK : write packet fifo deadlock interrupt request
 * -- INTR_IID_MASK  : interrupt id
 * -- INTR_GIE_MASK  : global interrupt enable
 * -- INTR_NOPEND    : the DIPR has no pending interrupts
 */
#define INTR_TERR_MASK (0x00000001UL)
#define INTR_DPTO_MASK (0x00000002UL)
#define INTR_IPIR_MASK (0x00000004UL)
#define INTR_RFDL_MASK (0x00000020UL)
#define INTR_WFDL_MASK (0x00000040UL)
#define INTR_IID_MASK (0x000000FFUL)
#define INTR_GIE_MASK (0x80000000UL)
#define INTR_NOPEND (0x80)

/**
 * Write Packet FIFO Register/Data Space Offsets
 * -- WRFIFO_RST  : write packet fifo reset register
 * -- WRFIFO_SR   : write packet fifo status register
 * -- WRFIFO_DATA : write packet fifo data
 */
#define QMFIR_WRFIFO_REG_SPACE_OFFSET (0x00000200)
#define QMFIR_WRFIFO_RST_OFFSET (QMFIR_WRFIFO_REG_SPACE_OFFSET + 0x00000000)
#define QMFIR_WRFIFO_SR_OFFSET (QMFIR_WRFIFO_REG_SPACE_OFFSET + 0x00000004)
#define QMFIR_WRFIFO_DATA_SPACE_OFFSET (0x00000300)
#define QMFIR_WRFIFO_DATA_OFFSET (QMFIR_WRFIFO_DATA_SPACE_OFFSET + 0x00000000)

/**
 * Write Packet FIFO Masks
 * -- WRFIFO_FULL_MASK  : write packet fifo full condition
 * -- WRFIFO_AF_MASK    : write packet fifo almost full condition
 * -- WRFIFO_DL_MASK    : write packet fifo deadlock condition
 * -- WRFIFO_SCL_MASK   : write packet fifo vacancy scaling enabled
 * -- WRFIFO_WIDTH_MASK : write packet fifo encoded data port width
 * -- WRFIFO_DREP_MASK  : write packet fifo DRE present
 * -- WRFIFO_VAC_MASK   : write packet fifo vacancy
 * -- WRFIFO_RESET      : write packet fifo reset
 */
#define WRFIFO_FULL_MASK (0x80000000UL)
#define WRFIFO_AF_MASK (0x40000000UL)
#define WRFIFO_DL_MASK (0x20000000UL)
#define WRFIFO_SCL_MASK (0x10000000UL)
#define WRFIFO_WIDTH_MASK (0x0E000000UL)
#define WRFIFO_DREP_MASK (0x01000000UL)
#define WRFIFO_VAC_MASK (0x00FFFFFFUL)
#define WRFIFO_RESET (0x0000000A)

/**************************** Type Definitions *****************************/


/***************** Macros (Inline Functions) Definitions *******************/

/**
 *
 * Write a value to a QMFIR register. A 32 bit write is performed.
 * If the component is implemented in a smaller width, only the least
 * significant data is written.
 *
 * @param   BaseAddress is the base address of the QMFIR device.
 * @param   RegOffset is the register offset from the base to write to.
 * @param   Data is the data written to the register.
 *
 * @return  None.
 *
 * @note
 * C-style signature:
 * 	void QMFIR_mWriteReg(Xuint32 BaseAddress, unsigned RegOffset, Xuint32 Data)
 *
 */
#define QMFIR_mWriteReg(BaseAddress, RegOffset, Data) \
 	XIo_Out32((BaseAddress) + (RegOffset), (Xuint32)(Data))

/**
 *
 * Read a value from a QMFIR register. A 32 bit read is performed.
 * If the component is implemented in a smaller width, only the least
 * significant data is read from the register. The most significant data
 * will be read as 0.
 *
 * @param   BaseAddress is the base address of the QMFIR device.
 * @param   RegOffset is the register offset from the base to write to.
 *
 * @return  Data is the data from the register.
 *
 * @note
 * C-style signature:
 * 	Xuint32 QMFIR_mReadReg(Xuint32 BaseAddress, unsigned RegOffset)
 *
 */
#define QMFIR_mReadReg(BaseAddress, RegOffset) \
 	XIo_In32((BaseAddress) + (RegOffset))


/**
 *
 * Write/Read 32 bit value to/from QMFIR user logic slave registers.
 *
 * @param   BaseAddress is the base address of the QMFIR device.
 * @param   RegOffset is the offset from the slave register to write to or read from.
 * @param   Value is the data written to the register.
 *
 * @return  Data is the data from the user logic slave register.
 *
 * @note
 * C-style signature:
 * 	void QMFIR_mWriteSlaveRegn(Xuint32 BaseAddress, unsigned RegOffset, Xuint32 Value)
 * 	Xuint32 QMFIR_mReadSlaveRegn(Xuint32 BaseAddress, unsigned RegOffset)
 *
 */
#define QMFIR_mWriteSlaveReg0(BaseAddress, RegOffset, Value) \
 	XIo_Out32((BaseAddress) + (QMFIR_SLV_REG0_OFFSET) + (RegOffset), (Xuint32)(Value))
#define QMFIR_mWriteSlaveReg1(BaseAddress, RegOffset, Value) \
 	XIo_Out32((BaseAddress) + (QMFIR_SLV_REG1_OFFSET) + (RegOffset), (Xuint32)(Value))
#define QMFIR_mWriteSlaveReg2(BaseAddress, RegOffset, Value) \
 	XIo_Out32((BaseAddress) + (QMFIR_SLV_REG2_OFFSET) + (RegOffset), (Xuint32)(Value))
#define QMFIR_mWriteSlaveReg3(BaseAddress, RegOffset, Value) \
 	XIo_Out32((BaseAddress) + (QMFIR_SLV_REG3_OFFSET) + (RegOffset), (Xuint32)(Value))

#define QMFIR_mReadSlaveReg0(BaseAddress, RegOffset) \
 	XIo_In32((BaseAddress) + (QMFIR_SLV_REG0_OFFSET) + (RegOffset))
#define QMFIR_mReadSlaveReg1(BaseAddress, RegOffset) \
 	XIo_In32((BaseAddress) + (QMFIR_SLV_REG1_OFFSET) + (RegOffset))
#define QMFIR_mReadSlaveReg2(BaseAddress, RegOffset) \
 	XIo_In32((BaseAddress) + (QMFIR_SLV_REG2_OFFSET) + (RegOffset))
#define QMFIR_mReadSlaveReg3(BaseAddress, RegOffset) \
 	XIo_In32((BaseAddress) + (QMFIR_SLV_REG3_OFFSET) + (RegOffset))

/**
 *
 * Write/Read 32 bit value to/from QMFIR user logic memory (BRAM).
 *
 * @param   Address is the memory address of the QMFIR device.
 * @param   Data is the value written to user logic memory.
 *
 * @return  The data from the user logic memory.
 *
 * @note
 * C-style signature:
 * 	void QMFIR_mWriteMemory(Xuint32 Address, Xuint32 Data)
 * 	Xuint32 QMFIR_mReadMemory(Xuint32 Address)
 *
 */
#define QMFIR_mWriteMemory(Address, Data) \
 	XIo_Out32(Address, (Xuint32)(Data))
#define QMFIR_mReadMemory(Address) \
 	XIo_In32(Address)

/**
 *
 * Reset write packet FIFO of QMFIR to its initial state.
 *
 * @param   BaseAddress is the base address of the QMFIR device.
 *
 * @return  None.
 *
 * @note
 * C-style signature:
 * 	void QMFIR_mResetWriteFIFO(Xuint32 BaseAddress)
 *
 */
#define QMFIR_mResetWriteFIFO(BaseAddress) \
 	XIo_Out32((BaseAddress)+(QMFIR_WRFIFO_RST_OFFSET), WRFIFO_RESET)

/**
 *
 * Check status of QMFIR write packet FIFO module.
 *
 * @param   BaseAddress is the base address of the QMFIR device.
 *
 * @return  Status is the result of status checking.
 *
 * @note
 * C-style signature:
 * 	bool QMFIR_mWriteFIFOFull(Xuint32 BaseAddress)
 * 	Xuint32 QMFIR_mWriteFIFOVacancy(Xuint32 BaseAddress)
 *
 */
#define QMFIR_mWriteFIFOFull(BaseAddress) \
 	((XIo_In32((BaseAddress)+(QMFIR_WRFIFO_SR_OFFSET)) & WRFIFO_FULL_MASK) == WRFIFO_FULL_MASK)
#define QMFIR_mWriteFIFOVacancy(BaseAddress) \
 	(XIo_In32((BaseAddress)+(QMFIR_WRFIFO_SR_OFFSET)) & WRFIFO_VAC_MASK)

/**
 *
 * Write 32 bit data to QMFIR write packet FIFO module.
 *
 * @param   BaseAddress is the base address of the QMFIR device.
 * @param   DataOffset is the offset from the data port to write to.
 * @param   Data is the value to be written to write packet FIFO.
 *
 * @return  None.
 *
 * @note
 * C-style signature:
 * 	void QMFIR_mWriteToFIFO(Xuint32 BaseAddress, unsigned DataOffset, Xuint32 Data)
 *
 */
#define QMFIR_mWriteToFIFO(BaseAddress, DataOffset, Data) \
 	XIo_Out32((BaseAddress) + (QMFIR_WRFIFO_DATA_OFFSET) + (DataOffset), (Xuint32)(Data))

/************************** Function Prototypes ****************************/


/**
 *
 * Enable all possible interrupts from QMFIR device.
 *
 * @param   baseaddr_p is the base address of the QMFIR device.
 *
 * @return  None.
 *
 * @note    None.
 *
 */
void QMFIR_EnableInterrupt(void * baseaddr_p);

/**
 *
 * Example interrupt controller handler.
 *
 * @param   baseaddr_p is the base address of the QMFIR device.
 *
 * @return  None.
 *
 * @note    None.
 *
 */
void QMFIR_Intr_DefaultHandler(void * baseaddr_p);

/**
 *
 * Run a self-test on the driver/device. Note this may be a destructive test if
 * resets of the device are performed.
 *
 * If the hardware system is not built correctly, this function may never
 * return to the caller.
 *
 * @param   baseaddr_p is the base address of the QMFIR instance to be worked on.
 *
 * @return
 *
 *    - XST_SUCCESS   if all self-test code passed
 *    - XST_FAILURE   if any self-test code failed
 *
 * @note    Caching must be turned off for this function to work.
 * @note    Self test may fail if data memory and device are not on the same bus.
 *
 */
XStatus QMFIR_SelfTest(void * baseaddr_p);

#endif /** QMFIR_H */

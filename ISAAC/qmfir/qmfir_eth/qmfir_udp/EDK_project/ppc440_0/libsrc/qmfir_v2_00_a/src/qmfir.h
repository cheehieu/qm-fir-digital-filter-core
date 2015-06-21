/*****************************************************************************
* Filename:          /proj/sw/Xilinx/11.1/edk_user_repository/MyProcessorIPLib/drivers/qmfir_v2_00_a/src/qmfir.h
* Version:           2.00.a
* Description:       qmfir Driver Header File
* Date:              Thu Feb 17 12:52:30 2011 (by Create and Import Peripheral Wizard)
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

/************************** Function Prototypes ****************************/


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

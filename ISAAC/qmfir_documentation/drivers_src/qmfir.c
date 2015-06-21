/*****************************************************************************
* Filename:          /proj/users/hmnguyen/EDKproject/qmfir_2new/drivers/qmfir_v1_00_a/src/qmfir.c
* Version:           1.00.a
* Description:       qmfir Driver Source File
* Date:              Fri Feb 25 13:30:20 2011 (by Create and Import Peripheral Wizard)
*****************************************************************************/


/***************************** Include Files *******************************/

#include "qmfir.h"

/************************** Function Definitions ***************************/

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
void QMFIR_EnableInterrupt(void * baseaddr_p)
{
  Xuint32 baseaddr;
  baseaddr = (Xuint32) baseaddr_p;

  /*
   * Enable all interrupt source from user logic.
   */
  QMFIR_mWriteReg(baseaddr, QMFIR_INTR_IPIER_OFFSET, 0x00000001);

  /*
   * Enable all possible interrupt sources from device.
   */
	xil_printf("before DIER");
  QMFIR_mWriteReg(baseaddr, QMFIR_INTR_DIER_OFFSET,
    INTR_TERR_MASK
    | INTR_DPTO_MASK
    | INTR_IPIR_MASK
    | INTR_WFDL_MASK
    );
	xil_printf("after DIER");
	
  /*
   * Set global interrupt enable.
   */
  QMFIR_mWriteReg(baseaddr, QMFIR_INTR_DGIER_OFFSET, INTR_GIE_MASK);
}

/**
 *
 * Example interrupt controller handler for QMFIR device.
 * This is to show example of how to toggle write back ISR to clear interrupts.
 *
 * @param   baseaddr_p is the base address of the QMFIR device.
 *
 * @return  None.
 *
 * @note    None.
 *
 */
void QMFIR_Intr_DefaultHandler(void * baseaddr_p)
{
  Xuint32 baseaddr;
  Xuint32 IntrStatus;
Xuint32 IpStatus;
  baseaddr = (Xuint32) baseaddr_p;

  /*
   * Get status from Device Interrupt Status Register.
   */
  IntrStatus = QMFIR_mReadReg(baseaddr, QMFIR_INTR_DISR_OFFSET);

  xil_printf("Device Interrupt! DISR value : 0x%08x \n\r", IntrStatus);

  /*
   * Verify the source of the interrupt is the user logic and clear the interrupt
   * source by toggle write baca to the IP ISR register.
   */
  if ( (IntrStatus & INTR_IPIR_MASK) == INTR_IPIR_MASK )
  {
    xil_printf("User logic interrupt! \n\r");
    IpStatus = QMFIR_mReadReg(baseaddr, QMFIR_INTR_IPISR_OFFSET);
    QMFIR_mWriteReg(baseaddr, QMFIR_INTR_IPISR_OFFSET, IpStatus);
  }

}


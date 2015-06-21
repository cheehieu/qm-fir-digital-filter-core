/******************************************************************************
* File: int_setup.c
* $Rev: 2 $
* $Author: dbekker $
* $Date: 2008-10-06 10:17:03 -0700 (Mon, 06 Oct 2008) $
*
* Target: ML507 (based on V5FX70T) when XPAR_CPU_PPC440_CORE_CLOCK_FREQ_HZ
*         ML410 (based on V4FX12) otherwise
*
* Interrupt setup functions.
* Derived from Xilinx sample application (see original header below)
*
*******************************************************************************
*
* Copyright (c) 2007 Xilinx, Inc.  All rights reserved.
*
* Xilinx, Inc.
* XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS" AS A
* COURTESY TO YOU.  BY PROVIDING THIS DESIGN, CODE, OR INFORMATION AS
* ONE POSSIBLE   IMPLEMENTATION OF THIS FEATURE, APPLICATION OR
* STANDARD, XILINX IS MAKING NO REPRESENTATION THAT THIS IMPLEMENTATION
* IS FREE FROM ANY CLAIMS OF INFRINGEMENT, AND YOU ARE RESPONSIBLE
* FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE FOR YOUR IMPLEMENTATION.
* XILINX EXPRESSLY DISCLAIMS ANY WARRANTY WHATSOEVER WITH RESPECT TO
* THE ADEQUACY OF THE IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO
* ANY WARRANTIES OR REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE
* FROM CLAIMS OF INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY
* AND FITNESS FOR A PARTICULAR PURPOSE.
*
******************************************************************************/

#include "arch/cc.h"       /* type definitions associated with lwip library */
#include "xparameters.h"   /* system-specific environment definition */
#include "xintc.h"         /* interrupt controller header */
#include "xexception_l.h"  /* exception defines */
#include "xtime_l.h"       /* for the PPC timer */
#include "qmfir.h"         /* QMFIR interface header */
#include "qmfir_comm.h"    /* network interface to QMFIR core */

/* define the timer interval */
#ifdef XPAR_CPU_PPC440_CORE_CLOCK_FREQ_HZ
#define PIT_INTERVAL (0.250 * XPAR_CPU_PPC440_CORE_CLOCK_FREQ_HZ)
#else
#define PIT_INTERVAL (0.250 * XPAR_CPU_PPC405_CORE_CLOCK_FREQ_HZ)
#endif

/* local function prototypes */
void setup_qmfir();
void setup_timer();
void timer_callback();
void xadapter_timer_handler(void *);
void qmfir_intr(void *);

/* global variable for interrupt controller */
XIntc intc;

/******************************************************************************
* Name:        enable_interrupts
* Description: Enable all interrupts
******************************************************************************/
void enable_interrupts() {

   XExc_mEnableExceptions(XEXC_NON_CRITICAL);
   
} /* enable_interrupts */

/******************************************************************************
* Name:        setup_interrupts
* Description: Initialize the interrupt controller and setup QMFIR and timer
*              interrupts
******************************************************************************/
void setup_interrupts() {
   
   /* declare a pointer and set it to the global interrupt controller */
   XIntc *intcp;
   intcp = &intc;

   /* initialize, start, and enable the interrupt controller */
   XIntc_Initialize(intcp, XPAR_XPS_INTC_0_DEVICE_ID);
   XIntc_Start(intcp, XIN_REAL_MODE);
	XIntc_mMasterEnable(XPAR_XPS_INTC_0_BASEADDR);
   
   /* register the default interrupt handler */
   XExc_Init();
   XExc_RegisterHandler( XEXC_ID_NON_CRITICAL_INT,
                         ( XExceptionHandler )XIntc_DeviceInterruptHandler,
                         ( void* )XPAR_XPS_INTC_0_DEVICE_ID );
   
   /* setup QMFIR interrupts */
	setup_qmfir();

   /* setup the PPC timer for debug */
   #ifdef QMFIR_DEBUG
	setup_timer();
   #endif

} /* setup_interrupts */

/******************************************************************************
* Name:        setup_qmfir
* Description: Setup QMFIR interrupts
******************************************************************************/
void setup_qmfir() {
   /* register the QMFIR interrupt handler and enable it*/
   XIntc_Connect( &intc, XPAR_INTC_0_QMFIR_0_VEC_ID,
                  ( XInterruptHandler )qmfir_intr,
                  ( void* )XPAR_QMFIR_0_BASEADDR );  					
   XIntc_Enable( &intc, XPAR_INTC_0_QMFIR_0_VEC_ID );
   QMFIR_EnableInterrupt( ( void* )XPAR_QMFIR_0_BASEADDR );

} /* setup_qmfir */

/******************************************************************************
* Name:        setup_timer
* Description: Setup a 250ms timer to update TCP timers
******************************************************************************/
void setup_timer() {

   /* Set PIT to interrupt every 250 mseconds */ 
#ifdef XPAR_CPU_PPC440_CORE_CLOCK_FREQ_HZ   
   XExc_RegisterHandler(XEXC_ID_DEC_INT, (XExceptionHandler)xadapter_timer_handler, NULL);
   XTime_DECSetInterval(PIT_INTERVAL);
   XTime_TSRClearStatusBits(XREG_TSR_CLEAR_ALL);
   XTime_DECEnableAutoReload();
   XTime_DECEnableInterrupt();
#else   
   XExc_RegisterHandler(XEXC_ID_PIT_INT, (XExceptionHandler)xadapter_timer_handler, NULL);
	XTime_PITSetInterval(PIT_INTERVAL);
	XTime_TSRClearStatusBits(XREG_TSR_CLEAR_ALL);
	XTime_PITEnableAutoReload();
	XTime_PITEnableInterrupt();
#endif   
   
} /* setup_timer */

/******************************************************************************
* Name:        timer_callback
* Description: Used for debug
******************************************************************************/
void timer_callback() {
   
   /* go into debugging mode */
   qmfir_debug();
      
} /* timer_callback */

/******************************************************************************
* Name:        xadapter_timer_handler
* Description: PIT timer interrupt handler
*
* Arguments:   void *p  - pointer to address / id
******************************************************************************/
void xadapter_timer_handler( void *p ) {
	
   /* call the timer callback routine to refresh TCP timers */
   timer_callback();

   /* clear itnerrupt */
   XTime_TSRClearStatusBits(XREG_TSR_CLEAR_ALL);
   
} /* xadapter_timer_handler */

/******************************************************************************
* Name:        qmfir_intr
* Description: QMFIR interrupt handler
*
* Arguments:   void *baseaddr_p  - pointer to QMFIR core base address
******************************************************************************/
void qmfir_intr(void * baseaddr_p) {

   /* set the base address and declare an interrupt status variable */
   Xuint32 baseaddr;
   Xuint32 IpStatus;
   baseaddr = (Xuint32) baseaddr_p;
 
   /* read the interrupt register status */
   IpStatus = QMFIR_mReadReg(baseaddr, QMFIR_INTR_IPISR_OFFSET);
   
   #ifdef QMFIR_DEBUG
   #ifndef DATA_DUMP
   xil_printf( "IRQ %d\r", IpStatus );
   #endif
   #endif
   
   /* do something */
   transfer_data( IpStatus );
   
   /* clear the corresponding interrupt in interrupt controller */
   QMFIR_mWriteReg(baseaddr, QMFIR_INTR_IPISR_OFFSET, IpStatus);

} /* qmfir_intr */

/******************************************************************************
* File: int_setup.h
* $Rev: 2 $
* $Author: dbekker $
* $Date: 2008-10-06 10:17:03 -0700 (Mon, 06 Oct 2008) $
*
* Target: ML507 (based on V5FX70T) when XPAR_CPU_PPC440_CORE_CLOCK_FREQ_HZ
*         ML410 (based on V4FX60) otherwise
*
* Header for interrupt setup functions.
* Derived from Xilinx sample application (see original header below)
*
*******************************************************************************
*
* Copyright (c) 2008 Xilinx, Inc.  All rights reserved.
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

#ifndef INT_SETUP_H
#define INT_SETUP_H

/******************************************************************************
* Name:        enable_interrupts
* Description: Enable all interrupts
******************************************************************************/
void enable_interrupts();

/******************************************************************************
* Name:        setup_interrupts
* Description: Initialize the interrupt controller and setup QMFIR and timer
*              interrupts
******************************************************************************/
void setup_interrupts();

#endif

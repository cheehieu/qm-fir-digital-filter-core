/******************************************************************************
* File: qmfir_comm.h
* $Rev: 2 $
* $Author: dbekker $
* $Date: 2008-10-06 10:17:03 -0700 (Mon, 06 Oct 2008) $
*
* Target: ML507 (based on V5FX70T) when XPAR_CPU_PPC440_CORE_CLOCK_FREQ_HZ
*         ML410 (based on V4FX60) otherwise
*
* Header for qmfir and ethernet communication functions.
*
******************************************************************************/

#ifndef QMFIR_COMM_H
#define QMFIR_COMM_H

/******************************************************************************
* Name:        start_application
* Description: Setup buffers and configure IP / UDP
* 
* Returns:     int   - returns 0 if no errors
******************************************************************************/
int start_application();

/******************************************************************************
* Name:        transfer_data
* Description: Send out UDP data
* 
* Arguments:   unsinged int  - interrupt bits
* Returns:     int           - returns 0 if no errors
******************************************************************************/
int transfer_data( unsigned int );

/******************************************************************************
* Name:        debug_menu
* Description: Print the debug menu
******************************************************************************/
void debug_menu();

/******************************************************************************
* Name:        qmfir_debug
* Description: Debugging mode for QMFIR testing. Allows user to manually send
*              commands to QMFIR (via UART).
******************************************************************************/
void qmfir_debug();

#endif

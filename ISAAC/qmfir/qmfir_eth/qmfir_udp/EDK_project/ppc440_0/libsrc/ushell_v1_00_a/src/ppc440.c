/***************************************************************
 * uShell - A minimalist shell for the Xilinx Virtex PPC-class 
 * uProcessors
 *
 * ORIGINAL AUTHOR: Thomas Werne
 * COMPANY: Jet Propulsion Laboratory
 * VERSION: 1.00
 *
 * File: ppc440.c
 * $Author$
 * $Date$
 * $Rev$
 *
 * Target: PowerPC 440
 *
 * PowerPC 440-specific functions
 *
 * Copyright 2009, 2010, by the California Institute of Technology.  ALL
 * RIGHTS RESERVED.  United States Government Sponsorship acknowledged.
 * Any commercial use must be negotiated with the Office of Technology
 * Transfer at the California Institute of Technology.
 *
 * This software may be subject to U.S. export control laws and
 * regulations.  By accepting this document, the user agrees to comply
 * with all U.S. export laws and regulations.  User has the
 * responsibility to obtain export licenses, or other export authority
 * as may be required before exporting such information to foreign
 * countries or providing access to foreign persons.
 **************************************************************/

#include <stdlib.h>

#include "ushell.h"
#include "ushell_config.h"

#ifdef ENABLE_REBOOT
/* Reboot the shell */
int reboot() {
    user_halt();

    /* Jump to the reset vector */
    asm volatile ( "ba 0xFfffFffc" );

    return 0;
}
#endif

#ifdef ENABLE_HALT
/* Shutdown the shell */
int halt() {
    /* Call the user custom defined shutdown routine */
    user_halt();
    /* Shutdown procedure, taken from Lfpu_init_done */
    exit(0);
    
    /* If the previous code breaks, try this:
    asm volatile ( "b 0"); */

    return 0;
}
#endif

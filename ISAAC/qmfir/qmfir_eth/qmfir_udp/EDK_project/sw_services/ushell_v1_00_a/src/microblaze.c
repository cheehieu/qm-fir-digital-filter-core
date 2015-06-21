/***************************************************************
 * uShell - A minimalist shell for the Xilinx Virtex PPC-class 
 * uProcessors
 *
 * ORIGINAL AUTHOR: Thomas Werne
 * COMPANY: Jet Propulsion Laboratory
 * VERSION: 1.00
 *
 * File: microblaze.c
 * $Author$
 * $Date$
 * $Rev$
 *
 * Target: Microblaze
 *
 * Microblaze-specific functions
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

/* UNTESTED as of 08 June, 2009 */
/* TAW */

#include "ushell.h"

/* Reboot the shell */
int reboot() {
    /* Jump to the reset vector */
//    asm volatile ( "br _start" );

    return 0;
}

/* Shutdown the shell */
int halt() {
    /* Call the user custom defined shutdown routine */
    user_halt();
    /* Shutdown procedure, taken from Lfpu_init_done */
//    asm volatile ( "br __fini" );
//    asm volatile ( "br _program_clean" );
//    asm volatile ( "br exit" );
    
    /* If the previous code breaks, try this:
    asm volatile ( "b 0"); */

    exit(0);

    return 0;
}


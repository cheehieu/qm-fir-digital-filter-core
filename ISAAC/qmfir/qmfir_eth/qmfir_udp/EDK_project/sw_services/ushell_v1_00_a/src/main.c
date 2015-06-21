/**************************************************************
 * uShell - A minimalist shell for the Xilinx Virtex PPC-class 
 * uProcessors
 *
 * ORIGINAL AUTHOR: Thomas Werne
 * COMPANY: Jet Propulsion Laboratory
 * VERSION: 1.00
 *
 * File: main.c
 * $Author$
 * $Date$
 * $Rev$
 *
 * Target: PowerPC 440, PowerPC 405, Microblaze
 *
 * Program entry point.
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

#include "stdio.h"
#include "ushell.h"

const char __attribute__((weak)) PROMPT[] = "uShell> ";
const unsigned int __attribute((weak)) MAX_ARGS = 7;
//const unsigned int LENGTH = 256;
//const unsigned int HISTORY = 10;

int main() {

    /* Call initialization functions */
    clear_screen();
    init();
    ushell_init();
    user_init();

    xil_printf("\r\n%s", PROMPT);
    while(1) {
        user_loop();
        execute_loop();
    }

    return 0;
}


/***************************************************************
 * uShell - A minimalist shell for the Xilinx Virtex PPC-class 
 * uProcessors
 *
 * ORIGINAL AUTHOR: Thomas Werne
 * COMPANY: Jet Propulsion Laboratory
 * VERSION: 1.00
 *
 * File: ushell_sem.c
 * $Author$
 * $Date$
 * $Rev$
 *
 * Target: PowerPC 440, PowerPC 405, Microblaze
 *
 * Source code for uShell semaphore library
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

#include "ushell_sem.h"

void sem_init(semaphore *sem) {
    sem->count = 0;
}

void sem_give(semaphore *sem) {
    sem->count = 1;
}

int sem_take(semaphore *sem) {
    if (sem->count)
        return sem->count--;
    else
        return 0;
}

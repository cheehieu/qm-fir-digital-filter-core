/**************************************************************
 *
 * uShell - A minimalist shell for the Xilinx Virtex PPC-class 
 * uProcessors
 *
 * ORIGINAL AUTHOR: Thomas Werne
 * COMPANY: Jet Propulsion Laboratory
 * VERSION: 1.00
 *
 * File: memory_map.c
 * $Author: $
 * $Date: $
 * $Rev: -1 $
 *
 * Target: PowerPC 440, PowerPC 405, Microblaze
 *
 * uShell memory map file
 * Copyright 2009, 2010, by the California Institute of Technology.  ALL
 * RIGHTS RESERVED.  United States Government Sponsorship acknowledged.
 *  Any commercial use must be negotiated with the Office of Technology
 * Transfer at the California Institute of Technology.
 *
 * This software may be subject to U.S. export control laws and
 * regulations.  by accepting this document, the user agrees to comply
 * with all U.S. export laws and regulations.  User has the
 * responsibility to obtain export licenses, or other export authority
 * as may be required before exporting such information to foreign
 * countries or providing access to foreign persons.
 **************************************************************/

#include <stdlib.h>
#include "ushell.h"

const address_table memory_map[] = {
    { 1, "DDR_SDRAM_0", 0x00000000, 0x1fffffff},
    { 2, "xps_bram_if_cntlr_0", 0xffff8000, 0xffffffff},
    { 0, NULL, 0, 0} 
};


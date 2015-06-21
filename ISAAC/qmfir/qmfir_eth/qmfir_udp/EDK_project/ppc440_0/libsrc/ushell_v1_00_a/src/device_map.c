/**************************************************************
 *
 * uShell - A minimalist shell for the Xilinx Virtex PPC-class 
 * uProcessors
 *
 * ORIGINAL AUTHOR: Thomas Werne
 * COMPANY: Jet Propulsion Laboratory
 * VERSION: 1.00
 *
 * File: device_map.c
 * $Author: $
 * $Date: $
 * $Rev: -1 $
 *
 * Target: PowerPC 440, PowerPC 405, Microblaze
 *
 * uShell device map file
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

const address_table device_map[] = {
    { 1, "Hard_Ethernet_MAC", 0x83c80000, 0x83cfffff},
    { 2, "Hard_Ethernet_MAC_fifo", 0x81a00000, 0x81a0ffff},
    { 3, "RS232_0", 0x84000000, 0x8400ffff},
    { 4, "qmfir_0", 0xcea00000, 0xcea0ffff},
    { 5, "xps_intc_0", 0x81800000, 0x8180ffff},
    { 6, "xps_sysmon_adc_0", 0x83800000, 0x8380ffff},
    { 7, "xps_timer_0", 0x83c00000, 0x83c0ffff},
    { 0, NULL, 0, 0} 
};


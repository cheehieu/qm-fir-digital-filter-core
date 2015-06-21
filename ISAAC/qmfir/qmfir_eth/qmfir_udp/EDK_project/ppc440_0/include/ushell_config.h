/**************************************************************
 *
 * uShell - A minimalist shell for the Xilinx Virtex PPC-class 
 * uProcessors
 *
 * ORIGINAL AUTHOR: Thomas Werne
 * COMPANY: Jet Propulsion Laboratory
 * VERSION: 1.00
 *
 * File: ushell_config.h
 * $Author: $
 * $Date: $
 * $Rev: -1 $
 *
 * Target: PowerPC 440, PowerPC 405, Microblaze
 *
 * Configuration header for conditionally including functions in uShell
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

#ifndef USHELL_CONFIG_H
#define USHELL_CONFIG_H

#define ENABLE_CACHE
#define ENABLE_USAGE
#define ENABLE_EXEC
#define ENABLE_HISTORY
#define ENABLE_HELP
#define ENABLE_HALT
#define ENABLE_REBOOT
#define ENABLE_COPY
#define ENABLE_LOAD
#define ENABLE_DUMP
#define ENABLE_RWR
#define ENABLE_RRD
#define ENABLE_MWR
#define ENABLE_MRD
#define ENABLE_WR
#define ENABLE_RD
#define ENABLE_MEMS
#define ENABLE_DEVS
#define ENABLE_LIST
#define ENABLE_LS
#define PPC440

#endif /* USHELL_CONFIG_H */

/**************************************************************
 *
 * uShell - A minimalist shell for the Xilinx Virtex PPC-class 
 * uProcessors
 *
 * ORIGINAL AUTHOR: Thomas Werne
 * COMPANY: Jet Propulsion Laboratory
 * VERSION: 1.00
 *
 * File: function_map.c
 * $Author: $
 * $Date: $
 * $Rev: -1 $
 *
 * Target: PowerPC 440, PowerPC 405, Microblaze
 *
 * uShell function map file
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

extern int copy(int argc, char **argv);
extern int devs();
extern int dump(int argc, char **argv);
extern int exec(int argc, char **argv);
extern int halt();
extern int help();
extern int list();
extern int load(int argc, char **argv);
extern int ls();
extern int mems();
extern int mrd(int argc, char **argv);
extern int mwr(int argc, char **argv);
extern int rd(int argc, char **argv);
extern int reboot();
extern int rrd(int argc, char **argv);
extern int rwr(int argc, char **argv);
extern int version();
extern int wr(int argc, char **argv);

const function_table function_map[] = {
    {"copy", copy},
    {"devs", devs},
    {"dump", dump},
    {"exec", exec},
    {"halt", halt},
    {"help", help},
    {"list", list},
    {"load", load},
    {"ls", ls},
    {"mems", mems},
    {"mrd", mrd},
    {"mwr", mwr},
    {"rd", rd},
    {"reboot", reboot},
    {"rrd", rrd},
    {"rwr", rwr},
    {"version", version},
    {"wr", wr},
    {NULL, NULL} 
};


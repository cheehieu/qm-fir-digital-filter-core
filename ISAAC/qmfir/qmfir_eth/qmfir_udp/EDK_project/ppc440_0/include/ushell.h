/**************************************************************
 * uShell - A minimalist shell for the Xilinx Virtex PPC-class 
 * uProcessors
 *
 * ORIGINAL AUTHOR: Thomas Werne
 * COMPANY: Jet Propulsion Laboratory
 * VERSION: 1.00
 *
 * File: ushell.h
 * $Author$
 * $Date$
 * $Rev$
 *
 * Target: PowerPC 440
 *
 * Header for uShell
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

#ifndef USHELL_H
#define USHELL_H

#include "ushell_config.h"
#include "ushell_sem.h"
#include "xbasic_types.h"

/* Necessary.  Permits redefinition of USHELL to something
 * searchable*/
#ifndef USHELL
    #define USHELL
#endif

#define VERSION "1.00"

#if   defined(PPC440)
#define TAGLINE "uShell - A minimalist PPC440 shell"
#elif defined(PPC405)
#define TAGLINE "uShell - A minimalist PPC405 shell"
#elif defined(MICROBLAZE)
#define TAGLINE "uShell - A minimalist Microblaze shell"
#endif

#define min(x,y) ((x) < (y) ? (x) : (y))

extern const char PROMPT[];
extern const unsigned int MAX_ARGS;
#ifdef ENABLE_INTERRUPT_DRIVEN
extern volatile semaphore io_sem;
#endif /* ENABLE_INTERRUPT_DRIVEN */

//extern static const unsigned int LENGTH;
//extern const unsigned int HISTORY;
#define LENGTH 32
#define HISTORY 5

#ifdef ENABLE_USAGE
    #define PRINT_USAGE(x) xil_printf("Usage: " x)
#else
    #define PRINT_USAGE(x) /* x */
#endif

extern void outbyte(char);
extern char inbyte();

typedef struct FUNCTION_TABLE {
    char *name;
    int  (*address)();
} function_table;

typedef struct ADDRESS_TABLE {
    char key;
    char *name;
    unsigned int base_addr;
    unsigned int high_addr;
} address_table;

extern const address_table device_map[];
extern const address_table memory_map[];
extern const function_table function_map[];

#ifdef ENABLE_LS
USHELL int ls();
#endif
#ifdef ENABLE_LIST
USHELL int list();
#endif
#ifdef ENABLE_DEVS
USHELL int devs();
#endif
#ifdef ENABLE_MEMS
USHELL int mems();
#endif
#ifdef ENABLE_RD
USHELL int rd(int argc, char **argv);
#endif
#ifdef ENABLE_WR
USHELL int wr(int argc, char **argv);
#endif
#ifdef ENABLE_MRD
USHELL int mrd(int argc, char **argv);
#endif
#ifdef ENABLE_MWR
USHELL int mwr(int argc, char **argv);
#endif
#ifdef ENABLE_RRD
USHELL int rrd(int argc, char **argv);
#endif
#ifdef ENABLE_RWR
USHELL int rwr(int argc, char **argv);
#endif
#ifdef ENABLE_DUMP
USHELL int dump(int argc, char **argv);
#endif
#ifdef ENABLE_LOAD
USHELL int load(int argc, char **argv);
#endif
#ifdef ENABLE_JUMP
USHELL int jump(int argc, char **argv);
#endif
#ifdef ENABLE_COPY
USHELL int copy(int argc, char **argv);
#endif
#ifdef ENABLE_EXEC
USHELL int exec(int argc, char **argv);
#endif
#ifdef ENABLE_REBOOT
USHELL int reboot();
#endif
#ifdef ENABLE_HALT
USHELL int halt();
#endif
#ifdef ENABLE_HELP
USHELL int help();
#endif
USHELL int version();

/* Used to process input */
/* Not for general population usage */
void backspace();
int strtoi(char *string);
void get_offset(char *address, int *offset);
int get_address(const address_table *table, char *id, u32 *address);
void ushell_memcpy(void * dest, const void * src, int n); 
int isEmpty();
int execute(char *command);
int get_line(char *line, const unsigned int length);
int parse_command(char *command, int *argc, char **argv);
int strequ(const char *str1, const char *str2);
int main();
void ushell_uart_interrupt_handler();

/* These do the real work */
void ushell_read(u32, char);
void ushell_write(u32, u32, char);

/* Initialization functions 
 * init() and user_init are user-customizable, ushell_init is not
 * The functions are called in the order:
 * init()
 * ushell_init()
 * user_init()
 *
 * This allows you to put setup code (cache and interrupt enables,
 * etc.) as the first piece of code that's run, then print custom
 * information on boot.
 */
void init();
void ushell_init();
void user_init();

/* user_help() is called immediately before the help() function
 * returns.  This allows a user to include help for their own
 * commands.  This function is optional.
 */
void user_help();

/* user_halt() is called immediately before the processor halts.
 * This allows a user to clean up and properly shut down any devices.
 * This function is optional.
 */
void user_halt();

void user_loop();

#endif /* USHELL_H */

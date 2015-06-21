/***************************************************************
 * uShell - A minimalist shell for the Xilinx Virtex PPC-class 
 * uProcessors
 *
 * ORIGINAL AUTHOR: Thomas Werne
 * COMPANY: Jet Propulsion Laboratory
 * VERSION: 1.00
 *
 * File: ushell.c
 * $Author$
 * $Date$
 * $Rev$
 *
 * Target: PowerPC 440, PowerPC 405, Microblaze
 *
 * Source code for uShell
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
#include <string.h>
#include "stdio.h"
#include "ushell.h"
#include "ushell_config.h"
#include "ushell_processor.h"
#include "xbasic_types.h"
#include "ushell_sem.h"
// project specific...
#include "xparameters.h"
#include "xuartlite_l.h"

#ifdef ENABLE_INTERRUPT_DRIVEN
volatile semaphore io_sem;
#endif /* ENABLE_INTERRUPT_DRIVEN */

static const char oops[] = "WEASEL says: ";
static const char divider[] = 
"----------------------------------------------------------";

/* Define empty default user-redefinable functions */
void __attribute__((weak)) init() { asm volatile ("nop"); }
void __attribute__((weak)) user_init() { asm volatile ("nop"); }
void __attribute__((weak)) user_help() { asm volatile ("nop"); }
void __attribute__((weak)) user_halt() { asm volatile ("nop"); }
void __attribute__((weak)) user_loop() { asm volatile ("nop"); }

#ifdef ENABLE_LIST
/* Print function table */
int list() {
    int i;
    
    xil_printf("Functions:\r\n");
    // iterate through the function list, printing as we go
    for (i = 0; function_map[i].name != NULL; i++) {
        xil_printf(" - %s\r\n", function_map[i].name);
    }

    return 0;
}
#endif /* ENABLE_LIST */

#ifdef ENABLE_DEVS
// Print device information
int devs() {
    int i;

    xil_printf("Devices:\r\n\tKey\tDevice\t\tBase\tHigh\r\n%s\r\n", divider);
    // iterate through the device map, printing as we go
    for (i = 0; device_map[i].name != NULL; i++) {
        xil_printf("\t%02d\t%s\t0x%08x\t0x%08x\r\n", device_map[i].key, 
                device_map[i].name, device_map[i].base_addr, 
                device_map[i].high_addr);
    }

    return 0;
}
#endif /* ENABLE_DEVS */

#ifdef ENABLE_MEMS
// Print memory information 
int mems() {
    int i;

    xil_printf("Memory:\r\n\tKey\tDevice\t\tBase\tHigh\r\n%s\r\n", divider);
    // iterate through the memory map, printing as we go
    for (i = 0; memory_map[i].name != NULL; i++) {
        xil_printf("\t%02d\t%s\t0x%08x\t0x%08x\r\n", memory_map[i].key, 
                memory_map[i].name, memory_map[i].base_addr, 
                memory_map[i].high_addr);
    }

    return 0;
}
#endif /* ENABLE_MEMS */

#ifdef ENABLE_LS
int ls() {
#ifdef ENABLE_LIST
    list();
    xil_printf("\r\n");
#endif
#ifdef ENABLE_DEVS
    devs();
    xil_printf("\r\n");
#endif
#ifdef ENABLE_MEMS
    mems();
#endif
    return 0;
}
#endif /* ENABLE_LS */

// execute a command taken from stdin
int execute(char *command) {
    int i;
    int argc;
    char *argv[MAX_ARGS];

    // parse the input command, separating the command from arguments
    parse_command(command, &argc, argv);
    
    // iterate through the function map
    for (i = 0; function_map[i].name != NULL; i++) {
        if (strequ(function_map[i].name, argv[0])) {
            (*(function_map[i].address))(argc, argv);
            return 0;
        }
    }

    return -1;
}

// Parse a space-delimited command string using standard C: 
// argv is an array of strings, each one holding an argument
// argv[0] is the function name
// argc is the number of arguments, including function name
//
// Use quotes to include spaces in command
int parse_command(char *command, int *argc, char *argv[MAX_ARGS]) {
    
/* TODO: accept quotes in strings */
    int i = 0;
    int inside_quotes = 0;

    // the function name begins the command
    for (i = 0; command[i] == ' '; i++);
    argv[0] = command + i;

    // now start getting command arguments
    *argc = 1;
    for( ; command[i] != '\0'; i++) {
        if (command[i] == '"') {
            // deal with quoted strings
            command[i] = '\0';
            inside_quotes = !inside_quotes;
            if (inside_quotes && command[i + 1] != '"' && 
                    command[i + 1] != '\0') {
                if (*argc == MAX_ARGS) {
                    break;
                }
                argv[(*argc)++] = command + i + 1;
            }
        } else if (!inside_quotes) {
            if (command[i] == ' ') {
                command[i] = '\0';

                if (command[i + 1] != ' ' && command[i + 1] != '"' && 
                        command[i + 1] != '\0') {
                    if (*argc == MAX_ARGS) {
                        break;
                    }
                    argv[(*argc)++] = command + i + 1;
                }
            }
        }
    }

    return 0;
}

/* Read a line from stdin */
int get_line(char *command, const unsigned int length) {
    static int position = 0;
    static u8 control = 0;

#ifdef ENABLE_HISTORY
    static u8 history_length = 0;
    static int history_position = -1;
    static char command_history[HISTORY][LENGTH];
#endif /* ENABLE_HISTORY */

    command[length - 1] = '\0';

    while (position < length - 1) {
        // careful... project specific
        if (isEmpty()) {;
            return -1;
        }
        command[position] = inbyte();
        if (command[position] == '\r') {
            /* if we get a CR from stdin, replace with a
               null terminator, echo CRLF */
            command[position] = '\0';
            outbyte('\r'); outbyte('\n');

#ifdef ENABLE_HISTORY 
            /* copy history... */
            for (history_position = HISTORY - 1; 
                    history_position > 0; history_position--) {
                strcpy(command_history[history_position], 
                        command_history[history_position - 1]);
            }
            strcpy(command_history[0], command);
            history_position = -1;
            history_length = min(history_length + 1, HISTORY);
#endif /* ENABLE_HISTORY */
            position = 0;
            return 0;
        } else if (command[position] == '\b') {
            /* handle BS */
            if (position > 0) {
                position--;
                backspace();
            }
        } else if (command[position] == '') {
            /* Handle Ctrl+C */
            command[0] = '\0';
            outbyte('\r'); outbyte('\n');
            position = 0;
#ifdef ENABLE_HISTORY
            history_position = -1;
#endif /* ENABLE_HISTORY */
            return 0;
        } else if (command[position] >= ' ' && command[position] <= '~') {
            /* only accept alphanumeric characters */
            /* handle up, down commands */
            if (control && (command[position] == 'A' || 
                        command[position] == 'B')) {
#ifdef ENABLE_HISTORY
                history_position += (command[position] == 'A') ?  1 : 
                    ((history_position == -1) ?  
                     min(history_length, HISTORY) : 
                     min(history_length, HISTORY) -1);

                history_position %= min(history_length, HISTORY);
#endif /* ENABLE_HISTORY */

                /* clear line */
                for (; position > 0; position--) {
                    backspace();
                }
#ifdef ENABLE_HISTORY
                for (position = 0; 
                    command_history[history_position][position] != '\0'; 
                    position++) {

                    command[position] = 
                        command_history[history_position][position];
                    outbyte(command[position]);
                }
#endif /* ENABLE_HISTORY */
            } else if (control && (command[position] == 'C' || 
                        command[position] == 'D')) {
                backspace();
                position--;
            } else {
                control = (command[position] == '[') ? 1 : 0;
                outbyte(command[position++]);
            }
            
        } else {
            command[position] = '\0';
        }
    }

    return -1;
}

#ifdef ENABLE_JUMP
/* Jump to an address, begin execution */
int jump(int argc, char **argv) {
    // TODO: Check that address is valid
    void (*address)(int, char **) = (void *)strtoi(argv[1]);
    (*address)(argc - 1, argv + 1);

    return 0;
}
#endif /* ENABLE_JUMP */

#if defined(ENABLE_MRD) || defined(ENABLE_RRD) || defined(ENABLE_RD)
void ushell_read(u32 addr, char specifier) {
    switch (0x60 | specifier) {
        case 'b':
            xil_printf("0x%02x\r\n", *(u8 *)(addr + 3));
            break;
        case 'h':
            xil_printf("0x%04x\r\n", *(u16 *)(addr + 2));
            break;
        case 'w':
            xil_printf("0x%08x\r\n", *(u32 *)addr);
            break;
        default:
            xil_printf("Unknown specifier in read\r\n");
    }
}
#endif /*defined(ENABLE_MRD) || defined(ENABLE_RRD) || defined(ENABLE_RD) */

#if defined(ENABLE_MWR) || defined(ENABLE_RWR) || defined(ENABLE_WR)
void ushell_write(u32 addr, u32 data, char specifier) {
    switch (0x60 | specifier) {
        case 'b':
            *(u8 *)(addr + 3) = (u8)data;
            break;
        case 'h':
            *(u16 *)(addr + 2) = (u16)data;
            break;
        case 'w':
            *(u32 *)addr = (u32)data;
            break;
        default:
            xil_printf("Unknown specifier in write\r\n");
    }
}
#endif /*defined(ENABLE_MWR) || defined(ENABLE_RWR) || defined(ENABLE_WR) */

            

#ifdef ENABLE_RD
/* Read data stored at memory location
 *
 * rd addr [b|h|w] 
 *
 * Read a (b)yte, (h)alfword, (w)ord of data from memory at addr.
 * Defaults to word read.
 * Interprets addr at a hex address if prefixed with 'x' or '0x', 
 * otherwise a decimal address
 */
int rd(int argc, char **argv) {
    char fmt = 'w';
    if (argc == 3) {
        fmt = argv[2][0];
    } else if (argc != 2) {
        PRINT_USAGE("rd addr [b|h|w]\r\n");
        return -1;
    }

    ushell_read((u32)strtoi(argv[1]), fmt);

    return 0;
}
#endif /* ENABLE_RD */

#ifdef ENABLE_WR
/* Write data to memory location
 *
 * mwr addr data [b|h|w] 
 *
 * Read a (b)yte, (h)alfword, (w)ord of data from memory at addr.
 * Defaults to word read.
 * Interprets addr at a hex address if prefixed with 'x' or '0x', 
 * otherwise a decimal address
 */
int wr(int argc, char **argv) {
    char fmt = 'w';

    if (argc == 4) {
        // assume there is no data size specification, write word
        fmt = argv[3][0];
    } else if (argc != 3) {
        PRINT_USAGE("wr addr data [b|h|w] \r\n");
        return -1;
    }
    ushell_write((u32)strtoi(argv[1]), 
        (u32)strtoi(argv[2]), fmt);
    return 0;
}
#endif /* ENABLE_WR */

#ifdef ENABLE_MRD
/* mrd <name|key>[offset] [b|h|w]
 */
int mrd(int argc, char **argv) {
    u32 addr;
    char fmt = 'w';

    if (argc == 3) {
        fmt = argv[2][0];
    } else if (argc != 2) {
        PRINT_USAGE("mrd <name|key>[offset] [b|h|w]\r\n");
        return -1;
    }

    if (!get_address(memory_map, argv[1], &addr)) {
        ushell_read(addr, fmt);
        return 0;
    }

    return -1;
}
#endif /* ENABLE_MRD */

#ifdef ENABLE_RRD
/* rrd <name|key>[offset] [b|h|w]
 */
int rrd(int argc, char **argv) {
    u32 addr;
    char fmt = 'w';

    if (argc == 3) {
        fmt = argv[2][0];
    } else if (argc != 2) {
        PRINT_USAGE("rrd <name|key>[offset] [b|h|w]\r\n");
        return -1;
    }
    
    if (!get_address(device_map, argv[1], &addr)) {
        ushell_read(addr, fmt);
        return 0;
    }

    return -1;
}
#endif /* ENABLE_RRD */

#ifdef ENABLE_MWR
/* mwr <name|key>[offset] data [b|h|w]
 */
int mwr(int argc, char **argv) {
    u32 addr;
    char fmt = 'w';

    if (argc == 4) {
        fmt = argv[3][0];
    } else if (argc != 3) {
        PRINT_USAGE("mwr <name|key>[offset] data [b|h|w]\r\n");
        return -1;
    }
    
    if (!get_address(memory_map, argv[1], &addr)) {
        ushell_write(addr, (u32)strtoi(argv[2]), fmt);
        return 0;
    }

    return -1;
}
#endif /* ENABLE_MWR */

#ifdef ENABLE_RWR
/* rwr <name|key>[offset] data [b|h|w]
 */
int rwr(int argc, char **argv) {
    u32 addr;
    char fmt = 'w';

    if (argc == 4) {
        fmt = argv[3][0];
    } else if (argc != 3) {
        PRINT_USAGE("rwr <name|key>[offset] data [b|h|w]\r\n");
        return -1;
    }
    
    if (!get_address(device_map, argv[1], &addr)) {
        ushell_write(addr, (u32)strtoi(argv[2]), fmt);
        return 0;
    }

    return -1;
}
#endif /* ENABLE_RWR */

#ifdef ENABLE_LOAD
/* load base_addr length */
/* in kermit, you can load a file using:
 * transmit /binary filename
 */
int load(int argc, char **argv) {
    //TODO:  reorder the inbytes?
    int cnt = 0;

    u8 *base_address = (u8 *)strtoi(argv[1]);
    for(cnt = strtoi(argv[2]); cnt > 0; cnt--) {
        *base_address++ = inbyte();
    }

    return 0;
}
#endif /* ENABLE_LOAD */

#ifdef ENABLE_DUMP
/* dump base_addr number */
int dump(int argc, char **argv) {
    int cnt = 0;
    int number;

    u8 *base_address = (u8 *)strtoi(argv[1]);
    number = strtoi(argv[2]);
    for(cnt = 0; cnt < number; cnt++) {
        //TODO:  reorder the outbytes??
        if (cnt % 16 == 0) {
            if (cnt != 0) {
                xil_printf("\r\n");
            }
            xil_printf("0x%08x:\t", (int)base_address + cnt);
        }
        xil_printf("%02x ", base_address[cnt]);
        if (cnt % 4 == 3) {
            xil_printf("   ");
        }
    }
    xil_printf("\r\n");

    return 0;
}
#endif /* ENABLE_DUMP */

#ifdef ENABLE_COPY
/* copy num from to */
int copy(int argc, char **argv) {
    if (argc == 4) {
        ushell_memcpy((void *)strtoi(argv[3]), (void *)strtoi(argv[2]), 
                strtoi(argv[1]));
    } else {
        PRINT_USAGE("copy needs 3 arguments\r\n");
    }

    return 0;
}
#endif /* ENABLE_COPY */

#ifdef ENABLE_HELP
/* Print information about uShell commands */
int help() {
    xil_printf(
    "\r\n" 
    "  Help\r\n%s\r\n"
    "  * ls - display information\r\n"
    "  * list - list available functions\r\n"
    "  * mems - print memory information\r\n"
    "  * devs - print device information\r\n"
    "  * rd  addr fmt - read data stored at addr\r\n"
    "  * mrd <name|key>[off] fmt - read data from memory\r\n"
    "  * rrd <name|key>[off] fmt - read data from register\r\n"
    "  * wr  addr data fmt - write data to addr\r\n"
    "  * mwr <name|key>[off] data fmt - write data to memory + offset\r\n"
    "  * rwr <name|key>[off] data fmt - write data to reg + offset\r\n"
    "  * copy num faddr taddr - copy num bytes from faddr to taddr\r\n"
    "  * load base_address num - read num bytes into memory\r\n"
    "  * dump base_address num - dump num bytes from memory\r\n"
    "  * jump addr - branch execution to addr\r\n"
    "  * reboot -  reload shell\r\n"
    "  * halt - stop shell\r\n"
    "  * version - print a version string\r\n"
    "  * help - view this menu\r\n", divider);

    user_help();
    return 0;
}
#endif /* ENABLE_HELP */

#ifdef ENABLE_EXEC
/* A minimal ELF loader & execution program */
/* Reference: Executable and Linkable Format (ELF)
 * http://www.skyfree.org/linux/references/LEF_Format.pdf
 * 21 July 2009
 */

typedef Xuint32 Elf32_Addr;
typedef Xuint16 Elf32_Half;
typedef Xuint32 Elf32_Off;
typedef Xint32  Elf32_Sword;
typedef Xuint32 Elf32_Word;

#define EI_NIDENT 16
#define ELFMAG0 0x7f
#define ELFMAG1 'E'
#define ELFMAG2 'L'
#define ELFMAG3 'F'

typedef struct {
    unsigned char e_ident[EI_NIDENT];
    Elf32_Half    e_type;
    Elf32_Half    e_machine;
    Elf32_Word    e_version;
    Elf32_Addr    e_entry;
    Elf32_Off     e_phoff;
    Elf32_Off     e_shoff;
    Elf32_Word    e_flags;
    Elf32_Half    e_ehsize;
    Elf32_Half    e_phentsize;
    Elf32_Half    e_phnum;
    Elf32_Half    e_shentsize;
    Elf32_Half    e_shnum;
    Elf32_Half    e_shstrndx;
} Elf32_Ehdr;

typedef struct {
    Elf32_Word p_type;
    Elf32_Off  p_offset;
    Elf32_Addr p_vaddr;
    Elf32_Addr p_addr;
    Elf32_Word p_filesz;
    Elf32_Word p_memsz;
    Elf32_Word p_flags;
    Elf32_Word p_align;
} Elf32_Phdr;
    
int exec(int argc, char **argv) {
    int i, j;
    Elf32_Ehdr *ehdr = (Elf32_Ehdr *)strtoi(argv[1]);
    Elf32_Phdr *phdr = (Elf32_Phdr *)((char *)ehdr + ehdr->e_phoff);
    void (*func)();
    if (argc != 2) {
        PRINT_USAGE("exec <ELF address>\r\n");
        return -1;
    }
    if (ehdr->e_ident[0] != ELFMAG0 || 
        ehdr->e_ident[1] != ELFMAG1 || 
        ehdr->e_ident[2] != ELFMAG2 || 
        ehdr->e_ident[3] != ELFMAG3) {
        xil_printf("Not an ELF file\r\n");
        return -1;
    }
    /* Extract program segments */
    for (i = 0; i < ehdr->e_phnum; i++) {
        ushell_memcpy((char *)phdr->p_vaddr, (char *)ehdr + phdr->p_offset, phdr->p_filesz);
        /* If there's a difference in file and memory footprints,
         * fill with zeros. */
        if (phdr->p_filesz != phdr->p_memsz) {
            for (j = phdr->p_filesz; j < phdr->p_memsz; j += 4) {
                ((Xuint32 *)phdr->p_vaddr)[j] = 0;
            }
        }
        phdr++;
    }

#if defined(PPC440) || defined(PPC405)
#ifdef ENABLE_CACHE
    XCache_DisableDCache();
    XCache_DisableICache();
#endif /* ENABLE_CACHE */
#ifdef ENABLE_INTERRUPT_DRIVEN
    XExc_mDisableExceptions(0xFfffFfff);
#endif /* ENABLE_INTERRUPT_DRIVEN */
#endif /* defined(PPC440) || defined(PPC405) */
            
    func = (void *)ehdr->e_entry;
    (*func)();

    return 0;
}
#endif /* ENABLE_EXEC */

// Print version information
int version() {
    xil_printf("uShell v" VERSION "\r\nBuilt: " __DATE__ "\r\n");//, VERSION, __DATE__);
    return 0;
}

void clear_screen() {
    int i;

    for(i = 0; i < 25; i++) {
        xil_printf("\r\n");
    }
}

// Print a tagline on init
void ushell_init() {
    xil_printf("\r%s\r\n", TAGLINE);
    version();
}

/* Small homebrew strcmp replacement
 * 
 * Returns 1 if the two strings are equal, 0 otherwise
 */
int strequ(const char *str1, const char *str2) {
    int i;
    for (i = 0; str1[i] == str2[i]; i++) {
        if ((str1[i] == '\0') && (str2[i] == '\0')) {
            return 1;
        }
    }
    return 0;
}

/* Small homebrew memcpy */
void ushell_memcpy(void *dest, const void *src, int n) {
    for(n--; n >= 0; n--) {
        ((u8 *)dest)[n] = ((u8 *)src)[n];
    }
}

void get_offset(char *address, int *offset) {
    int i;
    for (i = 0; address[i] != '\0'; i++) {
        if (address[i] == '[') {
            address[i] = '\0';
            *offset = (int)strtoi(address + i + 1);
            return;
        }
    }
    *offset = 0;
}

/* base-10 and base-16 numbers only */
int strtoi(char *string) {
    char sgn = 1; 
    char radix = 10;
    char digit;
    u8 i = 0;
    int total = 0;

    if (string[i] == '-') {
        i++;
        sgn = -1;
    }

    if (string[i] == '0') {
        i++;
        if ((string[i] | 0x60) == 'x' ) {
            i++;
            radix = 16;
        }
    }

    /* slightly dangerous, but probably not*/
    while(1) {
        if (string[i] >= '0') {
            if (string[i] <= '9') {
                digit = string[i] - '0';
            } else if (radix == 16 && 
                    ((0x60 | string[i]) >= 'a') &&
                    ((0x60 | string[i]) <= 'f')) {
                digit = (0x60 | string[i]) - 'W';
            } else {
                break;
            }

            total *= radix;
            total += digit;
            i++;
        } else {
            break;
        }
    }

    return sgn*total;
}

int get_address(const address_table *table, char *identifier, u32 *address) {
    int i = 0;
    int working_address;

    get_offset(identifier, &working_address);

    for (; table[i].key != 0; i++) {
        if (strequ(table[i].name, identifier) || 
                (table[i].key == strtoi(identifier))) {

            // If the offset is negative, go from the end
            working_address += ((working_address >= 0) ? 
                    table[i].base_addr : table[i].high_addr);

            if (working_address >= table[i].base_addr && 
                    working_address <= table[i].high_addr) {
                *address = (u32)working_address;
                return 0;
            } else {
                xil_printf("Bad offset .\r\n");
                return -1;
            }
        }
    }

    return -1;
}
    


void backspace() {
    outbyte('\b');
    outbyte(' ' );
    outbyte('\b');
}


// Need to make this work for different UARTs
int isEmpty() {
    return XUartLite_mIsReceiveEmpty(STDIN_BASEADDRESS);
}

#ifdef ENABLE_INTERRUPT_DRIVEN
/* Call sem_init((semaphore *)&io_sem); before attaching the interrupt
 * handler */
void ushell_uart_interrupt_handler() {
    if (!XUartLite_mIsReceiveEmpty(STDIN_BASEADDRESS)) {
        /* Make sure Rx caused interrupt */
        sem_give((semaphore *)&io_sem);
    }
}
#endif /* ENABLE_INTERRUPT_DRIVEN */

void execute_loop() {
    static char function[LENGTH];
#ifdef ENABLE_INTERRUPT_DRIVEN
    if (sem_take((semaphore *)&io_sem)) {
#endif /* ENABLE_INTERRUPT_DRIVEN */
        if (get_line(function, LENGTH) != -1) {        
            if (function[0] != '\0') {
                if (execute(function) != 0) {
                    xil_printf("%s No such function.\r\n", oops);
                }
            } 
            xil_printf(PROMPT);
        }
#ifdef ENABLE_INTERRUPT_DRIVEN
    }
#endif /* ENABLE_INTERRUPT_DRIVEN */
}

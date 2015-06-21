/*--------------------------------------------------------------------------
 * Filename:        $RCSfile$
 * Author:          Yutao He (Yutao.He@jpl.nasa.gov)
 * Copyright:       (c) 2009, Caltech/JPL
 * Creation Date:   2009-12-08
 * Version:         1.0.0.0
 *
 * Description:     This is the tiny shell for the ISAAC iBoard based on a software developed for MicroInspector Avionics Task.
 *
 * $Log$
 *
 *--------------------------------------------------------------------------*/
#include "xparameters.h"
#define UARTLITE
#ifdef UARTLITE
#include "xuartlite_l.h"
#else
#include "xuartns550_l.h"
#endif
#include "xutil.h"
#include "xpseudo_asm.h"

#undef DEBUG_READLINE
#undef DEBUG_PARSER
#undef DEBUG_CMD
#undef DEBUG_FTEST

/* Global Constants */
#define CMD_BUF_SIZE 16*8 /* UARTLite's TX and RX FIFO Buffers have 16 bytes each */
#define MAX_NUM_CMDS  13  /* Maximum number of commands */
#define MAX_NUM_ARGS  4   /* Maximum number of arguments in a command */
#define WORD_LENGTH   4   /* Number of bytes in a word */

#define FLASH_BASE_ADDR                0x40000000 /* the flash base address */
#define FLASH_CYCLE1_ADDR              0x00001554 /* the first cycle address */
#define FLASH_CYCLE2_ADDR              0x00000AA8 /* the second cycle address */
#define FLASH_CYCLE3_ADDR              0x00001554 /* the third cycle address */
#define FLASH_CYCLE4_ADDR              0x00001554 /* the forth cycle address */
#define FLASH_CYCLE5_ADDR              0x00000AA8 /* the fifth cycle address */
#define FLASH_CYCLE6_ADDR              0x00001554 /* the six cycle address */

#define FLASH_WRITE_CYCLE1_DATA        0x00AA00AA /* the first flash write cycle data */
#define FLASH_WRITE_CYCLE2_DATA        0x00550055 /* the second flash write cycle data */
#define FLASH_WRITE_CYCLE3_DATA        0x00A000A0 /* the third flash write cycle data */

#define FLASH_ERASE_CYCLE1_DATA        0x00AA00AA /* the first flash erase cycle data */
#define FLASH_ERASE_CYCLE2_DATA        0x00550055 /* the second flash erase cycle data */
#define FLASH_ERASE_CYCLE3_DATA        0x00800080 /* the third flash erase cycle data */
#define FLASH_ERASE_CYCLE4_DATA        0x00AA00AA /* the fourth flash erase cycle data */
#define FLASH_ERASE_CYCLE5_DATA        0x00550055 /* the fifth flash erase cycle data */
#define FLASH_CHIP_ERASE_CYCLE6_DATA   0x00100010 /* the sixth flash chip erase cycle data */
#define FLASH_SECTOR_ERASE_CYCLE6_DATA 0x00300030 /* the sixth flash sector erase cycle data */

#define FLASH_BIG_SECTOR_SIZE          0x8000     /* the big sector size */
#define FLASH_SMALL_SECTOR_SIZE        0x1000     /* the small sector size */
#define FLASH_BIG_SECTOR_SIZE          0x8000     /* the big sector size */

/* Global Variables */
static char platform_logo[] = "ISAAC iBoard";
static char platform_version[] = "v0.9";
static char sw_version[] = "v1.0.0";
static char prompt[] = "iShell # ";
static char *iboardif_cmd[] = {"rd",
                       	    "wr",
			    "fse",
			    "fce",
			    "fw",
			    "fwp",
			    "fcheck",
			    "ftest",
			    "ddrtest",
			    "clear",
			    "help",
			    "addrmap",
			    "version"};
static int ipcore_version;
char cmd_buf[ CMD_BUF_SIZE ];

/* Functional Prototypes */
int  read_line( void );
int  parse_line( char *, char *[] );
void run_command( int, char *[] );
int  hex2int( char *, int * );
int  get_ipcore_version( void );
void iBoard_init( void );
void flash_sector_erase ( unsigned int, unsigned int );
void flash_chip_erase ( unsigned int );
void flash_write ( unsigned int, unsigned int, unsigned int );
void flash_write_pattern ( unsigned int, unsigned int, unsigned int );
int flash_check ( unsigned int, unsigned int );

int  find_command( char * );
void do_rd( char *[] );
void do_wr( char *[] );
void do_ddrtest( char *[] );
void do_fse( char *[] );
void do_fce( char *[] );
void do_fw( char *[] );
void do_fwp( char *[] );
void do_fcheck( char *[] );
void do_ftest( char *[] );
void do_clear( char *[] );
void do_help( char *[] );
void do_addrmap( char *[] );
void do_version( char *[] );

/* main routine */
int main( unsigned argc, char *argv[] ) {
   Xuint32 val = 0;
   int num_of_chars = 0;
   int cmd_argc= 0;
   char c;
   char *cmd_argv[MAX_NUM_ARGS + 1]; /* NULL terminated */
   int i;

#ifdef UARTLITE
#else
   XUartNs550_SetBaud(STDOUT_BASEADDRESS, 100000000, 9600);
   XUartNs550_mSetLineControlReg(STDOUT_BASEADDRESS, XUN_LCR_8_DATA_BITS);
#endif

//   XCache_EnableICache(0x00000003);
//   XCache_EnableDCache(0x00000003);

   xil_printf("\033[H\033[J");
   xil_printf( "\r\n" );
	xil_printf("Hello World from iBoard!!");
	xil_printf( "\r\n" );
   xil_printf( "%s ( %s ) \r\n", platform_logo, platform_version );
   iBoard_init();
   xil_printf( "\r\n%s", prompt );

   /* infinite loop to process commands */
   for ( ; ; ) {
#ifdef UARTLITE
      if ( XUartLite_mIsReceiveEmpty( STDIN_BASEADDRESS ) )
#else
      if ( !XUartNs550_mIsReceiveData( STDIN_BASEADDRESS ) )
#endif
	 continue;
      num_of_chars = read_line();
      if ( num_of_chars  > CMD_BUF_SIZE ) {
         xil_printf( "Too many characters: %d!\r\n", num_of_chars );
         xil_printf( "%s", prompt );
	 continue;
      }

#ifdef DEBUG_READLINE
      xil_printf( "command: %s\r\n", cmd_buf );
#endif

      cmd_argc = parse_line( cmd_buf, cmd_argv );

#ifdef DEBUG_PARSER
      for ( i = 0; i < cmd_argc; i++ )
         xil_printf( "cmd_argv[%d]: %s\r\n", i, cmd_argv[i] );
#endif
      run_command( cmd_argc, cmd_argv );

      xil_printf( "%s", prompt );
   } /* for */

   return ( 0 );
}

/*--------------------------------------------------------------------------
 * Function:    read_line()
 * Arguments:   
 *    Inputs:
 *              void
 *    Outputs:
 *              void
 * return:      int - number of read characters
 * Description: Read into the cmd_buf a line from the serial console 
 * -----------------------------------------------------------------------*/
int read_line( void ) {
   char *p = cmd_buf;
   char c;
   int n = 0;

   for ( ; ; ) {
#ifdef UARTLITE
      c = ( char ) XUartLite_RecvByte( STDIN_BASEADDRESS );
#else
      c = ( char ) XUartNs550_RecvByte( STDIN_BASEADDRESS );
#endif

      switch ( c ) {
	 /*
	  * Special character handling
	  */
	 case '\r': /* Enter */
	 case '\n': /* Newline */
            *p = '\0';
#ifdef UARTLITE
	    XUartLite_SendByte( STDOUT_BASEADDRESS, '\r' );
	    XUartLite_SendByte( STDOUT_BASEADDRESS, '\n' );
#else
	    XUartNs550_SendByte( STDOUT_BASEADDRESS, '\r' );
	    XUartNs550_SendByte( STDOUT_BASEADDRESS, '\n' );
#endif
	    return( n );

	 case '\0': /* NULL */
	    continue;

	 case 0x03: /* ^C - Break */
	    cmd_buf[0] = '\0'; /* discard the input */
	    return( -1 );

	 case 0x15: /* ^U - Erase line */
	    while ( p > cmd_buf ) {
#ifdef UARTLITE
	       XUartLite_SendByte( STDOUT_BASEADDRESS, '\b' );
	       XUartLite_SendByte( STDOUT_BASEADDRESS, ' ' );
	       XUartLite_SendByte( STDOUT_BASEADDRESS, '\b' );
#else
	       XUartNs550_SendByte( STDOUT_BASEADDRESS, '\b' );
	       XUartNs550_SendByte( STDOUT_BASEADDRESS, ' ' );
	       XUartNs550_SendByte( STDOUT_BASEADDRESS, '\b' );
#endif
	       p--;
	    }
	    p = cmd_buf;
	    continue;

	 case 0x08: /* ^H - Backspace */
	 case 0x7F: /* DEL - Backspace */
	    if ( p > cmd_buf ) {
#ifdef UARTLITE
	       XUartLite_SendByte( STDOUT_BASEADDRESS, '\b' );
	       XUartLite_SendByte( STDOUT_BASEADDRESS, ' ' );
	       XUartLite_SendByte( STDOUT_BASEADDRESS, '\b' );
#else
	       XUartNs550_SendByte( STDOUT_BASEADDRESS, '\b' );
	       XUartNs550_SendByte( STDOUT_BASEADDRESS, ' ' );
	       XUartNs550_SendByte( STDOUT_BASEADDRESS, '\b' );
#endif
	       p--;
	    }
	    continue;

	 /* 
	  * Now it must be a normal character
	  */
	 default:
	    *p++ = c;
	    n++;
#ifdef UARTLITE
	    XUartLite_SendByte( STDOUT_BASEADDRESS, c ); /* echo the input */
#else
	    XUartNs550_SendByte( STDOUT_BASEADDRESS, c ); /* echo the input */
#endif
      } /* switch */

   } /* for */

}

/*--------------------------------------------------------------------------
 * Function:    parse_line()
 * Arguments:   
 *    Inputs:
 *              char *line - pointer to the buffer to be parsed
 *    Outputs:
 *              cmd_argv[] - pointer to an array of commands and their arguments
 * return:      number of arguments in a command
 * Description: parse the cmd_buf to decide which command to take.
 * -----------------------------------------------------------------------*/
int parse_line( char *line, char *cmd_argv[] ) {
   int argc = 0;

#ifdef DEBUG_PARSER
      xil_printf( "parse_line: %s\r\n", line);
#endif

   while ( argc < MAX_NUM_ARGS ) {
      /* skip any white space */
      while (( *line == ' ' ) || ( *line == '\t' )) 
	 line++;

      /* reach the end of line and no more args */
      if ( *line == '\0' ) {
	 cmd_argv[argc] = NULL;
	 return ( argc );
      }

      /* start of the argument string */
      cmd_argv[argc++] = line;

      /* find the end of string */
      while ( *line && ( *line != ' ' ) && ( *line != '\t' ) )
	 line++;

      /* reach the end of line and no more args */
      if ( *line == '\0' ) {
	 cmd_argv[argc] = NULL;
	 return ( argc );
      }

      /* terminate the current argument */
      *line++ = '\0';
   }
   
   /* too many arguments */
   xil_printf( "Too many arguments: %d!\r\n", argc );

   return ( argc );
}

/*--------------------------------------------------------------------------
 * Function:    get_ipcore_version ()
 * Arguments:
 *    Inputs:
 *              None
 *    Outputs:
 *              None
 * return:      the IP core version value
 * Description: Get the IPcore version
 * -----------------------------------------------------------------------*/
int get_ipcore_version( void ) {

    return 0;
}

/*--------------------------------------------------------------------------
 * Function:    iBoard_init ()
 * Arguments:
 *    Inputs:
 *              None
 *    Outputs:
 *              None
 * return:      None
 * Description: Initialize the IP core
 * -----------------------------------------------------------------------*/
void iBoard_init( void ) {
   xil_printf( "Initialize the iBoard hardware...\r\n" );

   return;
}

/*--------------------------------------------------------------------------
 * Function:    run_command()
 * Arguments:   
 *    Inputs:
 *              int   cmd_argc   - number of arguments in the command
 *              char *cmd_argv[] - array of a command and its arguments
 *    Outputs:
 *              None
 * return:      None
 * Description: Actually run the command entered at the serial console
 * -----------------------------------------------------------------------*/
void run_command( int cmd_argc, char *cmd_argv[] ) {
   int i;

   i = find_command( cmd_argv[0] );
   switch ( i ) {
      case 0:
	      do_rd( cmd_argv );
	      break;
      case 1:
	      do_wr( cmd_argv );
	      break;
      case 2:
	      do_fse( cmd_argv );
	      break;
      case 3:
	      do_fce( cmd_argv );
	      break;
      case 4:
	      do_fw( cmd_argv );
	      break;
      case 5:
	      do_fwp( cmd_argv );
	      break;
      case 6:
	      do_fcheck( cmd_argv );
	      break;
      case 7:
	      do_ftest( cmd_argv );
	      break;
      case 8:
	      do_ddrtest( cmd_argv );
	      break;
      case 9:
	      do_clear( cmd_argv );
	      break;
      case 10:
	      do_help( cmd_argv );
	      break;
      case 11:
	      do_addrmap( cmd_argv );
	      break;
      case 12:
	      do_version( cmd_argv );
	      break;
      default:
	      xil_printf("%s - Invalid command!\r\n", cmd_argv[0] );
   }
   
}

/*--------------------------------------------------------------------------
 * Function:    find_command()
 * Arguments:
 *    Inputs:
 *              char * command - the command
 *    Outputs:
 *              None
 * return:      the index of the command entry in the command table, or -1
 *              if is not found
 * Description: find the command entry
 * -----------------------------------------------------------------------*/
int find_command( char *cmd ) {
   int i;

   for ( i = 0; i < MAX_NUM_CMDS; i++ ) {
      if ( strcmp ( iboardif_cmd[i], cmd ) == 0 )
	 return  ( i );
   }
   return ( -1 );
}

/*--------------------------------------------------------------------------
 * Function:    do_rd( char* cmd_argv[] )
 * Arguments:
 *    Inputs:
 *              char *cmd_argv[] command and its arguments
 *    Outputs:
 *              None
 * return:      None
 * Description: execute the rd command
 * -----------------------------------------------------------------------*/
void do_rd( char *cmd_argv[] ) {
   unsigned int dest_addr;
   volatile unsigned int *addr;

#ifdef DEBUG_CMD
   xil_printf( "add: %s\r\n", cmd_argv[1] );
#endif
   hex2int( cmd_argv[1], &dest_addr );
#ifdef DEBUG_CMD
   xil_printf( "add: %x\r\n", dest_addr );
#endif

   addr = ( unsigned int * ) dest_addr;
   xil_printf("0x%08x: 0x%08x\r\n", addr, *addr );
   return;
}

/*--------------------------------------------------------------------------
 * Function:    do_wr( char* cmd_argv[] )
 * Arguments:
 *    Inputs:
 *              char *cmd_argv[] command and its arguments
 *    Outputs:
 *              None
 * return:      None
 * Description: execute the wr command
 * -----------------------------------------------------------------------*/
void do_wr( char *cmd_argv[] ) {
   int val;
   unsigned int dest_addr;
   volatile unsigned int *addr;

   hex2int( cmd_argv[1], &dest_addr );
   hex2int( cmd_argv[2], &val );

   addr = ( unsigned int * ) dest_addr;
   *addr = val;

   xil_printf("Write 0x%08x to 0x%08x.\r\n", val, addr );

   return;
}

/*--------------------------------------------------------------------------
 * Function:    do_ddrtest( char* cmd_argv[] )
 * Arguments:
 *    Inputs:
 *              char *cmd_argv[] command and its arguments
 *    Outputs:
 *              None
 * return:      None
 * Description: execute the ddrtest command
 * -----------------------------------------------------------------------*/
void do_ddrtest( char *cmd_argv[] ) {
   int i;
   unsigned int start_addr;
   unsigned int end_addr;
   int errorcount = 0;
   unsigned int *mem;
   int range;
   char c;

   hex2int ( cmd_argv[1], &start_addr );
   hex2int ( cmd_argv[2], &end_addr );

   mem = ( unsigned int * ) start_addr;
   range = ( end_addr - start_addr ) / 4;

   xil_printf ( "Filling DDR RAM from 0x%08X to 0x%08X with 0 ... \r\n", start_addr, end_addr );
   for ( i = 0; i < range; i++ )
      mem[i] = 0;

   xil_printf ( "Reading DDR RAM ... \n\r" );
   for ( i = 0; i < range; i++ ) {
      if ( mem[i] != 0 ) {
	 errorcount++;
	 xil_printf ( "Error at 0x%08X, read 0x%08X, should be 0x%08X\n\r",
	              ( start_addr + ( i * 4 ) ), mem[i], 0 );
      }
   }

   xil_printf ( "Filling DDR RAM from 0x%08X to 0x%08X with 0xFFFFFFFF ...\r\n", start_addr, end_addr );
   for ( i = 0; i < range; i++ )
      mem[i] = 0xFFFFFFFF;

   xil_printf ( "Reading DDR RAM ... \n\r" );
   for ( i = 0; i < range; i++ ) {
      if ( mem[i] != 0xFFFFFFFF ) {
	 errorcount++;
	 xil_printf ( "Error at 0x%08X, read 0x%08X, should be 0x%08X\n\r",
		      ( start_addr + ( i * 4 ) ), mem[i], 0xFFFFFFFF );
      }
   }

   xil_printf ( "Filling DDR RAM from 0x%08X to 0x%08X with 0x55555555 ...\r\n", start_addr, end_addr );
   for ( i = 0; i < range; i++ )
      mem[i] = 0x55555555;

   xil_printf ( "Reading DDR RAM ... \n\r" );
   for ( i = 0; i < range; i++ ) {
      if ( mem[i] != 0x55555555 ) {
	 errorcount++;
	 xil_printf ( "Error at 0x%08X, read 0x%08X, should be 0x%08X\n\r",
		      ( start_addr + ( i * 4 ) ), mem[i], 0x55555555 );
      }
   }

   xil_printf ( "Filling DDR RAM from 0x%08X to 0x%08X with 0xAAAAAAAA ...\r\n", start_addr, end_addr );
   for ( i = 0; i < range; i++ )
      mem[i] = 0xAAAAAAAA;

   xil_printf ( "Reading DDR RAM ... \n\r" );
   for ( i = 0; i < range; i++ ) {
      if ( mem[i] != 0xAAAAAAAA ) {
 	 errorcount++;
	 xil_printf ( "Error at 0x%08X, read 0x%08X, should be 0x%08X\n\r", 
	              ( start_addr + ( i * 4 ) ), mem[i], 0xAAAAAAAA );
      }
   }

   xil_printf("Filling DDR RAM from 0x%08X to 0x%08X with address\r\n", start_addr, end_addr );
   for ( i = 0; i < range * 2; i++ ) {
      unsigned short *memshort = ( short * ) mem;
      memshort[i] = i;
   }

   xil_printf ( "Reading DDR RAM ... \n\r" );
   for ( i = 0; i < range * 2; i++ ) {
      unsigned short *memshort = (short *) mem;
      unsigned short test = ( short ) (i % 0x10000 );
      if ( memshort[i] != test ) {
	 errorcount++;
	 xil_printf ( "Error at 0x%08X, read 0x%08X, should be 0x%08X\n\r", 
		      ( start_addr + ( i * 2 ) ), memshort[i], test );
      }
   }

   xil_printf ( "Final error count = %d\n\r", errorcount );

   return;
}

/*--------------------------------------------------------------------------
 * Function:    do_fse( char* cmd_argv[] )
 * Arguments:
 *    Inputs:
 *              char *cmd_argv[] command and its arguments
 *    Outputs:
 *              None
 * return:      None
 * Description: execute the fse command
 * -----------------------------------------------------------------------*/
void do_fse( char *cmd_argv[] ) {
   volatile unsigned int *addr; /* need to be volatile to get fresh data */
   unsigned int bank_no, sect;
   int i;

   hex2int( cmd_argv[1], ( int * ) &bank_no );
   hex2int( cmd_argv[2], ( int * ) &sect );

   xil_printf("Erasing Sector 0x%08x... in Bank %d\r\n", sect, bank_no );

   flash_sector_erase ( bank_no, sect );

   xil_printf("Done.\r\n");

   return;
}

/*--------------------------------------------------------------------------
 * Function:    do_fce( char* cmd_argv[] )
 * Arguments:
 *    Inputs:
 *              char *cmd_argv[] command and its arguments
 *    Outputs:
 *              None
 * return:      None
 * Description: execute the fce command
 * -----------------------------------------------------------------------*/
void do_fce( char *cmd_argv[] ) {
   volatile unsigned int *addr; /* need to be volatile to get fresh data */
   unsigned int bank_no;
   int i;

   hex2int( cmd_argv[1], ( int * ) &bank_no );

   xil_printf("Erasing Bank %d\r\n", bank_no );

   flash_chip_erase ( bank_no );

   xil_printf("Done.\r\n");

   return;
}

/*--------------------------------------------------------------------------
 * Function:    do_fw( char* cmd_argv[] )
 * Arguments:
 *    Inputs:
 *              char *cmd_argv[] command and its arguments
 *    Outputs:
 *              None
 * return:      None
 * Description: execute the fw command
 * -----------------------------------------------------------------------*/
void do_fw( char *cmd_argv[] ) {
   volatile unsigned int *addr;
   unsigned int bank_no, dest_addr, val;

   hex2int( cmd_argv[1], &bank_no );
   hex2int( cmd_argv[2], &dest_addr );
   hex2int( cmd_argv[3], &val );

   xil_printf( "Start write to 0x%08x in Bank %d with (0x%08x)...\r\n" , dest_addr, bank_no, val );

   flash_write ( bank_no, dest_addr, val );

   xil_printf("Done.\r\n");

   return;
}

/*--------------------------------------------------------------------------
 * Function:    do_fwp( char* cmd_argv[] )
 * Arguments:
 *    Inputs:
 *              char *cmd_argv[] command and its arguments
 *    Outputs:
 *              None
 * return:      None
 * Description: execute the fwp command
 * -----------------------------------------------------------------------*/
void do_fwp( char *cmd_argv[] ) {
   volatile unsigned int *addr;
   unsigned int bank_no, dest_addr, val;
   int i, j, count;
   char byte_val[WORD_LENGTH];

   hex2int( cmd_argv[1], &bank_no );
   hex2int( cmd_argv[2], &dest_addr );
   hex2int( cmd_argv[3], &count );

   xil_printf( "Start write to 0x%08x in Bank %d (%d)...\r\n" , dest_addr, bank_no, count );

   for ( i = 0; i < count; i++, dest_addr += 4 ) {
       /* compose the test pattern */
       for ( j = 0; j < WORD_LENGTH; j++ ) {
	  byte_val[j] = i * 4 + j;
       }
       val = byte_val[3] << 24 | byte_val[2] << 16 | byte_val[1] << 8 | byte_val[0];

       flash_write ( bank_no, dest_addr, val );
   }

   xil_printf("Done.\r\n");

   return;
}

/*--------------------------------------------------------------------------
 * Function:    do_fcheck( char* cmd_argv[] )
 * Arguments:
 *    Inputs:
 *              char *cmd_argv[] command and its arguments
 *    Outputs:
 *              None
 * return:      None
 * Description: execute the fcheck command
 * -----------------------------------------------------------------------*/
void do_fcheck( char *cmd_argv[] ) {
   volatile unsigned int *addr;
   unsigned int dest_addr, count, val;
   int i, j, err_counts = 0;
   char byte_val[WORD_LENGTH];

   hex2int( cmd_argv[1], &dest_addr );
   hex2int( cmd_argv[2], &count );

   for ( i = 0; i < count; i++, dest_addr += 4 ) {
       /* compose the test pattern */
       for ( j = 0; j < WORD_LENGTH; j++ ) {
	  byte_val[j] = i * 4 + j;
       }
       val = byte_val[3] << 24 | byte_val[2] << 16 | byte_val[1] << 8 | byte_val[0];

       /* verify the written data */
       addr = ( unsigned int * ) dest_addr;
       if ( *addr != val ) {
	  xil_printf( "Mismatch: Written-0x%08x <--> Read-0x%08x \r\n", val, *addr );
	  err_counts++;
       }
   }

   if ( !err_counts ) 
      xil_printf( "Pass the test.\r\n" );
   else
      xil_printf( "Total mismatches: %d.\r\n", err_counts );

   return;
}

/*--------------------------------------------------------------------------
 * Function:    do_ftest( char* cmd_argv[] )
 * Arguments:
 *    Inputs:
 *              char *cmd_argv[] command and its arguments
 *    Outputs:
 *              None
 * return:      None
 * Description: execute the ftest command
 * -----------------------------------------------------------------------*/
void do_ftest( char *cmd_argv[] ) {
   volatile unsigned int *addr;
   unsigned int start_bank_no, end_bank_no, sect_start_addr;
   int i, sect, err_counts = 0;
   char byte_val[WORD_LENGTH];

   hex2int( cmd_argv[1], &start_bank_no );
   hex2int( cmd_argv[2], &end_bank_no );

   for ( i = start_bank_no; i <= end_bank_no; i++ ) {

      xil_printf( "Testing Bank %d...\r\n", i );

      /* region 1 of 4k sectors */
      for ( sect = 0; sect < 8; sect++ ) {
#ifdef DEBUG_FTEST
         xil_printf( "Erasing Sector %d in Bank %d...\r\n", sect, i );
#endif
         /* erase the entire sector */
         sect_start_addr = FLASH_BASE_ADDR + 0x01000000 * i +
		 ( sect * FLASH_SMALL_SECTOR_SIZE ) * 4;
#ifdef DEBUG_FTEST
         xil_printf( "Sector address: 0x%08x\r\n", sect_start_addr );
#endif
         flash_sector_erase ( i, sect_start_addr );

         /* write to the sector */
#ifdef DEBUG_FTEST
         xil_printf( "Writing test patterns to Sector %d...\r\n", sect );
#endif
	 flash_write_pattern( i, sect_start_addr, FLASH_SMALL_SECTOR_SIZE );

         /* check to the sector */
#ifdef DEBUG_FTEST
         xil_printf( "Checking Sector %d... \r\n", sect );
#endif
         err_counts += flash_check ( sect_start_addr, FLASH_SMALL_SECTOR_SIZE );
      }

      /* region 2 of 32k sectors */
      for ( sect = 8; sect < 134; sect++ ) {
#ifdef DEBUG_FTEST
         xil_printf( "Erasing Sector %d in Bank %d...\r\n", sect, i );
#endif
         /* erase the entire sector */
         sect_start_addr = FLASH_BASE_ADDR + 0x01000000 * i +
		 ( 0x8000 + ( sect - 8 ) * FLASH_BIG_SECTOR_SIZE ) * 4;
#ifdef DEBUG_FTEST
         xil_printf( "Sector address: 0x%08x\r\n", sect_start_addr );
#endif
         flash_sector_erase ( i, sect_start_addr );

         /* write to the sector */
#ifdef DEBUG_FTEST
         xil_printf( "Writing test patterns to Sector %d...\r\n", sect );
#endif
	 flash_write_pattern( i, sect_start_addr, FLASH_BIG_SECTOR_SIZE );

         /* check to the sector */
#ifdef DEBUG_FTEST
         xil_printf( "Checking Sector %d... \r\n", sect );
#endif
         err_counts += flash_check ( sect_start_addr, FLASH_BIG_SECTOR_SIZE );
      }

      /* region 3 of 4k sectors */
      for ( sect = 134; sect < 142; sect++ ) {
#ifdef DEBUG_FTEST
         xil_printf( "Erasing Sector %d in Bank %d...\r\n", sect, i );
#endif
         /* erase the entire sector */
         sect_start_addr = FLASH_BASE_ADDR + 0x01000000 * i +
		 ( 0x3F8000 + ( sect - 134 ) * FLASH_SMALL_SECTOR_SIZE ) * 4;
#ifdef DEBUG_FTEST
         xil_printf( "Sector address: 0x%08x\r\n", sect_start_addr );
#endif
         flash_sector_erase ( i, sect_start_addr );

         /* write to the sector */
#ifdef DEBUG_FTEST
         xil_printf( "Writing test patterns to Sector %d...\r\n", sect );
#endif
	 flash_write_pattern( i, sect_start_addr, FLASH_SMALL_SECTOR_SIZE );

         /* check to the sector */
#ifdef DEBUG_FTEST
         xil_printf( "Checking Sector %d... \r\n", sect );
#endif
         err_counts += flash_check ( sect_start_addr, FLASH_SMALL_SECTOR_SIZE );
      }

      if ( !err_counts ) 
         xil_printf( "Bank %d passes the test.\r\n", i );
      else
         xil_printf( "Total mismatches: %d.\r\n", err_counts );
   }

   return;
}

/*--------------------------------------------------------------------------
 * Function:    flash_sector_erase( unsigned int, unsigned int )
 * Arguments:
 *    Inputs:
 *              bank_no - bank number
 *              sector  - sector address
 *    Outputs:
 *              None
 * Return:      None
 * Description: erase the flash sector
 * -----------------------------------------------------------------------*/
void flash_sector_erase( unsigned int bank_no, unsigned int sect ) {
   volatile unsigned int *addr; /* need to be volatile to get fresh data */
   int i;

   /* send the sector erase command sequence */
   addr  = ( unsigned int * ) ( FLASH_BASE_ADDR + 0x01000000 * bank_no + FLASH_CYCLE1_ADDR );
   *addr = FLASH_ERASE_CYCLE1_DATA;
   addr  = ( unsigned int * ) ( FLASH_BASE_ADDR + 0x01000000 * bank_no + FLASH_CYCLE2_ADDR );
   *addr = FLASH_ERASE_CYCLE2_DATA;
   addr  = ( unsigned int * ) ( FLASH_BASE_ADDR + 0x01000000 * bank_no + FLASH_CYCLE3_ADDR );
   *addr = FLASH_ERASE_CYCLE3_DATA;
   addr  = ( unsigned int * ) ( FLASH_BASE_ADDR + 0x01000000 * bank_no + FLASH_CYCLE4_ADDR );
   *addr = FLASH_ERASE_CYCLE4_DATA;
   addr  = ( unsigned int * ) ( FLASH_BASE_ADDR + 0x01000000 * bank_no + FLASH_CYCLE5_ADDR );
   *addr = FLASH_ERASE_CYCLE5_DATA;
   addr  = ( unsigned int * ) sect;
   *addr = FLASH_SECTOR_ERASE_CYCLE6_DATA;

   /* wait for at least 80-us timeout */
   for ( i = 0; i < 10000000; i++ );

   /* data polling */
   while ( *addr != 0xFFFFFFFF );

   return;
}

/*--------------------------------------------------------------------------
 * Function:    flash_chip_erase( unsigned int, unsigned int )
 * Arguments:
 *    Inputs:
 *              bank_no - bank number
 *    Outputs:
 *              None
 * Return:      None
 * Description: erase the flash chip
 * -----------------------------------------------------------------------*/
void flash_chip_erase( unsigned int bank_no ) {
   volatile unsigned int *addr; /* need to be volatile to get fresh data */
   int i;

   /* send the sector erase command sequence */
   addr  = ( unsigned int * ) ( FLASH_BASE_ADDR + 0x01000000 * bank_no + FLASH_CYCLE1_ADDR );
   *addr = FLASH_ERASE_CYCLE1_DATA;
   addr  = ( unsigned int * ) ( FLASH_BASE_ADDR + 0x01000000 * bank_no + FLASH_CYCLE2_ADDR );
   *addr = FLASH_ERASE_CYCLE2_DATA;
   addr  = ( unsigned int * ) ( FLASH_BASE_ADDR + 0x01000000 * bank_no + FLASH_CYCLE3_ADDR );
   *addr = FLASH_ERASE_CYCLE3_DATA;
   addr  = ( unsigned int * ) ( FLASH_BASE_ADDR + 0x01000000 * bank_no + FLASH_CYCLE4_ADDR );
   *addr = FLASH_ERASE_CYCLE4_DATA;
   addr  = ( unsigned int * ) ( FLASH_BASE_ADDR + 0x01000000 * bank_no + FLASH_CYCLE5_ADDR );
   *addr = FLASH_ERASE_CYCLE5_DATA;
   addr  = ( unsigned int * ) ( FLASH_BASE_ADDR + 0x01000000 * bank_no + FLASH_CYCLE6_ADDR );
   *addr = FLASH_CHIP_ERASE_CYCLE6_DATA;

   /* wait for at least 80-us timeout */
   for ( i = 0; i < 10000000; i++ );

   /* data polling */
   while ( *addr != 0xFFFFFFFF );

   return;
}

/*--------------------------------------------------------------------------
 * Function:    flash_write( unsigned int, unsigned int, unsigned int )
 * Arguments:
 *    Inputs:
 *              - bank_no: bank no
 *              - dest_addr: destination address
 *              - val: value to be written
 *    Outputs:
 *              None
 * Return:      None
 * Description: write to one flash location
 * -----------------------------------------------------------------------*/
void flash_write( unsigned int bank_no, unsigned int dest_addr, unsigned int val ) {
   volatile unsigned int *addr;

   /* send the write command sequence */
   addr  = ( unsigned int * ) ( FLASH_BASE_ADDR + 0x01000000 * bank_no + FLASH_CYCLE1_ADDR );
   *addr = FLASH_WRITE_CYCLE1_DATA;
   addr  = ( unsigned int * ) ( FLASH_BASE_ADDR + 0x01000000 * bank_no + FLASH_CYCLE2_ADDR );
   *addr = FLASH_WRITE_CYCLE2_DATA;
   addr  = ( unsigned int * ) ( FLASH_BASE_ADDR + 0x01000000 * bank_no + FLASH_CYCLE3_ADDR );
   *addr = FLASH_WRITE_CYCLE3_DATA;

   addr = ( unsigned int * ) dest_addr;
   *addr = val;

   /* data polling */
   while ( *addr != val );

   return;
}

/*--------------------------------------------------------------------------
 * Function:    flash_write_pattern( unsigned int, unsigned int, unsigned int )
 * Arguments:
 *    Inputs:
 *              - bank_no
 *              - start_sect_addr
 *              - size
 *    Outputs:
 *              None
 * return:      None
 * Description: write the test pattern to a flash sector
 * -----------------------------------------------------------------------*/
void flash_write_pattern( unsigned int bank_no, unsigned int start_sect_addr, unsigned int size ) {
   volatile unsigned int *addr;
   unsigned int val;
   int i, j;
   char byte_val[WORD_LENGTH];

   for ( i = 0; i < size; i++, start_sect_addr += 4 ) {
       /* compose the test pattern */
       for ( j = 0; j < WORD_LENGTH; j++ ) {
	  byte_val[j] = i * 4 + j;
       }
       val = byte_val[3] << 24 | byte_val[2] << 16 | byte_val[1] << 8 | byte_val[0];

       flash_write ( bank_no, start_sect_addr, val );
   }

   return;
}

/*--------------------------------------------------------------------------
 * Function:    flash_check( unsigned int, unsigned int )
 * Arguments:
 *    Inputs:
 *              - start_sect_addr
 *              - size
 *    Outputs:
 *              None
 * return:      no_of_errors
 * Description: check the flash write
 * -----------------------------------------------------------------------*/
int flash_check( unsigned int start_addr, unsigned int size ) {
   volatile unsigned int *addr;
   unsigned int val;
   int i, j, err_counts = 0;
   char byte_val[WORD_LENGTH];

   for ( i = 0; i < size; i++, start_addr += 4 ) {
       /* compose the test pattern */
       for ( j = 0; j < WORD_LENGTH; j++ ) {
	  byte_val[j] = i * 4 + j;
       }
       val = byte_val[3] << 24 | byte_val[2] << 16 | byte_val[1] << 8 | byte_val[0];

       /* verify the written data */
       addr = ( unsigned int * ) start_addr;
       if ( *addr != val ) {
	  err_counts++;
       }
   }

   return err_counts;
}

/*--------------------------------------------------------------------------
 * Function:    do_clear( char* cmd_argv[] )
 * Arguments:
 *    Inputs:
 *              char *cmd_argv[] command and its arguments
 *    Outputs:
 *              None
 * return:      None
 * Description: execute the clear command
 * -----------------------------------------------------------------------*/
void do_clear( char *cmd_argv[] ) {
   xil_printf("\033[H\033[J");

   return;
}

/*--------------------------------------------------------------------------
 * Function:    do_help( char* cmd_argv[] )
 * Arguments:
 *    Inputs:
 *              char *cmd_argv[] command and its arguments
 *    Outputs:
 *              None
 * return:      None
 * Description: execute the help command
 * -----------------------------------------------------------------------*/
void do_help( char *cmd_argv[] ) {

   xil_printf( "Valid commands are: \r\n" );
   xil_printf( "rd          - rd addr \r\n" );
   xil_printf( "wr          - wr addr value \r\n" );
   xil_printf( "fse         - flash sector erase\r\n" );
   xil_printf( "fce         - flash chip erase\r\n" );
   xil_printf( "fw          - flash write \r\n" );
   xil_printf( "fwp         - flash write pattern \r\n" );
   xil_printf( "fcheck      - check the flash memory\r\n" );
   xil_printf( "ftest       - test the flash memory\r\n" );
   xil_printf( "ddrtest     - test the DDR memory \r\n" );
   xil_printf( "clear       - clear \r\n" );
   xil_printf( "help        - help \r\n" );
   xil_printf( "addrmap     - print out the address map \r\n" );
   xil_printf( "version     - version \r\n" );

   return;
}

/*--------------------------------------------------------------------------
 * Function:    do_addrmap( char* cmd_argv[] )
 * Arguments:
 *    Inputs:
 *              char *cmd_argv[] command and its arguments
 *    Outputs:
 *              None
 * return:      None
 * Description: execute the addrmap command
 * -----------------------------------------------------------------------*/
void do_addrmap( char *cmd_argv[] ) {

   //xil_printf( "PLB2OPB0:    0xFFFE0000 - 0xFFFEFFFF (64KB) \r\n" );
   xil_printf( "  PLBUART:        0x84000000 - 0x8400FFFF (64KB) \r\n" );
   //xil_printf( "  ETH_MAC:   0xFFFE4000 - 0xFFFE7FFF (16KB) \r\n" );
   //xil_printf( "  IIC:       0xFFFE8800 - 0xFFFE89FF (512B) \r\n" );
   xil_printf( "  PLBINTC:        0x81800000 - 0x8180FFFF (64KB) \r\n" );
   //xil_printf( "  OPBFLASH:  0x40000000 - 0x43FFFFFF (64MB) \r\n" );
   //xil_printf( "    BANK0:   0x40000000 - 0x40FFFFFF (16MB) \r\n" );
   //xil_printf( "    BANK1:   0x41000000 - 0x41FFFFFF (16MB) \r\n" );
   //xil_printf( "    BANK2:   0x42000000 - 0x42FFFFFF (16MB) \r\n" );
   //xil_printf( "    BANK3:   0x43000000 - 0x43FFFFFF (16MB) \r\n" );
   xil_printf( "  PLBBRAM:        0xFFFF8000 - 0xFFFFFFFF (32KB) \r\n" );
   xil_printf( "  PLBDDRSDRAM:    0x00000000 - 0x1FFFFFFF (512MB) \r\n" );
	xil_printf( "  PLBDDRMPMCCTRL: 0x84800000 - 0x8480FFFF (64KB) \r\n" );

   return;
}

/*--------------------------------------------------------------------------
 * Function:    do_version( char* cmd_argv[] )
 * Arguments:
 *    Inputs:
 *              char *cmd_argv[] command and its arguments
 *    Outputs:
 *              None
 * return:      None
 * Description: execute the version command
 * -----------------------------------------------------------------------*/
void do_version( char *cmd_argv[] ) {

   xil_printf( "%s iShell %s \r\n", platform_logo, sw_version );

   return;
}

/*--------------------------------------------------------------------------
 * Function:    hex2int( char* hex_string, int* inval )
 * Arguments:
 *    Inputs:
 *              char *hex_string - hexidemical string
 *    Outputs:
 *              None
 * return:      None
 * Description: convert a hexidecimal string to an integer value
 * -----------------------------------------------------------------------*/
int hex2int( char *hex_string, int * pval ) {
	char * p;
	int nibble;

	*pval = 0;
	if ( !*hex_string )
		return 0;

	p = hex_string;
	if ( p[0] == '0' ) {
		if ( ( p[1] == 'x' ) || ( p[1] == 'X' ) )
			p += 2;
	}

	for ( ; *p; p++ ) {
		if ( ( *p >= '0') && (*p <= '9' ) )
			nibble = *p - '0';
		else if ( ( *p >= 'a' ) && ( *p <= 'f' ) )
			nibble = *p - 'a' + 0xa;
		else if ( ( *p >= 'A' ) && ( *p <= 'F' ) )
			nibble = *p - 'A' + 0xa;
		else
			return 0;
		*pval <<= 4;
		*pval |= nibble;
	}

	return 1;
}

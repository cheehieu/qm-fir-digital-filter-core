/* $Id: xio.h,v 1.1.4.1 2009/03/19 19:16:42 moleres Exp $ */
/******************************************************************************
*
* (c) Copyright 2007-2009 Xilinx, Inc. All rights reserved.
*
* This file contains confidential and proprietary information of Xilinx, Inc.
* and is protected under U.S. and international copyright and other
* intellectual property laws.
*
* DISCLAIMER
* This disclaimer is not a license and does not grant any rights to the
* materials distributed herewith. Except as otherwise provided in a valid
* license issued to you by Xilinx, and to the maximum extent permitted by
* applicable law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND WITH ALL
* FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES AND CONDITIONS, EXPRESS,
* IMPLIED, OR STATUTORY, INCLUDING BUT NOT LIMITED TO WARRANTIES OF
* MERCHANTABILITY, NON-INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE;
* and (2) Xilinx shall not be liable (whether in contract or tort, including
* negligence, or under any other theory of liability) for any loss or damage
* of any kind or nature related to, arising under or in connection with these
* materials, including for any direct, or any indirect, special, incidental,
* or consequential loss or damage (including loss of data, profits, goodwill,
* or any type of loss or damage suffered as a result of any action brought by
* a third party) even if such damage or loss was reasonably foreseeable or
* Xilinx had been advised of the possibility of the same.
*
* CRITICAL APPLICATIONS
* Xilinx products are not designed or intended to be fail-safe, or for use in
* any application requiring fail-safe performance, such as life-support or
* safety devices or systems, Class III medical devices, nuclear facilities,
* applications related to the deployment of airbags, or any other applications
* that could lead to death, personal injury, or severe property or
* environmental damage (individually and collectively, "Critical
* Applications"). Customer assumes the sole risk and liability of any use of
* Xilinx products in Critical Applications, subject only to applicable laws
* and regulations governing limitations on product liability.
*
* THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS PART OF THIS FILE
* AT ALL TIMES.
*
******************************************************************************/
/*****************************************************************************/
/**
*
* @file xio.h
*
* This file contains the interface for the XIo component, which encapsulates
* the Input/Output functions for the PowerPC architecture.
* This header file needs to be updated to replace eieio with mbar when
* compilers support the mbar mnemonic.
*
* @note
*
* This file contains architecture-dependent items (memory mapped or non memory
* mapped I/O).
*
* <pre>
* MODIFICATION HISTORY:
*
* Ver   Who  Date     Changes
* ----- ---- -------- --------------------------------------------------------
* 1.00a ecm  10/18/07 initial release
* 1.00b va   04/17/08 Updated Tcl for better CORE_CLOCK_FREQ_HZ definition
* 1.01a sdm  03/12/09 a) Updated Tcl to define XPAR_XLLDMA_USE_DCR only when
*			 the HW design contains HDMA
*		      b) Updated Tcl to define correct value for
*			 CORE_CLOCK_FREQ_HZ (CR  #502010)
*		      c) Updated the Mdd to use the new lldma driver
* </pre>
******************************************************************************/

#ifndef XIO_H           /* prevent circular inclusions */
#define XIO_H           /* by using protection macros */

#ifdef __cplusplus
extern "C" {
#endif

/***************************** Include Files *********************************/

#include "xbasic_types.h"

/************************** Constant Definitions *****************************/


/**************************** Type Definitions *******************************/

/**
 * Typedef for an I/O address.  Typically correlates to the width of the
 * address bus.
 */
typedef u32 XIo_Address;

/***************** Macros (Inline Functions) Definitions *********************/

/* The following macro is specific to the GNU compiler and PowerPC family. It
 * performs an EIEIO instruction such that I/O operations are synced correctly.
 * This macro is not necessarily portable across compilers since it uses
 * inline assembly.
 */
#if defined __GNUC__
#  define SYNCHRONIZE_IO __asm__ volatile ("eieio") /* should be 'mbar' ultimately */
#elif defined __DCC__
#  define SYNCHRONIZE_IO __asm volatile(" eieio")   /* should be 'mbar' ultimately */
#else
#  define SYNCHRONIZE_IO
#endif

/* The following macros allow the software to be transportable across
 * processors which use big or little endian memory models.
 *
 * Defined first are processor-specific endian conversion macros specific to
 * the GNU compiler and the PowerPC family, as well as a no-op endian conversion
 * macro. These macros are not to be used directly by software. Instead, the
 * XIo_To/FromLittleEndianXX and XIo_To/FromBigEndianXX macros below are to be
 * used to allow the endian conversion to only be performed when necessary
 */

#define XIo_EndianNoop(Source, DestPtr)    (*DestPtr = Source)

#if defined __GNUC__

#define XIo_EndianSwap16(Source, DestPtr)  __asm__ __volatile__(\
                                           "sthbrx %0,0,%1\n"\
                                           : : "r" (Source), "r" (DestPtr)\
                                           )

#define XIo_EndianSwap32(Source, DestPtr)  __asm__ __volatile__(\
                                           "stwbrx %0,0,%1\n"\
                                           : : "r" (Source), "r" (DestPtr)\
                                           )
#elif defined __DCC__

__asm void XIo_EndianSwap16(u16 Source, u16 *DestPtr)
{
% reg Source; reg DestPtr;

  sthbrx Source,0,DestPtr
}

__asm void XIo_EndianSwap32(u32 Source, u32 *DestPtr)
{
% reg Source; reg DestPtr;

  stwbrx Source,0,DestPtr
}

#else

#define XIo_EndianSwap16(Source, DestPtr) \
{\
   u16 src = (Source); \
   u16 *destptr = (DestPtr); \
   *destptr = src >> 8; \
   *destptr |= (src << 8); \
}

#define XIo_EndianSwap32(Source, DestPtr) \
{\
   u32 src = (Source); \
   u32 *destptr = (DestPtr); \
   *destptr = src >> 24; \
   *destptr |= ((src >> 8)  & 0x0000FF00); \
   *destptr |= ((src << 8)  & 0x00FF0000); \
   *destptr |= ((src << 24) & 0xFF000000); \
}

#endif

#ifdef XLITTLE_ENDIAN
/* little-endian processor */

#define XIo_ToLittleEndian16                XIo_EndianNoop
#define XIo_ToLittleEndian32                XIo_EndianNoop
#define XIo_FromLittleEndian16              XIo_EndianNoop
#define XIo_FromLittleEndian32              XIo_EndianNoop

#define XIo_ToBigEndian16(Source, DestPtr)  XIo_EndianSwap16(Source, DestPtr)
#define XIo_ToBigEndian32(Source, DestPtr)  XIo_EndianSwap32(Source, DestPtr)
#define XIo_FromBigEndian16                 XIo_ToBigEndian16
#define XIo_FromBigEndian32                 XIo_ToBigEndian32

#else
/* big-endian processor */

#define XIo_ToLittleEndian16(Source, DestPtr) XIo_EndianSwap16(Source, DestPtr)
#define XIo_ToLittleEndian32(Source, DestPtr) XIo_EndianSwap32(Source, DestPtr)
#define XIo_FromLittleEndian16                XIo_ToLittleEndian16
#define XIo_FromLittleEndian32                XIo_ToLittleEndian32

#define XIo_ToBigEndian16                     XIo_EndianNoop
#define XIo_ToBigEndian32                     XIo_EndianNoop
#define XIo_FromBigEndian16                   XIo_EndianNoop
#define XIo_FromBigEndian32                   XIo_EndianNoop

#endif


/************************** Function Prototypes ******************************/

/* The following functions allow the software to be transportable across
 * processors which may use memory mapped I/O or I/O which is mapped into a
 * seperate address space such as X86.  The functions are better suited for
 * debugging and are therefore the default implementation. Macros can instead
 * be used if USE_IO_MACROS is defined.
 */
#ifndef USE_IO_MACROS

/* Functions */
u8 XIo_In8(XIo_Address InAddress);
u16 XIo_In16(XIo_Address InAddress);
u32 XIo_In32(XIo_Address InAddress);

void XIo_Out8(XIo_Address OutAddress, u8 Value);
void XIo_Out16(XIo_Address OutAddress, u16 Value);
void XIo_Out32(XIo_Address OutAddress, u32 Value);

#else

/* The following macros allow optimized I/O operations for memory mapped I/O
 * Note that the SYNCHRONIZE_IO may be moved by the compiler during
 * optimization.
 */

#define XIo_In8(InputPtr)  (*(volatile u8  *)(InputPtr)); SYNCHRONIZE_IO;
#define XIo_In16(InputPtr) (*(volatile u16 *)(InputPtr)); SYNCHRONIZE_IO;
#define XIo_In32(InputPtr) (*(volatile u32 *)(InputPtr)); SYNCHRONIZE_IO;

#define XIo_Out8(OutputPtr, Value)  \
    { (*(volatile u8  *)(OutputPtr) = Value); SYNCHRONIZE_IO; }
#define XIo_Out16(OutputPtr, Value) \
    { (*(volatile u16 *)(OutputPtr) = Value); SYNCHRONIZE_IO; }
#define XIo_Out32(OutputPtr, Value) \
    { (*(volatile u32 *)(OutputPtr) = Value); SYNCHRONIZE_IO; }

#endif

/* The following functions handle IO addresses where data must be swapped
 * They cannot be implemented as macros
 */
u16 XIo_InSwap16(XIo_Address InAddress);
u32 XIo_InSwap32(XIo_Address InAddress);
void XIo_OutSwap16(XIo_Address OutAddress, u16 Value);
void XIo_OutSwap32(XIo_Address OutAddress, u32 Value);

#ifdef __cplusplus
}
#endif

#endif /* end of protection macro */

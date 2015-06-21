/* $Id: xio.c,v 1.1.4.1 2009/03/19 19:16:42 moleres Exp $ */
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
* @file xio.c
*
* Contains I/O functions for memory-mapped or non-memory-mapped I/O
* architectures.  These functions encapsulate PowerPC architecture-specific
* I/O requirements.
*
* @note
*
* This file contains architecture-dependent code.
*
* The order of the SYNCHRONIZE_IO and the read or write operation is
* important. For the Read operation, all I/O needs to complete prior
* to the desired read to insure valid data from the address. The PPC
* is a weakly ordered I/O model and reads can and will occur prior
* to writes and the SYNCHRONIZE_IO ensures that any writes occur prior
* to the read. For the Write operation the SYNCHRONIZE_IO occurs
* after the desired write to ensure that the address is updated with
* the new value prior to any subsequent read.
*
* <pre>
* MODIFICATION HISTORY:
*
* Ver   Who  Date     Changes
* ----- ---- -------- --------------------------------------------------------
* 1.00a ecm  10/18/07 initial release
* </pre>
******************************************************************************/


/***************************** Include Files *********************************/
#include "xio.h"
#include "xbasic_types.h"

/************************** Constant Definitions *****************************/


/**************************** Type Definitions *******************************/


/***************** Macros (Inline Functions) Definitions *********************/
#if defined __DCC__
asm volatile u16 InSwap16(XIo_Address InAddress)
{
%reg InAddress
! "r3"

	eieio
	lhbrx r3, 0, InAddress
}

asm volatile u32 InSwap32(XIo_Address InAddress)
{
%reg InAddress
! "r3"

	eieio
	lwbrx r3, 0, InAddress
}

asm volatile void OutSwap16(XIo_Address OutAddress, u16 Value)
{
%reg OutAddress; reg Value

	sthbrx Value, 0, OutAddress
        eieio
}

asm volatile void OutSwap32(XIo_Address OutAddress, u32 Value)
{
%reg OutAddress; reg Value

	stwbrx Value, 0, OutAddress
	eieio
}

#endif
/************************** Function Prototypes ******************************/
/*****************************************************************************/
/**
*
* Performs an input operation for an 8-bit memory location by reading from the
* specified address and returning the value read from that address.
*
* @param    InAddress contains the address to perform the input operation at.
*
* @return
*
* The value read from the specified input address.
*
* @note
*
* None.
*
******************************************************************************/
    u8 XIo_In8(XIo_Address InAddress)
{
    /* read the contents of the I/O location and then synchronize the I/O
     * such that the I/O operation completes before proceeding on
     */

#if defined __GNUC__

    u8 IoContents;
    __asm__ volatile ("eieio; lbz %0,0(%1)":"=r" (IoContents):"b"
              (InAddress));
    return IoContents;

#else

    SYNCHRONIZE_IO;
    return *(u8 *) InAddress;

#endif

}

/*****************************************************************************/
/**
*
* Performs an input operation for a 16-bit memory location by reading from the
* specified address and returning the value read from that address.
*
* @param    InAddress contains the address to perform the input operation at.
*
* @return
*
* The value read from the specified input address.
*
* @note
*
* None.
*
******************************************************************************/
u16 XIo_In16(XIo_Address InAddress)
{
    /* read the contents of the I/O location and then synchronize the I/O
     * such that the I/O operation completes before proceeding on
     */

#if defined __GNUC__

    u16 IoContents;
    __asm__ volatile ("eieio; lhz %0,0(%1)":"=r" (IoContents):"b"
              (InAddress));
    return IoContents;

#else

    SYNCHRONIZE_IO;
    return *(u16 *) InAddress;

#endif
}

/*****************************************************************************/
/**
*
* Performs an input operation for a 32-bit memory location by reading from the
* specified address and returning the value read from that address.
*
* @param    InAddress contains the address to perform the input operation at.
*
* @return
*
* The value read from the specified input address.
*
* @note
*
* None.
*
******************************************************************************/
u32 XIo_In32(XIo_Address InAddress)
{
    /* read the contents of the I/O location and then synchronize the I/O
     * such that the I/O operation completes before proceeding on
     */

#ifdef __GNUC__

    u32 IoContents;
    __asm__ volatile ("eieio; lwz %0,0(%1)":"=r" (IoContents):"b"
              (InAddress));
    return IoContents;

#else

    SYNCHRONIZE_IO;
    return *(u32 *) InAddress;

#endif

}

/*****************************************************************************/
/**
*
* Performs an input operation for a 16-bit memory location by reading from the
* specified address and returning the byte-swapped value read from that
* address.
*
* @param    InAddress contains the address to perform the input operation at.
*
* @return
*
* The byte-swapped value read from the specified input address.
*
* @note
*
* None.
*
******************************************************************************/
u16 XIo_InSwap16(XIo_Address InAddress)
{
    /* read the contents of the I/O location and then synchronize the I/O
     * such that the I/O operation completes before proceeding on
     */
#ifdef __GNUC__
    u16 IoContents;

    __asm__ volatile ("eieio; lhbrx %0,0,%1":"=r" (IoContents):"b"
              (InAddress));
    return IoContents;
#else
    return InSwap16(InAddress);
#endif
}

/*****************************************************************************/
/**
*
* Performs an input operation for a 32-bit memory location by reading from the
* specified address and returning the byte-swapped value read from that
* address.
*
* @param    InAddress contains the address to perform the input operation at.
*
* @return
*
* The byte-swapped value read from the specified input address.
*
* @note
*
* None.
*
******************************************************************************/
u32 XIo_InSwap32(XIo_Address InAddress)
{
    /* read the contents of the I/O location and then synchronize the I/O
     * such that the I/O operation completes before proceeding on
     */
#ifdef __GNUC__
    u32 IoContents;

    __asm__ volatile ("eieio; lwbrx %0,0,%1":"=r" (IoContents):"b"
              (InAddress));
    return IoContents;
#else
    return InSwap32(InAddress);
#endif

}


/*****************************************************************************/
/**
*
* Performs an output operation for an 8-bit memory location by writing the
* specified value to the the specified address.
*
* @param    OutAddress contains the address to perform the output operation at.
* @param    Value contains the value to be output at the specified address.
*
* @return
*
* None.
*
* @note
*
* None.
*
******************************************************************************/
void XIo_Out8(XIo_Address OutAddress, u8 Value)
{
    /* write the contents of the I/O location and then synchronize the I/O
     * such that the I/O operation completes before proceeding on
     */

#ifdef __GNUC__

    __asm__ volatile ("stb %0,0(%1); eieio"::"r" (Value), "b"(OutAddress));

#else

    *(volatile u8 *) OutAddress = Value;
    SYNCHRONIZE_IO;

#endif

}

/*****************************************************************************/
/**
*
* Performs an output operation for a 16-bit memory location by writing the
* specified value to the the specified address.
*
* @param    OutAddress contains the address to perform the output operation at.
* @param    Value contains the value to be output at the specified address.
*
* @return
*
* None.
*
* @note
*
* None.
*
******************************************************************************/
void XIo_Out16(XIo_Address OutAddress, u16 Value)
{
    /* write the contents of the I/O location and then synchronize the I/O
     * such that the I/O operation completes before proceeding on
     */

#ifdef __GNUC__

    __asm__ volatile ("sth %0,0(%1); eieio"::"r" (Value), "b"(OutAddress));

#else

    *(volatile u16 *) OutAddress = Value;
    SYNCHRONIZE_IO;

#endif
}

/*****************************************************************************/
/**
*
* Performs an output operation for a 32-bit memory location by writing the
* specified value to the the specified address.
*
* @param    OutAddress contains the address to perform the output operation at.
* @param    Value contains the value to be output at the specified address.
*
* @return
*
* None.
*
* @note
*
* None.
*
******************************************************************************/
void XIo_Out32(XIo_Address OutAddress, u32 Value)
{
    /* write the contents of the I/O location and then synchronize the I/O
     * such that the I/O operation completes before proceeding on
     */

#ifdef __GNUC__

    __asm__ volatile ("stw %0,0(%1); eieio"::"r" (Value), "b"(OutAddress));

#else

    *(volatile u32 *) OutAddress = Value;
    SYNCHRONIZE_IO;

#endif
}

/*****************************************************************************/
/**
*
* Performs a 16-bit endian converion.
*
* @param    Source contains the value to be converted.
* @param    DestPtr contains a pointer to the location to put the
*           converted value.
*
* @return
*
* None.
*
* @note
*
* None.
*
******************************************************************************/
void XIo_EndianSwap16OLD(u16 Source, u16 *DestPtr)
{
    *DestPtr = (u16) (((Source & 0xFF00) >> 8) | ((Source & 0x00FF) << 8));
}

/*****************************************************************************/
/**
*
* Performs a 32-bit endian converion.
*
* @param    Source contains the value to be converted.
* @param    DestPtr contains a pointer to the location to put the
*           converted value.
*
* @return
*
* None.
*
* @note
*
* None.
*
******************************************************************************/
void XIo_EndianSwap32OLD(u32 Source, u32 *DestPtr)
{

    /* get each of the half words from the 32 bit word */

    u16 LoWord = (u16) (Source & 0x0000FFFF);
    u16 HiWord = (u16) ((Source & 0xFFFF0000) >> 16);

    /* byte swap each of the 16 bit half words */

    LoWord = (((LoWord & 0xFF00) >> 8) | ((LoWord & 0x00FF) << 8));
    HiWord = (((HiWord & 0xFF00) >> 8) | ((HiWord & 0x00FF) << 8));

    /* swap the half words before returning the value */

    *DestPtr = (u32) ((LoWord << 16) | HiWord);
}

/*****************************************************************************/
/**
*
* Performs an output operation for a 16-bit memory location by writing the
* specified value to the the specified address. The value is byte-swapped
* before being written.
*
* @param    OutAddress contains the address to perform the output operation at.
* @param    Value contains the value to be output at the specified address.
*
* @return
*
* None.
*
* @note
*
* None.
*
******************************************************************************/
void XIo_OutSwap16(XIo_Address OutAddress, u16 Value)
{
    /* write the contents of the I/O location and then synchronize the I/O
     * such that the I/O operation completes before proceeding on
     */
#ifdef __GNUC__
    __asm__ volatile ("sthbrx %0,0,%1; eieio"::"r" (Value),
              "b"(OutAddress));
#else
    OutSwap16(OutAddress, Value);
#endif
}

/*****************************************************************************/
/**
*
* Performs an output operation for a 32-bit memory location by writing the
* specified value to the the specified address. The value is byte-swapped
* before being written.
*
* @param    OutAddress contains the address to perform the output operation at.
* @param    Value contains the value to be output at the specified address.
*
* @return
*
* None.
*
* @note
*
* None.
*
******************************************************************************/
void XIo_OutSwap32(XIo_Address OutAddress, u32 Value)
{
    /* write the contents of the I/O location and then synchronize the I/O
     * such that the I/O operation completes before proceeding on
     */
#ifdef __GNUC__
    __asm__ volatile ("stwbrx %0,0,%1; eieio"::"r" (Value),
              "b"(OutAddress));
#else
    OutSwap32(OutAddress, Value);
#endif
}

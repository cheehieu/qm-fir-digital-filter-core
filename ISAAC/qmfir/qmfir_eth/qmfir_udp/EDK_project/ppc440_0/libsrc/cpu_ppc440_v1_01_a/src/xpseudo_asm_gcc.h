/* $Id: xpseudo_asm_gcc.h,v 1.1.4.4 2009/04/21 19:26:09 meinelte Exp $ */
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
* @file xpseudo_asm_gcc.h
*
* This header file contains macros for using inline assembler code. It is
* written specifically for the GNU compiler.
*
* <pre>
* MODIFICATION HISTORY:
*
* Ver   Who  Date      Changes
* ----- ---- --------  -----------------------------------------------
* 1.00a ecm  10/18/07  moved over from standalone bsp and updated to standards
* 1.01a ecm  04/21/09 #ifndef'd 'sync' to to fix namespace collision
*					  with C++ streambuf.h include, CR511861 and CR518980
*					  This makes the inline assembly 'sync' unavailable in
*					  C++ applications which is probably a minor issue
*					  This is a workaround until the new API is released
* </pre>
*
******************************************************************************/

#ifndef XPSEUDO_ASM_H  /* prevent circular inclusions */
#define XPSEUDO_ASM_H  /* by using protection macros */

#ifdef __cplusplus
extern "C" {
#endif

/***************************** Include Files ********************************/
#ifndef XENV_VXWORKS
#include <ppc-asm.h>
#endif
#include "xreg440.h"
#define r2 2
#define r1 1

/************************** Constant Definitions ****************************/

/**************************** Type Definitions ******************************/

/***************** Macros (Inline Functions) Definitions ********************/

/* necessary for pre-processor */
#define stringify(s)    tostring(s)
#define tostring(s)     #s

/* pseudo assembler instructions */

#define mtgpr(rn, v)    __asm__ __volatile__(\
                          "mr " stringify(rn) ",%0\n"\
                          : : "r" (v)\
                        )

#define mfgpr(rn)       ({unsigned int rval; \
                          __asm__ __volatile__(\
                            "mr %0," stringify(rn) "\n"\
                            : "=r" (rval)\
                          );\
                          rval;\
                        })

#define mtspr(rn, v)    __asm__ __volatile__(\
                          "mtspr " stringify(rn) ",%0\n"\
                          : : "r" (v)\
                        )

#define mfspr(rn)       ({unsigned int rval; \
                          __asm__ __volatile__(\
                            "mfspr %0," stringify(rn) "\n"\
                            : "=r" (rval)\
                          );\
                          rval;\
                        })

#define mtdcr(rn, v)    __asm__ __volatile__(\
                          "mtdcr " stringify(rn) ",%0\n"\
                          : : "r" (v)\
                        )

#define mfdcr(rn)       ({unsigned int rval; \
                          __asm__ __volatile__(\
                            "mfdcr %0," stringify(rn) "\n"\
                            : "=r" (rval)\
                          );\
                          rval;\
                        })

#define mtmsr(v)        __asm__ __volatile__(\
                          "mtmsr %0\n"\
                          : : "r" (v)\
                        )

#define mfmsr()         ({unsigned int rval; \
                          __asm__ __volatile__(\
                            "mfmsr %0\n"\
                            : "=r" (rval)\
                          );\
                          rval;\
                        })

#define mfcr()          ({unsigned int rval; \
                          __asm__ __volatile__(\
                            "mfcr %0\n"\
                            : "=r" (rval)\
                          );\
                          rval;\
                        })

#define mtivpr(adr)     mtspr(XREG_SPR_IVPR, (adr))
#define mtivor0(v)      __asm__ __volatile__(\
                          "mtspr " stringify(XREG_SPR_IVOR0) ",%0\n"\
                          : : "r" (v)\
                        )
#define mtivor1(v)      __asm__ __volatile__(\
                          "mtspr " stringify(XREG_SPR_IVOR1) ",%0\n"\
                          : : "r" (v)\
                        )
#define mtivor2(v)      __asm__ __volatile__(\
                          "mtspr " stringify(XREG_SPR_IVOR2) ",%0\n"\
                          : : "r" (v)\
                        )
#define mtivor3(v)      __asm__ __volatile__(\
                          "mtspr " stringify(XREG_SPR_IVOR3) ",%0\n"\
                          : : "r" (v)\
                        )
#define mtivor4(v)      __asm__ __volatile__(\
                          "mtspr " stringify(XREG_SPR_IVOR4) ",%0\n"\
                          : : "r" (v)\
                        )
#define mtivor5(v)      __asm__ __volatile__(\
                          "mtspr " stringify(XREG_SPR_IVOR5) ",%0\n"\
                          : : "r" (v)\
                        )
#define mtivor6(v)      __asm__ __volatile__(\
                          "mtspr " stringify(XREG_SPR_IVOR6) ",%0\n"\
                          : : "r" (v)\
                        )
#define mtivor7(v)      __asm__ __volatile__(\
                          "mtspr " stringify(XREG_SPR_IVOR7) ",%0\n"\
                          : : "r" (v)\
                        )
#define mtivor8(v)      __asm__ __volatile__(\
                          "mtspr " stringify(XREG_SPR_IVOR8) ",%0\n"\
                          : : "r" (v)\
                        )
#define mtivor9(v)      __asm__ __volatile__(\
                          "mtspr " stringify(XREG_SPR_IVOR9) ",%0\n"\
                          : : "r" (v)\
                        )
#define mtivor10(v)      __asm__ __volatile__(\
                          "mtspr " stringify(XREG_SPR_IVOR10) ",%0\n"\
                          : : "r" (v)\
                        )
#define mtivor11(v)      __asm__ __volatile__(\
                          "mtspr " stringify(XREG_SPR_IVOR11) ",%0\n"\
                          : : "r" (v)\
                        )
#define mtivor12(v)      __asm__ __volatile__(\
                          "mtspr " stringify(XREG_SPR_IVOR12) ",%0\n"\
                          : : "r" (v)\
                        )
#define mtivor13(v)      __asm__ __volatile__(\
                          "mtspr " stringify(XREG_SPR_IVOR13) ",%0\n"\
                          : : "r" (v)\
                        )
#define mtivor14(v)      __asm__ __volatile__(\
                          "mtspr " stringify(XREG_SPR_IVOR14) ",%0\n"\
                          : : "r" (v)\
                        )
#define mtivor15(v)      __asm__ __volatile__(\
                          "mtspr " stringify(XREG_SPR_IVOR15) ",%0\n"\
                          : : "r" (v)\
                        )
#define mtcsrr0(v)      mtspr(XREG_SPR_CSRR0, (v))
#define mtcsrr1(v)      mtspr(XREG_SPR_CSRR1, (v))
#define mtmcsrr0(v)     mtspr(XREG_SPR_MCSRR0, (v))
#define mtmcsrr1(v)     mtspr(XREG_SPR_MCSRR1, (v))

/************************* instruction cache operations ***********************/
#define icbi(adr)       __asm__ __volatile__("icbi  %0,%1\n" : : "r" (0), "r" (adr))
#define icbt(adr)       __asm__ __volatile__("icbt  %0,%1\n" : : "r" (0), "r" (adr))
/* no arguments needed but retained for compatibilty with the PPC405 */
#define iccci           __asm__ __volatile__("iccci 0,0\n")
#define icread(adr)     __asm__ __volatile__("icread %0,%1\n" : : "r" (0), "r" (adr))

/***************************** data cache operations **************************/
#define dcbf(adr)       __asm__ __volatile__("dcbf  %0,%1\n" : : "r" (0), "r" (adr))
#define dcbi(adr)       __asm__ __volatile__("dcbi  %0,%1\n" : : "r" (0), "r" (adr))
#define dcbst(adr)      __asm__ __volatile__("dcbst %0,%1\n" : : "r" (0), "r" (adr))
#define dcbt(adr)       __asm__ __volatile__("dcbt  %0,%1\n" : : "r" (0), "r" (adr))
#define dcbz(adr)       __asm__ __volatile__("dcbz  %0,%1\n" : : "r" (0), "r" (adr))
/* no arguments needed but retained for compatibilty with the PPC405 */
#define dccci(adr)      __asm__ __volatile__("dccci 0,%0\n" : : "r" (adr))
#define dcread(adr)     ({register unsigned int rval; \
                          __asm__ __volatile__("\
                            dcread %0,%1,%2\n"\
                            : "=r" (rval) : "r" (0), "r" (adr)\
                          );\
                          rval;\
                        })

/*************************** synchonrization operations ***********************/
#define isync           __asm__ __volatile__("isync\n")
/*
 * 'sync' instruction will break vxworks BSP build, however standalone BSP
 * is using this instruction. Have to use this conditional statement make both
 * happy.
 */
#if !defined(XENV_VXWORKS)
#define __sync            __asm__ __volatile__("sync\n")

#ifndef __cplusplus
#define sync            __asm__ __volatile__("sync\n")
#endif

#endif
#define msync           __asm__ __volatile__("msync\n")
#define mbar            __asm__ __volatile__("mbar\n")
#define eieio           __asm__ __volatile__("eieio\n")

#define tlbsx(adr, offset)        ({unsigned int rval; \
                          __asm__ __volatile__(\
                            "tlbsx. %0,%1,%2\n" \
                            : "=r" (rval) \
                            : "r" (adr), "r" (offset) \
                          );\
                          rval; })

#define tlbre(entry, word)        ({unsigned int rval; \
                          __asm__ __volatile__(\
                            "tlbre %0,%1,%2\n" \
                            : "=r" (rval) \
                            : "r" (entry), "i" (word) \
                          );\
                          rval; })

#define tlbwe(val, index, word) __asm__ __volatile__(\
                            "tlbwe %0,%1,%2\n" \
                            : : "r"(val), "r"(index), "i"(word) \
                         )

#define lbz(adr)        ({unsigned char rval; \
                          __asm__ __volatile__(\
                            "lbz %0,0(%1)\n"\
                            : "=r" (rval) : "b" (adr)\
                          );\
                          rval;\
                        })

#define lhz(adr)        ({unsigned short rval; \
                          __asm__ __volatile__(\
                            "lhz %0,0(%1)\n"\
                            : "=r" (rval) : "b" (adr)\
                          );\
                          rval;\
                        })

#define lwz(adr)        ({unsigned int rval; \
                          __asm__ __volatile__(\
                            "lwz %0,0(%1)\n"\
                            : "=r" (rval) : "b" (adr)\
                          );\
                          rval;\
                        })

#define stb(adr, val)   __asm__ __volatile__(\
                          "stb %0,0(%1)\n"\
                          : : "r" (val), "b" (adr)\
                        )

#define sth(adr, val)   __asm__ __volatile__(\
                          "sth %0,0(%1)\n"\
                          : : "r" (val), "b" (adr)\
                        )

#define stw(adr, val)   __asm__ __volatile__(\
                          "stw %0,0(%1)\n"\
                          : : "r" (val), "b" (adr)\
                        )

#define lhbrx(adr)      ({unsigned short rval; \
                          __asm__ __volatile__(\
                            "lhbrx %0,0,%1\n"\
                            : "=r" (rval) : "r" (adr)\
                          );\
                          rval;\
                        })

#define lwbrx(adr)      ({unsigned int rval; \
                          __asm__ __volatile__(\
                            "lwbrx %0,0,%1\n"\
                            : "=r" (rval) : "r" (adr)\
                          );\
                          rval;\
                        })

#define sthbrx(adr, val)  __asm__ __volatile__(\
                            "sthbrx %0,0,%1\n"\
                            : : "r" (val), "r" (adr)\
                          )

#define stwbrx(adr, val)  __asm__ __volatile__(\
                            "stwbrx %0,0,%1\n"\
                            : : "r" (val), "r" (adr)\
                          )

#define wrtee(v)        __asm__ __volatile__(\
                          "wrtee %0\n"\
                          : : "r" (v)\
                        )

#define wrteei(v)        __asm__ __volatile__(\
                          "wrteei " stringify(v) "\n"\
                        )


/* Blocking Data Read and Write to FSL no. id */
#define getfsl(val, id)         __asm__ __volatile__ (\
                                        "get %0, " #id : "=r" (val))

#define putfsl(val, id)         __asm__ __volatile__(\
                                        "put %0, " #id :: "r" (val))

/* Non-blocking Data Read and Write to FSL no. id */
#define ngetfsl(val, id)        __asm__ __volatile__(\
                                        "nget %0, " #id : "=r" (val))

#define nputfsl(val, id)        __asm__ __volatile__(\
                                        "nput %0, " #id :: "r" (val))

/* Blocking Control Read and Write to FSL no. id */
#define cgetfsl(val, id)        __asm__ __volatile__(\
                                        "cget %0, " #id : "=r" (val))

#define cputfsl(val, id)        __asm__ __volatile__(\
                                        "cput %0, " #id :: "r" (val))


/* Non-blocking Control Read and Write to FSL no. id */
#define ncgetfsl(val, id)       __asm__ __volatile__(\
                                        "ncget %0, " #id : "=r" (val))

#define ncputfsl(val, id)       __asm__ __volatile__(\
                                        "ncput %0, " #id :: "r" (val))



/************************** APU UDI FCM Level 2 Internal Macros ****************************/

/************************** udi<n>fcm. Instruction Combinations ****************************/

/* udi0fcm. */

#define UDI0FCMCR_GPR_GPR_GPR(a, b, c)                    \
        __asm__ __volatile__("udi0fcm. %0,%1,%2" : "=r"(a) :  "r"(b), "r"(c))

#define UDI0FCMCR_GPR_GPR_IMM(a, b, c)                    \
        __asm__ __volatile__("udi0fcm. %0,%1," #c : "=r"(a) :  "r"(b))

#define UDI0FCMCR_GPR_IMM_IMM(a, b, c)                    \
        __asm__ __volatile__("udi0fcm. %0," #b "," #c : "=r"(a))

#define UDI0FCMCR_IMM_GPR_GPR(a, b, c)                    \
        __asm__ __volatile__("udi0fcm. " #a ",%0,%1" : : "r"(b), "r"(c))

#define UDI0FCMCR_IMM_IMM_GPR(a, b, c)                    \
        __asm__ __volatile__("udi0fcm. " #a "," #b ",%0" :: "r"(c))

#define UDI0FCMCR_IMM_IMM_IMM(a, b, c)                    \
        __asm__ __volatile__("udi0fcm. " #a "," #b "," #c)

/* udi1fcm. */

#define UDI1FCMCR_GPR_GPR_GPR(a, b, c)                    \
        __asm__ __volatile__("udi1fcm. %0,%1,%2" : "=r"(a) :  "r"(b), "r"(c))

#define UDI1FCMCR_GPR_GPR_IMM(a, b, c)                    \
        __asm__ __volatile__("udi1fcm. %0,%1," #c : "=r"(a) :  "r"(b))

#define UDI1FCMCR_GPR_IMM_IMM(a, b, c)                    \
        __asm__ __volatile__("udi1fcm. %0," #b "," #c : "=r"(a))

#define UDI1FCMCR_IMM_GPR_GPR(a, b, c)                    \
        __asm__ __volatile__("udi1fcm. " #a ",%0,%1" : : "r"(b), "r"(c))

#define UDI1FCMCR_IMM_IMM_GPR(a, b, c)                    \
        __asm__ __volatile__("udi1fcm. " #a "," #b ",%0" :: "r"(c))

#define UDI1FCMCR_IMM_IMM_IMM(a, b, c)                    \
        __asm__ __volatile__("udi1fcm. " #a "," #b "," #c)

/* udi2fcm. */

#define UDI2FCMCR_GPR_GPR_GPR(a, b, c)                    \
        __asm__ __volatile__("udi2fcm. %0,%1,%2" : "=r"(a) :  "r"(b), "r"(c))

#define UDI2FCMCR_GPR_GPR_IMM(a, b, c)                    \
        __asm__ __volatile__("udi2fcm. %0,%1," #c : "=r"(a) :  "r"(b))

#define UDI2FCMCR_GPR_IMM_IMM(a, b, c)                    \
        __asm__ __volatile__("udi2fcm. %0," #b "," #c : "=r"(a))

#define UDI2FCMCR_IMM_GPR_GPR(a, b, c)                    \
        __asm__ __volatile__("udi2fcm. " #a ",%0,%1" : : "r"(b), "r"(c))

#define UDI2FCMCR_IMM_IMM_GPR(a, b, c)                    \
        __asm__ __volatile__("udi2fcm. " #a "," #b ",%0" :: "r"(c))

#define UDI2FCMCR_IMM_IMM_IMM(a, b, c)                    \
        __asm__ __volatile__("udi2fcm. " #a "," #b "," #c)

/* udi3fcm. */

#define UDI3FCMCR_GPR_GPR_GPR(a, b, c)                    \
        __asm__ __volatile__("udi3fcm. %0,%1,%2" : "=r"(a) :  "r"(b), "r"(c))

#define UDI3FCMCR_GPR_GPR_IMM(a, b, c)                    \
        __asm__ __volatile__("udi3fcm. %0,%1," #c : "=r"(a) :  "r"(b))

#define UDI3FCMCR_GPR_IMM_IMM(a, b, c)                    \
        __asm__ __volatile__("udi3fcm. %0," #b "," #c : "=r"(a))

#define UDI3FCMCR_IMM_GPR_GPR(a, b, c)                    \
        __asm__ __volatile__("udi3fcm. " #a ",%0,%1" : : "r"(b), "r"(c))

#define UDI3FCMCR_IMM_IMM_GPR(a, b, c)                    \
        __asm__ __volatile__("udi3fcm. " #a "," #b ",%0" :: "r"(c))

#define UDI3FCMCR_IMM_IMM_IMM(a, b, c)                    \
        __asm__ __volatile__("udi3fcm. " #a "," #b "," #c)


/* udi4fcm. */

#define UDI4FCMCR_GPR_GPR_GPR(a, b, c)                    \
        __asm__ __volatile__("udi4fcm. %0,%1,%2" : "=r"(a) :  "r"(b), "r"(c))

#define UDI4FCMCR_GPR_GPR_IMM(a, b, c)                    \
        __asm__ __volatile__("udi4fcm. %0,%1," #c : "=r"(a) :  "r"(b))

#define UDI4FCMCR_GPR_IMM_IMM(a, b, c)                    \
        __asm__ __volatile__("udi4fcm. %0," #b "," #c : "=r"(a))

#define UDI4FCMCR_IMM_GPR_GPR(a, b, c)                    \
        __asm__ __volatile__("udi4fcm. " #a ",%0,%1" : : "r"(b), "r"(c))

#define UDI4FCMCR_IMM_IMM_GPR(a, b, c)                    \
        __asm__ __volatile__("udi4fcm. " #a "," #b ",%0" :: "r"(c))

#define UDI4FCMCR_IMM_IMM_IMM(a, b, c)                    \
        __asm__ __volatile__("udi4fcm. " #a "," #b "," #c)


/* udi5fcm. */

#define UDI5FCMCR_GPR_GPR_GPR(a, b, c)                    \
        __asm__ __volatile__("udi5fcm. %0,%1,%2" : "=r"(a) :  "r"(b), "r"(c))

#define UDI5FCMCR_GPR_GPR_IMM(a, b, c)                    \
        __asm__ __volatile__("udi5fcm. %0,%1," #c : "=r"(a) :  "r"(b))

#define UDI5FCMCR_GPR_IMM_IMM(a, b, c)                    \
        __asm__ __volatile__("udi5fcm. %0," #b "," #c : "=r"(a))

#define UDI5FCMCR_IMM_GPR_GPR(a, b, c)                    \
        __asm__ __volatile__("udi5fcm. " #a ",%0,%1" : : "r"(b), "r"(c))

#define UDI5FCMCR_IMM_IMM_GPR(a, b, c)                    \
        __asm__ __volatile__("udi5fcm. " #a "," #b ",%0" :: "r"(c))

#define UDI5FCMCR_IMM_IMM_IMM(a, b, c)                    \
        __asm__ __volatile__("udi5fcm. " #a "," #b "," #c)


/* udi6fcm. */

#define UDI6FCMCR_GPR_GPR_GPR(a, b, c)                    \
        __asm__ __volatile__("udi6fcm. %0,%1,%2" : "=r"(a) :  "r"(b), "r"(c))

#define UDI6FCMCR_GPR_GPR_IMM(a, b, c)                    \
        __asm__ __volatile__("udi6fcm. %0,%1," #c : "=r"(a) :  "r"(b))

#define UDI6FCMCR_GPR_IMM_IMM(a, b, c)                    \
        __asm__ __volatile__("udi6fcm. %0," #b "," #c : "=r"(a))

#define UDI6FCMCR_IMM_GPR_GPR(a, b, c)                    \
        __asm__ __volatile__("udi6fcm. " #a ",%0,%1" : : "r"(b), "r"(c))

#define UDI6FCMCR_IMM_IMM_GPR(a, b, c)                    \
        __asm__ __volatile__("udi6fcm. " #a "," #b ",%0" :: "r"(c))

#define UDI6FCMCR_IMM_IMM_IMM(a, b, c)                    \
        __asm__ __volatile__("udi6fcm. " #a "," #b "," #c)


/* udi7fcm. */

#define UDI7FCMCR_GPR_GPR_GPR(a, b, c)                    \
        __asm__ __volatile__("udi7fcm. %0,%1,%2" : "=r"(a) :  "r"(b), "r"(c))

#define UDI7FCMCR_GPR_GPR_IMM(a, b, c)                    \
        __asm__ __volatile__("udi7fcm. %0,%1," #c : "=r"(a) :  "r"(b))

#define UDI7FCMCR_GPR_IMM_IMM(a, b, c)                    \
        __asm__ __volatile__("udi7fcm. %0," #b "," #c : "=r"(a))

#define UDI7FCMCR_IMM_GPR_GPR(a, b, c)                    \
        __asm__ __volatile__("udi7fcm. " #a ",%0,%1" : : "r"(b), "r"(c))

#define UDI7FCMCR_IMM_IMM_GPR(a, b, c)                    \
        __asm__ __volatile__("udi7fcm. " #a "," #b ",%0" :: "r"(c))

#define UDI7FCMCR_IMM_IMM_IMM(a, b, c)                    \
        __asm__ __volatile__("udi7fcm. " #a "," #b "," #c)


/* /\* udi8fcm. *\/ */

#define UDI8FCMCR_GPR_GPR_GPR(a, b, c)       \
        __asm__ __volatile__("udi8fcm. %0,%1,%2" : "=r"(a) :  "r"(b), "r"(c))

#define UDI8FCMCR_GPR_GPR_IMM(a, b, c)       \
        __asm__ __volatile__("udi8fcm. %0,%1," #c : "=r"(a) :  "r"(b))

#define UDI8FCMCR_GPR_IMM_IMM(a, b, c)       \
        __asm__ __volatile__("udi8fcm. %0," #b "," #c : "=r"(a))

#define UDI8FCMCR_IMM_GPR_GPR(a, b, c)       \
        __asm__ __volatile__("udi8fcm. " #a ",%0,%1" : : "r"(b), "r"(c))

#define UDI8FCMCR_IMM_IMM_GPR(a, b, c)       \
        __asm__ __volatile__("udi8fcm. " #a "," #b ",%0" :: "r"(c))

#define UDI8FCMCR_IMM_IMM_IMM(a, b, c)       \
        __asm__ __volatile__("udi8fcm. " #a "," #b "," #c)


/* /\* udi9fcm. *\/ */

#define UDI9FCMCR_GPR_GPR_GPR(a, b, c)       \
        __asm__ __volatile__("udi9fcm. %0,%1,%2" : "=r"(a) :  "r"(b), "r"(c))

#define UDI9FCMCR_GPR_GPR_IMM(a, b, c)       \
        __asm__ __volatile__("udi9fcm. %0,%1," #c : "=r"(a) :  "r"(b))

#define UDI9FCMCR_GPR_IMM_IMM(a, b, c)       \
        __asm__ __volatile__("udi9fcm. %0," #b "," #c : "=r"(a))

#define UDI9FCMCR_IMM_GPR_GPR(a, b, c)       \
        __asm__ __volatile__("udi9fcm. " #a ",%0,%1" : : "r"(b), "r"(c))

#define UDI9FCMCR_IMM_IMM_GPR(a, b, c)       \
        __asm__ __volatile__("udi9fcm. " #a "," #b ",%0" :: "r"(c))

#define UDI9FCMCR_IMM_IMM_IMM(a, b, c)       \
        __asm__ __volatile__("udi9fcm. " #a "," #b "," #c)


/* /\* udi10fcm. *\/ */

#define UDI10FCMCR_GPR_GPR_GPR(a, b, c)       \
        __asm__ __volatile__("udi10fcm. %0,%1,%2" : "=r"(a) :  "r"(b), "r"(c))

#define UDI10FCMCR_GPR_GPR_IMM(a, b, c)       \
        __asm__ __volatile__("udi10fcm. %0,%1," #c : "=r"(a) :  "r"(b))

#define UDI10FCMCR_GPR_IMM_IMM(a, b, c)       \
        __asm__ __volatile__("udi10fcm. %0," #b "," #c : "=r"(a))

#define UDI10FCMCR_IMM_GPR_GPR(a, b, c)       \
        __asm__ __volatile__("udi10fcm. " #a ",%0,%1" : : "r"(b), "r"(c))

#define UDI10FCMCR_IMM_IMM_GPR(a, b, c)       \
        __asm__ __volatile__("udi10fcm. " #a "," #b ",%0" :: "r"(c))

#define UDI10FCMCR_IMM_IMM_IMM(a, b, c)       \
        __asm__ __volatile__("udi10fcm. " #a "," #b "," #c)


/* /\* udi11fcm. *\/ */

#define UDI11FCMCR_GPR_GPR_GPR(a, b, c)       \
        __asm__ __volatile__("udi11fcm. %0,%1,%2" : "=r"(a) :  "r"(b), "r"(c))

#define UDI11FCMCR_GPR_GPR_IMM(a, b, c)       \
        __asm__ __volatile__("udi11fcm. %0,%1," #c : "=r"(a) :  "r"(b))

#define UDI11FCMCR_GPR_IMM_IMM(a, b, c)       \
        __asm__ __volatile__("udi11fcm. %0," #b "," #c : "=r"(a))

#define UDI11FCMCR_IMM_GPR_GPR(a, b, c)       \
        __asm__ __volatile__("udi11fcm. " #a ",%0,%1" : : "r"(b), "r"(c))

#define UDI11FCMCR_IMM_IMM_GPR(a, b, c)       \
        __asm__ __volatile__("udi11fcm. " #a "," #b ",%0" :: "r"(c))

#define UDI11FCMCR_IMM_IMM_IMM(a, b, c)       \
        __asm__ __volatile__("udi11fcm. " #a "," #b "," #c)


/* /\* udi12fcm. *\/ */

#define UDI12FCMCR_GPR_GPR_GPR(a, b, c)       \
        __asm__ __volatile__("udi12fcm. %0,%1,%2" : "=r"(a) :  "r"(b), "r"(c))

#define UDI12FCMCR_GPR_GPR_IMM(a, b, c)       \
        __asm__ __volatile__("udi12fcm. %0,%1," #c : "=r"(a) :  "r"(b))

#define UDI12FCMCR_GPR_IMM_IMM(a, b, c)       \
        __asm__ __volatile__("udi12fcm. %0," #b "," #c : "=r"(a))

#define UDI12FCMCR_IMM_GPR_GPR(a, b, c)       \
        __asm__ __volatile__("udi12fcm. " #a ",%0,%1" : : "r"(b), "r"(c))

#define UDI12FCMCR_IMM_IMM_GPR(a, b, c)       \
        __asm__ __volatile__("udi12fcm. " #a "," #b ",%0" :: "r"(c))

#define UDI12FCMCR_IMM_IMM_IMM(a, b, c)       \
        __asm__ __volatile__("udi12fcm. " #a "," #b "," #c)


/* /\* udi13fcm. *\/ */

#define UDI13FCMCR_GPR_GPR_GPR(a, b, c)       \
        __asm__ __volatile__("udi13fcm. %0,%1,%2" : "=r"(a) :  "r"(b), "r"(c))

#define UDI13FCMCR_GPR_GPR_IMM(a, b, c)       \
        __asm__ __volatile__("udi13fcm. %0,%1," #c : "=r"(a) :  "r"(b))

#define UDI13FCMCR_GPR_IMM_IMM(a, b, c)       \
        __asm__ __volatile__("udi13fcm. %0," #b "," #c : "=r"(a))

#define UDI13FCMCR_IMM_GPR_GPR(a, b, c)       \
        __asm__ __volatile__("udi13fcm. " #a ",%0,%1" : : "r"(b), "r"(c))

#define UDI13FCMCR_IMM_IMM_GPR(a, b, c)       \
        __asm__ __volatile__("udi13fcm. " #a "," #b ",%0" :: "r"(c))

#define UDI13FCMCR_IMM_IMM_IMM(a, b, c)       \
        __asm__ __volatile__("udi13fcm. " #a "," #b "," #c)


/* /\* udi14fcm. *\/ */

#define UDI14FCMCR_GPR_GPR_GPR(a, b, c)       \
        __asm__ __volatile__("udi14fcm. %0,%1,%2" : "=r"(a) :  "r"(b), "r"(c))

#define UDI14FCMCR_GPR_GPR_IMM(a, b, c)       \
        __asm__ __volatile__("udi14fcm. %0,%1," #c : "=r"(a) :  "r"(b))

#define UDI14FCMCR_GPR_IMM_IMM(a, b, c)       \
        __asm__ __volatile__("udi14fcm. %0," #b "," #c : "=r"(a))

#define UDI14FCMCR_IMM_GPR_GPR(a, b, c)       \
        __asm__ __volatile__("udi14fcm. " #a ",%0,%1" : : "r"(b), "r"(c))

#define UDI14FCMCR_IMM_IMM_GPR(a, b, c)       \
        __asm__ __volatile__("udi14fcm. " #a "," #b ",%0" :: "r"(c))

#define UDI14FCMCR_IMM_IMM_IMM(a, b, c)       \
        __asm__ __volatile__("udi14fcm. " #a "," #b "," #c)


/* /\* udi15fcm. *\/ */

#define UDI15FCMCR_GPR_GPR_GPR(a, b, c)       \
        __asm__ __volatile__("udi15fcm. %0,%1,%2" : "=r"(a) :  "r"(b), "r"(c))

#define UDI15FCMCR_GPR_GPR_IMM(a, b, c)       \
        __asm__ __volatile__("udi15fcm. %0,%1," #c : "=r"(a) :  "r"(b))

#define UDI15FCMCR_GPR_IMM_IMM(a, b, c)       \
        __asm__ __volatile__("udi15fcm. %0," #b "," #c : "=r"(a))

#define UDI15FCMCR_IMM_GPR_GPR(a, b, c)       \
        __asm__ __volatile__("udi15fcm. " #a ",%0,%1" : : "r"(b), "r"(c))

#define UDI15FCMCR_IMM_IMM_GPR(a, b, c)       \
        __asm__ __volatile__("udi15fcm. " #a "," #b ",%0" :: "r"(c))

#define UDI15FCMCR_IMM_IMM_IMM(a, b, c)       \
        __asm__ __volatile__("udi15fcm. " #a "," #b "," #c)


/************************** udi<n>fcm Instruction Combinations ****************************/

/* udi0fcm */

#define UDI0FCM_GPR_GPR_GPR(a, b, c)                    \
        __asm__ __volatile__("udi0fcm %0,%1,%2" : "=r"(a) :  "r"(b), "r"(c))

#define UDI0FCM_GPR_GPR_IMM(a, b, c)                    \
        __asm__ __volatile__("udi0fcm %0,%1," #c : "=r"(a) :  "r"(b))

#define UDI0FCM_GPR_IMM_IMM(a, b, c)                    \
        __asm__ __volatile__("udi0fcm %0," #b "," #c : "=r"(a))

#define UDI0FCM_IMM_GPR_GPR(a, b, c)                    \
        __asm__ __volatile__("udi0fcm " #a ",%0,%1" : : "r"(b), "r"(c))

#define UDI0FCM_IMM_IMM_GPR(a, b, c)                    \
        __asm__ __volatile__("udi0fcm " #a "," #b ",%0" :: "r"(c))

#define UDI0FCM_IMM_IMM_IMM(a, b, c)                    \
        __asm__ __volatile__("udi0fcm " #a "," #b "," #c)

/* udi1fcm */

#define UDI1FCM_GPR_GPR_GPR(a, b, c)                    \
        __asm__ __volatile__("udi1fcm %0,%1,%2" : "=r"(a) :  "r"(b), "r"(c))

#define UDI1FCM_GPR_GPR_IMM(a, b, c)                    \
        __asm__ __volatile__("udi1fcm %0,%1," #c : "=r"(a) :  "r"(b))

#define UDI1FCM_GPR_IMM_IMM(a, b, c)                    \
        __asm__ __volatile__("udi1fcm %0," #b "," #c : "=r"(a))

#define UDI1FCM_IMM_GPR_GPR(a, b, c)                    \
        __asm__ __volatile__("udi1fcm " #a ",%0,%1" : : "r"(b), "r"(c))

#define UDI1FCM_IMM_IMM_GPR(a, b, c)                    \
        __asm__ __volatile__("udi1fcm " #a "," #b ",%0" :: "r"(c))

#define UDI1FCM_IMM_IMM_IMM(a, b, c)                    \
        __asm__ __volatile__("udi1fcm " #a "," #b "," #c)

/* udi2fcm */

#define UDI2FCM_GPR_GPR_GPR(a, b, c)                    \
        __asm__ __volatile__("udi2fcm %0,%1,%2" : "=r"(a) :  "r"(b), "r"(c))

#define UDI2FCM_GPR_GPR_IMM(a, b, c)                    \
        __asm__ __volatile__("udi2fcm %0,%1," #c : "=r"(a) :  "r"(b))

#define UDI2FCM_GPR_IMM_IMM(a, b, c)                    \
        __asm__ __volatile__("udi2fcm %0," #b "," #c : "=r"(a))

#define UDI2FCM_IMM_GPR_GPR(a, b, c)                    \
        __asm__ __volatile__("udi2fcm " #a ",%0,%1" : : "r"(b), "r"(c))

#define UDI2FCM_IMM_IMM_GPR(a, b, c)                    \
        __asm__ __volatile__("udi2fcm " #a "," #b ",%0" :: "r"(c))

#define UDI2FCM_IMM_IMM_IMM(a, b, c)                    \
        __asm__ __volatile__("udi2fcm " #a "," #b "," #c)

/* udi3fcm */

#define UDI3FCM_GPR_GPR_GPR(a, b, c)                    \
        __asm__ __volatile__("udi3fcm %0,%1,%2" : "=r"(a) :  "r"(b), "r"(c))

#define UDI3FCM_GPR_GPR_IMM(a, b, c)                    \
        __asm__ __volatile__("udi3fcm %0,%1," #c : "=r"(a) :  "r"(b))

#define UDI3FCM_GPR_IMM_IMM(a, b, c)                    \
        __asm__ __volatile__("udi3fcm %0," #b "," #c : "=r"(a))

#define UDI3FCM_IMM_GPR_GPR(a, b, c)                    \
        __asm__ __volatile__("udi3fcm " #a ",%0,%1" : : "r"(b), "r"(c))

#define UDI3FCM_IMM_IMM_GPR(a, b, c)                    \
        __asm__ __volatile__("udi3fcm " #a "," #b ",%0" :: "r"(c))

#define UDI3FCM_IMM_IMM_IMM(a, b, c)                    \
        __asm__ __volatile__("udi3fcm " #a "," #b "," #c)


/* udi4fcm */

#define UDI4FCM_GPR_GPR_GPR(a, b, c)                    \
        __asm__ __volatile__("udi4fcm %0,%1,%2" : "=r"(a) :  "r"(b), "r"(c))

#define UDI4FCM_GPR_GPR_IMM(a, b, c)                    \
        __asm__ __volatile__("udi4fcm %0,%1," #c : "=r"(a) :  "r"(b))

#define UDI4FCM_GPR_IMM_IMM(a, b, c)                    \
        __asm__ __volatile__("udi4fcm %0," #b "," #c : "=r"(a))

#define UDI4FCM_IMM_GPR_GPR(a, b, c)                    \
        __asm__ __volatile__("udi4fcm " #a ",%0,%1" : : "r"(b), "r"(c))

#define UDI4FCM_IMM_IMM_GPR(a, b, c)                    \
        __asm__ __volatile__("udi4fcm " #a "," #b ",%0" :: "r"(c))

#define UDI4FCM_IMM_IMM_IMM(a, b, c)                    \
        __asm__ __volatile__("udi4fcm " #a "," #b "," #c)


/* udi5fcm */

#define UDI5FCM_GPR_GPR_GPR(a, b, c)                    \
        __asm__ __volatile__("udi5fcm %0,%1,%2" : "=r"(a) :  "r"(b), "r"(c))

#define UDI5FCM_GPR_GPR_IMM(a, b, c)                    \
        __asm__ __volatile__("udi5fcm %0,%1," #c : "=r"(a) :  "r"(b))

#define UDI5FCM_GPR_IMM_IMM(a, b, c)                    \
        __asm__ __volatile__("udi5fcm %0," #b "," #c : "=r"(a))

#define UDI5FCM_IMM_GPR_GPR(a, b, c)                    \
        __asm__ __volatile__("udi5fcm " #a ",%0,%1" : : "r"(b), "r"(c))

#define UDI5FCM_IMM_IMM_GPR(a, b, c)                    \
        __asm__ __volatile__("udi5fcm " #a "," #b ",%0" :: "r"(c))

#define UDI5FCM_IMM_IMM_IMM(a, b, c)                    \
        __asm__ __volatile__("udi5fcm " #a "," #b "," #c)


/* udi6fcm */

#define UDI6FCM_GPR_GPR_GPR(a, b, c)                    \
        __asm__ __volatile__("udi6fcm %0,%1,%2" : "=r"(a) :  "r"(b), "r"(c))

#define UDI6FCM_GPR_GPR_IMM(a, b, c)                    \
        __asm__ __volatile__("udi6fcm %0,%1," #c : "=r"(a) :  "r"(b))

#define UDI6FCM_GPR_IMM_IMM(a, b, c)                    \
        __asm__ __volatile__("udi6fcm %0," #b "," #c : "=r"(a))

#define UDI6FCM_IMM_GPR_GPR(a, b, c)                    \
        __asm__ __volatile__("udi6fcm " #a ",%0,%1" : : "r"(b), "r"(c))

#define UDI6FCM_IMM_IMM_GPR(a, b, c)                    \
        __asm__ __volatile__("udi6fcm " #a "," #b ",%0" :: "r"(c))

#define UDI6FCM_IMM_IMM_IMM(a, b, c)                    \
        __asm__ __volatile__("udi6fcm " #a "," #b "," #c)


/* udi7fcm */

#define UDI7FCM_GPR_GPR_GPR(a, b, c)                    \
        __asm__ __volatile__("udi7fcm %0,%1,%2" : "=r"(a) :  "r"(b), "r"(c))

#define UDI7FCM_GPR_GPR_IMM(a, b, c)                    \
        __asm__ __volatile__("udi7fcm %0,%1," #c : "=r"(a) :  "r"(b))

#define UDI7FCM_GPR_IMM_IMM(a, b, c)                    \
        __asm__ __volatile__("udi7fcm %0," #b "," #c : "=r"(a))

#define UDI7FCM_IMM_GPR_GPR(a, b, c)                    \
        __asm__ __volatile__("udi7fcm " #a ",%0,%1" : : "r"(b), "r"(c))

#define UDI7FCM_IMM_IMM_GPR(a, b, c)                    \
        __asm__ __volatile__("udi7fcm " #a "," #b ",%0" :: "r"(c))

#define UDI7FCM_IMM_IMM_IMM(a, b, c)                    \
        __asm__ __volatile__("udi7fcm " #a "," #b "," #c)


/* /\* udi8fcm *\/ */

#define UDI8FCM_GPR_GPR_GPR(a, b, c)       \
        __asm__ __volatile__("udi8fcm %0,%1,%2" : "=r"(a) :  "r"(b), "r"(c))

#define UDI8FCM_GPR_GPR_IMM(a, b, c)       \
        __asm__ __volatile__("udi8fcm %0,%1," #c : "=r"(a) :  "r"(b))

#define UDI8FCM_GPR_IMM_IMM(a, b, c)       \
        __asm__ __volatile__("udi8fcm %0," #b "," #c : "=r"(a))

#define UDI8FCM_IMM_GPR_GPR(a, b, c)       \
        __asm__ __volatile__("udi8fcm " #a ",%0,%1" : : "r"(b), "r"(c))

#define UDI8FCM_IMM_IMM_GPR(a, b, c)       \
        __asm__ __volatile__("udi8fcm " #a "," #b ",%0" :: "r"(c))

#define UDI8FCM_IMM_IMM_IMM(a, b, c)       \
        __asm__ __volatile__("udi8fcm " #a "," #b "," #c)


/* /\* udi9fcm *\/ */

#define UDI9FCM_GPR_GPR_GPR(a, b, c)       \
        __asm__ __volatile__("udi9fcm %0,%1,%2" : "=r"(a) :  "r"(b), "r"(c))

#define UDI9FCM_GPR_GPR_IMM(a, b, c)       \
        __asm__ __volatile__("udi9fcm %0,%1," #c : "=r"(a) :  "r"(b))

#define UDI9FCM_GPR_IMM_IMM(a, b, c)       \
        __asm__ __volatile__("udi9fcm %0," #b "," #c : "=r"(a))

#define UDI9FCM_IMM_GPR_GPR(a, b, c)       \
        __asm__ __volatile__("udi9fcm " #a ",%0,%1" : : "r"(b), "r"(c))

#define UDI9FCM_IMM_IMM_GPR(a, b, c)       \
        __asm__ __volatile__("udi9fcm " #a "," #b ",%0" :: "r"(c))

#define UDI9FCM_IMM_IMM_IMM(a, b, c)       \
        __asm__ __volatile__("udi9fcm " #a "," #b "," #c)


/* /\* udi10fcm *\/ */

#define UDI10FCM_GPR_GPR_GPR(a, b, c)       \
        __asm__ __volatile__("udi10fcm %0,%1,%2" : "=r"(a) :  "r"(b), "r"(c))

#define UDI10FCM_GPR_GPR_IMM(a, b, c)       \
        __asm__ __volatile__("udi10fcm %0,%1," #c : "=r"(a) :  "r"(b))

#define UDI10FCM_GPR_IMM_IMM(a, b, c)       \
        __asm__ __volatile__("udi10fcm %0," #b "," #c : "=r"(a))

#define UDI10FCM_IMM_GPR_GPR(a, b, c)       \
        __asm__ __volatile__("udi10fcm " #a ",%0,%1" : : "r"(b), "r"(c))

#define UDI10FCM_IMM_IMM_GPR(a, b, c)       \
        __asm__ __volatile__("udi10fcm " #a "," #b ",%0" :: "r"(c))

#define UDI10FCM_IMM_IMM_IMM(a, b, c)       \
        __asm__ __volatile__("udi10fcm " #a "," #b "," #c)


/* /\* udi11fcm *\/ */

#define UDI11FCM_GPR_GPR_GPR(a, b, c)       \
        __asm__ __volatile__("udi11fcm %0,%1,%2" : "=r"(a) :  "r"(b), "r"(c))

#define UDI11FCM_GPR_GPR_IMM(a, b, c)       \
        __asm__ __volatile__("udi11fcm %0,%1," #c : "=r"(a) :  "r"(b))

#define UDI11FCM_GPR_IMM_IMM(a, b, c)       \
        __asm__ __volatile__("udi11fcm %0," #b "," #c : "=r"(a))

#define UDI11FCM_IMM_GPR_GPR(a, b, c)       \
        __asm__ __volatile__("udi11fcm " #a ",%0,%1" : : "r"(b), "r"(c))

#define UDI11FCM_IMM_IMM_GPR(a, b, c)       \
        __asm__ __volatile__("udi11fcm " #a "," #b ",%0" :: "r"(c))

#define UDI11FCM_IMM_IMM_IMM(a, b, c)       \
        __asm__ __volatile__("udi11fcm " #a "," #b "," #c)


/* /\* udi12fcm *\/ */

#define UDI12FCM_GPR_GPR_GPR(a, b, c)       \
        __asm__ __volatile__("udi12fcm %0,%1,%2" : "=r"(a) :  "r"(b), "r"(c))

#define UDI12FCM_GPR_GPR_IMM(a, b, c)       \
        __asm__ __volatile__("udi12fcm %0,%1," #c : "=r"(a) :  "r"(b))

#define UDI12FCM_GPR_IMM_IMM(a, b, c)       \
        __asm__ __volatile__("udi12fcm %0," #b "," #c : "=r"(a))

#define UDI12FCM_IMM_GPR_GPR(a, b, c)       \
        __asm__ __volatile__("udi12fcm " #a ",%0,%1" : : "r"(b), "r"(c))

#define UDI12FCM_IMM_IMM_GPR(a, b, c)       \
        __asm__ __volatile__("udi12fcm " #a "," #b ",%0" :: "r"(c))

#define UDI12FCM_IMM_IMM_IMM(a, b, c)       \
        __asm__ __volatile__("udi12fcm " #a "," #b "," #c)


/* /\* udi13fcm *\/ */

#define UDI13FCM_GPR_GPR_GPR(a, b, c)       \
        __asm__ __volatile__("udi13fcm %0,%1,%2" : "=r"(a) :  "r"(b), "r"(c))

#define UDI13FCM_GPR_GPR_IMM(a, b, c)       \
        __asm__ __volatile__("udi13fcm %0,%1," #c : "=r"(a) :  "r"(b))

#define UDI13FCM_GPR_IMM_IMM(a, b, c)       \
        __asm__ __volatile__("udi13fcm %0," #b "," #c : "=r"(a))

#define UDI13FCM_IMM_GPR_GPR(a, b, c)       \
        __asm__ __volatile__("udi13fcm " #a ",%0,%1" : : "r"(b), "r"(c))

#define UDI13FCM_IMM_IMM_GPR(a, b, c)       \
        __asm__ __volatile__("udi13fcm " #a "," #b ",%0" :: "r"(c))

#define UDI13FCM_IMM_IMM_IMM(a, b, c)       \
        __asm__ __volatile__("udi13fcm " #a "," #b "," #c)


/* /\* udi14fcm *\/ */

#define UDI14FCM_GPR_GPR_GPR(a, b, c)       \
        __asm__ __volatile__("udi14fcm %0,%1,%2" : "=r"(a) :  "r"(b), "r"(c))

#define UDI14FCM_GPR_GPR_IMM(a, b, c)       \
        __asm__ __volatile__("udi14fcm %0,%1," #c : "=r"(a) :  "r"(b))

#define UDI14FCM_GPR_IMM_IMM(a, b, c)       \
        __asm__ __volatile__("udi14fcm %0," #b "," #c : "=r"(a))

#define UDI14FCM_IMM_GPR_GPR(a, b, c)       \
        __asm__ __volatile__("udi14fcm " #a ",%0,%1" : : "r"(b), "r"(c))

#define UDI14FCM_IMM_IMM_GPR(a, b, c)       \
        __asm__ __volatile__("udi14fcm " #a "," #b ",%0" :: "r"(c))

#define UDI14FCM_IMM_IMM_IMM(a, b, c)       \
        __asm__ __volatile__("udi14fcm " #a "," #b "," #c)


/* /\* udi15fcm *\/ */

#define UDI15FCM_GPR_GPR_GPR(a, b, c)       \
        __asm__ __volatile__("udi15fcm %0,%1,%2" : "=r"(a) :  "r"(b), "r"(c))

#define UDI15FCM_GPR_GPR_IMM(a, b, c)       \
        __asm__ __volatile__("udi15fcm %0,%1," #c : "=r"(a) :  "r"(b))

#define UDI15FCM_GPR_IMM_IMM(a, b, c)       \
        __asm__ __volatile__("udi15fcm %0," #b "," #c : "=r"(a))

#define UDI15FCM_IMM_GPR_GPR(a, b, c)       \
        __asm__ __volatile__("udi15fcm " #a ",%0,%1" : : "r"(b), "r"(c))

#define UDI15FCM_IMM_IMM_GPR(a, b, c)       \
        __asm__ __volatile__("udi15fcm " #a "," #b ",%0" :: "r"(c))

#define UDI15FCM_IMM_IMM_IMM(a, b, c)       \
        __asm__ __volatile__("udi15fcm " #a "," #b "," #c)


/************************** APU UDI FCM Level 1 Internal Macros ****************************/

#define UDI0FCMM(a,b,c,FMT)     UDI0FCM ## _ ## FMT(a, b, c)
#define UDI1FCMM(a,b,c,FMT)     UDI1FCM ## _ ## FMT(a, b, c)
#define UDI2FCMM(a,b,c,FMT)     UDI2FCM ## _ ## FMT(a, b, c)
#define UDI3FCMM(a,b,c,FMT)     UDI3FCM ## _ ## FMT(a, b, c)
#define UDI4FCMM(a,b,c,FMT)     UDI4FCM ## _ ## FMT(a, b, c)
#define UDI5FCMM(a,b,c,FMT)     UDI5FCM ## _ ## FMT(a, b, c)
#define UDI6FCMM(a,b,c,FMT)     UDI6FCM ## _ ## FMT(a, b, c)
#define UDI7FCMM(a,b,c,FMT)     UDI7FCM ## _ ## FMT(a, b, c)

#define UDI8FCMM(a,b,c,FMT)     UDI8FCM ## _ ## FMT(a, b, c)
#define UDI9FCMM(a,b,c,FMT)     UDI9FCM ## _ ## FMT(a, b, c)
#define UDI10FCMM(a,b,c,FMT)    UDI10FCM ## _ ## FMT(a, b, c)
#define UDI11FCMM(a,b,c,FMT)    UDI11FCM ## _ ## FMT(a, b, c)
#define UDI12FCMM(a,b,c,FMT)    UDI12FCM ## _ ## FMT(a, b, c)
#define UDI13FCMM(a,b,c,FMT)    UDI13FCM ## _ ## FMT(a, b, c)
#define UDI14FCMM(a,b,c,FMT)    UDI14FCM ## _ ## FMT(a, b, c)
#define UDI15FCMM(a,b,c,FMT)    UDI15FCM ## _ ## FMT(a, b, c)


#define UDI0FCMCRM(a,b,c,FMT)     UDI0FCMCR ## _ ## FMT(a, b, c)
#define UDI1FCMCRM(a,b,c,FMT)     UDI1FCMCR ## _ ## FMT(a, b, c)
#define UDI2FCMCRM(a,b,c,FMT)     UDI2FCMCR ## _ ## FMT(a, b, c)
#define UDI3FCMCRM(a,b,c,FMT)     UDI3FCMCR ## _ ## FMT(a, b, c)
#define UDI4FCMCRM(a,b,c,FMT)     UDI4FCMCR ## _ ## FMT(a, b, c)
#define UDI5FCMCRM(a,b,c,FMT)     UDI5FCMCR ## _ ## FMT(a, b, c)
#define UDI6FCMCRM(a,b,c,FMT)     UDI6FCMCR ## _ ## FMT(a, b, c)
#define UDI7FCMCRM(a,b,c,FMT)     UDI7FCMCR ## _ ## FMT(a, b, c)

#define UDI8FCMCRM(a,b,c,FMT)     UDI8FCMCR ## _ ## FMT(a, b, c)
#define UDI9FCMCRM(a,b,c,FMT)     UDI9FCMCR ## _ ## FMT(a, b, c)
#define UDI10FCMCRM(a,b,c,FMT)    UDI10FCMCR ## _ ## FMT(a, b, c)
#define UDI11FCMCRM(a,b,c,FMT)    UDI11FCMCR ## _ ## FMT(a, b, c)
#define UDI12FCMCRM(a,b,c,FMT)    UDI12FCMCR ## _ ## FMT(a, b, c)
#define UDI13FCMCRM(a,b,c,FMT)    UDI13FCMCR ## _ ## FMT(a, b, c)
#define UDI14FCMCRM(a,b,c,FMT)    UDI14FCMCR ## _ ## FMT(a, b, c)
#define UDI15FCMCRM(a,b,c,FMT)    UDI15FCMCR ## _ ## FMT(a, b, c)

/************************** APU FCM UDI Macros ****************************/

/************************** UDIFCM Macros ****************************/
#define UDI0FCM(a, b, c, FMT)   UDI0FCMM(a, b, c, FMT)
#define UDI1FCM(a, b, c, FMT)   UDI1FCMM(a, b, c, FMT)
#define UDI2FCM(a, b, c, FMT)   UDI2FCMM(a, b, c, FMT)
#define UDI3FCM(a, b, c, FMT)   UDI3FCMM(a, b, c, FMT)
#define UDI4FCM(a, b, c, FMT)   UDI4FCMM(a, b, c, FMT)
#define UDI5FCM(a, b, c, FMT)   UDI5FCMM(a, b, c, FMT)
#define UDI6FCM(a, b, c, FMT)   UDI6FCMM(a, b, c, FMT)
#define UDI7FCM(a, b, c, FMT)   UDI7FCMM(a, b, c, FMT)

#define UDI8FCM(a, b, c, FMT)   UDI8FCMM(a, b, c, FMT)
#define UDI9FCM(a, b, c, FMT)   UDI9FCMM(a, b, c, FMT)
#define UDI10FCM(a, b, c, FMT)  UDI10FCMM(a, b, c, FMT)
#define UDI11FCM(a, b, c, FMT)  UDI11FCMM(a, b, c, FMT)
#define UDI12FCM(a, b, c, FMT)  UDI12FCMM(a, b, c, FMT)
#define UDI13FCM(a, b, c, FMT)  UDI13FCMM(a, b, c, FMT)
#define UDI14FCM(a, b, c, FMT)  UDI14FCMM(a, b, c, FMT)
#define UDI15FCM(a, b, c, FMT)  UDI15FCMM(a, b, c, FMT)


/************************** UDIFCMCR Macros ****************************/
#define UDI0FCMCR(a, b, c, FMT)   UDI0FCMCRM(a, b, c, FMT)
#define UDI1FCMCR(a, b, c, FMT)   UDI1FCMCRM(a, b, c, FMT)
#define UDI2FCMCR(a, b, c, FMT)   UDI2FCMCRM(a, b, c, FMT)
#define UDI3FCMCR(a, b, c, FMT)   UDI3FCMCRM(a, b, c, FMT)
#define UDI4FCMCR(a, b, c, FMT)   UDI4FCMCRM(a, b, c, FMT)
#define UDI5FCMCR(a, b, c, FMT)   UDI5FCMCRM(a, b, c, FMT)
#define UDI6FCMCR(a, b, c, FMT)   UDI6FCMCRM(a, b, c, FMT)
#define UDI7FCMCR(a, b, c, FMT)   UDI7FCMCRM(a, b, c, FMT)

#define UDI8FCMCR(a, b, c, FMT)   UDI8FCMCRM(a, b, c, FMT)
#define UDI9FCMCR(a, b, c, FMT)   UDI9FCMCRM(a, b, c, FMT)
#define UDI10FCMCR(a, b, c, FMT)  UDI10FCMCRM(a, b, c, FMT)
#define UDI11FCMCR(a, b, c, FMT)  UDI11FCMCRM(a, b, c, FMT)
#define UDI12FCMCR(a, b, c, FMT)  UDI12FCMCRM(a, b, c, FMT)
#define UDI13FCMCR(a, b, c, FMT)  UDI13FCMCRM(a, b, c, FMT)
#define UDI14FCMCR(a, b, c, FMT)  UDI14FCMCRM(a, b, c, FMT)
#define UDI15FCMCR(a, b, c, FMT)  UDI15FCMCRM(a, b, c, FMT)

/************************** Format specifiers for APU UDI FCM macros ****************************/

#define FMT_GPR_GPR_GPR         GPR_GPR_GPR
#define FMT_GPR_GPR_IMM         GPR_GPR_IMM
#define FMT_GPR_IMM_IMM         GPR_IMM_IMM
#define FMT_IMM_GPR_GPR         IMM_GPR_GPR
#define FMT_IMM_IMM_GPR         IMM_IMM_GPR
#define FMT_IMM_IMM_IMM         IMM_IMM_IMM

/*************************************************************************************/

/* End APU UDI macros */

/************************** Variable Definitions ****************************/

/************************** Function Prototypes *****************************/
#ifdef __cplusplus
}
#endif

#endif

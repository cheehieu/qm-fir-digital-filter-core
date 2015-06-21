/* $Id: xreg440.h,v 1.1.4.1 2009/03/19 19:16:43 moleres Exp $ */
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
* @file xreg440.h
*
* This header file contains definitions for using inline assembler code. It is
* written specifically for the GNU compiler.
*
* All of the PPC440 GPR's, SPR's, Timers, Core Configuration Registers, and
* Debug Registers are defined along with the positions of the bits within each
* register.
*
*
* <pre>
* MODIFICATION HISTORY:
*
* Ver   Who  Date     Changes
* ----- ---- -------- -------------------------------------------------------
* 1.00a ecm  10/18/07 moved over from standalone bsp and updated to standards
* </pre>
*
******************************************************************************/

#ifndef XREG440_H
#define XREG440_H

#ifdef __cplusplus
extern "C" {
#endif

/* General Purpose Registers */
#define XREG_GPR0                           r0
#define XREG_GPR1                           r1
#define XREG_GPR2                           r2
#define XREG_GPR3                           r3
#define XREG_GPR4                           r4
#define XREG_GPR5                           r5
#define XREG_GPR6                           r6
#define XREG_GPR7                           r7
#define XREG_GPR8                           r8
#define XREG_GPR9                           r9
#define XREG_GPR10                          r10
#define XREG_GPR11                          r11
#define XREG_GPR12                          r12
#define XREG_GPR13                          r13
#define XREG_GPR14                          r14
#define XREG_GPR15                          r15
#define XREG_GPR16                          r16
#define XREG_GPR17                          r17
#define XREG_GPR18                          r18
#define XREG_GPR19                          r19
#define XREG_GPR20                          r20
#define XREG_GPR21                          r21
#define XREG_GPR22                          r22
#define XREG_GPR23                          r23
#define XREG_GPR24                          r24
#define XREG_GPR25                          r25
#define XREG_GPR26                          r26
#define XREG_GPR27                          r27
#define XREG_GPR28                          r28
#define XREG_GPR29                          r29
#define XREG_GPR30                          r30
#define XREG_GPR31                          r31

/* Special Purpose Registers */
#define XREG_SPR_CSRR0                      0x03a
#define XREG_SPR_CSRR1                      0x03b
#define XREG_SPR_CTR                        0x009
#define XREG_SPR_DAC1                       0x13c
#define XREG_SPR_DAC2                       0x13d
#define XREG_SPR_DBCR0                      0x134
#define XREG_SPR_DBCR1                      0x135
#define XREG_SPR_DBCR2                      0x136
#define XREG_SPR_DBDR                       0x3f3
#define XREG_SPR_DBSR                       0x130
#define XREG_SPR_DCDBTRH                    0x39d
#define XREG_SPR_DCDBTRL                    0x39c
#define XREG_SPR_DEAR                       0x03d
#define XREG_SPR_DNV0                       0x390
#define XREG_SPR_DNV1                       0x391
#define XREG_SPR_DNV2                       0x392
#define XREG_SPR_DNV3                       0x393
#define XREG_SPR_DTV0                       0x394
#define XREG_SPR_DTV1                       0x395
#define XREG_SPR_DTV2                       0x396
#define XREG_SPR_DTV3                       0x397
#define XREG_SPR_DVC1                       0x13e
#define XREG_SPR_DVC2                       0x13f
#define XREG_SPR_DVLIM                      0x398
#define XREG_SPR_ESR                        0x03e
#define XREG_SPR_IAC1                       0x138
#define XREG_SPR_IAC2                       0x139
#define XREG_SPR_IAC3                       0x13a
#define XREG_SPR_IAC4                       0x13b
#define XREG_SPR_ICDBDR                     0x3d3
#define XREG_SPR_ICDBTRH                    0x39f
#define XREG_SPR_ICDBTRL                    0x39e
#define XREG_SPR_INV0                       0x370
#define XREG_SPR_INV1                       0x371
#define XREG_SPR_INV2                       0x372
#define XREG_SPR_INV3                       0x373
#define XREG_SPR_ITV0                       0x374
#define XREG_SPR_ITV1                       0x375
#define XREG_SPR_ITV2                       0x376
#define XREG_SPR_ITV3                       0x377
#define XREG_SPR_IVLIM                      0x399
#define XREG_SPR_IVOR0                      0x190
#define XREG_SPR_IVOR1                      0x191
#define XREG_SPR_IVOR2                      0x192
#define XREG_SPR_IVOR3                      0x193
#define XREG_SPR_IVOR4                      0x194
#define XREG_SPR_IVOR5                      0x195
#define XREG_SPR_IVOR6                      0x196
#define XREG_SPR_IVOR7                      0x197
#define XREG_SPR_IVOR8                      0x198
#define XREG_SPR_IVOR9                      0x199
#define XREG_SPR_IVOR10                     0x19a
#define XREG_SPR_IVOR11                     0x19b
#define XREG_SPR_IVOR12                     0x19c
#define XREG_SPR_IVOR13                     0x19d
#define XREG_SPR_IVOR14                     0x19e
#define XREG_SPR_IVOR15                     0x19f
#define XREG_SPR_MCSR                       0x23c
#define XREG_SPR_MCSRR0                     0x23a
#define XREG_SPR_MCSRR1                     0x23b
#define XREG_SPR_LR                         0x008
#define XREG_SPR_PID                        0x030
#define XREG_SPR_PVR                        0x11f
#define XREG_SPR_SPRG0_SU                   0x110
#define XREG_SPR_SPRG1_SU                   0x111
#define XREG_SPR_SPRG2_SU                   0x112
#define XREG_SPR_SPRG3_SU                   0x113
#define XREG_SPR_SPRG4_SU                   0x114
#define XREG_SPR_SPRG5_SU                   0x115
#define XREG_SPR_SPRG6_SU                   0x116
#define XREG_SPR_SPRG7_SU                   0x117
#define XREG_SPR_SPRG4_U                    0x104
#define XREG_SPR_SPRG5_U                    0x105
#define XREG_SPR_SPRG6_U                    0x106
#define XREG_SPR_SPRG7_U                    0x107
#define XREG_SPR_SRR0                       0x01a
#define XREG_SPR_SRR1                       0x01b
#define XREG_SPR_TBL_READ                   0x10c
#define XREG_SPR_TBU_READ                   0x10d
#define XREG_SPR_TBL_WRITE                  0x11c
#define XREG_SPR_TBU_WRITE                  0x11d
#define XREG_SPR_TSR                        0x150
#define XREG_SPR_TCR                        0x154
#define XREG_SPR_DEC                        0x016
#define XREG_SPR_DECAR                      0x036
#define XREG_SPR_CCR0                       0x3b3
#define XREG_SPR_CCR1                       0x378
#define XREG_SPR_IVPR                       0x03f
#define XREG_SPR_MMUCR                      0x3b2
#define XREG_SPR_PIR                        0x11e
#define XREG_SPR_RSTCFG                     0x39b
#define XREG_SPR_USPRG0                     0x100
#define XREG_SPR_XER                        0x001

/* Machine Status Register (MSR) Bits */
#define XREG_MSR_WAIT_STATE_ENABLE              0x00040000
#define XREG_MSR_CRITICAL_INTERRUPT_ENABLE      0x00020000
#define XREG_MSR_NON_CRITICAL_INTERRUPT_ENABLE  0x00008000
#define XREG_MSR_USER_MODE                      0x00004000
#define XREG_MSR_MACHINE_CHECK_ENABLE           0x00001000
#define XREG_MSR_FLOATING_POINT_EXCEPTION_MODE0 0x00000800
#define XREG_MSR_DEBUG_WAIT_ENABLE              0x00000400
#define XREG_MSR_DEBUG_INTERRUPT_ENABLE         0x00000200
#define XREG_MSR_FLOATING_POINT_EXCEPTION_MODE1 0x00000100
#define XREG_MSR_TLB_INSTRUCTION_TS             0x00000020
#define XREG_MSR_TLB_DATA_TS                    0x00000010

/* Timer Control Register (TCR) Bits */
#define XREG_TCR_WDT_INTERRUPT_ENABLE           0x08000000
#define XREG_TCR_DEC_INTERRUPT_ENABLE           0x04000000
#define XREG_TCR_FIT_INTERRUPT_ENABLE           0x00800000
#define XREG_TCR_AUTORELOAD_ENABLE              0x00400000

/* WTD Timer Period Settings (note: intervals different from 405) */
#define XREG_TCR_WDT_PERIOD_11                  0xc0000000
#define XREG_TCR_WDT_PERIOD_10                  0x80000000
#define XREG_TCR_WDT_PERIOD_01                  0x40000000
#define XREG_TCR_WDT_PERIOD_00                  0x00000000

/* WTD Reset Control Settings */
#define XREG_TCR_WDT_RESET_CONTROL_11           0x30000000
#define XREG_TCR_WDT_RESET_CONTROL_10           0x20000000
#define XREG_TCR_WDT_RESET_CONTROL_01           0x10000000
#define XREG_TCR_WDT_RESET_CONTROL_00           0x00000000

/* FIT Timer Period Settings (note: intervals different from 405) */
#define XREG_TCR_FIT_PERIOD_11                  0x03000000
#define XREG_TCR_FIT_PERIOD_10                  0x02000000
#define XREG_TCR_FIT_PERIOD_01                  0x01000000
#define XREG_TCR_FIT_PERIOD_00                  0x00000000

/* Timer Status Register (TSR) Bits */
#define XREG_TSR_WDT_ENABLE_NEXT_WATCHDOG       0x80000000
#define XREG_TSR_WDT_INTERRUPT_STATUS           0x40000000
#define XREG_TSR_WDT_RESET_STATUS_11            0x30000000
#define XREG_TSR_WDT_RESET_STATUS_10            0x20000000
#define XREG_TSR_WDT_RESET_STATUS_01            0x10000000
#define XREG_TSR_WDT_RESET_STATUS_00            0x00000000
#define XREG_TSR_DEC_INTERRUPT_STATUS           0x08000000
#define XREG_TSR_FIT_INTERRUPT_STATUS           0x04000000
#define XREG_TSR_CLEAR_ALL                      0xffffffff

/* Core-Configuration Register (CCR0) Bits */
#define XREG_CCR0_DISABLE_STORE_GATHERING       0x00200000
#define XREG_CCR0_DISABLE_APU_INSTR_BROADCAST   0x00100000
#define XREG_CCR0_DISABLE_TRACE_BROADCAST       0x00008000
#define XREG_CCR0_GUARANTEE_ICACHE_LINE_FILL    0x00004000
#define XREG_CCR0_GUARANTEE_DCACHE_LINE_FILL    0x00002000
#define XREG_CCR0_FORCE_LOAD_STORE_ALIGN        0x00000100
#define XREG_CCR0_DISABLE_BTAC                  0x00000040
#define XREG_CCR0_ICACHE_SPEC_LINE_COUNT_3      0x0000000C
#define XREG_CCR0_ICACHE_SPEC_LINE_COUNT_2      0x00000008
#define XREG_CCR0_ICACHE_SPEC_LINE_COUNT_1      0x00000004
#define XREG_CCR0_ICACHE_SPEC_LINE_COUNT_0      0x00000000
#define XREG_CCR0_ICACHE_SPEC_LINE_THRESH_3     0x00000003
#define XREG_CCR0_ICACHE_SPEC_LINE_THRESH_2     0x00000002
#define XREG_CCR0_ICACHE_SPEC_LINE_THRESH_1     0x00000001
#define XREG_CCR0_ICACHE_SPEC_LINE_THRESH_0     0x00000000

/* Debug Control Register 0 Bits */
#define XREG_DBCR0_EXTERNAL_DEBUG_MODE          0x80000000
#define XREG_DBCR0_INTERNAL_DEBUG_MODE          0x40000000
#define XREG_DBCR0_CORE_RESET                   0x10000000
#define XREG_DBCR0_CHIP_RESET                   0x20000000
#define XREG_DBCR0_SYSTEM_RESET                 0x30000000
#define XREG_DBCR0_INSTR_COMPLETE_EVENT         0x08000000
#define XREG_DBCR0_BRANCH_TAKEN_EVENT           0x04000000
#define XREG_DBCR0_INTERRUPT_EVENT              0x02000000
#define XREG_DBCR0_TRAP_EVENT                   0x01000000
#define XREG_DBCR0_IAC1_EVENT                   0x00800000
#define XREG_DBCR0_IAC2_EVENT                   0x00400000
#define XREG_DBCR0_IAC3_EVENT                   0x00200000
#define XREG_DBCR0_IAC4_EVENT                   0x00100000
#define XREG_DBCR0_DAC1_READ_EVENT              0x00080000
#define XREG_DBCR0_DAC1_WRITE_EVENT             0x00040000
#define XREG_DBCR0_DAC2_READ_EVENT              0x00020000
#define XREG_DBCR0_DAC2_WRITE_EVENT             0x00010000
#define XREG_DBCR0_RETURN_EVENT                 0x00008000
#define XREG_DBCR0_FREEZE_TIMERS_EVENT          0x00000001

#ifdef __cplusplus
}
#endif

#endif

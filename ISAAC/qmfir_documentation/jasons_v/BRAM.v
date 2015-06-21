/*******************************************************************************
*     This file is owned and controlled by Xilinx and must be used             *
*     solely for design, simulation, implementation and creation of            *
*     design files limited to Xilinx devices or technologies. Use              *
*     with non-Xilinx devices or technologies is expressly prohibited          *
*     and immediately terminates your license.                                 *
*                                                                              *
*     XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"            *
*     SOLELY FOR USE IN DEVELOPING PROGRAMS AND SOLUTIONS FOR                  *
*     XILINX DEVICES.  BY PROVIDING THIS DESIGN, CODE, OR INFORMATION          *
*     AS ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE, APPLICATION              *
*     OR STANDARD, XILINX IS MAKING NO REPRESENTATION THAT THIS                *
*     IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT,                  *
*     AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE         *
*     FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY DISCLAIMS ANY                 *
*     WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE                  *
*     IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR           *
*     REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF          *
*     INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS          *
*     FOR A PARTICULAR PURPOSE.                                                *
*                                                                              *
*     Xilinx products are not intended for use in life support                 *
*     appliances, devices, or systems. Use in such applications are            *
*     expressly prohibited.                                                    *
*                                                                              *
*     (c) Copyright 1995-2007 Xilinx, Inc.                                     *
*     All rights reserved.                                                     *
*******************************************************************************/
// The synthesis directives "translate_off/translate_on" specified below are
// supported by Xilinx, Mentor Graphics and Synplicity synthesis
// tools. Ensure they are correct for your synthesis tool(s).

// You must compile the wrapper file BRAM.v when simulating
// the core, BRAM. When compiling the wrapper file, be sure to
// reference the XilinxCoreLib Verilog simulation library. For detailed
// instructions, please refer to the "CORE Generator Help".

`timescale 1ns/1ps

module BRAM(
	clka,
	dina,
	addra,
	wea,
	clkb,
	addrb,
	doutb);


input clka;
input [31 : 0] dina;
input [6 : 0] addra;
input [0 : 0] wea;
input clkb;
input [6 : 0] addrb;
output [31 : 0] doutb;

// synthesis translate_off

      BLK_MEM_GEN_V2_8 #(
		.C_ADDRA_WIDTH(7),
		.C_ADDRB_WIDTH(7),
		.C_ALGORITHM(1),
		.C_BYTE_SIZE(9),
		.C_COMMON_CLK(0),
		.C_DEFAULT_DATA("0"),
		.C_DISABLE_WARN_BHV_COLL(0),
		.C_DISABLE_WARN_BHV_RANGE(0),
		.C_FAMILY("virtex2"),
		.C_HAS_ENA(0),
		.C_HAS_ENB(0),
		.C_HAS_MEM_OUTPUT_REGS_A(0),
		.C_HAS_MEM_OUTPUT_REGS_B(0),
		.C_HAS_MUX_OUTPUT_REGS_A(0),
		.C_HAS_MUX_OUTPUT_REGS_B(0),
		.C_HAS_REGCEA(0),
		.C_HAS_REGCEB(0),
		.C_HAS_SSRA(0),
		.C_HAS_SSRB(0),
		.C_INIT_FILE_NAME("no_coe_file_loaded"),
		.C_LOAD_INIT_FILE(0),
		.C_MEM_TYPE(1),
		.C_MUX_PIPELINE_STAGES(0),
		.C_PRIM_TYPE(1),
		.C_READ_DEPTH_A(100),
		.C_READ_DEPTH_B(100),
		.C_READ_WIDTH_A(32),
		.C_READ_WIDTH_B(32),
		.C_SIM_COLLISION_CHECK("ALL"),
		.C_SINITA_VAL("0"),
		.C_SINITB_VAL("0"),
		.C_USE_BYTE_WEA(0),
		.C_USE_BYTE_WEB(0),
		.C_USE_DEFAULT_DATA(0),
		.C_USE_ECC(0),
		.C_USE_RAMB16BWER_RST_BHV(0),
		.C_WEA_WIDTH(1),
		.C_WEB_WIDTH(1),
		.C_WRITE_DEPTH_A(100),
		.C_WRITE_DEPTH_B(100),
		.C_WRITE_MODE_A("READ_FIRST"),
		.C_WRITE_MODE_B("READ_FIRST"),
		.C_WRITE_WIDTH_A(32),
		.C_WRITE_WIDTH_B(32),
		.C_XDEVICEFAMILY("virtex2"))
	inst (
		.CLKA(clka),
		.DINA(dina),
		.ADDRA(addra),
		.WEA(wea),
		.CLKB(clkb),
		.ADDRB(addrb),
		.DOUTB(doutb),
		.ENA(),
		.REGCEA(),
		.SSRA(),
		.DOUTA(),
		.DINB(),
		.ENB(),
		.REGCEB(),
		.WEB(),
		.SSRB(),
		.DBITERR(),
		.SBITERR());


// synthesis translate_on

// XST black box declaration
// box_type "black_box"
// synthesis attribute box_type of BRAM is "black_box"

endmodule


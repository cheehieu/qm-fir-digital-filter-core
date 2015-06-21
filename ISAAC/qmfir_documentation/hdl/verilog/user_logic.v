// ******************************************************************************* //
// **                    General Information                                    ** //
// ******************************************************************************* //
// **  Module             : user_logic.v                                        ** //
// **  Project            : ISAAC NEWTON                                        ** //
// **  Author             : Kayla Nguyen                                        ** //
// **  First Release Date : August 13, 2008                                     ** //
// **  Description        : Newton Core                                         ** //
// ******************************************************************************* //
// **                     Revision History                                      ** //
// ******************************************************************************* //
// **                                                                           ** //
// **  File        : newton.v                                                   ** //
// **  Revision    : 1                                                          ** //
// **  Author      : kaylangu                                                   ** //
// **  Date        : August 13, 2008                                            ** //
// **  FileName    :                                                            ** //
// **  Notes       : Initial Release for ISAAC demo                             ** //
// **                                                                           ** //
// **  File        : newton.v                                                   ** //
// **  Revision    : 2                                                          ** //
// **  Author      : kaylangu                                                   ** //
// **  Date        : August 19, 2008                                            ** //
// **  FileName    :                                                            ** //
// **  Notes       : 1. Remove temp signal                                      ** //
// **                2. Bit ReOrdering function change to for loop              ** //
// **                3. Modify IP2Bus_Data_int mux logic                        ** //
// **                4. Modify IP2Bus_WrAck to include WrAck from BRAM          ** //
// **                                                                           ** //
// **  File        : user_logic.v                                               ** //
// **  Revision    : 3                                                          ** //
// **  Author      : kaylangu                                                   ** //
// **  Date        : August 21, 2008                                            ** //
// **  FileName    :                                                            ** //
// **  Notes       : 1. Changed file name to user_logic.v to match EDK          ** //
// **                                                                           ** //
// **  File        : user_logic.v                                               ** //
// **  Revision    : 4                                                          ** //
// **  Author      : kaylangu                                                   ** //
// **  Date        : August 23, 2008                                            ** //
// **  FileName    :                                                            ** //
// **  Notes       : 1. changed the six 16-bit BRAM to three 32-bit wide BRAM   ** //
// **                                                                           ** //
// **  File        : user_logic.v                                               ** //
// **  Revision    : 5                                                          ** //
// **  Author      : kaylangu                                                   ** //
// **  Date        : September 2, 2008                                          ** //
// **  FileName    :                                                            ** //
// **  Notes       : 1. Un-ReOrder the bits                                     ** //
// **                2. Change address of BRAM to Bus2IP_Addr[20:29]            ** //
// **                3. Fix ordering of input and output signals to match EDK   ** //
// **                4. RAM2IP_RdAck changed to one clock pulse                 ** //
// **                5. Delay CS signal to output data when RdAck is high       ** //
// **                                                                           ** //
// ******************************************************************************* //
`timescale 1 ns / 100 ps

module user_logic
  (Bus2IP_Clk,         
   Bus2IP_Reset,        
   Bus2IP_Addr,         
   Bus2IP_CS,           
   Bus2IP_RNW,          
   Bus2IP_Data,         
   Bus2IP_BE,           
   Bus2IP_RdCE,         
   Bus2IP_WrCE,         
   IP2Bus_Data,         
   IP2Bus_RdAck,        
   IP2Bus_WrAck,        
   IP2Bus_Error,        
   IP2Bus_IntrEvent,    
   IP2WFIFO_RdReq,
	IP2WFIFO_RdMark,                // IP to WFIFO : mark beginning of packet being read
	IP2WFIFO_RdRelease,             // IP to WFIFO : return WFIFO to normal FIFO operation
	IP2WFIFO_RdRestore,             // IP to WFIFO : restore the WFIFO to the last packet mark	
   WFIFO2IP_Data,      
   WFIFO2IP_RdAck,      
   WFIFO2IP_AlmostEmpty,
   WFIFO2IP_Empty,    
	WFIFO2IP_Occupancy              // WFIFO to IP : WFIFO occupancy	
   );
   
   
   //**************************************************************************//
   //*                         Declarations                                   *//
   //**************************************************************************//
   // DATA TYPE - PARAMETERS
   parameter C_SLV_AWIDTH                   = 32;  
   parameter C_SLV_DWIDTH                   = 32;
   parameter C_NUM_REG                      = 4;
   parameter C_NUM_MEM                      = 3;
   parameter C_NUM_INTR                     = 1;
   
   // DATA TYPE - INPUTS AND OUTPUTS
   input                                     Bus2IP_Clk;           // Bus to IP clock  
   input                                     Bus2IP_Reset;         // Bus to IP reset 
   input [0 : C_SLV_AWIDTH-1]                Bus2IP_Addr;          // Bus to IP address bus   
   input [0 : C_NUM_MEM-1]                   Bus2IP_CS;            // Bus to IP chip select for user logic memory selection
   input                                     Bus2IP_RNW;           // Bus to IP read/not write 
   input [0 : C_SLV_DWIDTH-1]                Bus2IP_Data;          // Bus to IP data bus  
   input [0 : C_SLV_DWIDTH/8-1]              Bus2IP_BE;            // Bus to IP byte enables  
   input [0 : C_NUM_REG-1]                   Bus2IP_RdCE;          // Bus to IP read chip enable  
   input [0 : C_NUM_REG-1]                   Bus2IP_WrCE;          // Bus to IP write chip enable       
   output [0 : C_SLV_DWIDTH-1]               IP2Bus_Data;          // IP to Bus data bus       
   output                                    IP2Bus_RdAck;         // IP to Bus read transfer acknowledgement        
   output                                    IP2Bus_WrAck;         // IP to Bus write transfer acknowledgement  
   output                                    IP2Bus_Error;         // IP to Bus error response    
   output [0 : C_NUM_INTR-1]                 IP2Bus_IntrEvent;     // IP to Bus interrupt event  
   output                                    IP2WFIFO_RdReq;       // IP to WFIFO : IP read request
	output                                    IP2WFIFO_RdMark;
	output                                    IP2WFIFO_RdRelease;
	output                                    IP2WFIFO_RdRestore;	
   input [0 : C_SLV_DWIDTH-1]                WFIFO2IP_Data;        // WFIFO to IP : WFIFO read data  
   input                                     WFIFO2IP_RdAck;       // WFIFO to IP : WFIFO read acknowledge
   input                                     WFIFO2IP_AlmostEmpty; // WFIFO to IP : WFIFO almost empty 
   input                                     WFIFO2IP_Empty;       // WFIFO to IP : WFIFO empty
	input      [0 : 9]                        WFIFO2IP_Occupancy;

   // DATA TYPE - WIRES   
   wire [9:0]                                CPTR;      // Pointer to BRAM Address
   wire                                      SYNC;
   
   wire [15:0]                               RealOut1;
   wire [15:0]                               ImagOut1;
   wire [15:0]                               RealOut2;
   wire [15:0]                               ImagOut2;
   wire [15:0]                               RealOut3;
   wire [15:0]                               ImagOut3;
   wire                                      FIR_WE;
   
   wire [0:C_NUM_MEM-1]                      RAM_WE;
   wire                                      iReg2IP_RdAck;
   wire                                      iReg2IP_WrAck;
   wire                                      RAM2IP_WrAck;
   wire [10:0]                               CPTR_1;

   // For bit reordering
   wire [31:0]                               Bus2IP_Data_int;
   wire [31:0]                               WFIFO2IP_Data_int;
   wire [31:0]                               iReg2IP_Data_int;
   wire [0:31]                               iReg2IP_Data;
   

   wire [31:0]                               RAM2IP_Data_int;  // Data from BRAM 
   wire [31:0]                               RAM2IP_Data_int0; // Data from BRAM0
   wire [31:0]                               RAM2IP_Data_int1; // Data from BRAM1
   wire [31:0]                               RAM2IP_Data_int2; // Data from BRAM2
   
   // DATA TYPE - REG
   wire 				     RAM2IP_RdAck_int;
   reg 					     RAM2IP_RdAck_dly1;
   wire 				     RAM2IP_RdAck;
   reg [31:0] 				     IP2Bus_Data_int;
   reg [0:3] 				     Bus2IP_CS_dly1;
      

   //**************************************************************************//
   //*                     Bit ReOrdering                                     *//
   //**************************************************************************//
   assign Bus2IP_Data_int[31:0]   = fnBitReordering031to310(Bus2IP_Data[0:31]);
   assign WFIFO2IP_Data_int[31:0] = fnBitReordering031to310(WFIFO2IP_Data[0:31]);
   assign iReg2IP_Data_int[31:0]  = fnBitReordering031to310(iReg2IP_Data[0:31]);

   assign IP2Bus_Data[0:31]       = fnBitReordering310to031(IP2Bus_Data_int[31:0]);

   
   //**************************************************************************//
   //*                       BRAM Logic                                       *//
   //**************************************************************************//
   // WRITE 
   assign RAM_WE[0:C_NUM_MEM-1] = Bus2IP_CS[0:C_NUM_MEM-1]&{(C_NUM_MEM){~Bus2IP_RNW}};

   // READ
//   always @ (posedge Bus2IP_Clk or posedge Bus2IP_Reset)     
//     if (Bus2IP_Reset !== 1'b0)                                 
//       RAM2IP_RdAck <= 1'b0;                                 
//     else                                                    
   assign RAM2IP_RdAck_int = |Bus2IP_CS[0:C_NUM_MEM-1] & Bus2IP_RNW;

   always @ (posedge Bus2IP_Clk or posedge Bus2IP_Reset)
     if (Bus2IP_Reset !== 0)
       RAM2IP_RdAck_dly1 <= 1'b0;
     else
       RAM2IP_RdAck_dly1 <= RAM2IP_RdAck_int;

   assign RAM2IP_RdAck = RAM2IP_RdAck_int & RAM2IP_RdAck_dly1;
      
   assign RAM2IP_WrAck = |RAM_WE[0:C_NUM_MEM-1];

   always @ (posedge Bus2IP_Clk or posedge Bus2IP_Reset)
     if (Bus2IP_Reset !== 1'b0)
       Bus2IP_CS_dly1[0:2] <= 3'b000;
     else
       Bus2IP_CS_dly1[0:2] <= Bus2IP_CS[0:2];
   
   assign RAM2IP_Data_int[31:0] = RAM2IP_Data_int0[31:0] & {(32){Bus2IP_CS_dly1[0]}} |
                                  RAM2IP_Data_int1[31:0] & {(32){Bus2IP_CS_dly1[1]}} |
                                  RAM2IP_Data_int2[31:0] & {(32){Bus2IP_CS_dly1[2]}} ;

   
   //**************************************************************************//
   //*                          Outputs                                       *//
   //**************************************************************************//
   assign IP2WFIFO_RdReq   = ~WFIFO2IP_Empty;
   assign CPTR[9:0]        = CPTR_1[9:0];  // Choosing bits 9:0 to output to BRAM

   always @ (/*AS*/RAM2IP_Data_int or RAM2IP_RdAck or iReg2IP_Data_int
	     or iReg2IP_RdAck)
     begin
        if (RAM2IP_RdAck)
          IP2Bus_Data_int[31:0] = RAM2IP_Data_int[31:0];
        else if (iReg2IP_RdAck)
          IP2Bus_Data_int[31:0] = iReg2IP_Data_int[31:0];
        else
          IP2Bus_Data_int[31:0] = 32'd0;
     end

   assign IP2Bus_RdAck     = RAM2IP_RdAck | iReg2IP_RdAck;
   assign IP2Bus_WrAck     = RAM2IP_WrAck | iReg2IP_WrAck;

   assign IP2Bus_Error     = iReg2IP_RdAck & RAM2IP_RdAck;
   

   //**************************************************************************//
   //*                         Submodules                                     *//
   //**************************************************************************//
   iReg iReg
     (//Inputs
      .Bus2IP_Clk    (Bus2IP_Clk),
      .Bus2IP_Reset  (Bus2IP_Reset),
      .Bus2IP_RdCE   (Bus2IP_RdCE[0:3]),
      .Bus2IP_WrCE   (Bus2IP_WrCE[0:3]),
      .Bus2IP_Data   (Bus2IP_Data[0:C_SLV_DWIDTH-1]),    
      .WFIFO_WE      (WFIFO2IP_RdAck),
      .FIR_WE        (FIR_WE),
      //Outputs
      .iReg_intr     (IP2Bus_IntrEvent),
      .iReg2IP_RdAck (iReg2IP_RdAck),
      .IP2Bus_WrAck  (iReg2IP_WrAck),
      .IP2Bus_Data   (iReg2IP_Data[0:C_SLV_DWIDTH-1]), 
      .CPTR          (CPTR_1[10:0]),       
      .SYNC          (SYNC)
      );

   QM_FIR QM_FIR
     (//Inputs
      .CLK           (Bus2IP_Clk),
      .ARST          (Bus2IP_Reset),
      .Constant      (WFIFO2IP_Data_int[15:0]), //using lower 16 bits
      .InputValid    (WFIFO2IP_RdAck),
      .Sync          (SYNC),
      //Outputs
      .RealOut1      (RealOut1[15:0]),
      .ImagOut1      (ImagOut1[15:0]),
      .RealOut2      (RealOut2[15:0]),
      .ImagOut2      (ImagOut2[15:0]),
      .RealOut3      (RealOut3[15:0]),
      .ImagOut3      (ImagOut3[15:0]),
      .DataValid_R   (FIR_WE)
      );

   BRAM BRAM0
     (//Inputs
      .clka          (Bus2IP_Clk),
      .addra         (CPTR[9:0]),
      .dina          ({ImagOut1[15:0],RealOut1[15:0]}),
      .wea           (FIR_WE),
      .clkb          (Bus2IP_Clk),
      .addrb         (Bus2IP_Addr[20:29]),     //Original 32-bit
      .dinb          (Bus2IP_Data_int[31:0]), 
      .web           (RAM_WE[0]),     
      //Outputs
      .doutb         (RAM2IP_Data_int0[31:0])
      );                                                              

   BRAM BRAM1                                                         
     (//Inputs                                                        
      .clka          (Bus2IP_Clk),                                    
      .addra         (CPTR[9:0]),                                     
      .dina          ({ImagOut2[15:0],RealOut2[15:0]}),                                
      .wea           (FIR_WE),                                     
      .clkb          (Bus2IP_Clk),                                    
      .addrb         (Bus2IP_Addr[20:29]),     //Original 32-bit   
      .dinb          (Bus2IP_Data_int[31:0]),    
      .web           (RAM_WE[1]),                                     
      //Outputs                                                       
      .doutb         (RAM2IP_Data_int1[31:0])                         
      );

   BRAM BRAM2                                                         
     (//Inputs                                                        
      .clka          (Bus2IP_Clk),                                    
      .addra         (CPTR[9:0]),                                     
      .dina          ({ImagOut3[15:0],RealOut3[15:0]}),                                
      .wea           (FIR_WE),                                     
      .clkb          (Bus2IP_Clk),  
      .addrb         (Bus2IP_Addr[20:29]),
      .dinb          (Bus2IP_Data_int[31:0]),    
      .web           (RAM_WE[2]),                                     
      //Outputs                                                       
      .doutb         (RAM2IP_Data_int2[31:0])                         
      );



   //**************************************************************************//
   //*                    Bit ReOrddering Functions                           *//
   //**************************************************************************//   
   function [31:0] fnBitReordering031to310; // From [0:31] to [31:0]
      input [0:31]                           Data1;
      integer                                i;
      begin
         for (i=0;i<32;i=i+1)
           fnBitReordering031to310[i] = Data1[31-i];
      end
   endfunction // fnBitReordering031to310

   function [0:31] fnBitReordering310to031; // From [31:0] to [0:31]           
      input [31:0]                           Data1;   
      integer                                i;
      begin                           
         for (i=0;i<32;i=i+1)
           fnBitReordering310to031[i]  = Data1[31-i];           
      end                                              
   endfunction // fnBitReordering310to031         
   
endmodule // user_logic


// Copyright(C) 2004 by Xilinx, Inc. All rights reserved. 
// This text/file contains proprietary, confidential 
// information of Xilinx, Inc., is distributed under license 
// from Xilinx, Inc., and may be used, copied and/or 
// disclosed only pursuant to the terms of a valid license 
// agreement with Xilinx, Inc. Xilinx hereby grants you 
// a license to use this text/file solely for design, simulation, 
// implementation and creation of design files limited 
// to Xilinx devices or technologies. Use with non-Xilinx 
// devices or technologies is expressly prohibited and 
// immediately terminates your license unless covered by 
// a separate agreement. 
// 
// Xilinx is providing this design, code, or information 
// "as is" solely for use in developing programs and 
// solutions for Xilinx devices. By providing this design, 
// code, or information as one possible implementation of 
// this feature, application or standard, Xilinx is making no 
// representation that this implementation is free from any 
// claims of infringement. You are responsible for 
// obtaining any rights you may require for your implementation. 
// Xilinx expressly disclaims any warranty whatsoever with 
// respect to the adequacy of the implementation, including 
// but not limited to any warranties or representations that this 
// implementation is free from claims of infringement, implied 
// warranties of merchantability or fitness for a particular 
// purpose. 
// 
// Xilinx products are not intended for use in life support 
// appliances, devices, or systems. Use in such applications are 
// expressly prohibited. 
// 
// This copyright and support notice must be retained as part 
// of this text at all times. (c) Copyright 1995-2004 Xilinx, Inc. 
// All rights reserved.

/**************************************************************************
 * $RCSfile: BLKMEMDP_V6_3.v,v $ $Revision: 1.1.2.1 $ $Date: 2005/08/01 18:40:58 $ 
 **************************************************************************
 * Dual Port Block Memory - Verilog Behavioral Model
 * ************************************************************************
 *
 *
 *************************************************************************
 * Filename:    BLKMEMDP_V6_3.v
 * 
 * Description: The Verilog behavioral model for the Dual Port Block Memory
 * 
 * ***********************************************************************
 */

`timescale 1ns/10ps
`celldefine


`define c_dp_rom 4
`define c_dp_ram 2
`define c_write_first 0
`define c_read_first  1
`define c_no_change   2

module BLKMEMDP_V6_3(DOUTA, DOUTB, ADDRA, CLKA, DINA, ENA, SINITA, WEA, NDA, RFDA, RDYA, ADDRB, CLKB, DINB, ENB, SINITB, WEB,NDB, RFDB, RDYB);



  parameter  c_addra_width         =  11 ;
  parameter  c_addrb_width         =  9 ;
  parameter  c_default_data        = "0"; // indicates string of hex characters used to initialize memory
  parameter  c_depth_a             = 2048 ;
  parameter  c_depth_b             = 512 ;
  parameter  c_enable_rlocs        = 0 ; //  core includes placement constraints
  parameter  c_has_default_data    =  1;
  parameter  c_has_dina            = 1  ;  // indicate port A has data input pins
  parameter  c_has_dinb            = 1  ;  // indicate port B has data input pins
  parameter  c_has_douta           = 1 ; // indicates port A has  output
  parameter  c_has_doutb           = 1 ; // indicates port B has  output
  parameter  c_has_ena             =  1 ; // indicates port A has a ENA pin
  parameter  c_has_enb             =  1 ; // indicates port B has a ENB pin
  parameter  c_has_limit_data_pitch       = 1 ;
  parameter  c_has_nda             = 0 ; //  Port A has a new data pin
  parameter  c_has_ndb             = 0 ; //  Port B has a new data pin
  parameter  c_has_rdya            = 0 ; //  Port A has result ready pin
  parameter  c_has_rdyb            = 0 ; //  Port B has result ready pin
  parameter  c_has_rfda            = 0 ; //  Port A has ready for data pin
  parameter  c_has_rfdb            = 0 ; //  Port B has ready for data pin
  parameter  c_has_sinita          =  1 ; // indicates port A has a SINITA pin
  parameter  c_has_sinitb          =  1 ; // indicates port B has a SINITB pin
  parameter  c_has_wea             =  1 ; // indicates port A has a WEA pin
  parameter  c_has_web             =  1 ; // indicates port B has a WEB pin
  parameter  c_limit_data_pitch           = 16 ;
  parameter  c_mem_init_file     =  "null.mif";  // controls which .mif file used to initialize memory
  parameter  c_pipe_stages_a       =  0 ; // indicates the number of pipe stages needed in port A
  parameter  c_pipe_stages_b       =  0 ; // indicates the number of pipe stages needed in port B
  parameter  c_reg_inputsa         = 0 ; // indicates we, addr, and din of port A are registered
  parameter  c_reg_inputsb         = 0 ; // indicates we, addr, and din of port B are registered
  parameter  c_sim_collision_check = "NONE";
  parameter  c_sinita_value        = "0000"; // indicates string of hex used to initialize A output registers
  parameter  c_sinitb_value        = "0000"; // indicates string of hex used to initialize B output resisters
  parameter  c_width_a             =  8 ;
  parameter  c_width_b             = 32 ;
  parameter  c_write_modea        = 2; // controls which write modes shall be used
  parameter  c_write_modeb        = 2; // controls which write modes shall be used

  // New Generics for Primitive Selection and Pin Polarity
   parameter c_ybottom_addr        = "1024";
   parameter c_yclka_is_rising     = 1; // controls the active edge of the CLKA Pin
   parameter c_yclkb_is_rising     = 1; // controls the active edge of the CLKB Pin
   parameter c_yena_is_high        = 1; // controls the polarity of the ENA Pin
   parameter c_yenb_is_high        = 1; // controls the polarity of the ENB Pin
   parameter c_yhierarchy          = "hierarchy1";
   parameter c_ymake_bmm           = 0;
   parameter c_yprimitive_type     = "4kx4"; // Indicates which primitive should be used to build the
                                             // memory if c_yuse_single_primitive=1
   parameter c_ysinita_is_high     = 1; // controls the polarity of the SINITA Pin
   parameter c_ysinitb_is_high     = 1; // controls the polarity of the SINITB Pin
   parameter c_ytop_addr           = "0";   
   parameter c_yuse_single_primitive = 0; // controls whether the Memory is build out of a
                                          // user selected primitive or is built from multiple
                                          // primitives with the "optimize for area" algorithm used
   parameter c_ywea_is_high        = 1; // controls the polarity of the WEA Pin
   parameter c_yweb_is_high        = 1; // controls the polarity of the WEB Pin

   parameter c_yydisable_warnings  = 1; //1=no warnings, 0=print warnings
  
 

// IO ports



    output [c_width_a-1:0] DOUTA;

    input [c_addra_width-1:0] ADDRA;
    input [c_width_a-1:0] DINA;
    input ENA, CLKA, WEA, SINITA, NDA;
    output RFDA, RDYA;

    output [c_width_b-1:0] DOUTB;

    input [c_addrb_width-1:0] ADDRB;
    input [c_width_b-1:0] DINB;
    input ENB, CLKB, WEB, SINITB, NDB;
    output RFDB, RDYB;


// internal signals

    reg [c_width_a-1:0] douta_mux_out ; // output of multiplexer --
    wire [c_width_a-1:0] DOUTA = douta_mux_out;
    reg  RFDA, RDYA ;

    reg [c_width_b-1:0] doutb_mux_out ; // output of multiplexer --
    wire [c_width_b-1:0] DOUTB = doutb_mux_out;
    reg RFDB, RDYB;


    reg [c_width_a-1:0] douta_out_q; // registered output of douta_out
    reg [c_width_a-1:0] doa_out;  // output of Port A RAM
    reg [c_width_a-1:0] douta_out; // output of pipeline mux for port A

    reg [c_width_b-1:0] doutb_out_q ; // registered output for doutb_out
    reg [c_width_b-1:0] dob_out; // output of Port B RAM
    reg [c_width_b-1:0] doutb_out ; // output of pipeline mux for port B

    reg [c_depth_a*c_width_a-1 : 0] mem; 
    reg [24:0] count ;
    reg [1:0] wr_mode_a, wr_mode_b;

    reg [(c_width_a-1) : 0]  pipelinea [0 : c_pipe_stages_a];
    reg [(c_width_b-1) : 0]  pipelineb [0 : c_pipe_stages_b];
    reg sub_rdy_a[0 : c_pipe_stages_a];
    reg sub_rdy_b[0 : c_pipe_stages_b];

    reg [10:0] ci, cj;
    reg [10:0] dmi, dmj, dni, dnj, doi, doj, dai, daj, dbi, dbj, dci, dcj, ddi, ddj;
    reg [10:0] pmi, pmj, pni, pnj, poi, poj, pai, paj, pbi, pbj, pci, pcj, pdi, pdj;
    integer ai, aj, ak, al, am, an, ap ;
    integer bi, bj, bk, bl, bm, bn, bp ;
    integer i, j, k, l, m, n, p; 

    wire [c_addra_width-1:0] addra_i = ADDRA;
    reg [c_width_a-1:0] dia_int ;
    reg [c_width_a-1:0] dia_q ;
    wire [c_width_a-1:0] dia_i ;
    wire ena_int  ;
    reg ena_q ;
    wire clka_int ;
    reg wea_int  ;
    wire wea_i  ;
    reg wea_q ;
    wire ssra_int  ;
    wire nda_int ;
    wire nda_i ;
    reg rfda_int ;
    reg rdya_int ;
    reg nda_q ;
    reg new_data_a ;
    reg new_data_a_q ;
    reg [c_addra_width-1:0] addra_q;
    reg [c_addra_width-1:0] addra_int;
    reg [c_width_a-1:0] sinita_value ; // initialization value for output registers of Port A

    wire [c_addrb_width-1:0] addrb_i = ADDRB;
    reg [c_width_b-1:0] dib_int ;
    reg [c_width_b-1:0] dib_q ;
    wire [c_width_b-1:0] dib_i ;
    wire enb_int ;
    reg enb_q ;
    wire clkb_int ;
    reg web_int  ;
    wire web_i ;
    reg web_q ;
    wire ssrb_int  ;
    wire ndb_int ;
    wire ndb_i ;
    reg rfdb_int ;
    reg rdyb_int ;
    reg ndb_q ;
    reg new_data_b ;
    reg new_data_b_q ;
    reg [c_addrb_width-1:0] addrb_q ;
    reg [c_addrb_width-1:0] addrb_int ;
    reg [c_width_b-1:0] sinitb_value ; // initialization value for output registers of Port B

//  variables used to initialize memory contents to default values.

    reg [c_width_a-1:0] bitval ;
    reg [c_width_a-1:0] ram_temp [0:c_depth_a-1] ;
    reg [c_width_a-1:0] default_data ;

//  variables used to detect address collision on dual port Rams

    reg recovery_a, recovery_b;
    reg address_collision;    

     wire clka_enable_pp = ena_int && wea_int && enb_int && address_collision 
                          && c_yclka_is_rising && c_yclkb_is_rising;
    wire clkb_enable_pp = enb_int && web_int && ena_int && address_collision
                          && c_yclka_is_rising && c_yclkb_is_rising;
    wire collision_posa_posb = clka_enable_pp || clkb_enable_pp;

    // For posedge clka and negedge clkb

    wire clka_enable_pn = ena_int && wea_int && enb_int && address_collision
                          && c_yclka_is_rising && (!c_yclkb_is_rising);
    wire clkb_enable_pn = enb_int && web_int && ena_int && address_collision
                          && c_yclka_is_rising && (!c_yclkb_is_rising);
    wire collision_posa_negb = clka_enable_pn || clkb_enable_pn;

    // For negedge clka and posedge clkb

    wire clka_enable_np = ena_int && wea_int && enb_int && address_collision
                          && (!c_yclka_is_rising) && c_yclkb_is_rising;
    wire clkb_enable_np = enb_int && web_int && ena_int && address_collision
                          && (!c_yclka_is_rising) && c_yclkb_is_rising;
    wire collision_nega_posb = clka_enable_np || clkb_enable_np;

    // For negedge clka and clkb

    wire clka_enable_nn = ena_int && wea_int && enb_int && address_collision
                          && (!c_yclka_is_rising) && (!c_yclkb_is_rising);
    wire clkb_enable_nn = enb_int && web_int && ena_int && address_collision
                          && (!c_yclka_is_rising) && (!c_yclkb_is_rising);
    wire collision_nega_negb = clka_enable_nn || clkb_enable_nn;


//   tri0 GSR = glbl.GSR;

    assign dia_i    = (c_has_dina === 1)?DINA:'b0;
    assign ena_int  = defval(ENA, c_has_ena, 1, c_yena_is_high);
    assign ssra_int = defval(SINITA, c_has_sinita, 0, c_ysinita_is_high);
    assign nda_i    = defval(NDA, c_has_nda, 1, 1);
    assign clka_int = defval(CLKA, 1, 1, c_yclka_is_rising);

    assign dib_i    = (c_has_dinb === 1)?DINB:'b0;
    assign enb_int  = defval(ENB, c_has_enb, 1, c_yenb_is_high);
    assign ssrb_int = defval(SINITB, c_has_sinitb, 0, c_ysinitb_is_high);
    assign ndb_i    = defval(NDB, c_has_ndb, 1, 1);
    assign clkb_int = defval(CLKB, 1, 1, c_yclkb_is_rising);

// RAM/ROM functionality

    assign wea_i = defval(WEA, c_has_wea, 0, c_ywea_is_high);
    assign web_i = defval(WEB, c_has_web, 0, c_yweb_is_high);


    function defval;
      input i;
      input hassig;
      input val;  
      input active_high;
    begin
      if(hassig == 1)
      begin
        if (active_high == 1)
          defval = i;
        else
          defval = ~i;
      end
      else
        defval = val;
      end
    endfunction

    function max;
      input a;
      input b;
        begin
                max = (a > b) ? a : b;
        end
    endfunction

    function a_is_X;
      input [c_width_a-1 : 0] i;
      integer j ;
        begin
                a_is_X = 1'b0;
                for(j = 0; j < c_width_a; j = j + 1)
                begin
                        if(i[j] === 1'bx)
                                a_is_X = 1'b1;
                end // loop
        end
    endfunction
 
    function b_is_X;
      input [c_width_b-1 : 0] i;
      integer j ;
        begin
                b_is_X = 1'b0;
                for(j = 0; j < c_width_b; j = j + 1)
                begin
                        if(i[j] === 1'bx)
                                b_is_X = 1'b1;
                end // loop
        end
    endfunction

  function [c_width_a-1:0] hexstr_conv;
    input [(c_width_a*8)-1:0] def_data;
 
    integer index,i,j;
    reg [3:0] bin;
 
    begin
      index = 0;
      hexstr_conv = 'b0;
      for( i=c_width_a-1; i>=0; i=i-1 )
      begin
        case (def_data[7:0])
          8'b00000000 :
          begin
            bin = 4'b0000;
            i = -1;
          end
          8'b00110000 : bin = 4'b0000;
          8'b00110001 : bin = 4'b0001;
          8'b00110010 : bin = 4'b0010;
          8'b00110011 : bin = 4'b0011;
          8'b00110100 : bin = 4'b0100;
          8'b00110101 : bin = 4'b0101;
          8'b00110110 : bin = 4'b0110;
          8'b00110111 : bin = 4'b0111;
          8'b00111000 : bin = 4'b1000;
          8'b00111001 : bin = 4'b1001;
          8'b01000001 : bin = 4'b1010;
          8'b01000010 : bin = 4'b1011;
          8'b01000011 : bin = 4'b1100;
          8'b01000100 : bin = 4'b1101;
          8'b01000101 : bin = 4'b1110;
          8'b01000110 : bin = 4'b1111;
          8'b01100001 : bin = 4'b1010;
          8'b01100010 : bin = 4'b1011;
          8'b01100011 : bin = 4'b1100;
          8'b01100100 : bin = 4'b1101;
          8'b01100101 : bin = 4'b1110;
          8'b01100110 : bin = 4'b1111;
          default :
          begin
            if (c_yydisable_warnings == 0) begin
              $display("ERROR in %m at time %t: NOT A HEX CHARACTER",$time);
            end
            bin = 4'bx;
          end
        endcase
        for( j=0; j<4; j=j+1)
        begin
          if ((index*4)+j < c_width_a)
          begin
            hexstr_conv[(index*4)+j] = bin[j];
          end
        end
        index = index + 1;
        def_data = def_data >> 8;
      end
    end
  endfunction

  function [c_width_b-1:0] hexstr_conv_b;
    input [(c_width_b*8)-1:0] def_data;
 
    integer index,i,j;
    reg [3:0] bin;
 
    begin
      index = 0;
      hexstr_conv_b = 'b0;
      for( i=c_width_b-1; i>=0; i=i-1 )
      begin
        case (def_data[7:0])
          8'b00000000 :
          begin
            bin = 4'b0000;
            i = -1;
          end
          8'b00110000 : bin = 4'b0000;
          8'b00110001 : bin = 4'b0001;
          8'b00110010 : bin = 4'b0010;
          8'b00110011 : bin = 4'b0011;
          8'b00110100 : bin = 4'b0100;
          8'b00110101 : bin = 4'b0101;
          8'b00110110 : bin = 4'b0110;
          8'b00110111 : bin = 4'b0111;
          8'b00111000 : bin = 4'b1000;
          8'b00111001 : bin = 4'b1001;
          8'b01000001 : bin = 4'b1010;
          8'b01000010 : bin = 4'b1011;
          8'b01000011 : bin = 4'b1100;
          8'b01000100 : bin = 4'b1101;
          8'b01000101 : bin = 4'b1110;
          8'b01000110 : bin = 4'b1111;
          8'b01100001 : bin = 4'b1010;
          8'b01100010 : bin = 4'b1011;
          8'b01100011 : bin = 4'b1100;
          8'b01100100 : bin = 4'b1101;
          8'b01100101 : bin = 4'b1110;
          8'b01100110 : bin = 4'b1111;
          default :
          begin
            if (c_yydisable_warnings == 0) begin
              $display("ERROR in %m at time %t: NOT A HEX CHARACTER",$time);
            end
            bin = 4'bx;
          end
        endcase
        for( j=0; j<4; j=j+1)
        begin
          if ((index*4)+j < c_width_b)
          begin
            hexstr_conv_b[(index*4)+j] = bin[j];
          end
        end
        index = index + 1;
        def_data = def_data >> 8;
      end
    end
  endfunction





//  Initialize memory contents to 0 for now . 

    initial begin
        sinita_value = 'b0 ;
        sinitb_value = 'b0 ;

             default_data = hexstr_conv(c_default_data);
        if (c_has_sinita == 1 )
             sinita_value = hexstr_conv(c_sinita_value);
        if (c_has_sinitb == 1 ) 
             sinitb_value = hexstr_conv_b(c_sinitb_value);
            for(i = 0; i < c_depth_a; i = i + 1)
              ram_temp[i] = default_data;
       if (c_has_default_data == 0)
          $readmemb(c_mem_init_file, ram_temp) ;

        for(i = 0; i < c_depth_a; i = i + 1)
           for(j = 0; j < c_width_a; j = j + 1)
              begin
                 bitval = (1'b1 << j);
                 mem[(i*c_width_a) + j] = (ram_temp[i] & bitval) >> j;
              end
        recovery_a = 0;
        recovery_b = 0;
        for (k = 0; k <= c_pipe_stages_a; k = k + 1)
            pipelinea[k] = sinita_value ;
        for (l = 0; l <= c_pipe_stages_b; l = l + 1)
            pipelineb[l] = sinitb_value ;
        for (m = 0; m <= c_pipe_stages_a; m = m + 1)
            sub_rdy_a[m] = 0 ;
        for (n = 0; n <= c_pipe_stages_b; n = n + 1) 
            sub_rdy_b[n] = 0 ;
        doa_out = sinita_value ;
        dob_out = sinitb_value ;
        nda_q = 0;
        ndb_q = 0;
        new_data_a_q = 0 ;
        new_data_b_q = 0 ;
        dia_q = 0;
        dib_q = 0;
        addra_q = 0;
        addrb_q = 0;
        wea_q   = 0;
        web_q   = 0;
        #1 douta_out = sinita_value;
        #1 doutb_out = sinitb_value;
        #1 rdya_int = 0;
        #1 rdyb_int = 0;
    end


    always @(addra_int or addrb_int) begin  //  check address collision
	address_collision <= 1'b0;
	for (ci = 0; ci < c_width_a; ci = ci + 1) begin // absolute address A
	    for (cj = 0; cj < c_width_b; cj = cj + 1) begin // absolute address B
		if ((addra_int * c_width_a + ci) == (addrb_int * c_width_b + cj)) begin
		    address_collision <= 1'b1;
		end
	    end
	end
    end
/***********************************************************************************************************
* The following 3 always blocks handle memory inputs for the case of an address collision on ADDRA and ADDRB
***********************************************************************************************************/
     always @(posedge recovery_a or posedge recovery_b) begin
	if (((wr_mode_a == 2'b01) && (wr_mode_b == 2'b01)) ||
	    ((wr_mode_a != 2'b01) && (wr_mode_b != 2'b01))) begin
	    if (wea_int == 1 && web_int == 1) begin
              if (addra_int < c_depth_a)
		for (dmi = 0; dmi < c_width_a; dmi = dmi + 1) begin
		    for (dmj = 0; dmj < c_width_b; dmj = dmj + 1) begin
			if ((addra_int * c_width_a + dmi) == (addrb_int * c_width_b + dmj)) begin
//Fixed read-first collision
//                        mem[addra_int * c_width_a + dmi] <= 1'bX;
                          if ((wr_mode_a == 2'b01) && (wr_mode_b == 2'b01))
                          begin
                            doa_out[dmi] <= 1'bX;
                            dob_out[dmj] <= 1'bX;
                          end
                          else
                            mem[addra_int * c_width_a + dmi] <= 1'bX;
                        end
		    end
		end
              else begin
                //Warning Condition: 
		//Write Mode PortA is "Read First" and Write Mode PortB is "Read First" and WEA = 1 and WEB = 1 and ADDRA out of the valid range
		//or
		//Write Mode PortA is not "Read First" and Write Mode PortB is not "Read First" and WEA = 1 and WEB = 1 and ADDRA out of the valid range
                if (c_yydisable_warnings == 0) begin
	          $display("Invalid Address Warning #1: Warning in %m at time %t: Port A address %d (%b) of block memory invalid. Valid depth configured as 0 to %d",$time,addra_int,addra_int,c_depth_a-1);
                end
                doa_out <= {c_width_a{1'bX}};     // assign data bus to X
              end
	    end
	end
	recovery_a <= 0;
        recovery_b <= 0;
    end

    always @(posedge recovery_a or posedge recovery_b) begin
	if ((wr_mode_a == 2'b01) && (wr_mode_b != 2'b01)) begin
	    if (wea_int == 1 && web_int == 1) begin
              if (addra_int < c_depth_a)
		for (dni = 0; dni < c_width_a; dni = dni + 1) begin
		    for (dnj = 0; dnj < c_width_b; dnj = dnj + 1) begin
			if ((addra_int * c_width_a + dni) == (addrb_int * c_width_b + dnj)) begin
			    mem[addra_int * c_width_a + dni] <= dia_int[dni];
			end
		    end
		end
              else begin
                //Warning Condition:
		//Write Mode PortA is "Read First" and Write Mode PortB is not "Read First" and WEA = 1 and WEB = 1 and ADDRA out of the valid range
                if (c_yydisable_warnings == 0) begin
	          $display("Invalid Address Warning #2: Warning in %m at time %t: Port A address %d (%b) of block memory invalid. Valid depth configured as 0 to %d",$time,addra_int,addra_int,c_depth_a-1);
                end
                doa_out <= {c_width_a{1'bX}};     // assign data bus to X
              end
	    end
	end
    end

    always @(posedge recovery_a or posedge recovery_b) begin
	if ((wr_mode_a != 2'b01) && (wr_mode_b == 2'b01)) begin
	    if (wea_int == 1 && web_int == 1) begin
              if (addrb_int < c_depth_b)
		for (doi = 0; doi < c_width_a; doi = doi + 1) begin
		    for (doj = 0; doj < c_width_b; doj = doj + 1) begin
			if ((addra_int * c_width_a + doi) == (addrb_int * c_width_b + doj)) begin
			    mem[addrb_int * c_width_b + doj] <= dib_int[doj];
			end
		    end
		end
              else begin
                //Warning Condition: 
		//Write Mode PortA is not "Read First" and Write Mode PortB is "Read First" and WEA = 1 and WEB = 1 and ADDRB out of the valid range
                if (c_yydisable_warnings == 0) begin
	          $display("Invalid Address Warning #3: Warning in %m at time %t: Port B address %d (%b) of block memory invalid. Valid depth configured as 0 to %d",$time,addrb_int,addrb_int,c_depth_b-1);
                end
                dob_out <= {c_width_b{1'bX}};     // assign data bus to X
              end
	    end
	end
    end
/***********************************************************************************************************
*The following 4 always blocks handle memory outputs for the case of an address collision on ADDRA and ADDRB
***********************************************************************************************************/
     always @(posedge recovery_a or posedge recovery_b) begin
	if ((wr_mode_b == 2'b00) || (wr_mode_b == 2'b10)) begin
	    if ((wea_int == 0) && (web_int == 1) && (ssra_int == 0)) begin
              if (addra_int < c_depth_a)
		for (dai = 0; dai < c_width_a; dai = dai + 1) begin
		    for (daj = 0; daj < c_width_b; daj = daj + 1) begin
			if ((addra_int * c_width_a + dai) == (addrb_int * c_width_b + daj)) begin
			    doa_out[dai] <= 1'bX;
			end
		    end
		end
              else begin
                //Warning Condition: 
		//Write Mode PortB is "Write First" and WEA = 0 and WEB = 1 and SINITA = 0 and ADDRA out of the valid range
		//or
		//Write Mode PortB is "No Change" and WEA = 0 and WEB = 1 and SINITA = 0 and ADDRA out of the valid range
                if (c_yydisable_warnings == 0) begin
	          $display("Invalid Address Warning #4: Warning in %m at time %t: Port A address %d (%b) of block memory invalid. Valid depth configured as 0 to %d",$time,addra_int,addra_int,c_depth_a-1);
                end
                doa_out <= {c_width_a{1'bX}};     // assign data bus to X
              end
	    end
	end
    end

    always @(posedge recovery_a or posedge recovery_b) begin
	if ((wr_mode_a == 2'b00) || (wr_mode_a == 2'b10)) begin
	    if ((wea_int == 1) && (web_int == 0) && (ssrb_int == 0)) begin
              if (addrb_int < c_depth_b)
		for (dbi = 0; dbi < c_width_a; dbi = dbi + 1) begin
		    for (dbj = 0; dbj < c_width_b; dbj = dbj + 1) begin
			if ((addra_int * c_width_a + dbi) == (addrb_int * c_width_b + dbj)) begin
			    dob_out[dbj] <= 1'bX;
			end
		    end
		end
              else begin
		//Warning Condition: 
		//Write Mode PortA is "Write First" and WEA = 1 and WEB = 0 and SINITB = 0 and ADDRB out of the valid range
		//or
		//Write Mode PortA is "No Change" and WEA = 1 and WEB = 0 and SINITB = 0 and ADDRB out of the valid range
                if (c_yydisable_warnings == 0) begin
	          $display("Invalid Address Warning #5: Warning in %m at time %t: Port B address %d (%b) of block memory invalid. Valid depth configured as 0 to %d",$time,addrb_int,addrb_int,c_depth_b-1);
                end
                dob_out <= {c_width_b{1'bX}};     // assign data bus to X
              end
	    end
	end
    end

    always @(posedge recovery_a or posedge recovery_b) begin
	if (((wr_mode_a == 2'b00) && (wr_mode_b == 2'b00)) ||
	    ((wr_mode_a != 2'b10) && (wr_mode_b == 2'b10)) ||
	    ((wr_mode_a == 2'b01) && (wr_mode_b == 2'b00))) begin
	    if ((wea_int == 1) && (web_int == 1) && (ssra_int == 0)) begin
              if (addra_int < c_depth_a)
		for (dci = 0; dci < c_width_a; dci = dci + 1) begin
		    for (dcj = 0; dcj < c_width_b; dcj = dcj + 1) begin
			if ((addra_int * c_width_a + dci) == (addrb_int * c_width_b + dcj)) begin
			    doa_out[dci] <= 1'bX;
			end
		    end
		end
              else begin
                //Warning Condition: 
		//Write Mode PortA is "Write First" and Write Mode PortB is "Write First" and WEA = 1 and WEB = 1 and SINITA = 0 and ADDRA out of the valid range
		//or
		//Write Mode PortA is not "No Change" and Write Mode PortB is "No Change" and WEA = 1 and WEB = 1 and SINITA = 0 and ADDRA out of the valid range
		//or
		//Write Mode PortA is "Read First" and Write Mode PortB is "Write First" and WEA = 1 and WEB = 1 and SINITA = 0 and ADDRA out of the valid range
                if (c_yydisable_warnings == 0) begin
	          $display("Invalid Address Warning #6: Warning in %m at time %t: Port A address %d (%b) of block memory invalid. Valid depth configured as 0 to %d",$time,addra_int,addra_int,c_depth_a-1);
                end
                doa_out <= {c_width_a{1'bX}};     // assign data bus to X
              end
	    end
	end
    end

    always @(posedge recovery_a or posedge recovery_b) begin
	if (((wr_mode_a == 2'b00) && (wr_mode_b == 2'b00)) ||
	    ((wr_mode_a == 2'b10) && (wr_mode_b != 2'b10)) ||
	    ((wr_mode_a == 2'b00) && (wr_mode_b == 2'b01))) begin
	    if ((wea_int == 1) && (web_int == 1) && (ssrb_int == 0)) begin
              if (addrb_int < c_depth_b)
		for (ddi = 0; ddi < c_width_a; ddi = ddi + 1) begin
		    for (ddj = 0; ddj < c_width_b; ddj = ddj + 1) begin
			if ((addra_int * c_width_a + ddi) == (addrb_int * c_width_b + ddj)) begin
			    dob_out[ddj] <= 1'bX;
			end
		    end
		end
              else begin
                //Warning Condition: 
		//Write Mode PortA is "Write First" and Write Mode PortB is "Write First" and WEA = 1 and WEB = 1 and SINITB = 0 and ADDRB out of the valid range
		//or
		//Write Mode PortA is "No Change" and Write Mode PortB is not "No Change" and WEA = 1 and WEB = 1 and SINITB = 0 and ADDRB out of the valid range
		//or
		//Write Mode PortA is "Write First" and Write Mode PortB is "Read First" and WEA = 1 and WEB = 1 and SINITB = 0 and ADDRB out of the valid range
                if (c_yydisable_warnings == 0) begin
	          $display("Invalid Address Warning #7: Warning in %m at time %t: Port B address %d (%b) of block memory invalid. Valid depth configured as 0 to %d",$time,addrb_int,addrb_int,c_depth_b-1);
                end
                dob_out <= {c_width_b{1'bX}};     // assign data bus to X
              end
	    end
	end
    end

 //   Parity Section is deleted

    initial begin
	case (c_write_modea)
	    `c_write_first : wr_mode_a <= 2'b00;
	    `c_read_first  : wr_mode_a <= 2'b01;
	    `c_no_change   : wr_mode_a <= 2'b10;
	    default       : begin
                                if (c_yydisable_warnings == 0) begin
			          $display("Error in %m at time %t: c_write_modea = %s is not WRITE_FIRST, READ_FIRST or NO_CHANGE.",$time, c_write_modea);
                                end
				$finish;
			    end
	endcase
    end

    initial begin
	case (c_write_modeb)
	    `c_write_first : wr_mode_b <= 2'b00;
	    `c_read_first  : wr_mode_b <= 2'b01;
	    `c_no_change   : wr_mode_b <= 2'b10;
	    default       : begin
                                if (c_yydisable_warnings == 0) begin
				  $display("Error in %m at time %t: c_write_modeb = %s is not WRITE_FIRST, READ_FIRST or NO_CHANGE.",$time, c_write_modeb);
                                end
				$finish;
			    end
	endcase
    end

// Port A


// Generate ouput control signals for Port A: RFDA and RDYA
   
    always @ (rfda_int or rdya_int)
    begin
       if (c_has_rfda == 1)
          RFDA = rfda_int ;
       else
          RFDA = 1'b0 ;
      
       if ((c_has_rdya == 1) && (c_has_nda == 1) && (c_has_rfda == 1) )
          RDYA  = rdya_int;
       else
          RDYA  = 1'b0 ;
    end

    always @ (ena_int )
    begin
       if (ena_int == 1'b1)
          rfda_int <= 1'b1 ;
       else
          rfda_int <= 1'b0 ;
    end

// Gate nd signal with en     

   assign nda_int = ena_int && nda_i ;

// Register hanshaking signals for port A

    always @ (posedge clka_int)
    begin
       if (ena_int == 1'b1)
          begin
              if (ssra_int == 1'b1)
                 nda_q <= 1'b0 ;
              else
                 nda_q <= nda_int ;
          end
       else
          nda_q  <= nda_q ;  
    end

// Register data/ address / we inputs for port A

    always @ (posedge clka_int)
    begin
      if (ena_int == 1'b1)
         begin
          dia_q  <= dia_i ;
          addra_q <= addra_i ;
          wea_q  <= wea_i ;
      end
    end


// Select registered or non-registered write enable for Port A

   always @ ( wea_i or wea_q )
   begin
      if (c_reg_inputsa == 1)
         wea_int = wea_q ;
      else
         wea_int = wea_i ;
   end

// Select registered or non-registered  data/address/nd inputs for Port A

    always @ ( dia_i or dia_q )
    begin
         if ( c_reg_inputsa == 1)
            dia_int = dia_q;
         else
            dia_int = dia_i;
    end

    always @ ( addra_i or addra_q or nda_q or nda_int )
    begin
         if ( c_reg_inputsa == 1)
            begin
                addra_int = addra_q ;
                if ((wea_q == 1'b1) && (c_write_modea == 2))
                  new_data_a = 1'b0 ;
	        else
                  new_data_a = nda_q ;		 
            end
         else
            begin
                addra_int = addra_i;
	        if ((wea_i == 1'b1) && (c_write_modea == 2))
                  new_data_a = 1'b0 ;
	        else
                  new_data_a = nda_int ;
            end
    end

// Register the new_data signal for Port A to track the synchronous RAM output

    always @(posedge clka_int)
       begin
          if (ena_int == 1'b1)
             begin
                if (ssra_int == 1'b1)
                   new_data_a_q <= 1'b0 ;
                else
                  // Do not update RDYA if write mode is no_change and wea=1
                  //if (!(c_write_modea == 2 && wea_int == 1)) begin 
		  // rii1 : 10/20 Make dual port behavior the same as single port
                    new_data_a_q <= new_data_a ;
                  //end
             end
       end

// Generate data outputs for Port A


    /***************************************************************
    *The following always block assigns the value for the DOUTA bus
    ***************************************************************/
      always @(posedge clka_int) begin
	if (ena_int == 1'b1) begin
	    if (ssra_int == 1'b1) begin
             //   for ( ai = 0; ai < c_width_a; ai = ai + 1)
             //       doa_out[ai] <= sinita_value[ai];
                    doa_out <= sinita_value;
	    end
	    else begin
	        //The following IF block assigns the output for a write operation
		if (wea_int == 1'b1) begin
		    if (wr_mode_a == 2'b00) begin
                      if (addra_int < c_depth_a)
                    //    for ( aj = 0; aj < c_width_a; aj = aj + 1)
                    //        doa_out[aj] <= dia_int[aj] ;
                            doa_out <= dia_int ;
                      else begin
                        //Warning Condition (Error occurs on rising edge of CLKA): 
			//Write Mode PortA is "Write First" and ENA = 1 and SINITA = 0 and WEA = 1 and ADDRA out of the valid range
                        if (c_yydisable_warnings == 0) begin
		          $display("Invalid Address Warning #8: Warning in %m at time %t: Port A address %d (%b) of block memory invalid. Valid depth configured as 0 to %d",$time,addra_int,addra_int,c_depth_a-1);
                        end
                        doa_out <= {c_width_a{1'bX}};    // assign data bus to X
                      end
		    end
		    else if (wr_mode_a == 2'b01) begin
                      if (addra_int < c_depth_a)
                      //  for ( ak = 0; ak < c_width_a; ak = ak + 1)
                       //     doa_out[ak] <= mem[(addra_int*c_width_a) + ak];
                            doa_out <= mem >> (addra_int*c_width_a);
                      else begin
                        //Warning Condition (Error occurs on rising edge of CLKA): 
			//Write Mode PortA is "Read First" and ENA = 1 and SINITA = 0 and WEA = 1 and ADDRA out of the valid range
                        if (c_yydisable_warnings == 0) begin
		          $display("Invalid Address Warning #9: Warning in %m at time %t: Port A address %d (%b) of block memory invalid. Valid depth configured as 0 to %d",$time,addra_int,addra_int,c_depth_a-1);
                        end
                        doa_out <= {c_width_a{1'bX}};     //assign data bus to X
                      end
		    end
		    else begin
                      if (addra_int < c_depth_a)
                        doa_out <= doa_out;
                      else begin
                        //Warning Condition (Error occurs on rising edge of CLKA): 
			//Write Mode PortA is "No Change" and ENA = 1 and SINITA = 0 and WEA = 1 and ADDRA out of the valid range 
                        if (c_yydisable_warnings == 0) begin
		          $display("Invalid Address Warning #10: Warning in %m at time %t: Port A address %d (%b) of block memory invalid. Valid depth configured as 0 to %d",$time,addra_int,addra_int,c_depth_a-1);
                        end
                        doa_out <= {c_width_a{1'bX}};     //assign data bus to X
                      end
		    end
		end
	        //The following ELSE block assigns the output for a read operation
		else begin
                  if (addra_int < c_depth_a)
                  //  for ( al = 0; al < c_width_a; al = al + 1)
                  //      doa_out[al]  <= mem[(addra_int*c_width_a) + al];
                        doa_out  <= mem >> (addra_int*c_width_a);
                  else begin
		    if (c_has_douta == 1)//New IF statement to remove read errors when port is write only
		      begin
			 //Warning Condition (Error occurs on rising edge of CLKA): 
			 //ENA = 1 and SINITA = 0 and WEA = 0 and ADDRA out of the valid range 
                         if (c_yydisable_warnings == 0) begin
			   $display("Invalid Address Warning #11: Warning in %m at time %t: Port A address %d (%b) of block memory invalid. Valid depth configured as 0 to %d",$time,addra_int,addra_int,c_depth_a-1);
                         end
                         doa_out <= {c_width_a{1'bX}};    //assign data bus to X
		      end
		  end
		end
	    end
	end
      end
    /***************************************************************************************
    *The following always block assigns the DINA bus to the memory during a write operation
    ***************************************************************************************/ 
      always @(posedge clka_int) begin
	if (ena_int == 1'b1 && wea_int == 1'b1) begin
          if (addra_int < c_depth_a)
            for ( am = 0; am < c_width_a; am = am + 1)
                mem[(addra_int*c_width_a) + am] <= dia_int[am];
          else begin
            //Warning Condition (Error occurs on rising edge of CLKA): 
	    //ENA = 1 and WEA = 1 and ADDRA out of the valid range
            if (c_yydisable_warnings == 0) begin
	      $display("Invalid Address Warning #12: Warning in %m at time %t: Port A address %d (%b) of block memory invalid. Valid depth configured as 0 to %d",$time,addra_int,addra_int,c_depth_a-1);
            end
            doa_out <= {c_width_a{1'bX}};    //assign data bus to X
          end
	end
    end
   
    //  output pipelines for Port A

   always @(posedge clka_int) begin
       if (ena_int == 1'b1 && c_pipe_stages_a > 0)
         begin
             for (i = c_pipe_stages_a; i >= 1; i = i -1 )
               begin
                  if (ssra_int == 1'b1 && ena_int == 1'b1 )
					 begin
                      pipelinea[i] <= sinita_value ;
                      sub_rdy_a[i]   <= 0 ;
                     end
                  else
		    begin
		      // Do not change output when no_change and web=1  
//	              if (!(c_write_modea == 2 && wea_int == 1)) begin
		        if (i==1)
                 	  pipelinea[i] <= doa_out ;
		        else
	 		  pipelinea[i] <= pipelinea[i-1] ;
//                      end // if (!(c_write_modea == 2 && wea_int == 1))
		      if (i==1)
                 	sub_rdy_a[i]  <= new_data_a_q ;
  		      else
 			sub_rdy_a[i] <= sub_rdy_a[i-1] ;
		   end
               end
	 end
   end 
   
// Select pipeline output if c_pipe_stages_a > 0

   always @( pipelinea[c_pipe_stages_a] or sub_rdy_a[c_pipe_stages_a] or new_data_a_q or doa_out ) begin
          if (c_pipe_stages_a == 0 )
             begin 
                douta_out = doa_out ;
                rdya_int  = new_data_a_q;
             end
          else
             begin
                douta_out = pipelinea[c_pipe_stages_a];
                rdya_int  = sub_rdy_a[c_pipe_stages_a];
             end
   end

 
 // Select Port A data outputs based on c_has_douta parameter
 
  always @( douta_out ) begin
         if ( c_has_douta == 1)
            douta_mux_out = douta_out ;
         else
            douta_mux_out = 0 ;
  end
 
 

// Port B



// Generate output control signals for Port B: RFDB and RDYB
   
    always @ (rfdb_int or rdyb_int)
    begin
       if (c_has_rfdb == 1)
          RFDB = rfdb_int ;
       else
          RFDB = 1'b0 ;

       if ((c_has_rdyb == 1) && (c_has_ndb == 1) && (c_has_rfdb == 1) )
          RDYB  = rdyb_int;
       else
          RDYB  = 1'b0 ;
    end

    always @ (enb_int )
    begin
        if ( enb_int == 1'b1 )
           rfdb_int = 1'b1 ;
        else
          rfdb_int  = 1'b0 ;
    end

// Gate nd signal with en

   assign ndb_int = enb_int && ndb_i ;

// Register hanshaking signals for port B

    always @ (posedge clkb_int)
    begin
       if (enb_int == 1'b1)
          begin
             if (ssrb_int == 1'b1)
                 ndb_q <= 1'b0 ;
             else
                 ndb_q   <=  ndb_int ;
          end
       else
          ndb_q <=  ndb_q;
    end

// Register data / address / we  inputs for port B

    always @ (posedge clkb_int)
    begin
      if (enb_int == 1'b1)
         begin
           dib_q  <= dib_i ;
           addrb_q <= addrb_i ;
           web_q  <= web_i ;
         end
    end

// Select registered or non-registered write enable for port B

   always @ (web_i or web_q )
   begin
      if (c_reg_inputsb == 1)
         web_int = web_q ;
      else
         web_int = web_i ;
   end


 
// Select registered or non-registered  data/address/nd inputs for Port B
 
    always @ ( dib_i or dib_q )
    begin
         if ( c_reg_inputsb == 1)
            dib_int = dib_q;
         else
            dib_int = dib_i;
    end
 
    always @ ( addrb_i or addrb_q or  ndb_q or ndb_int or web_q or web_i)
    begin
         if ( c_reg_inputsb == 1)
            begin
                addrb_int = addrb_q ;
                if ((web_q == 1'b1) && (c_write_modeb == 2))
                  new_data_b = 1'b0 ;
	        else
	          new_data_b = ndb_q ;
            end
         else
          begin
                addrb_int = addrb_i;
                if ((web_i == 1'b1) && (c_write_modeb == 2))
                  new_data_b = 1'b0 ;
	        else
                  new_data_b = ndb_int ;
         end
    end

// Register the new_data signal for Port B to track the synchronous RAM output
 
    always @(posedge clkb_int)
       begin
         if (enb_int == 1'b1 )
            begin
              if (ssrb_int == 1'b1)
                 new_data_b_q <= 1'b0 ;
              else
                 // Do not update RDYB if write mode is no_change and web=1
                 //if (!(c_write_modeb == 2 && web_int == 1)) begin 
	         // rii1 : 10/20 Make dual port behavior the same as single port
                   new_data_b_q <= new_data_b ;
                 //end
            end 
       end





// Generate data outputs for Port B


    /***************************************************************
    *The following always block assigns the value for the DOUTB bus
    ***************************************************************/
    always @(posedge clkb_int) begin
	if (enb_int == 1'b1) begin
	    if (ssrb_int == 1'b1) begin
            //    for (bi = 0; bi < c_width_b; bi = bi + 1)
            //        dob_out[bi]  <= sinitb_value[bi];
                    dob_out  <= sinitb_value;
	    end
	    else begin
   	        //The following IF block assigns the output for a write operation
		if (web_int == 1'b1) begin
		    if (wr_mode_b == 2'b00) begin
                      if (addrb_int < c_depth_b)
                       // for (bj = 0; bj < c_width_b; bj = bj + 1)
                       //     dob_out[bj] <= dib_int[bj];
                            dob_out <= dib_int;
                      else begin
                        //Warning Condition (Error occurs on rising edge of CLKB): 
			//Write Mode PortB is "Write First" and ENB = 1 and SINITB = 0 and WEB = 1 and ADDRB out of the valid range
                        if (c_yydisable_warnings == 0) begin
		          $display("Invalid Address Warning #13: Warning in %m at time %t: Port B address %d (%b) of block memory invalid. Valid depth configured as 0 to %d",$time,addrb_int,addrb_int,c_depth_b-1);
                        end
                        dob_out <= {c_width_b{1'bX}};     //assign data bus to X
                      end
		    end
		    else if (wr_mode_b == 2'b01) begin
                      if (addrb_int < c_depth_b)
                       //  for (bk = 0; bk < c_width_b; bk = bk + 1)
                       //      dob_out[bk] <= mem[(addrb_int*c_width_b) + bk];
                             dob_out <= mem >> (addrb_int*c_width_b);
                      else begin
                        //Warning Condition (Error occurs on rising edge of CLKB): 
			//Write Mode PortB is "Read First" and ENB = 1 and SINITB = 0 and WEB = 1 and ADDRB out of the valid range
                        if (c_yydisable_warnings == 0) begin
		          $display("Invalid Address Warning #14: Warning in %m at time %t: Port B address %d (%b) of block memory invalid. Valid depth configured as 0 to %d",$time,addrb_int,addrb_int,c_depth_b-1);
                        end
                        dob_out <= {c_width_b{1'bX}};     //assign data bus to X
                      end
		    end
		    else begin
                      if (addrb_int < c_depth_b)
                         dob_out  <= dob_out ;
                      else begin
                        //Warning Condition (Error occurs on rising edge of CLKB): 
			//Write Mode PortB is "No Change" and ENB = 1 and SINITB = 0 and WEB = 1 and ADDRB out of the valid range
                        if (c_yydisable_warnings == 0) begin
		          $display("Invalid Address Warning #15: Warning in %m at time %t: Port B address %d (%b) of block memory invalid. Valid depth configured as 0 to %d",$time,addrb_int,addrb_int,c_depth_b-1);
                        end
                        dob_out <= {c_width_b{1'bX}};     //assign data bus to X
                      end
		    end
		end
	        //The following ELSE block assigns the output for a read operation
		else begin
                  if (addrb_int < c_depth_b)
                  //   for (bl = 0; bl < c_width_b; bl = bl + 1)
                   //      dob_out[bl] <= mem[(addrb_int*c_width_b) + bl];
                         dob_out <= mem >> (addrb_int*c_width_b);
                  else begin
		    if (c_has_doutb == 1)//New IF statement to remove read errors when port is write only
		      begin
			 //Warning Condition (Error occurs on rising edge of CLKB): 
			 //ENB = 1 and SINITB = 0 and WEB = 0 and ADDRB out of the valid range
                         if (c_yydisable_warnings == 0) begin
			   $display("Invalid Address Warning #16: Warning in %m at time %t: Port B address %d (%b) of block memory invalid. Valid depth configured as 0 to %d",$time,addrb_int,addrb_int,c_depth_b-1);
                         end
                         dob_out <= {c_width_b{1'bX}};    //assign data bus to X
		      end
		  end
		end 
	    end
	end
    end
    /***************************************************************************************
    *The following always block assigns the DINA bus to the memory during a write operation
    ***************************************************************************************/ 
    always @(posedge clkb_int) begin
	if (enb_int == 1'b1 && web_int == 1'b1) begin
          if (addrb_int < c_depth_b)
            for (bm = 0; bm < c_width_b; bm = bm + 1)
                 mem[(addrb_int*c_width_b) + bm]  <= dib_int[bm];
          else begin
            //Warning Condition (Error occurs on rising edge of CLKB): 
	    //ENB = 1 and WEB = 1 and ADDRB out of the valid range
            if (c_yydisable_warnings == 0) begin
	      $display("Invalid Address Warning #17: Warning in %m at time %t: Port B address %d (%b) of block memory invalid. Valid depth configured as 0 to %d",$time,addrb_int,addrb_int,c_depth_b-1);
            end
            dob_out <= {c_width_b{1'bX}};     // assign data bus to X
          end
	end
    end
   
  //  output pipelines for Port B

    always @(posedge clkb_int) begin
      if (enb_int == 1'b1 &&  c_pipe_stages_b > 0)
         begin
              for (j = c_pipe_stages_b; j >= 1; j = j -1 )
                begin
                  if (ssrb_int == 1'b1 && enb_int == 1'b1 )
                     begin
                       pipelineb[j] <= sinitb_value ;
                       sub_rdy_b[j] <= 0 ;
                     end
                  else
		   begin
		     // Do not change output when no_change and web=1  
//	             if (!(c_write_modeb == 2 && web_int == 1)) begin
	               if (j==1)
                   	 pipelineb[j] <= dob_out ;
		       else						  
                         pipelineb[j] <= pipelineb[j-1] ;
//		     end
 	             if (j==1)
                       sub_rdy_b[j] <= new_data_b_q ;
		     else						  
                       sub_rdy_b[j] <= sub_rdy_b[j-1] ;
		   end
              end
         end
    end 
   
// Select pipeline for B if c_pipe_stages_b > 0

    always @(pipelineb[c_pipe_stages_b] or sub_rdy_b[c_pipe_stages_b] or new_data_b_q or dob_out) begin
           if ( c_pipe_stages_b == 0 )
              begin
               doutb_out = dob_out ;
               rdyb_int = new_data_b_q;
              end
           else
              begin
               rdyb_int   = sub_rdy_b[c_pipe_stages_b];
               doutb_out  = pipelineb[c_pipe_stages_b];
              end
    end

 
// Select Port B data outputs based on c_has_doutb parameter
 
   always @(   doutb_out) begin
          if ( c_has_doutb == 1)
             doutb_mux_out = doutb_out ;
          else
             doutb_mux_out = 0 ;
   end
 

 


    specify

        // when both CLKA and CLKB are active on the positive edge
	$recovery (posedge CLKB, posedge CLKA &&& collision_posa_posb, 1, recovery_b);
	$recovery (posedge CLKA, posedge CLKB &&& collision_posa_posb, 1, recovery_a);

        // when both CLKA active on positive edge and CLKB are active on the negative edge
	$recovery (negedge CLKB, posedge CLKA &&& collision_posa_negb, 1, recovery_b);
	$recovery (posedge CLKA, negedge CLKB &&& collision_posa_negb, 1, recovery_a);

        // when both CLKA active on negative edge and CLKB are active on the positive edge
	$recovery (posedge CLKB, negedge CLKA &&& collision_nega_posb, 1, recovery_b);
	$recovery (negedge CLKA, posedge CLKB &&& collision_nega_posb, 1, recovery_a);

        // when both CLKA and CLKB are active on the negative edge
	$recovery (negedge CLKB, negedge CLKA &&& collision_nega_negb, 1, recovery_b);
	$recovery (negedge CLKA, negedge CLKB &&& collision_nega_negb, 1, recovery_a);

    endspecify

endmodule // BLKMEMDP_V6_3



//*********************************************************************************//
// **                    General Information                                    ** //
// ******************************************************************************* //
// **  Module     : LkupTbl1.v                                                  ** //     
// **  Project    : ISAAC NEWTON                                                ** //
// **  Date       : 2008-08-08                                                  ** //  
// **  Description: This is the sine/cosine lookup table for Channel 1.         ** //
// **               Center Frequency: 12.5MHz                                   ** //
// **               Sampling Frequency: 60MHz                                   ** //   
// **  Python file: LUT.py                                                      ** //                          
//*********************************************************************************//                           
`timescale 1 ns / 100 ps

module LkupTbl1 
  (//Outputs
  cosine,
  sine,
  //Input
  CLK,
  ARST,
  cntr
  );


//******************************************************************************//
//*                         Declarations                                       *//
//******************************************************************************//
// DATA TYPE - INPUTS AND OUTPUTS
output reg [15:0]        sine    ;
output reg [15:0]        cosine  ;

input                    CLK     ;
input                    ARST    ;
input      [4:0]         cntr    ;


//******************************************************************************//
//*                        Look-Up Table                                       *//
//******************************************************************************//
always @ (posedge CLK or posedge ARST)
if (ARST)
 begin
  sine   = 'b0000000000000000; // Reset to 0
  cosine = 'b0000000000000000; // Reset to 0
 end
else
 begin
 case (cntr)
  0: // theta=0.0000
    begin
      sine   = 'b0000000000000000; // 0.0000
      cosine = 'b0100000000000000; // 1.0000
    end
  1: // theta=1.3090
    begin
      sine   = 'b0011110111010001; // 0.9659
      cosine = 'b0001000010010000; // 0.2588
    end
  2: // theta=2.6180
    begin
      sine   = 'b0001111111111111; // 0.5000
      cosine = 'b1100100010010100; // -0.8660
    end
  3: // theta=3.9270
    begin
      sine   = 'b1101001010111111; // -0.7071
      cosine = 'b1101001010111111; // -0.7071
    end
  4: // theta=5.2360
    begin
      sine   = 'b1100100010010100; // -0.8660
      cosine = 'b0010000000000000; // 0.5000
    end
  5: // theta=0.2618
    begin
      sine   = 'b0001000010010000; // 0.2588
      cosine = 'b0011110111010001; // 0.9659
    end
  6: // theta=1.5708
    begin
      sine   = 'b0100000000000000; // 1.0000
      cosine = 'b0000000000000000; // 0.0000
    end
  7: // theta=2.8798
    begin
      sine   = 'b0001000010010000; // 0.2588
      cosine = 'b1100001000101111; // -0.9659
    end
  8: // theta=4.1888
    begin
      sine   = 'b1100100010010100; // -0.8660
      cosine = 'b1110000000000001; // -0.5000
    end
  9: // theta=5.4978
    begin
      sine   = 'b1101001010111111; // -0.7071
      cosine = 'b0010110101000001; // 0.7071
    end
  10: // theta=0.5236
    begin
      sine   = 'b0001111111111111; // 0.5000
      cosine = 'b0011011101101100; // 0.8660
    end
  11: // theta=1.8326
    begin
      sine   = 'b0011110111010001; // 0.9659
      cosine = 'b1110111101110000; // -0.2588
    end
  12: // theta=3.1416
    begin
      sine   = 'b0000000000000000; // 0.0000
      cosine = 'b1100000000000000; // -1.0000
    end
  13: // theta=4.4506
    begin
      sine   = 'b1100001000101111; // -0.9659
      cosine = 'b1110111101110000; // -0.2588
    end
  14: // theta=5.7596
    begin
      sine   = 'b1110000000000000; // -0.5000
      cosine = 'b0011011101101100; // 0.8660
    end
  15: // theta=0.7854
    begin
      sine   = 'b0010110101000001; // 0.7071
      cosine = 'b0010110101000001; // 0.7071
    end
  16: // theta=2.0944
    begin
      sine   = 'b0011011101101100; // 0.8660
      cosine = 'b1110000000000000; // -0.5000
    end
  17: // theta=3.4034
    begin
      sine   = 'b1110111101110000; // -0.2588
      cosine = 'b1100001000101111; // -0.9659
    end
  18: // theta=4.7124
    begin
      sine   = 'b1100000000000000; // -1.0000
      cosine = 'b0000000000000000; // -0.0000
    end
  19: // theta=6.0214
    begin
      sine   = 'b1110111101110000; // -0.2588
      cosine = 'b0011110111010001; // 0.9659
    end
  20: // theta=1.0472
    begin
      sine   = 'b0011011101101100; // 0.8660
      cosine = 'b0010000000000000; // 0.5000
    end
  21: // theta=2.3562
    begin
      sine   = 'b0010110101000001; // 0.7071
      cosine = 'b1101001010111111; // -0.7071
    end
  22: // theta=3.6652
    begin
      sine   = 'b1110000000000001; // -0.5000
      cosine = 'b1100100010010100; // -0.8660
    end
  23: // theta=4.9742
    begin
      sine   = 'b1100001000101111; // -0.9659
      cosine = 'b0001000010010000; // 0.2588
    end
  default:
    begin
      sine   = 'b0000000000000000; // 0
      cosine = 'b0000000000000000; // 0
    end
  endcase
 end

endmodule
//*********************************************************************************//           
// **                    General Information                                    ** //                           
// ******************************************************************************* //                           
// **  Module     : LkupTbl2.v                                                  ** //                               
// **  Project    : ISAAC NEWTON                                                ** // 
// **  Date       : 2008-08-08                                                  ** //                        
// **  Description: This is the sine/cosine lookup table for noise channel      ** //                           
// **               Center Frequency: 15MHz                                     ** //                             
// **               Sampling Frequency: 60MHz                                   ** //                           
// **  Python file: LUT.py                                                      ** //                                
//*********************************************************************************//                           
`timescale 1 ns / 100 ps

module LkupTbl2 
  (//Outputs
  cosine,
  sine,
  //Input
  CLK,
  ARST,
  cntr
  );


//******************************************************************************//
//*                         Declarations                                       *//
//******************************************************************************//
// DATA TYPE - INPUTS AND OUTPUTS
output reg [15:0]        sine    ;
output reg [15:0]        cosine  ;

input                    CLK     ;
input                    ARST    ;
input      [1:0]         cntr    ;


//******************************************************************************//
//*                        Look-Up Table                                       *//
//******************************************************************************//
always @ (posedge CLK or posedge ARST)
if (ARST)
 begin
  sine   = 'b0000000000000000; // Reset to 0
  cosine = 'b0000000000000000; // Reset to 0
 end
else
 begin
 case (cntr)
  0: // theta=0.0000
    begin
      sine   = 'b0000000000000000; // 0.0000
      cosine = 'b0100000000000000; // 1.0000
    end
  1: // theta=1.5708
    begin
      sine   = 'b0100000000000000; // 1.0000
      cosine = 'b0000000000000000; // 0.0000
    end
  2: // theta=3.1416
    begin
      sine   = 'b0000000000000000; // 0.0000
      cosine = 'b1100000000000000; // -1.0000
    end
  3: // theta=4.7124
    begin
      sine   = 'b1100000000000000; // -1.0000
      cosine = 'b0000000000000000; // -0.0000
    end
  default:
    begin
      sine   = 'b0000000000000000; // 0
      cosine = 'b0000000000000000; // 0
    end
  endcase
 end

endmodule
//*********************************************************************************//           
// **                    General Information                                    ** //                           
// ******************************************************************************* //                           
// **  Module     : LkupTbl3.v                                                  ** //                               
// **  Project    : ISAAC NEWTON                                                ** //
// **  Date       : 2008-08-08                                                  ** //                            
// **  Description: This is the sine/cosine lookup table for Channel 2.         ** //                           
// **               Center Frequency: 17.5MHz                                   ** //                             
// **               Sampling Frequency: 60MHz                                   ** //                           
// **  Python file: LUT.py                                                      ** //                                
//*********************************************************************************//                           
`timescale 1 ns / 100 ps

module LkupTbl3 
  (//Outputs
  cosine,
  sine,
  //Input
  CLK,
  ARST,
  cntr
  );


//******************************************************************************//
//*                         Declarations                                       *//
//******************************************************************************//
// DATA TYPE - INPUTS AND OUTPUTS
output reg [15:0]        sine    ;
output reg [15:0]        cosine  ;

input                    CLK     ;
input                    ARST    ;
input      [4:0]         cntr    ;


//******************************************************************************//
//*                        Look-Up Table                                       *//
//******************************************************************************//
always @ (posedge CLK or posedge ARST)
if (ARST)
 begin
  sine   = 'b0000000000000000; // Reset to 0
  cosine = 'b0000000000000000; // Reset to 0
 end
else
 begin
 case (cntr)
  0: // theta=0.0000
    begin
      sine   = 'b0000000000000000; // 0.0000
      cosine = 'b0100000000000000; // 1.0000
    end
  1: // theta=1.8326
    begin
      sine   = 'b0011110111010001; // 0.9659
      cosine = 'b1110111101110000; // -0.2588
    end
  2: // theta=3.6652
    begin
      sine   = 'b1110000000000001; // -0.5000
      cosine = 'b1100100010010100; // -0.8660
    end
  3: // theta=5.4978
    begin
      sine   = 'b1101001010111111; // -0.7071
      cosine = 'b0010110101000001; // 0.7071
    end
  4: // theta=1.0472
    begin
      sine   = 'b0011011101101100; // 0.8660
      cosine = 'b0010000000000000; // 0.5000
    end
  5: // theta=2.8798
    begin
      sine   = 'b0001000010010000; // 0.2588
      cosine = 'b1100001000101111; // -0.9659
    end
  6: // theta=4.7124
    begin
      sine   = 'b1100000000000000; // -1.0000
      cosine = 'b0000000000000000; // -0.0000
    end
  7: // theta=0.2618
    begin
      sine   = 'b0001000010010000; // 0.2588
      cosine = 'b0011110111010001; // 0.9659
    end
  8: // theta=2.0944
    begin
      sine   = 'b0011011101101100; // 0.8660
      cosine = 'b1110000000000001; // -0.5000
    end
  9: // theta=3.9270
    begin
      sine   = 'b1101001010111111; // -0.7071
      cosine = 'b1101001010111111; // -0.7071
    end
  10: // theta=5.7596
    begin
      sine   = 'b1110000000000000; // -0.5000
      cosine = 'b0011011101101100; // 0.8660
    end
  11: // theta=1.3090
    begin
      sine   = 'b0011110111010001; // 0.9659
      cosine = 'b0001000010010000; // 0.2588
    end
  12: // theta=3.1416
    begin
      sine   = 'b0000000000000000; // 0.0000
      cosine = 'b1100000000000000; // -1.0000
    end
  13: // theta=4.9742
    begin
      sine   = 'b1100001000101111; // -0.9659
      cosine = 'b0001000010010000; // 0.2588
    end
  14: // theta=0.5236
    begin
      sine   = 'b0001111111111111; // 0.5000
      cosine = 'b0011011101101100; // 0.8660
    end
  15: // theta=2.3562
    begin
      sine   = 'b0010110101000001; // 0.7071
      cosine = 'b1101001010111111; // -0.7071
    end
  16: // theta=4.1888
    begin
      sine   = 'b1100100010010100; // -0.8660
      cosine = 'b1110000000000000; // -0.5000
    end
  17: // theta=6.0214
    begin
      sine   = 'b1110111101110000; // -0.2588
      cosine = 'b0011110111010001; // 0.9659
    end
  18: // theta=1.5708
    begin
      sine   = 'b0100000000000000; // 1.0000
      cosine = 'b0000000000000000; // -0.0000
    end
  19: // theta=3.4034
    begin
      sine   = 'b1110111101110000; // -0.2588
      cosine = 'b1100001000101111; // -0.9659
    end
  20: // theta=5.2360
    begin
      sine   = 'b1100100010010100; // -0.8660
      cosine = 'b0001111111111111; // 0.5000
    end
  21: // theta=0.7854
    begin
      sine   = 'b0010110101000001; // 0.7071
      cosine = 'b0010110101000001; // 0.7071
    end
  22: // theta=2.6180
    begin
      sine   = 'b0010000000000000; // 0.5000
      cosine = 'b1100100010010100; // -0.8660
    end
  23: // theta=4.4506
    begin
      sine   = 'b1100001000101111; // -0.9659
      cosine = 'b1110111101110000; // -0.2588
    end
  default:
    begin
      sine   = 'b0000000000000000; // 0
      cosine = 'b0000000000000000; // 0
    end
  endcase
 end

endmodule
// ******************************************************************************* //
// **                    General Information                                    ** //
// ******************************************************************************* //
// **  Module             : MAC1.v                                              ** //
// **  Project            : ISAAC Newton                                        ** //
// **  Author             : Kayla Nguyen                                        ** //
// **  First Release Date : August 13, 2008                                     ** //
// **  Description        : Multiplier-Accumulator Module                       ** //
// ******************************************************************************* //
// **                     Revision History                                      ** //
// ******************************************************************************* //
// **                                                                           ** //
// **  File        : MAC1.v                                                     ** //
// **  Revision    : 1                                                          ** //
// **  Author      : kaylangu                                                   ** //
// **  Date        : August 13, 2008                                            ** //
// **  Notes       : Initial Release for ISAAC demo                             ** //
// **                                                                           ** //
// ******************************************************************************* //
`timescale 1 ns / 100 ps

module MAC1
  (// Inputs
   CLK             ,   // Clock
   ARST            ,   // Reset
   filterCoef      ,   // Filter Coeficients
   InData          ,   // Input Data
   input_Valid     ,   // Input Valid
   initialize      ,   // Initialize
   // Outputs
   OutData         ,   // Output Data
   output_Valid        // Output Valid
   );


   //**************************************************************************//
   //*                         Declarations                                   *//
   //**************************************************************************//
   // DATA TYPE - PARAMETERS
   parameter IWIDTH    = 16;   // Input bit width
   parameter OWIDTH    = 32;   // Output bit width
   parameter AWIDTH    = 32;   // Internal bit width
   parameter NTAPS     = 15;   // Total number of taps including zeros
   parameter NTAPSr    = 15;   // Real number of taps in the filter
   parameter CNTWIDTH  = 4 ;   // Count bit width, depends on number of taps
   parameter NMULT     = 1 ;   // Number of clocks it takes for multiplier 
                               // to generate an answer

   // DATA TYPE - INPUTS AND OUTPUTS
   input                               CLK                     ;  // 60MHz Clock
   input                               ARST                    ;
   input                               input_Valid             ;
   input                               initialize              ;
   input   signed [(IWIDTH-1):0]       InData, filterCoef      ;
   output  signed [(OWIDTH-1):0]       OutData                 ;
   output                              output_Valid            ;

   // DATA TYPE - REGISTERS
   reg     signed [(AWIDTH-1):0]       mult, accum             ;
   reg                                 input_Valid0            ;
   reg                                 initialize1             ;

   reg                                 output_Valid_1          ;

   wire                                output_Valid            ;
   reg            [CNTWIDTH-1:0]       count                   ;

   // DATA TYPE - WIRES
   wire    signed [(AWIDTH-1):0]       accum_tmp               ;
   wire           [CNTWIDTH-1:0]       taps                    ;


   assign  taps = (NTAPS == NTAPSr) ? 0: (NTAPS - NTAPS + NTAPSr) ;


   //**************************************************************************//
   //*                         Input Buffers                                  *//
   //**************************************************************************//
   always @(posedge CLK or posedge ARST)
     if (ARST)     input_Valid0 <=  1'b0 ;
     else          input_Valid0 <=  input_Valid ;
   
   always @(posedge CLK or posedge ARST)
     if (ARST)     initialize1 <=  1'b0 ;
     else          initialize1 <=  initialize ;
   
   
   //**************************************************************************//
   //*                         Multiply-Accumulate                            *//
   //**************************************************************************//
   // Multiplier
   always @(posedge CLK or posedge ARST)
     if (ARST)     mult[(AWIDTH-1):0] <=  {(AWIDTH-1){1'b0}} ;
     else          mult[(AWIDTH-1):0] <=  filterCoef*InData  ;
   
   assign  accum_tmp[(AWIDTH-1):0] =   mult[(AWIDTH-1):0] + accum[(AWIDTH-1):0];
    
   // Accumulator
   always @(posedge CLK or posedge ARST)// or initialize)
     if (ARST)     accum[(OWIDTH-1):0] <=  {(OWIDTH){1'b0}} ;
     else          accum[(OWIDTH-1):0] <= (initialize1) ?
                                          mult[(AWIDTH-1):0] :
                                          (input_Valid0 ? accum_tmp[(AWIDTH-1):0]
                                           : accum[(AWIDTH-1):0]) ;
   
   
   //**************************************************************************//
   //*                            Counters                                    *//
   //**************************************************************************//
   always @ (posedge CLK or posedge ARST)
     if (ARST)     count[CNTWIDTH-1:0] <=  {(CNTWIDTH){1'b0}}  ;
     else          count[CNTWIDTH-1:0] <= initialize ?
                                          0 :
                                          input_Valid0 + count[CNTWIDTH-1:0] ;


   //**************************************************************************//
   //*                           Output Buffers                               *//
   //**************************************************************************//
   always @(posedge CLK or posedge ARST)
     if (ARST)     output_Valid_1 <=  1'b0 ;
     else          output_Valid_1 <=  (count[CNTWIDTH-1:0]==(NTAPSr-1+NMULT-1))   ;
   
   assign  output_Valid            = output_Valid_1 & (count[CNTWIDTH-1:0]==taps) ;
   assign  OutData[(OWIDTH-1):0]   = accum[(OWIDTH-1):0]                          ;
   
   
endmodule //MAC1// ******************************************************************************* //
// **                    General Information                                    ** //
// ******************************************************************************* //
// **  Module             : QM.v                                                ** //
// **  Project            : ISAAC NEWTON                                        ** //
// **  Author             : Kayla Nguyen                                        ** //
// **  First Release Date : August 13, 2008                                     ** //
// **  Description        : Quadrature Modulation.                              ** //
// **                       Using sin/cos look up table.                        ** //
// ******************************************************************************* //
// **                     Revision History                                      ** //
// ******************************************************************************* //
// **                                                                           ** //
// **  File        : QM.v                                                       ** //
// **  Revision    : 1                                                          ** //
// **  Author      : kaylangu                                                   ** //
// **  Date        : August 13, 2008                                            ** //
// **  FileName    :                                                            ** //
// **  Notes       : Initial Release for ISAAC demo                             ** //
// **                                                                           ** //
// ******************************************************************************* //
`timescale 1 ns / 100 ps

module QM
  (// Inputs
   CLK        ,
   ARST       ,
   Sync       ,
   Constant   ,
   InputValid ,
   //Outputs
   Real1      ,
   Imag1      ,
   Real2      ,
   Imag2      ,
   Real3      ,
   Imag3      ,
   OutputValid
   //   tp_1     //To print out QM output, use this as the DataValid
   );


   //**************************************************************************//
   //*                         Declarations                                   *//
   //**************************************************************************//
   // DATA TYPE - PARAMETERS
   parameter                OWIDTH        = 16 ; // output bit width
   parameter                IWIDTH        = 16 ; // input bit width
   parameter                MAXCNT1       = 23 ; // Counter up to repeating for ch1&2
   parameter                MAXCNT2       = 3  ; // Counter up to repeating for ch3
   parameter                CNTWIDTH1     = 5  ; // counter bit width for ch1 & ch2
   parameter                CNTWIDTH2     = 2  ; // counter bit width for ch3 (noise)

   // DATA TYPE - INPUTS AND OUTPUTS
   input       signed [IWIDTH-1:0] Constant      ;
   input                           CLK           ;
   input                           ARST          ;
   input                           InputValid    ;
   input                           Sync          ;
      
   output reg signed [OWIDTH-1:0]  Real1         ;
   output reg signed [OWIDTH-1:0]  Real2         ;
   output reg signed [OWIDTH-1:0]  Real3         ;
   output reg signed [OWIDTH-1:0]  Imag1         ;
   output reg signed [OWIDTH-1:0]  Imag2         ;
   output reg signed [OWIDTH-1:0]  Imag3         ;
   
   output reg                      OutputValid   ;
   //   output                     tp_1          ;  // only used to print results from
                                                    // test bench
   
   // DATA TYPE - REGISTERS
   reg [CNTWIDTH1-1:0]             counter1    ;
   reg [CNTWIDTH2-1:0]             counter2    ;
   
   reg        signed [IWIDTH-1:0]  Constant1   ;
   reg                             OutputValid1;
   
   // DATA TYPE - WIRES
   wire       signed [31:0]        Real_1      ;
   wire       signed [31:0]        Real_2      ;
   wire       signed [31:0]        Real_3      ;
   wire       signed [31:0]        Imag_1      ;
   wire       signed [31:0]        Imag_2      ;
   wire       signed [31:0]        Imag_3      ;
   
   
   wire       signed [15:0]        Cosine1     ;
   wire       signed [15:0]        Cosine2     ;
   wire       signed [15:0]        Cosine3     ;
   wire       signed [15:0]        Sine1       ;
   wire       signed [15:0]        Sine2       ;
   wire       signed [15:0]        Sine3       ;
   
   
   //**************************************************************************//
   //*                           Counters                                     *//
   //**************************************************************************//
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       begin
          counter1[CNTWIDTH1-1:0] <= {(CNTWIDTH1){1'b0}};
          counter2[CNTWIDTH2-1:0] <= {(CNTWIDTH2){1'b0}};
       end
     else if (Sync)
       begin
	  counter1[CNTWIDTH1-1:0] <= {(CNTWIDTH1){1'b0}};
	  counter2[CNTWIDTH2-1:0] <= {(CNTWIDTH2){1'b0}};
       end
     else
       begin
          counter1[CNTWIDTH1-1:0] <= InputValid ?
                                     (counter1[CNTWIDTH1-1:0] == MAXCNT1) ? 0
                                     : (counter1[CNTWIDTH1-1:0] + 1)
                                       : counter1[CNTWIDTH1-1:0];
          counter2[CNTWIDTH2-1:0] <= InputValid ?
                                     (counter2[CNTWIDTH2-1:0] == MAXCNT2) ? 0
                                     : (counter2[CNTWIDTH2-1:0] + 1)
                                       : counter2[CNTWIDTH2-1:0];
       end
   
   
   //**************************************************************************//
   //*                        Output Buffers                                  *//
   //**************************************************************************//
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       begin
          OutputValid     <= 1'b0 ;
          OutputValid1    <= 1'b0 ;
          Constant1[15:0] <= 16'sb0000_0000_0000_0000 ;
       end
     else
       begin
          OutputValid     <= OutputValid1 ;
          OutputValid1    <= InputValid ;
          Constant1[15:0] <= Constant[15:0] ;
       end
   
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       begin
          Real1[15:0] <= {(16){1'b0}} ;
          Imag1[15:0] <= {(16){1'b0}} ;
          Real2[15:0] <= {(16){1'b0}} ;
          Imag2[15:0] <= {(16){1'b0}} ;
          Real3[15:0] <= {(16){1'b0}} ;
          Imag3[15:0] <= {(16){1'b0}} ;
       end
     else
       begin
          Real1[15:0] <= Real_1[29:14];
          Imag1[15:0] <= Imag_1[29:14];
          Real2[15:0] <= Real_2[29:14];
          Imag2[15:0] <= Imag_2[29:14];
          Real3[15:0] <= Real_3[29:14];
          Imag3[15:0] <= Imag_3[29:14];
       end
   
   assign Real_1[31:0] = Cosine1 * Constant1 ;
   assign Imag_1[31:0] = Sine1 * Constant1   ;
   assign Real_2[31:0] = Cosine2 * Constant1 ;
   assign Imag_2[31:0] = Sine2 * Constant1   ;
   assign Real_3[31:0] = Cosine3 * Constant1 ;
   assign Imag_3[31:0] = Sine3 * Constant1   ;
   assign tp_1         = OutputValid1        ;
   
   
   
   //**************************************************************************//
   //*                            Submodules                                  *//
   //**************************************************************************//
   LkupTbl1 LkupTbl1      // Channel1 Sin/Cos Table Lookup
     (.cntr   (counter1), // Bus [9 : 0]
      .CLK    (CLK),
      .ARST   (ARST),
      .sine   (Sine1),    // Bus [15 : 0]
      .cosine (Cosine1)   // Bus [15:0]
      );

   LkupTbl2 LkupTbl2      // Noise Sin/Cos Table Lookup
     (.cntr   (counter2), // Bus [9 : 0]
      .CLK    (CLK),
      .ARST   (ARST),
      .sine   (Sine2),    // Bus [15 : 0]
      .cosine (Cosine2)   // Bus [15:0]
      );

   LkupTbl3 LkupTbl3      // Channel2 Sin/Cos Table Lookup
     (.cntr   (counter1), // Bus [9 : 0]
      .CLK    (CLK),
      .ARST   (ARST),
      .sine   (Sine3),    // Bus [15 : 0]
      .cosine (Cosine3)   // Bus [15:0]
      );


endmodule // QM
// ******************************************************************************* //
// **                    General Information                                    ** //
// ******************************************************************************* //
// **  Module             : QM_FIR.v                                            ** //
// **  Project            : ISAAC NEWTON                                        ** //
// **  Original Author    : Kayla Nguyen                                        ** //
// **  First Release Date : August 13, 2008                                     ** //
// **  Description        : Quadrature Modulation and Polyphase Decimation.     ** //
// **                       This module gives both the real part and the        ** //
// **                       ofimaginary part  the along with their polyphase    ** //
// **                       decimation.                                         ** //
// ******************************************************************************* //
// **                     Revision History                                      ** //
// ******************************************************************************* //
// **                                                                           ** //
// **  File        : QM_FIR.v                                                   ** //
// **  Revision    : 1                                                          ** //
// **  Author      : kaylangu                                                   ** //
// **  Date        : August 13, 2008                                            ** //
// **  FileName    :                                                            ** //
// **  Notes       : Initial Release for ISAAC demo                             ** //
// **                                                                           ** //
// ******************************************************************************* //
`timescale 1 ns / 100 ps

module QM_FIR
  (//Inputs
   CLK        ,
   ARST       ,
   Sync       ,
   Constant   ,
   InputValid ,
   //Ouputs
   RealOut1   ,
   ImagOut1   ,
   RealOut2   ,
   ImagOut2   ,
   RealOut3   ,
   ImagOut3   ,
   DataValid_R,
   DataValid_I
   );


   //*****************************************************************************//
   //*                        Declarations                                       *//
   //*****************************************************************************//
   // DATA TYPE - INPUTS AND OUTPUTS
   output signed [15:0] RealOut1, RealOut2, RealOut3;
   output signed [15:0] ImagOut1, ImagOut2, ImagOut3;
   output               DataValid_R;
   output               DataValid_I;
   
   
   input signed [15:0]  Constant;
   input                CLK;
   input                ARST;
   input                Sync;
   input                InputValid;
   
   // DATA TYPE - WIRES
   wire                 OutputValid_QM;
   wire signed [15:0]   Real1, Real2, Real3;
   wire signed [15:0]   Imag1, Imag2, Imag3;
   

   //*****************************************************************************//
   //*                           Submodules                                      *//
   //*****************************************************************************//
   //Quadrature Modulation
   QM QM
     (//Inputs
      .CLK         (CLK),
      .ARST        (ARST),
      .Sync        (Sync),
      .Constant    (Constant),
      .InputValid  (InputValid),
      //Outputs
      .Real1       (Real1),        // Channel1 Real
      .Imag1       (Imag1),        // Channel1 Imag
      .Real2       (Real2),        // Noise Channel Real
      .Imag2       (Imag2),        // Noise Channel Imag
      .Real3       (Real3),        // Channel2 Real
      .Imag3       (Imag3),        // Channel2 Imag
      .OutputValid (OutputValid_QM)
      //.tp_1(tp_1)      // To print out QM output, use this as the DataValid
      );

   //Firdecim 1st channel Real Filter
   firdecim firdecimR1
     (//Inputs
      .CLK         (CLK),
      .ARST        (ARST),
      .Sync        (Sync),
      .InputValid  (OutputValid_QM),
      .SigIn       (Real1),
      //Outputs
      .SigOut      (RealOut1),
      .DataValid   (DataValid_R)
      );

   //Firdecim 1st channel Imaginary Filter
   firdecim firdecimI1
     (//Inputs
      .CLK         (CLK),
      .ARST        (ARST),
      .Sync        (Sync),
      .InputValid  (OutputValid_QM),
      .SigIn       (Imag1),
      //Outputs
      .SigOut      (ImagOut1),
      .DataValid   (DataValid_I)
      );

   //Firdecim noise channel Real Filter
   firdecim firdecimR2
     (//Inputs
      .CLK         (CLK),
      .ARST        (ARST),
      .Sync        (Sync),
      .InputValid  (OutputValid_QM),
      .SigIn       (Real2),
      //Outputs
      .SigOut      (RealOut2)
      //.DataValid   (DataValid_R)
      );

   //Firdecim noise channel Imaginary Filter
   firdecim firdecimI2
     (//Inputs
      .CLK         (CLK),
      .ARST        (ARST),
      .Sync        (Sync),
      .InputValid  (OutputValid_QM),
      .SigIn       (Imag2),
      //Outputs
      .SigOut      (ImagOut2)
      //.DataValid   (DataValid_I)
      );

   //Firdecim 2nd channel Real Filter
   firdecim firdecimR3
     (//Inputs
      .CLK         (CLK),
      .ARST        (ARST),
      .Sync        (Sync),
      .InputValid  (OutputValid_QM),
      .SigIn       (Real3),
      //Outputs
      .SigOut      (RealOut3)
      //.DataValid   (DataValid_R)
      );

   //Firdecim 2nd channel Imaginary Filter
   firdecim firdecimI3
     (//Inputs
      .CLK         (CLK),
      .ARST        (ARST),
      .Sync        (Sync),
      .InputValid  (OutputValid_QM),
      .SigIn       (Imag3),
      //Outputs
      .SigOut      (ImagOut3)
      //.DataValid   (DataValid_I)
      );


endmodule // QM_FIR

// ******************************************************************************* //
// **                    General Information                                    ** //
// ******************************************************************************* //
// **  Module             : firdecim.v                                          ** //
// **  Project            : ISAAC NEWTON                                        ** //
// **  Author             : Kayla Nguyen                                        ** //
// **  First Release Date : August 13, 2008                                     ** //
// **  Description        : Polyphase Decimation Filter: 3 stages.              ** //
// **                       FIRDECIM1: M = 5, L = 15                            ** //
// **                       FIRDECIM1: M = 5, L = 20                            ** //
// **                       FIRDECIM1: M = 2, L = 50                            ** //
// ******************************************************************************* //
// **                     Revision History                                      ** //
// ******************************************************************************* //
// **                                                                           ** //
// **  File        : firdecim.v                                                 ** //
// **  Revision    : 1                                                          ** //
// **  Author      : kaylangu                                                   ** //
// **  Date        : August 13, 2008                                            ** //
// **  FileName    :                                                            ** //
// **  Notes       : Initial Release for ISAAC demo                             ** //
// **                                                                           ** //
// ******************************************************************************* //
`timescale 1 ns / 100 ps

module firdecim
  (//Outputs
   SigOut,   // Third Stage Output
   DataValid,// Third Stage DataValid
   //Inputs
   CLK,
   ARST,
   InputValid,
   Sync,
   SigIn
   );

   
   //******************************************************************************//
   //*                     Declarations                                           *//
   //******************************************************************************//
   //DATA TYPE - INPUTS AND OUTPUTS
   output signed [15:0] SigOut ;
   output               DataValid;

   input                CLK;
   input                ARST;
   input                Sync;
   input                InputValid;
   input signed [15:0]  SigIn;

   // DATA TYPE - WIRES
   wire signed [31:0]   SigOut1, SigOut_tmp, SigOut2;


   //******************************************************************************//
   //*                    Output Buffers                                          *//
   //******************************************************************************//
   assign SigOut[15:0] = SigOut_tmp[29:14];


   //******************************************************************************//
   //*                    Submodules                                              *//
   //******************************************************************************//
   // First firdecim filter
   firdecim_m5_n15 firdecim1
     (//Inputs
      .CLK        (CLK),
      .ARST       (ARST),
      .Sync       (Sync),
      .InputValid (InputValid),
      .SigIn      (SigIn),
      //Outputs
      .DataValid  (DataValid1),
      .SigOut     (SigOut1)
      );

   // Second firdecim filter
   firdecim_m5_n20 firdecim2
     (// Inputs
      .CLK        (CLK),
      .ARST       (ARST),
      .Sync       (Sync),
      .InputValid (DataValid1),
      .SigIn      (SigOut1[29:14]),
      // Outputs
      .DataValid  (DataValid2),
      .SigOut     (SigOut2[31:0])
      );

   // Third firdecim filter
   firdecim_m2_n50 firdecim3
     (// Inputs
      .CLK        (CLK),
      .ARST       (ARST),
      .Sync       (Sync),
      .InputValid (DataValid2),
      .SigIn      (SigOut2[29:14]),
      // Outputs
      .DataValid  (DataValid),
      .SigOut     (SigOut_tmp[31:0])
      );


endmodule // firdecim
// ******************************************************************************* //
// **                    General Information                                    ** //
// ******************************************************************************* //
// **  Module             : firdecim_m2_n50.v                                   ** //
// **  Project            : ISAAC Newton                                        ** //
// **  Author             : Kayla Nguyen                                        ** //
// **  First Release Date : August 13, 2008                                     ** //
// **  Description        : Polyphase Decimation Filter                         ** //
// **                       M = 2, L = 50                                       ** //
// ******************************************************************************* //
// **                     Revision History                                      ** //
// ******************************************************************************* //
// **                                                                           ** //
// **  File        : firdecim_m2_n50.v                                          ** //
// **  Revision    : 1                                                          ** //
// **  Author      : kaylangu                                                   ** //
// **  Date        : August 13, 2008                                            ** //
// **  FileName    :                                                            ** //
// **  Notes       : Initial Release for ISAAC demo                             ** //
// **                                                                           ** //
// ******************************************************************************* //
`timescale 1 ns / 100 ps

module firdecim_m2_n50
  (// Input
   CLK,
   ARST,
   Sync,
   InputValid,
   SigIn,
   // Output
   DataValid,
   SigOut
   );


   //**************************************************************************//
   //*                     Declarations                                       *//
   //**************************************************************************//
   // DATA TYPE - PARAMETERS
   parameter                 e49 = 16'sb0000_0000_0010_1001;
   parameter                 e48 = 16'sb0000_0000_0001_0010;
   parameter                 e47 = 16'sb1111_1111_1010_0000;
   parameter                 e46 = 16'sb1111_1111_0011_1100;

   parameter                 e45 = 16'sb1111_1111_1000_1011;
   parameter                 e44 = 16'sb0000_0000_0100_1010;
   parameter                 e43 = 16'sb0000_0000_0110_1011;
   parameter                 e42 = 16'sb1111_1111_1010_1110;

   parameter                 e41 = 16'sb1111_1111_0100_1101;
   parameter                 e40 = 16'sb0000_0000_0010_0000;
   parameter                 e39 = 16'sb0000_0000_1110_1110;
   parameter                 e38 = 16'sb0000_0000_0010_1101;

   parameter                 e37 = 16'sb1111_1110_1101_1101;
   parameter                 e36 = 16'sb1111_1111_0101_1000;
   parameter                 e35 = 16'sb0000_0001_0011_1100;
   parameter                 e34 = 16'sb0000_0001_0101_0100;

   parameter                 e33 = 16'sb1111_1110_1101_1011;
   parameter                 e32 = 16'sb1111_1101_1100_0101;
   parameter                 e31 = 16'sb0000_0000_1011_1100;
   parameter                 e30 = 16'sb0000_0011_0111_1011;

   parameter                 e29 = 16'sb0000_0000_0100_1000;
   parameter                 e28 = 16'sb1111_1010_0111_0101;
   parameter                 e27 = 16'sb1111_1100_1111_1001;
   parameter                 e26 = 16'sb0000_1011_1000_1111;

   parameter                 e25 = 16'sb0001_1010_0110_0111;
   parameter                 e24 = 16'sb0001_1010_0110_0111;

   parameter                 e23 = 16'sb0000_1011_1000_1111;
   parameter                 e22 = 16'sb1111_1100_1111_1001;
   parameter                 e21 = 16'sb1111_1010_0111_0101;
   parameter                 e20 = 16'sb0000_0000_0100_1000;

   parameter                 e19 = 16'sb0000_0011_0111_1011;
   parameter                 e18 = 16'sb0000_0000_1011_1100;
   parameter                 e17 = 16'sb1111_1101_1100_0101;
   parameter                 e16 = 16'sb1111_1110_1101_1011;

   parameter                 e15 = 16'sb0000_0001_0101_0100;
   parameter                 e14 = 16'sb0000_0001_0011_1100;
   parameter                 e13 = 16'sb1111_1111_0101_1000;
   parameter                 e12 = 16'sb1111_1110_1101_1101;

   parameter                 e11 = 16'sb0000_0000_0010_1101;
   parameter                 e10 = 16'sb0000_0000_1110_1110;
   parameter                 e9  = 16'sb0000_0000_0010_0000;
   parameter                 e8  = 16'sb1111_1111_0100_1101;

   parameter                 e7  = 16'sb1111_1111_1010_1110;
   parameter                 e6  = 16'sb0000_0000_0110_1011;
   parameter                 e5  = 16'sb0000_0000_0100_1010;
   parameter                 e4  = 16'sb1111_1111_1000_1011;

   parameter                 e3  = 16'sb1111_1111_0011_1100;
   parameter                 e2  = 16'sb1111_1111_1010_0000;
   parameter                 e1  = 16'sb0000_0000_0001_0010;
   parameter                 e0  = 16'sb0000_0000_0010_1001;

   parameter                 OWIDTH = 32       ; // output bit width
   parameter                 IWIDTH = 16       ; // input bit width
   parameter                 AWIDTH = 32       ; // internal bit width
   parameter                 NTAPS  = 50       ; // number of filter taps
   parameter                 ACCUMCNTWIDTH = 5 ; // accumulator count bit width
   parameter                 CNTWIDTH = 6      ; // counter bit width
   parameter                 NACCUM = 25       ; // numbers of accumulators

   // DATA TYPE - INPUTS AND OUTPUTS
   output reg signed [OWIDTH-1:0]  SigOut      ;
   output reg                      DataValid   ;
   
   input                           CLK         ; // 60MHz Clock
   input                           ARST        ;
   input                           InputValid  ;
   input      signed [IWIDTH-1:0]  SigIn       ;
   input                           Sync        ;
      
   // DATA TYPE - REGISTERS
   reg signed [IWIDTH-1:0]         coe49       ;
   reg signed [IWIDTH-1:0]         coe48       ;
   reg signed [IWIDTH-1:0]         coe47       ;
   reg signed [IWIDTH-1:0]         coe46       ;
   reg signed [IWIDTH-1:0]         coe45       ;
   reg signed [IWIDTH-1:0]         coe44       ;
   reg signed [IWIDTH-1:0]         coe43       ;
   reg signed [IWIDTH-1:0]         coe42       ;
   reg signed [IWIDTH-1:0]         coe41       ;
   reg signed [IWIDTH-1:0]         coe40       ;

   reg signed [IWIDTH-1:0]         coe39       ;
   reg signed [IWIDTH-1:0]         coe38       ;
   reg signed [IWIDTH-1:0]         coe37       ;
   reg signed [IWIDTH-1:0]         coe36       ;
   reg signed [IWIDTH-1:0]         coe35       ;
   reg signed [IWIDTH-1:0]         coe34       ;
   reg signed [IWIDTH-1:0]         coe33       ;
   reg signed [IWIDTH-1:0]         coe32       ;
   reg signed [IWIDTH-1:0]         coe31       ;
   reg signed [IWIDTH-1:0]         coe30       ;

   reg signed [IWIDTH-1:0]         coe29       ;
   reg signed [IWIDTH-1:0]         coe28       ;
   reg signed [IWIDTH-1:0]         coe27       ;
   reg signed [IWIDTH-1:0]         coe26       ;
   reg signed [IWIDTH-1:0]         coe25       ;
   reg signed [IWIDTH-1:0]         coe24       ;
   reg signed [IWIDTH-1:0]         coe23       ;
   reg signed [IWIDTH-1:0]         coe22       ;
   reg signed [IWIDTH-1:0]         coe21       ;
   reg signed [IWIDTH-1:0]         coe20       ;

   reg signed [IWIDTH-1:0]         coe19       ;
   reg signed [IWIDTH-1:0]         coe18       ;
   reg signed [IWIDTH-1:0]         coe17       ;
   reg signed [IWIDTH-1:0]         coe16       ;
   reg signed [IWIDTH-1:0]         coe15       ;
   reg signed [IWIDTH-1:0]         coe14       ;
   reg signed [IWIDTH-1:0]         coe13       ;
   reg signed [IWIDTH-1:0]         coe12       ;
   reg signed [IWIDTH-1:0]         coe11       ;
   reg signed [IWIDTH-1:0]         coe10       ;

   reg signed [IWIDTH-1:0]         coe9        ;
   reg signed [IWIDTH-1:0]         coe8        ;
   reg signed [IWIDTH-1:0]         coe7        ;
   reg signed [IWIDTH-1:0]         coe6        ;
   reg signed [IWIDTH-1:0]         coe5        ;
   reg signed [IWIDTH-1:0]         coe4        ;
   reg signed [IWIDTH-1:0]         coe3        ;
   reg signed [IWIDTH-1:0]         coe2        ;
   reg signed [IWIDTH-1:0]         coe1        ;
   reg signed [IWIDTH-1:0]         coe0        ;

   reg        [CNTWIDTH-1:0]       count       ;
   reg        [CNTWIDTH-1:0]       count1      ;
   reg        [ACCUMCNTWIDTH-1:0]  accum_cnt   ;  //Counter to keep track of which 
                                                  //accumulator is being accessed.

   reg                             InputValid0 ;
   reg                             InputValid1;
   
   reg signed [IWIDTH-1:0]         SigIn1      ;
   reg signed [IWIDTH-1:0]         SigIn2      ;
   
   reg signed [AWIDTH-1:0]         mult        ;
   
   reg signed [AWIDTH-1:0]         accum1      ;  //First accumulator
   reg signed [AWIDTH-1:0]         accum2      ;  //Second accumulator
   reg signed [AWIDTH-1:0]         accum3      ;  //Rhird accumulator
   reg signed [AWIDTH-1:0]         accum4      ;  //Fourth accumulator
   reg signed [AWIDTH-1:0]         accum5      ;  //Fifth accumulator
   reg signed [AWIDTH-1:0]         accum6      ;  //Sixth accumulator
   reg signed [AWIDTH-1:0]         accum7      ;  //Seventh accumulator
   reg signed [AWIDTH-1:0]         accum8      ;  //Eigth accumulator
   reg signed [AWIDTH-1:0]         accum9      ;  //Ninth accumulator
   reg signed [AWIDTH-1:0]         accum10     ;  //Tenth accumulator
   reg signed [AWIDTH-1:0]         accum11     ;  //Eleventh accumulator
   reg signed [AWIDTH-1:0]         accum12     ;  //Twelve accumulator
   reg signed [AWIDTH-1:0]         accum13     ;  //Thirteenth accumulator
   reg signed [AWIDTH-1:0]         accum14     ;  //Fourteenth accumulator
   reg signed [AWIDTH-1:0]         accum15     ;  //Fifteenth accumulator
   reg signed [AWIDTH-1:0]         accum16     ;  //Sixteenth accumulator
   reg signed [AWIDTH-1:0]         accum17     ;  //Seventeenth accumulator
   reg signed [AWIDTH-1:0]         accum18     ;  //Eighteenth accumulator
   reg signed [AWIDTH-1:0]         accum19     ;  //Ninteenth accumulator
   reg signed [AWIDTH-1:0]         accum20     ;  //20th accumulator
   reg signed [AWIDTH-1:0]         accum21     ;  //21st accumulator
   reg signed [AWIDTH-1:0]         accum22     ;  //22nd accumulator
   reg signed [AWIDTH-1:0]         accum23     ;  //23rd accumulator
   reg signed [AWIDTH-1:0]         accum24     ;  //24th accumulator
   reg signed [AWIDTH-1:0]         accum25     ;  //25th accumulator

   reg signed [IWIDTH-1:0]         coef1       ;
   reg signed [IWIDTH-1:0]         coef2       ;
   reg signed [IWIDTH-1:0]         coef3       ;
   reg signed [IWIDTH-1:0]         coef4       ;
   reg signed [IWIDTH-1:0]         coef        ;
   
   reg [ACCUMCNTWIDTH-1:0]         accum_cnt1  ;
   
   // DATA TYPE - WIRES
   wire                            valid       ;
   wire                            valid1      ;
   wire                            valid2      ;
   wire                            valid3      ;
   wire                            valid4      ;
   wire                            valid5      ;
   wire                            valid6      ;
   wire                            valid7      ;
   wire                            valid8      ;
   wire                            valid9      ;
   wire                            valid10     ;
   wire                            valid11     ;
   wire                            valid12     ;
   wire                            valid13     ;
   wire                            valid14     ;
   wire                            valid15     ;
   wire                            valid16     ;
   wire                            valid17     ;
   wire                            valid18     ;
   wire                            valid19     ;
   wire                            valid20     ;
   wire                            valid21     ;
   wire                            valid22     ;
   wire                            valid23     ;
   wire                            valid24     ;
   wire                            valid25     ;
   
   
   //**************************************************************************//
   //*                      Input Buffers                                     *//
   //**************************************************************************//
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       begin
          InputValid0 <= 1'b0 ;
          InputValid1 <= 1'b0 ;
       end
     else
       begin
          InputValid0 <= InputValid1;
          InputValid1 <= InputValid ;
       end
   
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       begin
          SigIn1[IWIDTH-1:0] <= {(IWIDTH){1'b0}} ;
          SigIn2[IWIDTH-1:0] <= {(IWIDTH){1'b0}};
       end
     else
       begin
          SigIn2[IWIDTH-1:0] <= SigIn[IWIDTH-1:0];
          SigIn1[IWIDTH-1:0] <= SigIn2[IWIDTH-1:0];
       end
   
   
   //**************************************************************************//
   //*                 Coefficient Rotation / Selector                        *//
   //**************************************************************************//
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       coef1[IWIDTH-1:0] <= {(IWIDTH){1'b0}} ;
     else
       case (accum_cnt[2:0])
         3'b000: coef1[IWIDTH-1:0] <= coe0[IWIDTH-1:0];
         3'b001: coef1[IWIDTH-1:0] <= coe2[IWIDTH-1:0];
         3'b010: coef1[IWIDTH-1:0] <= coe4[IWIDTH-1:0];
         3'b011: coef1[IWIDTH-1:0] <= coe6[IWIDTH-1:0];
         3'b100: coef1[IWIDTH-1:0] <= coe8[IWIDTH-1:0];
         3'b101: coef1[IWIDTH-1:0] <= coe10[IWIDTH-1:0];
         3'b110: coef1[IWIDTH-1:0] <= coe12[IWIDTH-1:0];
         3'b111: coef1[IWIDTH-1:0] <= coe14[IWIDTH-1:0];
       endcase // case (accum_cnt[2:0])
   
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       coef2[IWIDTH-1:0] <= {(IWIDTH){1'b0}};
     else
       case (accum_cnt[2:0])
         3'b000: coef2[IWIDTH-1:0] <= coe16[IWIDTH-1:0];
         3'b001: coef2[IWIDTH-1:0] <= coe18[IWIDTH-1:0];
         3'b010: coef2[IWIDTH-1:0] <= coe20[IWIDTH-1:0];
         3'b011: coef2[IWIDTH-1:0] <= coe22[IWIDTH-1:0];
         3'b100: coef2[IWIDTH-1:0] <= coe24[IWIDTH-1:0];
         3'b101: coef2[IWIDTH-1:0] <= coe26[IWIDTH-1:0];
         3'b110: coef2[IWIDTH-1:0] <= coe28[IWIDTH-1:0];
         3'b111: coef2[IWIDTH-1:0] <= coe30[IWIDTH-1:0];
       endcase // case (accumt_cnt[2:0])
   
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       coef3[IWIDTH-1:0] <= {(IWIDTH){1'b0}};
     else
       case (accum_cnt[2:0])
         3'b000: coef3[IWIDTH-1:0] <= coe32[IWIDTH-1:0];
         3'b001: coef3[IWIDTH-1:0] <= coe34[IWIDTH-1:0];
         3'b010: coef3[IWIDTH-1:0] <= coe36[IWIDTH-1:0];
         3'b011: coef3[IWIDTH-1:0] <= coe38[IWIDTH-1:0];
         3'b100: coef3[IWIDTH-1:0] <= coe40[IWIDTH-1:0];
         3'b101: coef3[IWIDTH-1:0] <= coe42[IWIDTH-1:0];
         3'b110: coef3[IWIDTH-1:0] <= coe44[IWIDTH-1:0];
         3'b111: coef3[IWIDTH-1:0] <= coe46[IWIDTH-1:0];
       endcase // case (accumt_cnt[2:0])
   
   always @ (posedge CLK or posedge ARST)
     if (ARST)     coef4[IWIDTH-1:0] <= {(IWIDTH){1'b0}}  ;
     else          coef4[IWIDTH-1:0] <= coe48[IWIDTH-1:0] ;
   
   always @ (accum_cnt1 or coef1 or coef2 or coef3 or coef4)
     begin
        case (accum_cnt1[4:3])
          2'b00: coef[IWIDTH-1:0] = coef1[IWIDTH-1:0];
          2'b01: coef[IWIDTH-1:0] = coef2[IWIDTH-1:0];
          2'b10: coef[IWIDTH-1:0] = coef3[IWIDTH-1:0];
          2'b11: coef[IWIDTH-1:0] = coef4[IWIDTH-1:0];
          default: coef[IWIDTH-1:0] = coef4[IWIDTH-1:0];
        endcase // case (accum_cnt[4:3])
     end
   
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       begin
          coe49[IWIDTH-1:0] <= e48 ;
          coe48[IWIDTH-1:0] <= e47 ;
          coe47[IWIDTH-1:0] <= e46 ;
          coe46[IWIDTH-1:0] <= e45 ;
          coe45[IWIDTH-1:0] <= e44 ;
          coe44[IWIDTH-1:0] <= e43 ;
          coe43[IWIDTH-1:0] <= e42 ;
          coe42[IWIDTH-1:0] <= e41 ;
          coe41[IWIDTH-1:0] <= e40 ;
          coe40[IWIDTH-1:0] <= e39 ;
          coe39[IWIDTH-1:0] <= e38 ;
          coe38[IWIDTH-1:0] <= e37 ;
          coe37[IWIDTH-1:0] <= e36 ;
          coe36[IWIDTH-1:0] <= e35 ;
          coe35[IWIDTH-1:0] <= e34 ;
          coe34[IWIDTH-1:0] <= e33 ;
          coe33[IWIDTH-1:0] <= e32 ;
          coe32[IWIDTH-1:0] <= e31 ;
          coe31[IWIDTH-1:0] <= e30 ;
          coe30[IWIDTH-1:0] <= e29 ;
          coe29[IWIDTH-1:0] <= e28 ;
          coe28[IWIDTH-1:0] <= e27 ;
          coe27[IWIDTH-1:0] <= e26 ;
          coe26[IWIDTH-1:0] <= e25 ;
          coe25[IWIDTH-1:0] <= e24 ;
          coe24[IWIDTH-1:0] <= e23 ;
          coe23[IWIDTH-1:0] <= e22 ;
          coe22[IWIDTH-1:0] <= e21 ;
          coe21[IWIDTH-1:0] <= e20 ;
          coe20[IWIDTH-1:0] <= e19 ;
          coe19[IWIDTH-1:0] <= e18 ;
          coe18[IWIDTH-1:0] <= e17 ;
          coe17[IWIDTH-1:0] <= e16 ;
          coe16[IWIDTH-1:0] <= e15 ;
          coe15[IWIDTH-1:0] <= e14 ;
          coe14[IWIDTH-1:0] <= e13 ;
          coe13[IWIDTH-1:0] <= e12 ;
          coe12[IWIDTH-1:0] <= e11 ;
          coe11[IWIDTH-1:0] <= e10 ;
          coe10[IWIDTH-1:0] <= e9  ;
          coe9[IWIDTH-1:0]  <= e8  ;
          coe8[IWIDTH-1:0]  <= e7  ;
          coe7[IWIDTH-1:0]  <= e6  ;
          coe6[IWIDTH-1:0]  <= e5  ;
          coe5[IWIDTH-1:0]  <= e4  ;
          coe4[IWIDTH-1:0]  <= e3  ;
          coe3[IWIDTH-1:0]  <= e2  ;
          coe2[IWIDTH-1:0]  <= e1  ;
          coe1[IWIDTH-1:0]  <= e0  ;
          coe0[IWIDTH-1:0]  <= e49 ;
       end // if (ARST)
     else if (Sync)
       begin
          coe49[IWIDTH-1:0] <= e48 ;
          coe48[IWIDTH-1:0] <= e47 ;
          coe47[IWIDTH-1:0] <= e46 ;
          coe46[IWIDTH-1:0] <= e45 ;
          coe45[IWIDTH-1:0] <= e44 ;
          coe44[IWIDTH-1:0] <= e43 ;
          coe43[IWIDTH-1:0] <= e42 ;
          coe42[IWIDTH-1:0] <= e41 ;
          coe41[IWIDTH-1:0] <= e40 ;
          coe40[IWIDTH-1:0] <= e39 ;
          coe39[IWIDTH-1:0] <= e38 ;
          coe38[IWIDTH-1:0] <= e37 ;
          coe37[IWIDTH-1:0] <= e36 ;
          coe36[IWIDTH-1:0] <= e35 ;
          coe35[IWIDTH-1:0] <= e34 ;
          coe34[IWIDTH-1:0] <= e33 ;
          coe33[IWIDTH-1:0] <= e32 ;
          coe32[IWIDTH-1:0] <= e31 ;
          coe31[IWIDTH-1:0] <= e30 ;
          coe30[IWIDTH-1:0] <= e29 ;
          coe29[IWIDTH-1:0] <= e28 ;
          coe28[IWIDTH-1:0] <= e27 ;
          coe27[IWIDTH-1:0] <= e26 ;
          coe26[IWIDTH-1:0] <= e25 ;
          coe25[IWIDTH-1:0] <= e24 ;
          coe24[IWIDTH-1:0] <= e23 ;
          coe23[IWIDTH-1:0] <= e22 ;
          coe22[IWIDTH-1:0] <= e21 ;
          coe21[IWIDTH-1:0] <= e20 ;
          coe20[IWIDTH-1:0] <= e19 ;
          coe19[IWIDTH-1:0] <= e18 ;
          coe18[IWIDTH-1:0] <= e17 ;
          coe17[IWIDTH-1:0] <= e16 ;
          coe16[IWIDTH-1:0] <= e15 ;
          coe15[IWIDTH-1:0] <= e14 ;
          coe14[IWIDTH-1:0] <= e13 ;
          coe13[IWIDTH-1:0] <= e12 ;
          coe12[IWIDTH-1:0] <= e11 ;
          coe11[IWIDTH-1:0] <= e10 ;
          coe10[IWIDTH-1:0] <= e9  ;
          coe9[IWIDTH-1:0]  <= e8  ;
          coe8[IWIDTH-1:0]  <= e7  ;
          coe7[IWIDTH-1:0]  <= e6  ;
          coe6[IWIDTH-1:0]  <= e5  ;
          coe5[IWIDTH-1:0]  <= e4  ;
          coe4[IWIDTH-1:0]  <= e3  ;
          coe3[IWIDTH-1:0]  <= e2  ;
          coe2[IWIDTH-1:0]  <= e1  ;
          coe1[IWIDTH-1:0]  <= e0  ;
          coe0[IWIDTH-1:0]  <= e49 ;
       end
     else if (InputValid)
       begin
          coe49[IWIDTH-1:0] <= coe0[IWIDTH-1:0];
          coe48[IWIDTH-1:0] <= coe49[IWIDTH-1:0] ;
          coe47[IWIDTH-1:0] <= coe48[IWIDTH-1:0] ;
          coe46[IWIDTH-1:0] <= coe47[IWIDTH-1:0] ;
          coe45[IWIDTH-1:0] <= coe46[IWIDTH-1:0] ;
          coe44[IWIDTH-1:0] <= coe45[IWIDTH-1:0] ;
          coe43[IWIDTH-1:0] <= coe44[IWIDTH-1:0] ;
          coe42[IWIDTH-1:0] <= coe43[IWIDTH-1:0] ;
          coe41[IWIDTH-1:0] <= coe42[IWIDTH-1:0] ;
          coe40[IWIDTH-1:0] <= coe41[IWIDTH-1:0] ;
          coe39[IWIDTH-1:0] <= coe40[IWIDTH-1:0] ;
          coe38[IWIDTH-1:0] <= coe39[IWIDTH-1:0] ;
          coe37[IWIDTH-1:0] <= coe38[IWIDTH-1:0] ;
          coe36[IWIDTH-1:0] <= coe37[IWIDTH-1:0] ;
          coe35[IWIDTH-1:0] <= coe36[IWIDTH-1:0] ;
          coe34[IWIDTH-1:0] <= coe35[IWIDTH-1:0] ;
          coe33[IWIDTH-1:0] <= coe34[IWIDTH-1:0] ;
          coe32[IWIDTH-1:0] <= coe33[IWIDTH-1:0] ;
          coe31[IWIDTH-1:0] <= coe32[IWIDTH-1:0] ;
          coe30[IWIDTH-1:0] <= coe31[IWIDTH-1:0] ;
          coe29[IWIDTH-1:0] <= coe30[IWIDTH-1:0] ;
          coe28[IWIDTH-1:0] <= coe29[IWIDTH-1:0] ;
          coe27[IWIDTH-1:0] <= coe28[IWIDTH-1:0] ;
          coe26[IWIDTH-1:0] <= coe27[IWIDTH-1:0] ;
          coe25[IWIDTH-1:0] <= coe26[IWIDTH-1:0] ;
          coe24[IWIDTH-1:0] <= coe25[IWIDTH-1:0] ;
          coe23[IWIDTH-1:0] <= coe24[IWIDTH-1:0] ;
          coe22[IWIDTH-1:0] <= coe23[IWIDTH-1:0] ;
          coe21[IWIDTH-1:0] <= coe22[IWIDTH-1:0] ;
          coe20[IWIDTH-1:0] <= coe21[IWIDTH-1:0] ;
          coe19[IWIDTH-1:0] <= coe20[IWIDTH-1:0] ;
          coe18[IWIDTH-1:0] <= coe19[IWIDTH-1:0] ;
          coe17[IWIDTH-1:0] <= coe18[IWIDTH-1:0] ;
          coe16[IWIDTH-1:0] <= coe17[IWIDTH-1:0] ;
          coe15[IWIDTH-1:0] <= coe16[IWIDTH-1:0] ;
          coe14[IWIDTH-1:0] <= coe15[IWIDTH-1:0] ;
          coe13[IWIDTH-1:0] <= coe14[IWIDTH-1:0] ;
          coe12[IWIDTH-1:0] <= coe13[IWIDTH-1:0] ;
          coe11[IWIDTH-1:0] <= coe12[IWIDTH-1:0] ;
          coe10[IWIDTH-1:0] <= coe11[IWIDTH-1:0] ;
          coe9[IWIDTH-1:0]  <= coe10[IWIDTH-1:0] ;
          coe8[IWIDTH-1:0]  <= coe9[IWIDTH-1:0]  ;
          coe7[IWIDTH-1:0]  <= coe8[IWIDTH-1:0]  ;
          coe6[IWIDTH-1:0]  <= coe7[IWIDTH-1:0]  ;
          coe5[IWIDTH-1:0]  <= coe6[IWIDTH-1:0]  ;
          coe4[IWIDTH-1:0]  <= coe5[IWIDTH-1:0]  ;
          coe3[IWIDTH-1:0]  <= coe4[IWIDTH-1:0]  ;
          coe2[IWIDTH-1:0]  <= coe3[IWIDTH-1:0]  ;
          coe1[IWIDTH-1:0]  <= coe2[IWIDTH-1:0]  ;
          coe0[IWIDTH-1:0]  <= coe1[IWIDTH-1:0]  ;
       end // else: !if(ARST)

   
   //**************************************************************************//
   //*                         Counters                                       *//
   //**************************************************************************//
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       accum_cnt[ACCUMCNTWIDTH-1:0] <= {(ACCUMCNTWIDTH){1'b0}} ;
     else
       accum_cnt[ACCUMCNTWIDTH-1:0] <= (InputValid  & ~InputValid0) ?
                                       0:
                                       (accum_cnt == NACCUM+1) ? (NACCUM+1) 
                                         : accum_cnt[ACCUMCNTWIDTH-1:0] + 1 ;

   always @ (posedge CLK or posedge ARST)                             
     if (ARST)                                                       
       count1[CNTWIDTH-1:0] <= {(CNTWIDTH){1'b0}} ;                     
     else if (InputValid & ~InputValid1)                                
       count1[CNTWIDTH-1:0] <= (count[CNTWIDTH-1:0] == NTAPS-1) ? 0     
                               : count[CNTWIDTH-1:0] + 1 ;       
       
    always @ (posedge CLK or posedge ARST)                                      
     if (ARST)     accum_cnt1[ACCUMCNTWIDTH-1:0] <= {(ACCUMCNTWIDTH){1'b0}}      ;
     else          accum_cnt1[ACCUMCNTWIDTH-1:0] <= accum_cnt[ACCUMCNTWIDTH-1:0] ;   
  
   always @ (posedge CLK or posedge ARST)
     if (ARST)     count[CNTWIDTH-1:0] <= {(CNTWIDTH){1'b0}}   ;
     else          count[CNTWIDTH-1:0] <= count1[CNTWIDTH-1:0] ;
   
   
   //**************************************************************************//
   //*                    Coefficient Rotation / Selector                     *//
   //**************************************************************************//
   always @ (posedge CLK or posedge ARST)
     if (ARST)     mult[AWIDTH-1:0] <= {(AWIDTH){1'b0}} ;
     else          mult[AWIDTH-1:0] <= coef * SigIn1    ;  // Signed multiplication
   
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       accum1[AWIDTH-1:0] <= {(AWIDTH){1'b0}} ;
     else if (accum_cnt1[ACCUMCNTWIDTH-1:0] == 1)
       accum1[AWIDTH-1:0] <= (count == 1) ? mult  
                             : mult[AWIDTH-1:0] + accum1[AWIDTH-1:0] ;
   
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       accum2[AWIDTH-1:0] <= {(AWIDTH){1'b0}} ;
     else if (accum_cnt1[ACCUMCNTWIDTH-1:0] == 2)
       accum2[AWIDTH-1:0] <= (count == 49) ? mult  
                             : mult[AWIDTH-1:0] + accum2[AWIDTH-1:0] ;
   
   
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       accum3[AWIDTH-1:0] <= {(AWIDTH){1'b0}} ;
     else if (accum_cnt1[ACCUMCNTWIDTH-1:0] == 3)
       accum3[AWIDTH-1:0] <= (count == 47) ? mult  
                             : mult[AWIDTH-1:0] + accum3[AWIDTH-1:0] ;
   
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       accum4[AWIDTH-1:0] <= {(AWIDTH){1'b0}} ;
     else if (accum_cnt1[ACCUMCNTWIDTH-1:0] == 4)
       accum4[AWIDTH-1:0] <= (count == 45) ? mult  
                             : mult[AWIDTH-1:0] + accum4[AWIDTH-1:0] ;
   
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       accum5[AWIDTH-1:0] <= {(AWIDTH){1'b0}} ;
     else if (accum_cnt1[ACCUMCNTWIDTH-1:0] == 5)
       accum5[AWIDTH-1:0] <= (count == 43) ? mult  
                             : mult[AWIDTH-1:0] + accum5[AWIDTH-1:0] ;
   
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       accum6[AWIDTH-1:0] <= {(AWIDTH){1'b0}} ;
     else if (accum_cnt1[ACCUMCNTWIDTH-1:0] == 6)
       accum6[AWIDTH-1:0] <= (count == 41) ? mult  
                             : mult[AWIDTH-1:0] + accum6[AWIDTH-1:0] ;

   always @ (posedge CLK or posedge ARST)
     if (ARST)
       accum7[AWIDTH-1:0] <= {(AWIDTH){1'b0}} ;
     else if (accum_cnt1[ACCUMCNTWIDTH-1:0] == 7)
       accum7[AWIDTH-1:0] <= (count == 39) ? mult  
                             : mult[AWIDTH-1:0] + accum7[AWIDTH-1:0] ;
   
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       accum8[AWIDTH-1:0] <= {(AWIDTH){1'b0}} ;
     else if (accum_cnt1[ACCUMCNTWIDTH-1:0] == 8)
       accum8[AWIDTH-1:0] <= (count == 37) ? mult  
                             : mult[AWIDTH-1:0] + accum8[AWIDTH-1:0] ;
   
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       accum9[AWIDTH-1:0] <= {(AWIDTH){1'b0}} ;
     else if (accum_cnt1[ACCUMCNTWIDTH-1:0] ==9)
       accum9[AWIDTH-1:0] <= (count == 35) ? mult  
                             : mult[AWIDTH-1:0] + accum9[AWIDTH-1:0] ;
   
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       accum10[AWIDTH-1:0] <= {(AWIDTH){1'b0}} ;
     else if (accum_cnt1[ACCUMCNTWIDTH-1:0] ==10)
       accum10[AWIDTH-1:0] <= (count == 33) ? mult  
                              : mult[AWIDTH-1:0] + accum10[AWIDTH-1:0] ;
   
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       accum11[AWIDTH-1:0] <= {(AWIDTH){1'b0}} ;
     else if (accum_cnt1[ACCUMCNTWIDTH-1:0] == 11)
       accum11[AWIDTH-1:0] <= (count == 31) ? mult  
                              :  mult[AWIDTH-1:0] + accum11[AWIDTH-1:0] ;
   
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       accum12[AWIDTH-1:0] <= {(AWIDTH){1'b0}} ;
     else if (accum_cnt1[ACCUMCNTWIDTH-1:0] == 12)
       accum12[AWIDTH-1:0] <= (count == 29) ? mult  
                              :  mult[AWIDTH-1:0] + accum12[AWIDTH-1:0] ;
   
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       accum13[AWIDTH-1:0] <= {(AWIDTH){1'b0}} ;
     else if (accum_cnt1[ACCUMCNTWIDTH-1:0] == 13)
       accum13[AWIDTH-1:0] <= (count == 27) ? mult  
                              :  mult[AWIDTH-1:0] + accum13[AWIDTH-1:0] ;
   
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       accum14[AWIDTH-1:0] <= {(AWIDTH){1'b0}} ;
     else if (accum_cnt1[ACCUMCNTWIDTH-1:0] == 14)
       accum14[AWIDTH-1:0] <= (count == 25) ? mult  
                              :  mult[AWIDTH-1:0] + accum14[AWIDTH-1:0] ;
   
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       accum15[AWIDTH-1:0] <= {(AWIDTH){1'b0}} ;
     else if (accum_cnt1[ACCUMCNTWIDTH-1:0] == 15)
       accum15[AWIDTH-1:0] <= (count == 23) ? mult  
                              :  mult[AWIDTH-1:0] + accum15[AWIDTH-1:0] ;
   
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       accum16[AWIDTH-1:0] <= {(AWIDTH){1'b0}} ;
     else if (accum_cnt1[ACCUMCNTWIDTH-1:0] == 16)
       accum16[AWIDTH-1:0] <= (count == 21) ? mult  
                              :  mult[AWIDTH-1:0] + accum16[AWIDTH-1:0] ;

   always @ (posedge CLK or posedge ARST)
     if (ARST)
       accum17[AWIDTH-1:0] <= {(AWIDTH){1'b0}} ;
     else if (accum_cnt1[ACCUMCNTWIDTH-1:0] == 17)
       accum17[AWIDTH-1:0] <= (count == 19) ? mult  
                              :  mult[AWIDTH-1:0] + accum17[AWIDTH-1:0] ;
   
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       accum18[AWIDTH-1:0] <= {(AWIDTH){1'b0}} ;
     else if (accum_cnt1[ACCUMCNTWIDTH-1:0] ==18)
       accum18[AWIDTH-1:0] <= (count == 17) ? mult  
                              :  mult[AWIDTH-1:0] + accum18[AWIDTH-1:0] ;
   
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       accum19[AWIDTH-1:0] <= {(AWIDTH){1'b0}} ;
     else if (accum_cnt1[ACCUMCNTWIDTH-1:0] == 19)
       accum19[AWIDTH-1:0] <= (count == 15) ? mult      
                              :  mult[AWIDTH-1:0] + accum19[AWIDTH-1:0] ;
   
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       accum20[AWIDTH-1:0] <= {(AWIDTH){1'b0}} ;
     else if (accum_cnt1[ACCUMCNTWIDTH-1:0] == 20)
       accum20[AWIDTH-1:0] <= (count == 13) ? mult  
                              : mult[AWIDTH-1:0] + accum20[AWIDTH-1:0] ;
   
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       accum21[AWIDTH-1:0] <= {(AWIDTH){1'b0}} ;
     else if (accum_cnt1[ACCUMCNTWIDTH-1:0] == 21)
       accum21[AWIDTH-1:0] <= (count == 11) ? mult  
                              : mult[AWIDTH-1:0] + accum21[AWIDTH-1:0] ;
   
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       accum22[AWIDTH-1:0] <= {(AWIDTH){1'b0}} ;
     else if (accum_cnt1[ACCUMCNTWIDTH-1:0] == 22)
       accum22[AWIDTH-1:0] <= (count == 9) ? mult  
                              :  mult[AWIDTH-1:0] + accum22[AWIDTH-1:0] ;
   
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       accum23[AWIDTH-1:0] <= {(AWIDTH){1'b0}} ;
     else if (accum_cnt1[ACCUMCNTWIDTH-1:0] == 23)
       accum23[AWIDTH-1:0] <= (count == 7) ? mult  
                              :  mult[AWIDTH-1:0] + accum23[AWIDTH-1:0] ;
   
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       accum24[AWIDTH-1:0] <= {(AWIDTH){1'b0}} ;
     else if (accum_cnt1[ACCUMCNTWIDTH-1:0] == 24)
       accum24[AWIDTH-1:0] <= (count == 5) ? mult  
                              :  mult[AWIDTH-1:0] + accum24[AWIDTH-1:0] ;
   
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       accum25[AWIDTH-1:0] <= {(AWIDTH){1'b0}} ;
     else if (accum_cnt1[ACCUMCNTWIDTH-1:0] == 0)
       accum25[AWIDTH-1:0] <= (count == 4) ? mult  
                              :  mult[AWIDTH-1:0] + accum25[AWIDTH-1:0] ;
   
   
   //**************************************************************************//
   //*                         Output Buffers                                 *//
   //**************************************************************************//
   assign valid1  = (count[CNTWIDTH-1:0] == 1)  & (accum_cnt1 == 1) ;
   assign valid2  = (count[CNTWIDTH-1:0] == 49) & (accum_cnt1 == 1) ;
   assign valid3  = (count[CNTWIDTH-1:0] == 47) & (accum_cnt1 == 1) ;
   assign valid4  = (count[CNTWIDTH-1:0] == 45) & (accum_cnt1 == 1) ;
   assign valid5  = (count[CNTWIDTH-1:0] == 43) & (accum_cnt1 == 1) ;
   assign valid6  = (count[CNTWIDTH-1:0] == 41) & (accum_cnt1 == 1) ;
   assign valid7  = (count[CNTWIDTH-1:0] == 39) & (accum_cnt1 == 1) ;
   assign valid8  = (count[CNTWIDTH-1:0] == 37) & (accum_cnt1 == 1) ;
   assign valid9  = (count[CNTWIDTH-1:0] == 35) & (accum_cnt1 == 1) ;
   assign valid10 = (count[CNTWIDTH-1:0] == 33) & (accum_cnt1 == 1) ;
   assign valid11 = (count[CNTWIDTH-1:0] == 31) & (accum_cnt1 == 1) ;
   assign valid12 = (count[CNTWIDTH-1:0] == 29) & (accum_cnt1 == 1) ;
   assign valid13 = (count[CNTWIDTH-1:0] == 27) & (accum_cnt1 == 1) ;
   assign valid14 = (count[CNTWIDTH-1:0] == 25) & (accum_cnt1 == 1) ;
   assign valid15 = (count[CNTWIDTH-1:0] == 23) & (accum_cnt1 == 1) ;
   assign valid16 = (count[CNTWIDTH-1:0] == 21) & (accum_cnt1 == 1) ;
   assign valid17 = (count[CNTWIDTH-1:0] == 19) & (accum_cnt1 == 1) ;
   assign valid18 = (count[CNTWIDTH-1:0] == 17) & (accum_cnt1 == 1) ;
   assign valid19 = (count[CNTWIDTH-1:0] == 15) & (accum_cnt1 == 1) ;
   assign valid20 = (count[CNTWIDTH-1:0] == 13) & (accum_cnt1 == 1) ;
   assign valid21 = (count[CNTWIDTH-1:0] == 11) & (accum_cnt1 == 1) ;
   assign valid22 = (count[CNTWIDTH-1:0] == 9)  & (accum_cnt1 == 1) ;
   assign valid23 = (count[CNTWIDTH-1:0] == 7)  & (accum_cnt1 == 1) ;
   assign valid24 = (count[CNTWIDTH-1:0] == 5)  & (accum_cnt1 == 1) ;
   assign valid25 = (count[CNTWIDTH-1:0] == 3)  & (accum_cnt1 == 1) ;

   assign valid =  valid1  | valid2  | valid3  | valid4  | valid5  | valid6  | 
                   valid7  | valid8  | valid9  | valid10 | valid11 | valid12 | 
                   valid13 | valid14 | valid15 | valid16 | valid17 | valid18 | 
                   valid19 | valid20 | valid21 | valid22 | valid23 | valid24 |
                   valid25;

   always @ (posedge CLK or posedge ARST)
     if (ARST)
       SigOut[OWIDTH-1:0] <= {(OWIDTH){1'b0}} ;
     else if (valid)
       SigOut[OWIDTH-1:0] <= (accum1[AWIDTH-1:0]  & {(AWIDTH){ valid1  }}) |
                             (accum2[AWIDTH-1:0]  & {(AWIDTH){ valid2  }}) |
                             (accum3[AWIDTH-1:0]  & {(AWIDTH){ valid3  }}) |
                             (accum4[AWIDTH-1:0]  & {(AWIDTH){ valid4  }}) |
                             (accum5[AWIDTH-1:0]  & {(AWIDTH){ valid5  }}) |
                             (accum6[AWIDTH-1:0]  & {(AWIDTH){ valid6  }}) |
                             (accum7[AWIDTH-1:0]  & {(AWIDTH){ valid7  }}) |
                             (accum8[AWIDTH-1:0]  & {(AWIDTH){ valid8  }}) |
                             (accum9[AWIDTH-1:0]  & {(AWIDTH){ valid9  }}) |
                             (accum10[AWIDTH-1:0] & {(AWIDTH){ valid10 }}) |
                             (accum11[AWIDTH-1:0] & {(AWIDTH){ valid11 }}) |
                             (accum12[AWIDTH-1:0] & {(AWIDTH){ valid12 }}) |
                             (accum13[AWIDTH-1:0] & {(AWIDTH){ valid13 }}) |
                             (accum14[AWIDTH-1:0] & {(AWIDTH){ valid14 }}) |
                             (accum15[AWIDTH-1:0] & {(AWIDTH){ valid15 }}) |
                             (accum16[AWIDTH-1:0] & {(AWIDTH){ valid16 }}) |
                             (accum17[AWIDTH-1:0] & {(AWIDTH){ valid17 }}) |
                             (accum18[AWIDTH-1:0] & {(AWIDTH){ valid18 }}) |
                             (accum19[AWIDTH-1:0] & {(AWIDTH){ valid19 }}) |
                             (accum20[AWIDTH-1:0] & {(AWIDTH){ valid20 }}) |
                             (accum21[AWIDTH-1:0] & {(AWIDTH){ valid21 }}) |
                             (accum22[AWIDTH-1:0] & {(AWIDTH){ valid22 }}) |
                             (accum23[AWIDTH-1:0] & {(AWIDTH){ valid23 }}) |
                             (accum24[AWIDTH-1:0] & {(AWIDTH){ valid24 }}) |
                             (accum25[AWIDTH-1:0] & {(AWIDTH){ valid25 }}) ;

   always @ (posedge CLK or posedge ARST)
     if (ARST)     DataValid <= 1'b0 ;
     else          DataValid <= valid;


endmodule  //firdecim_m2_n50// ******************************************************************************* //
// **                    General Information                                    ** //
// ******************************************************************************* //
// **  Module             : firdecim_m5_n15.v                                   ** //
// **  Project            : ISAAC Newton                                        ** //
// **  Author             : Kayla Nguyen                                        ** //
// **  First Release Date : August 13, 2008                                     ** //
// **  Description        : Polyphase Decimation Filter                         ** //
// **                       M = 5, L = 15                                       ** //
// ******************************************************************************* //
// **                     Revision History                                      ** //
// ******************************************************************************* //
// **                                                                           ** //
// **  File        : firdecim_m5_n15.v                                          ** //
// **  Revision    : 1                                                          ** //
// **  Author      : kaylangu                                                   ** //
// **  Date        : August 13, 2008                                            ** //
// **  FileName    :                                                            ** //
// **  Notes       : Initial Release for ISAAC demo                             ** //
// **                                                                           ** //
// ******************************************************************************* //
`timescale 1 ns / 100 ps

module firdecim_m5_n15
  (// Outputs
   SigOut, DataValid,
   // Inputs
   CLK, ARST, InputValid, SigIn, Sync
   );


   //**************************************************************************//
   //*                       Declarations                                     *//
   //**************************************************************************//
   // DATA TYPE - PARAMETERS
   parameter                 e14 = 16'sb0000_0000_0001_1111;
   parameter                 e13 = 16'sb0000_0000_1000_1101;
   parameter                 e12 = 16'sb0000_0001_1000_0010;

   parameter                 e11 = 16'sb0000_0011_0001_1110;
   parameter                 e10 = 16'sb0000_0101_0011_1111;
   parameter                 e9  = 16'sb0000_0111_0111_1000;

   parameter                 e8  = 16'sb0000_1001_0010_1011;
   parameter                 e7  = 16'sb0000_1001_1100_1111;
   parameter                 e6  = 16'sb0000_1001_0010_1011;

   parameter                 e5  = 16'sb0000_0111_0111_1000;
   parameter                 e4  = 16'sb0000_0101_0011_1111;
   parameter                 e3  = 16'sb0000_0011_0001_1110;

   parameter                 e2  = 16'sb0000_0001_1000_0010;
   parameter                 e1  = 16'sb0000_0000_1000_1101;
   parameter                 e0  = 16'sb0000_0000_0001_1111;

   parameter                 OWIDTH   = 32     ; // output bit width
   parameter                 IWIDTH   = 16     ; // input bit width
   parameter                 NTAPS    = 15     ; // number of taps in the filter
   parameter                 CNTWIDTH = 4      ; // counter bit width

   // DATA TYPE - INPUTS AND OUTPUTS
   output reg signed [OWIDTH-1:0]  SigOut      ;
   output reg                      DataValid   ;

   input                           CLK         ; // 60MHz Clock
   input                           ARST        ;
   input                           InputValid  ;
   input      signed [IWIDTH-1:0]  SigIn       ;
   input                           Sync        ;
   
   // DATA TYPE - REGISTERS
   reg        signed [IWIDTH-1:0]  coe14       ;
   reg        signed [IWIDTH-1:0]  coe13       ;
   reg        signed [IWIDTH-1:0]  coe12       ;
   reg        signed [IWIDTH-1:0]  coe11       ;
   reg        signed [IWIDTH-1:0]  coe10       ;
   reg        signed [IWIDTH-1:0]  coe9        ;
   reg        signed [IWIDTH-1:0]  coe8        ;
   reg        signed [IWIDTH-1:0]  coe7        ;
   reg        signed [IWIDTH-1:0]  coe6        ;
   reg        signed [IWIDTH-1:0]  coe5        ;
   reg        signed [IWIDTH-1:0]  coe4        ;
   reg        signed [IWIDTH-1:0]  coe3        ;
   reg        signed [IWIDTH-1:0]  coe2        ;
   reg        signed [IWIDTH-1:0]  coe1        ;
   reg        signed [IWIDTH-1:0]  coe0        ;

   reg               [CNTWIDTH-1:0] count      ;

   // DATA TYPE - WIRES
   wire       signed [OWIDTH-1:0]  SigOut1     ;
   wire       signed [OWIDTH-1:0]  SigOut2     ;
   wire       signed [OWIDTH-1:0]  SigOut3     ;

   wire                            initialize1 ;
   wire                            initialize2 ;
   wire                            initialize3 ;

   wire                            DataValid1  ;
   wire                            DataValid2  ;
   wire                            DataValid3  ;


   //**************************************************************************//
   //*                     Coefficient Rotation                              *//
   //**************************************************************************//
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       begin
          coe14[IWIDTH-1:0] <= e14 ;
          coe13[IWIDTH-1:0] <= e13 ;
          coe12[IWIDTH-1:0] <= e12 ;
          coe11[IWIDTH-1:0] <= e11 ;
          coe10[IWIDTH-1:0] <= e10 ;
          coe9[IWIDTH-1:0]  <= e9  ;
          coe8[IWIDTH-1:0]  <= e8  ;
          coe7[IWIDTH-1:0]  <= e7  ;
          coe6[IWIDTH-1:0]  <= e6  ;
          coe5[IWIDTH-1:0]  <= e5  ;
          coe4[IWIDTH-1:0]  <= e4  ;
          coe3[IWIDTH-1:0]  <= e3  ;
          coe2[IWIDTH-1:0]  <= e2  ;
          coe1[IWIDTH-1:0]  <= e1  ;
          coe0[IWIDTH-1:0]  <= e0  ;
       end // if (ARST)
     else if (Sync)
       begin
          coe14[IWIDTH-1:0] <= e14 ;
          coe13[IWIDTH-1:0] <= e13 ;
          coe12[IWIDTH-1:0] <= e12 ;
          coe11[IWIDTH-1:0] <= e11 ;
          coe10[IWIDTH-1:0] <= e10 ;
          coe9[IWIDTH-1:0]  <= e9  ;
          coe8[IWIDTH-1:0]  <= e8  ;
          coe7[IWIDTH-1:0]  <= e7  ;
          coe6[IWIDTH-1:0]  <= e6  ;
          coe5[IWIDTH-1:0]  <= e5  ;
          coe4[IWIDTH-1:0]  <= e4  ;
          coe3[IWIDTH-1:0]  <= e3  ;
          coe2[IWIDTH-1:0]  <= e2  ;
          coe1[IWIDTH-1:0]  <= e1  ;
          coe0[IWIDTH-1:0]  <= e0  ;
       end
     else if (InputValid)
       begin
          coe14[IWIDTH-1:0] <= coe0[IWIDTH-1:0]  ;
          coe13[IWIDTH-1:0] <= coe14[IWIDTH-1:0] ;
          coe12[IWIDTH-1:0] <= coe13[IWIDTH-1:0] ;
          coe11[IWIDTH-1:0] <= coe12[IWIDTH-1:0] ;
          coe10[IWIDTH-1:0] <= coe11[IWIDTH-1:0] ;
          coe9[IWIDTH-1:0]  <= coe10[IWIDTH-1:0] ;
          coe8[IWIDTH-1:0]  <= coe9[IWIDTH-1:0]  ;
          coe7[IWIDTH-1:0]  <= coe8[IWIDTH-1:0]  ;
          coe6[IWIDTH-1:0]  <= coe7[IWIDTH-1:0]  ;
          coe5[IWIDTH-1:0]  <= coe6[IWIDTH-1:0]  ;
          coe4[IWIDTH-1:0]  <= coe5[IWIDTH-1:0]  ;
          coe3[IWIDTH-1:0]  <= coe4[IWIDTH-1:0]  ;
          coe2[IWIDTH-1:0]  <= coe3[IWIDTH-1:0]  ;
          coe1[IWIDTH-1:0]  <= coe2[IWIDTH-1:0]  ;
          coe0[IWIDTH-1:0]  <= coe1[IWIDTH-1:0]  ;
       end


   //**************************************************************************//
   //*                         Counter                                        *//
   //**************************************************************************//
   always @ (posedge CLK or posedge ARST)
     if (ARST)          
        count[CNTWIDTH-1:0] <= {(CNTWIDTH){1'b0}} ;
     else if (InputValid)  
        count[CNTWIDTH-1:0] <= (count[CNTWIDTH-1:0] == (NTAPS-1)) ? 0 :
                                                         count[CNTWIDTH-1:0] + 1 ;


   //**************************************************************************//
   //*                        Reset each MAC                                  *//
   //**************************************************************************//
   assign initialize1   = (count == 0)   ;
   assign initialize2   = (count == 5)   ;
   assign initialize3   = (count == 10)  ;


   //**************************************************************************//
   //*                        Output Buffers                                  *//
   //**************************************************************************//
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       SigOut[OWIDTH-1:0] <= {(OWIDTH){1'b0}};
     else if (DataValid1 | DataValid2 | DataValid3)
       SigOut[OWIDTH-1:0] <= {(OWIDTH){DataValid1}} & SigOut1 |
                             {(OWIDTH){DataValid2}} & SigOut2 |
                             {(OWIDTH){DataValid3}} & SigOut3 ;

   always @ (posedge CLK or posedge ARST)
     if (ARST)     DataValid <= 1'b0 ;
     else          DataValid <= (DataValid1 | DataValid2 | DataValid3)  ;

   
   //**************************************************************************//
   //*                          Submodules                                    *//
   //**************************************************************************//
   //First MAC
   MAC1 MAC1_a 
     (// Inputs
      .CLK          (CLK),         // CLK
      .ARST         (ARST),        // ARST
      .filterCoef   (coe0),        // Filter Coeficients
      .InData       (SigIn),       // Input Data
      .input_Valid  (InputValid),  // Input Valid
      .initialize   (initialize1), // Initialize
      //Outputs
      .OutData      (SigOut1),     // Output Data
      .output_Valid (DataValid1)   // Output Valid
      );  

   // Second MAC
   MAC1 MAC1_b 
     (// Inputs
      .CLK          (CLK),         // CLK
      .ARST         (ARST),        // ARST
      .filterCoef   (coe10),       // Filter Coeficients
      .InData       (SigIn),       // Input Data
      .input_Valid  (InputValid),  // Input Valid
      .initialize   (initialize2), // Initialize
      //Outputs
      .OutData      (SigOut2),     // Output Data
      .output_Valid (DataValid2)   // Output Valid
      );  

   // Third MAC
   MAC1 MAC1_c 
     (// Inputs
      .CLK          (CLK),         // CLK
      .ARST         (ARST),        // ARST
      .filterCoef   (coe5),        // Filter Coeficients
      .InData       (SigIn),       // Input Data
      .input_Valid  (InputValid),  // Input Valid
      .initialize   (initialize3), // Initialize
      //Outputs
      .OutData      (SigOut3),     // Output Data
      .output_Valid (DataValid3)   // Output Valid
      );  

endmodule // firdecim_m5_n15





// ******************************************************************************* //
// **                    General Information                                    ** //
// ******************************************************************************* //
// **  Module             : firdecim_m5_n20.v                                   ** //
// **  Project            : ISAAC NEWTON                                        ** //
// **  Author             : Kayla Nguyen                                        ** //
// **  First Release Date : August 13, 2008                                     ** //
// **  Description        : Polyphase Decimation Filter                         ** //
// **                       M = 5, L = 20                                       ** //
// ******************************************************************************* //
// **                     Revision History                                      ** //
// ******************************************************************************* //
// **                                                                           ** //
// **  File        : firdecim_m5_n20.v                                          ** //
// **  Revision    : 1                                                          ** //
// **  Author      : kaylangu                                                   ** //
// **  Date        : August 13, 2008                                            ** //
// **  FileName    :                                                            ** //
// **  Notes       : Initial Release for ISAAC demo                             ** //
// **                                                                           ** //
// ******************************************************************************* //
`timescale 1 ns / 100 ps

module firdecim_m5_n20
  (// Input
   CLK,
   ARST,
   Sync,
   InputValid,
   SigIn,
   // Ouput
   DataValid,
   SigOut
   );

   //****************************************************************************//
   //*                         Declarations                                     *//
   //****************************************************************************//
   // DATA TYPE - PARAMETERS
   parameter                 e19 = 16'sb1111_1111_1011_1000;
   parameter                 e18 = 16'sb1111_1111_1000_0110;
   parameter                 e17 = 16'sb1111_1111_0110_1110;
   parameter                 e16 = 16'sb1111_1111_1011_1110;

   parameter                 e15 = 16'sb0000_0000_1011_0011;
   parameter                 e14 = 16'sb0000_0010_0110_1101;
   parameter                 e13 = 16'sb0000_0100_1100_0101;
   parameter                 e12 = 16'sb0000_0111_0101_0101;

   parameter                 e11 = 16'sb0000_1001_1000_0111;
   parameter                 e10 = 16'sb0000_1010_1100_1101;
   parameter                 e9  = 16'sb0000_1010_1100_1101;
   parameter                 e8  = 16'sb0000_1001_1000_0111;

   parameter                 e7  = 16'sb0000_0111_0101_0101;
   parameter                 e6  = 16'sb0000_0100_1100_0101;
   parameter                 e5  = 16'sb0000_0010_0110_1101;
   parameter                 e4  = 16'sb0000_0000_1011_0011;

   parameter                 e3  = 16'sb1111_1111_1011_1110;
   parameter                 e2  = 16'sb1111_1111_0110_1110;
   parameter                 e1  = 16'sb1111_1111_1000_0110;
   parameter                 e0  = 16'sb1111_1111_1011_1000;

   parameter                 OWIDTH        = 32 ; // output bit width
   parameter                 IWIDTH        = 16 ; // input bit width
   parameter                 AWIDTH        = 32 ; // internal bit width
   parameter                 NTAPS         = 20 ; // number of filter taps
   parameter                 ACCUMCNTWIDTH = 3  ; // accumulator count bit width
   parameter                 CNTWIDTH      = 5  ; // counter bit width
   parameter                 NACCUM        = 4  ; // numbers of accumulators

   // DATA TYPE - INPUTS AND OUTPUTS
   output reg signed [OWIDTH-1:0]  SigOut      ;
   output reg                      DataValid   ;
   
   input                           CLK         ; // 60MHz Clock
   input                           ARST        ;
   input                           InputValid  ;
   input                           Sync        ;
      
   input      signed [IWIDTH-1:0]  SigIn       ;
   
   // DATA TYPE - REGISTERS
   reg signed [IWIDTH-1:0]         coe19       ;
   reg signed [IWIDTH-1:0]         coe18       ;
   reg signed [IWIDTH-1:0]         coe17       ;
   reg signed [IWIDTH-1:0]         coe16       ;
   reg signed [IWIDTH-1:0]         coe15       ;
   reg signed [IWIDTH-1:0]         coe14       ;
   reg signed [IWIDTH-1:0]         coe13       ;
   reg signed [IWIDTH-1:0]         coe12       ;
   reg signed [IWIDTH-1:0]         coe11       ;
   reg signed [IWIDTH-1:0]         coe10       ;
   reg signed [IWIDTH-1:0]         coe9        ;
   reg signed [IWIDTH-1:0]         coe8        ;
   reg signed [IWIDTH-1:0]         coe7        ;
   reg signed [IWIDTH-1:0]         coe6        ;
   reg signed [IWIDTH-1:0]         coe5        ;
   reg signed [IWIDTH-1:0]         coe4        ;
   reg signed [IWIDTH-1:0]         coe3        ;
   reg signed [IWIDTH-1:0]         coe2        ;
   reg signed [IWIDTH-1:0]         coe1        ;
   reg signed [IWIDTH-1:0]         coe0        ;

   reg [CNTWIDTH-1:0]              count       ;
   reg [ACCUMCNTWIDTH-1:0]         accum_cnt   ;  //Counter to keep track of which
                                                  //accumulator is being accessed.
   reg signed [IWIDTH-1:0]         SigIn1      ;
   reg                             InputValid0 ;
   reg signed [AWIDTH-1:0]         mult        ;
   reg signed [AWIDTH-1:0]         accum1      ;  //First accumulator
   reg signed [AWIDTH-1:0]         accum2      ;  //Second accumulator
   reg signed [AWIDTH-1:0]         accum3      ;  //Third accumulator
   reg signed [AWIDTH-1:0]         accum4      ;  //Fourth accumulator


   // DATA TYPE - NETS
   wire signed [IWIDTH-1:0]        coef        ;  //Coefficient to be used in the
                                                  //multiplier.
   wire                            valid       ;
   wire                            valid1      ;
   wire                            valid2      ;
   wire                            valid3      ;
   wire                            valid4      ;
   

   //****************************************************************************//
   //*                           Input Buffers                                  *//
   //****************************************************************************//
   always @ (posedge CLK or posedge ARST)
     if (ARST)     InputValid0 <= 1'b0 ;
     else          InputValid0 <= InputValid ;

   always @ (posedge CLK or posedge ARST)
     if (ARST)     SigIn1[IWIDTH-1:0] <= {(IWIDTH){1'b0}} ;
     else          SigIn1[IWIDTH-1:0] <= SigIn[IWIDTH-1:0];
   
   
   //****************************************************************************//
   //*                   Coefficient Rotation / Selector                        *//
   //****************************************************************************//
   assign coef[IWIDTH-1:0] = (accum_cnt[ACCUMCNTWIDTH-1:0] == 0) ? coe0[IWIDTH-1:0] :
                             ((accum_cnt[ACCUMCNTWIDTH-1:0] == 1) ? coe5[IWIDTH-1:0] :
                              ((accum_cnt[ACCUMCNTWIDTH-1:0] == 2) ? coe10[IWIDTH-1:0]
                               : coe15[IWIDTH-1:0])) ;
   
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       begin
          coe19[IWIDTH-1:0] <= e18 ;
          coe18[IWIDTH-1:0] <= e17 ;
          coe17[IWIDTH-1:0] <= e16 ;
          coe16[IWIDTH-1:0] <= e15 ;
          coe15[IWIDTH-1:0] <= e14 ;
          coe14[IWIDTH-1:0] <= e13 ;
          coe13[IWIDTH-1:0] <= e12 ;
          coe12[IWIDTH-1:0] <= e11 ;
          coe11[IWIDTH-1:0] <= e10 ;
          coe10[IWIDTH-1:0] <= e9  ;
          coe9[IWIDTH-1:0]  <= e8  ;
          coe8[IWIDTH-1:0]  <= e7  ;
          coe7[IWIDTH-1:0]  <= e6  ;
          coe6[IWIDTH-1:0]  <= e5  ;
          coe5[IWIDTH-1:0]  <= e4  ;
          coe4[IWIDTH-1:0]  <= e3  ;
          coe3[IWIDTH-1:0]  <= e2  ;
          coe2[IWIDTH-1:0]  <= e1  ;
          coe1[IWIDTH-1:0]  <= e0  ;
          coe0[IWIDTH-1:0]  <= e19 ;
       end // if (ARST)
     else if (Sync)
       begin
          coe19[IWIDTH-1:0] <= e18 ;
          coe18[IWIDTH-1:0] <= e17 ;
          coe17[IWIDTH-1:0] <= e16 ;
          coe16[IWIDTH-1:0] <= e15 ;
          coe15[IWIDTH-1:0] <= e14 ;
          coe14[IWIDTH-1:0] <= e13 ;
          coe13[IWIDTH-1:0] <= e12 ;
          coe12[IWIDTH-1:0] <= e11 ;
          coe11[IWIDTH-1:0] <= e10 ;
          coe10[IWIDTH-1:0] <= e9  ;
          coe9[IWIDTH-1:0]  <= e8  ;
          coe8[IWIDTH-1:0]  <= e7  ;
          coe7[IWIDTH-1:0]  <= e6  ;
          coe6[IWIDTH-1:0]  <= e5  ;
          coe5[IWIDTH-1:0]  <= e4  ;
          coe4[IWIDTH-1:0]  <= e3  ;
          coe3[IWIDTH-1:0]  <= e2  ;
          coe2[IWIDTH-1:0]  <= e1  ;
          coe1[IWIDTH-1:0]  <= e0  ;
          coe0[IWIDTH-1:0]  <= e19 ;
       end
     else if (InputValid)
       begin
          coe19[IWIDTH-1:0] <= coe0[IWIDTH-1:0]  ;
          coe18[IWIDTH-1:0] <= coe19[IWIDTH-1:0] ;
          coe17[IWIDTH-1:0] <= coe18[IWIDTH-1:0] ;
          coe16[IWIDTH-1:0] <= coe17[IWIDTH-1:0] ;
          coe15[IWIDTH-1:0] <= coe16[IWIDTH-1:0] ;
          coe14[IWIDTH-1:0] <= coe15[IWIDTH-1:0] ;
          coe13[IWIDTH-1:0] <= coe14[IWIDTH-1:0] ;
          coe12[IWIDTH-1:0] <= coe13[IWIDTH-1:0] ;
          coe11[IWIDTH-1:0] <= coe12[IWIDTH-1:0] ;
          coe10[IWIDTH-1:0] <= coe11[IWIDTH-1:0] ;
          coe9[IWIDTH-1:0]  <= coe10[IWIDTH-1:0] ;
          coe8[IWIDTH-1:0]  <= coe9[IWIDTH-1:0]  ;
          coe7[IWIDTH-1:0]  <= coe8[IWIDTH-1:0]  ;
          coe6[IWIDTH-1:0]  <= coe7[IWIDTH-1:0]  ;
          coe5[IWIDTH-1:0]  <= coe6[IWIDTH-1:0]  ;
          coe4[IWIDTH-1:0]  <= coe5[IWIDTH-1:0]  ;
          coe3[IWIDTH-1:0]  <= coe4[IWIDTH-1:0]  ;
          coe2[IWIDTH-1:0]  <= coe3[IWIDTH-1:0]  ;
          coe1[IWIDTH-1:0]  <= coe2[IWIDTH-1:0]  ;
          coe0[IWIDTH-1:0]  <= coe1[IWIDTH-1:0]  ;
       end // else: !if(ARST)


   //****************************************************************************//
   //*                           Counters                                       *//
   //****************************************************************************//
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       accum_cnt[ACCUMCNTWIDTH-1:0] <= {(ACCUMCNTWIDTH){1'b0}} ;
     else
       accum_cnt[ACCUMCNTWIDTH-1:0] <= (InputValid  & ~InputValid0) ?
                                       0:
                                       (accum_cnt == NACCUM+1) ? (NACCUM+1)
                                         : accum_cnt[ACCUMCNTWIDTH-1:0] + 1 ;

   always @ (posedge CLK or posedge ARST)
     if (ARST)
       count[CNTWIDTH-1:0] <= {(CNTWIDTH){1'b0}} ;
     else if (InputValid & ~InputValid0)
       count[CNTWIDTH-1:0] <= (count[CNTWIDTH-1:0] == NTAPS-1) ? 0
                              : count[CNTWIDTH-1:0] + 1 ;
   
   
   //****************************************************************************//
   //*                         Multiplier - Accumulator                         *//
   //****************************************************************************//
    always @ (posedge CLK or posedge ARST)
      if (ARST)     mult[AWIDTH-1:0] <= {(AWIDTH){1'b0}} ;
      else          mult[AWIDTH-1:0] <= coef* SigIn1 ;

   always @ (posedge CLK or posedge ARST)
     if (ARST)
       accum1[AWIDTH-1:0] <= {(AWIDTH){1'b0}} ;
     else if (accum_cnt[ACCUMCNTWIDTH-1:0] == 1)
       accum1[AWIDTH-1:0] <= (count == 1) ? mult
                             : mult[AWIDTH-1:0] + accum1[AWIDTH-1:0] ;
   
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       accum2[AWIDTH-1:0] <= {(AWIDTH){1'b0}} ;
     else if (accum_cnt[ACCUMCNTWIDTH-1:0] == 2)
       accum2[AWIDTH-1:0] <= (count == 16) ? mult
                             :  mult[AWIDTH-1:0] + accum2[AWIDTH-1:0] ;
   
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       accum3[AWIDTH-1:0] <= {(AWIDTH){1'b0}} ;
     else if (accum_cnt[ACCUMCNTWIDTH-1:0] == 3)
       accum3[AWIDTH-1:0] <= (count == 11) ? mult
                             :  mult[AWIDTH-1:0] + accum3[AWIDTH-1:0] ;
   
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       accum4[AWIDTH-1:0] <= {(AWIDTH){1'b0}} ;
     else if (accum_cnt[ACCUMCNTWIDTH-1:0] == 4)
       accum4[AWIDTH-1:0] <= (count == 6) ? mult
                             : mult[AWIDTH-1:0] + accum4[AWIDTH-1:0] ;
   
   
   //****************************************************************************//
   //*                      Output Buffers                                      *//
   //****************************************************************************//
   assign valid1 = (count[CNTWIDTH-1:0] == 1)  & (accum_cnt == 0) ;
   assign valid2 = (count[CNTWIDTH-1:0] == 16) & (accum_cnt == 0) ;
   assign valid3 = (count[CNTWIDTH-1:0] == 11) & (accum_cnt == 0) ;
   assign valid4 = (count[CNTWIDTH-1:0] == 6)  & (accum_cnt == 0) ;
   
   assign valid = valid1 | valid2 | valid3 | valid4 ;
   
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       SigOut[OWIDTH-1:0] <= {(OWIDTH){1'b0}} ;
     else if (valid)
       SigOut[OWIDTH-1:0] <= (accum1[AWIDTH-1:0] & {(AWIDTH){ valid1 }}) |
                             (accum2[AWIDTH-1:0] & {(AWIDTH){ valid2 }}) |
                             (accum3[AWIDTH-1:0] & {(AWIDTH){ valid3 }}) |
                             (accum4[AWIDTH-1:0] & {(AWIDTH){ valid4 }}) ;
   
   always @ (posedge CLK or posedge ARST)
     if (ARST)     DataValid <= 1'b0 ;
     else          DataValid <= valid;
   

endmodule // firdecim_m5_n20
// ******************************************************************************* //
// **                    General Information                                    ** //
// ******************************************************************************* //
// **  Module             : iReg.v                                              ** //
// **  Project            : ISAAC NEWTON                                        ** //
// **  Author             : Kayla Nguyen                                        ** //
// **  First Release Date : August 5, 2008                                      ** //
// **  Description        : Internal Register for Newton core                   ** //
// ******************************************************************************* //
// **                     Revision History                                      ** //
// ******************************************************************************* //
// **                                                                           ** //
// **  File        : iReg.v                                                     ** //
// **  Revision    : 1                                                          ** //
// **  Author      : kaylangu                                                   ** //
// **  Date        : August 5, 2008                                             ** //
// **  FileName    :                                                            ** //
// **  Notes       : Initial Release for ISAAC demo                             ** //
// **                                                                           ** //
// **  File        : iReg.v                                                     ** //
// **  Revision    : 2                                                          ** //
// **  Author      : kaylangu                                                   ** //
// **  Date        : August 19, 2008                                            ** //
// **  FileName    :                                                            ** //
// **  Notes       : 1. Register 0 functional modification                      ** //
// **                2. Bit ReOrdering function change to for loop              ** //
// **                3. Register 1 and Register 2 counter modify to use         ** //
// **                   Write Enable bits                                       ** //
// **                                                                           ** //
// ******************************************************************************* //
`timescale 1 ns / 100 ps

module iReg
  (// Outputs
   iReg_intr, iReg2IP_RdAck, IP2Bus_WrAck, CPTR, IP2Bus_Data, SYNC,
   // Inputs
   Bus2IP_Clk, Bus2IP_Reset, Bus2IP_RdCE, Bus2IP_WrCE, Bus2IP_Data,
   WFIFO_WE, FIR_WE
   );
   
   
   //**************************************************************************//
   //*                         Declarations                                   *//
   //**************************************************************************//
   // DATA TYPE - PARAMETERS
   parameter         r0setclr      = 31;        // Register 0 set/clr bit
   
   parameter         initWM        = 16'hFFFF;
   parameter         ModuleVersion = 2;
              
   // DATA TYPE - INPUTS AND OUTPUTS
   input             Bus2IP_Clk;   // 100MHz Clock from BUS                                   
   input             Bus2IP_Reset; // Asynchronous Reset (positive logic)                     
   input [0:3]       Bus2IP_RdCE;  // Register Read Enable (from Bus)                         
   input [0:3]       Bus2IP_WrCE;  // Register Write Enable (from Bus)                
   input [0:31]      Bus2IP_Data;  // Data from Bus to IP                                     
   input             WFIFO_WE;     // Write Enable Signal from FIFO                           
   input             FIR_WE;       // Write Signal from QM_FIR                        
                                                                                            
   output reg        iReg_intr;    // Interrupt Signal                                
   output            iReg2IP_RdAck;// Read Acknowledgement                                    
   output            IP2Bus_WrAck; // Write Acknowledgement                                   
   output reg [10:0] CPTR;         // Data from IP to bus                                     
   output [0:31]     IP2Bus_Data;  // Pointer to BRAM                                         
   output reg        SYNC;         // Resets QM counter to zero and Reset FIR coef registers
                                   // to initial values                                     
   // DATA TYPE - INTERNAL REG
   reg               OVFL_MSK;     // Overflow Mask
   reg               WMI_MSK;      // WMI Mask
   reg               OVFL;         // Overflow for CPTR
   reg               WMI;          // Watermark Interrupt
   reg [9:0]         SPTR;         // Load to CPTR when SYNC is asserted
   reg [31:0]        ICNT;         // Counts the numbers of inputs
   reg [15:0]        OCNT_WM;      // Output counter watermark
   reg [15:0]        OCNT_int;     // Counts the numbers of outputs
   reg [7:0]         VERSION;      // Current Module version number
   reg [31:0] 	     	IP2Bus_Data_int;  // Internal IP2Bus_Data
   reg 		     		FIR_WE_dly1;
      
   // DATA TYPE - INTERNAL WIRES
   wire [31:0]       ESCR;
   wire [31:0]       WPTR;
   wire [31:0]       OCNT;
   wire [31:0]       Bus2IP_Data_int;  // Internal Bus2IP_Data_int
   wire              setclr;
   
   
   //**************************************************************************//   
   //*                    Reversing Bit ReOrdering                            *//   
   //**************************************************************************//
   assign Bus2IP_Data_int[31:0] = fnBitReordering031to310(Bus2IP_Data[0:31]);
   assign IP2Bus_Data[0:31]     = fnBitReordering310to031(IP2Bus_Data_int[31:0]);

   
   //**************************************************************************//
   //*                             REG 0                                      *//
   //**************************************************************************//
   assign setclr = Bus2IP_WrCE[0] & Bus2IP_Data_int[r0setclr];
   
   always @ (posedge Bus2IP_Clk or posedge Bus2IP_Reset)  
     if (Bus2IP_Reset !== 1'b0)
       OVFL_MSK <= 1'b0;
     else if (Bus2IP_WrCE[0] & Bus2IP_Data_int[18])
       OVFL_MSK <= Bus2IP_Data_int[r0setclr];
   
   always @ (posedge Bus2IP_Clk or posedge Bus2IP_Reset)  
     if (Bus2IP_Reset !== 1'b0)
       WMI_MSK <= 1'b0;
     else if (Bus2IP_WrCE[0] & Bus2IP_Data_int[17]) 
       WMI_MSK <= Bus2IP_Data_int[r0setclr];
   
   always @ (posedge Bus2IP_Clk or posedge Bus2IP_Reset)  
     if (Bus2IP_Reset !== 1'b0)
       OVFL <= 1'b0;     
     else if (CPTR[10] == 1'b1)    // BRAM pointer overflows
       OVFL <= 1'b1;
     else if (Bus2IP_WrCE[0] & Bus2IP_Data_int[2])
       OVFL <= Bus2IP_Data_int[r0setclr];
     
   always @ (posedge Bus2IP_Clk or posedge Bus2IP_Reset)
     if  (Bus2IP_Reset !== 1'b0)
       FIR_WE_dly1 <= 1'b0;
     else
       FIR_WE_dly1 <= FIR_WE;  
    
   always @ (posedge Bus2IP_Clk or posedge Bus2IP_Reset)
     if (Bus2IP_Reset !== 1'b0)
       WMI <= 1'b0;
     else if (FIR_WE_dly1 & (OCNT_int[15:0] == OCNT_WM[15:0])) // Output counter overflows       
       WMI <= 1'b1;
     else if (Bus2IP_WrCE[0] & Bus2IP_Data_int[1])
       WMI <= Bus2IP_Data_int[r0setclr];
   
   always @ (posedge Bus2IP_Clk or posedge Bus2IP_Reset)    
     if (Bus2IP_Reset !== 1'b0)                             
       SYNC <= 1'b0;
     else 
       SYNC <= setclr & Bus2IP_Data_int[0];
 
   always @ (posedge Bus2IP_Clk or posedge Bus2IP_Reset)
     if (Bus2IP_Reset !== 1'b0 )
       VERSION[7:0] <= 8'd0;
     else
       VERSION[7:0] <= ModuleVersion;

   always @ (posedge Bus2IP_Clk or posedge Bus2IP_Reset)
     if (Bus2IP_Reset !== 1'b0)
       iReg_intr <= 1'b0;
     else
       iReg_intr <= (WMI & ~WMI_MSK) | (OVFL & ~OVFL_MSK); 

   // Read out
   assign ESCR[31:0]  = {setclr, 12'd0, OVFL_MSK, WMI_MSK, 1'b0, 
                         VERSION[7:0], 5'd0, OVFL, WMI, 1'b0};   

   
   //**************************************************************************//
   //*                             REG 1                                      *//
   //**************************************************************************//
   always @ (posedge Bus2IP_Clk or posedge Bus2IP_Reset)
     if (Bus2IP_Reset !== 1'b0)
       SPTR[9:0] <= 10'd0;
     else if (Bus2IP_WrCE[1])
       SPTR[9:0] <= Bus2IP_Data_int[25:16];
   
   always @ (posedge Bus2IP_Clk or posedge Bus2IP_Reset)
     if (Bus2IP_Reset !== 1'b0)
       CPTR[10:0] <= 11'd0;
     else if (SYNC == 1'b1)
       begin
          CPTR[9:0] <= SPTR[9:0];
          CPTR[10]  <= 1'b0;
       end
     else if (OVFL == 1'b1)
       CPTR[10]   <= 1'b0;
   else
     CPTR[10:0] <= CPTR[10:0] + FIR_WE; //Pointer to BRAM address
   
   // Readout
   assign WPTR[31:0] = {6'd0, SPTR[9:0], 6'd0, CPTR[9:0]};
   
   
   //**************************************************************************//
   //*                             REG 2                                      *//
   //**************************************************************************//
   always @ (posedge Bus2IP_Clk or posedge Bus2IP_Reset)
     if (Bus2IP_Reset !== 1'b0)
       ICNT[31:0] <= 32'd0;
     else if (Bus2IP_WrCE[2])
       ICNT[31:0] <= Bus2IP_Data_int[31:0];
     else              
       ICNT[31:0] <= ICNT[31:0] + WFIFO_WE;
   
   
   //**************************************************************************//
   //*                             REG 3                                      *//
   //**************************************************************************//
   always @ (posedge Bus2IP_Clk or posedge Bus2IP_Reset)
     if (Bus2IP_Reset !== 1'b0)
       OCNT_WM[15:0] <= initWM;
     else if (Bus2IP_WrCE[3])
       OCNT_WM[15:0] <= Bus2IP_Data_int[31:16];
   
   always @ (posedge Bus2IP_Clk or posedge Bus2IP_Reset)
     if (Bus2IP_Reset !== 1'b0)
       OCNT_int[15:0] <= 16'd0;
     else if (Bus2IP_WrCE[3])
       OCNT_int[15:0] <= Bus2IP_Data_int[15:0];
     else                              
       OCNT_int[15:0] <= OCNT_int[15:0] + FIR_WE;
   
   // Read out
   assign OCNT[31:0] = {OCNT_WM[15:0], OCNT_int[15:0]};
   
   
   //**************************************************************************//
   //*                           Read Out                                     *//
   //**************************************************************************//
   always @ (/*AS*/Bus2IP_RdCE or ESCR or ICNT or OCNT or WPTR)
     begin
        IP2Bus_Data_int[31:0] = 32'b0;
        case (1'b1)
          Bus2IP_RdCE[0]   : IP2Bus_Data_int[31:0] = ESCR[31:0];
          Bus2IP_RdCE[1]   : IP2Bus_Data_int[31:0] = WPTR[31:0];
          Bus2IP_RdCE[2]   : IP2Bus_Data_int[31:0] = ICNT[31:0];
          Bus2IP_RdCE[3]   : IP2Bus_Data_int[31:0] = OCNT[31:0];
        endcase // case (1'b1)
     end

   assign iReg2IP_RdAck = |Bus2IP_RdCE[0:3];
   assign IP2Bus_WrAck  = |Bus2IP_WrCE[0:3];


   //**************************************************************************//
   //*                    Bit ReOrdering Functions                            *//
   //**************************************************************************//   
   function [31:0] fnBitReordering031to310; // From [0:31] to [31:0]
      input [0:31]                           Data1;
      integer                                i;
      begin
         for (i=0;i<32;i=i+1)
           fnBitReordering031to310[i]  = Data1[31-i];
      end                                          
   endfunction // fnBitReordering031to310

   function [0:31] fnBitReordering310to031; // From [31:0] to [0:31]           
      input [31:0]                           Data1;    
      integer                                i;    
      begin                                        
         for (i=0;i<32;i=i+1)                      
           fnBitReordering310to031[i]  = Data1[31-i]; 
      end                                                                               
   endfunction // fnBitReordering310to031
 
endmodule // iReg


 
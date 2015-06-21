// ******************************************************************************* //
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
// **  File        : firdecim_m5_n15.v                                          ** //
// **  Revision    : 2                                                          ** //
// **  Author      : kaylangu                                                   ** //
// **  Date        : October 23, 2008                                           ** //
// **  FileName    :                                                            ** //
// **  Notes       : Add Sync signal to synchronize filter with LkupTbl         ** //
// **                                                                           ** //
// **  File        : firdecim_m5_n15.v                                          ** //
// **  Revision    : 3                                                          ** //
// **  Author      : kaylangu                                                   ** //
// **  Date        : January 28, 2009                                           ** //
// **  FileName    :                                                            ** //
// **  Notes       : Remove Sync signal                                         ** //
// **                                                                           ** //
// **  File        : firdecim_m5_n15.v                                          ** //
// **  Revision    : 4                                                          ** //
// **  Author      : kaylangu                                                   ** //
// **  Date        : February 9, 2009                                           ** //
// **  FileName    :                                                            ** //
// **  Notes       : Remove shift registers for coefficients and replace with   ** //
// **                distrubited ROMs                                           ** //
// **                                                                           ** //
// ******************************************************************************* //
`timescale 1 ns / 100 ps

module firdecim_m5_n15
  (/*AUTOARG*/
   // Outputs
   SigOut, DataValid,
   // Inputs
   CLK, ARST, InputValid, SigIn
   );


   //**************************************************************************//
   //*                       Declarations                                     *//
   //**************************************************************************//
   // DATA TYPE - PARAMETERS
   parameter IWIDTH = 16;
   parameter OWIDTH = 32;
   parameter ACCUMWIDTH = 32;
   
   // DATA TYPE - INPUTS AND OUTPUTS
   output reg signed [(OWIDTH-1):0]  SigOut;
   output reg 			     DataValid;
   
   input 			     CLK; // 60MHz Clock
   input 			     ARST;
   input 			     InputValid;
   input signed [(IWIDTH-1):0] 	     SigIn;
   
   // DATA TYPE - REGISTERS
   reg signed [15:0] 		     coe10;
   reg signed [15:0] 		     coe5;
   reg signed [15:0] 		     coe0;
   
   reg [3:0] 			     count;
   
   // DATA TYPE - WIRES
   wire signed [(ACCUMWIDTH-1):0]    SigOut1;
   wire signed [(ACCUMWIDTH-1):0]    SigOut2;
   wire signed [(ACCUMWIDTH-1):0]    SigOut3;
   
   wire 			     initialize1;
   wire 			     initialize2;
   wire 			     initialize3;
   
   wire 			     DataValid1;
   wire 			     DataValid2;
   wire 			     DataValid3;
   
   wire [3:0] 			     coe0_cnt;
   wire [3:0] 			     coe5_cnt;
   wire [3:0] 			     coe10_cnt;
   
   
   //**************************************************************************//
   //*                     Coefficient Rotation                              *//
   //**************************************************************************//
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       begin
	  coe0[15:0] <= 16'd0;
       end
     else
       begin
	  case (coe0_cnt[3:0])
	    4'b0000: coe0[15:0] <= 16'sb1111111111001010;//0000_0000_0001_1111
	    4'b0001: coe0[15:0] <= 16'sb1111111111011001;//0000_0000_1000_1101
	    4'b0010: coe0[15:0] <= 16'sb0000000001111110;//0000_0001_1000_0010
	    4'b0011: coe0[15:0] <= 16'sb0000001000101101;//0000_0011_0001_1110
	    4'b0100: coe0[15:0] <= 16'sb0000010011101110;//0000_0101_0011_1111
	    4'b0101: coe0[15:0] <= 16'sb0000100000100111;//0000_0111_0111_1000
	    4'b0110: coe0[15:0] <= 16'sb0000101011001010;//0000_1001_0010_1011
	    4'b0111: coe0[15:0] <= 16'sb0000101111001111;//0000_1001_1100_1111
	    4'b1000: coe0[15:0] <= 16'sb0000101011001010;//0000_1001_0010_1011
	    4'b1001: coe0[15:0] <= 16'sb0000100000100111;//0000_0111_0111_1000
	    4'b1010: coe0[15:0] <= 16'sb0000010011101110;//0000_0101_0011_1111
	    4'b1011: coe0[15:0] <= 16'sb0000001000101101;//0000_0011_0001_1110
	    4'b1100: coe0[15:0] <= 16'sb0000000001111110;//0000_0001_1000_0010 
            4'b1101: coe0[15:0] <= 16'sb1111111111011001;//0000_0000_1000_1101
   	    4'b1110: coe0[15:0] <= 16'sb1111111111001010;//0000_0000_0001_1111

	    default: coe0[15:0] <= 16'sb1111111111001010;//0000_0000_0001_1111;
	  endcase 
       end 
















   always @ (posedge CLK or posedge ARST)
     if (ARST)
       begin
	  coe5[15:0] <= 16'd0;
       end
     else
       begin
	  case (coe5_cnt[3:0])
	    4'b0000: coe5[15:0] <= 16'sb0000_0000_0001_1111;
	    4'b0001: coe5[15:0] <= 16'sb0000_0000_1000_1101;
	    4'b0010: coe5[15:0] <= 16'sb0000_0001_1000_0010;
	    4'b0011: coe5[15:0] <= 16'sb0000_0011_0001_1110;
	    
	    4'b0100: coe5[15:0] <= 16'sb0000_0101_0011_1111;
	    4'b0101: coe5[15:0] <= 16'sb0000_0111_0111_1000;
	    4'b0110: coe5[15:0] <= 16'sb0000_1001_0010_1011;
	    4'b0111: coe5[15:0] <= 16'sb0000_1001_1100_1111;
	    
	    4'b1000: coe5[15:0] <= 16'sb0000_1001_0010_1011;
	    4'b1001: coe5[15:0] <= 16'sb0000_0111_0111_1000;
	    4'b1010: coe5[15:0] <= 16'sb0000_0101_0011_1111;
	    4'b1011: coe5[15:0] <= 16'sb0000_0011_0001_1110;
	    
	    4'b1100: coe5[15:0] <= 16'sb0000_0001_1000_0010; 
            4'b1101: coe5[15:0] <= 16'sb0000_0000_1000_1101;
   	    4'b1110: coe5[15:0] <= 16'sb0000_0000_0001_1111;

	    default: coe5[15:0] <= 16'sb0000_0000_0001_1111;
	  endcase 
       end

   always @ (posedge CLK or posedge ARST)
     if (ARST)
       begin
	  coe10[15:0] <= 16'd0;
       end
     else
       begin
	  case (coe10_cnt[3:0])
	    4'b0000: coe10[15:0] <= 16'sb0000_0000_0001_1111;
	    4'b0001: coe10[15:0] <= 16'sb0000_0000_1000_1101;
	    4'b0010: coe10[15:0] <= 16'sb0000_0001_1000_0010;
	    4'b0011: coe10[15:0] <= 16'sb0000_0011_0001_1110;
	    
	    4'b0100: coe10[15:0] <= 16'sb0000_0101_0011_1111;
	    4'b0101: coe10[15:0] <= 16'sb0000_0111_0111_1000;
	    4'b0110: coe10[15:0] <= 16'sb0000_1001_0010_1011;
	    4'b0111: coe10[15:0] <= 16'sb0000_1001_1100_1111;
	    
	    4'b1000: coe10[15:0] <= 16'sb0000_1001_0010_1011;
	    4'b1001: coe10[15:0] <= 16'sb0000_0111_0111_1000;
	    4'b1010: coe10[15:0] <= 16'sb0000_0101_0011_1111;
	    4'b1011: coe10[15:0] <= 16'sb0000_0011_0001_1110;
	    
	    4'b1100: coe10[15:0] <= 16'sb0000_0001_1000_0010; 
            4'b1101: coe10[15:0] <= 16'sb0000_0000_1000_1101;
   	    4'b1110: coe10[15:0] <= 16'sb0000_0000_0001_1111;

	    default: coe10[15:0] <= 16'sb0000_0000_0001_1111;
	  endcase 
       end 

   
   //**************************************************************************//
   //*                         Counter                                        *//
   //**************************************************************************//
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       begin
	  count[3:0] <= {(4){1'b0}} ;
       end
     else if (InputValid)  
       begin
	  count[3:0] <= (count[3:0] == (14)) ? 0 : count[3:0] + 1 ;
       end
   
   assign coe0_cnt[3:0] = count[3:0] == 14 ? 0 :
			  count[3:0] + 1; 
   assign coe5_cnt[3:0] = (count[3:0] + 6 ) > 14 ? count[3:0] - 9 :
			  count[3:0] + 6 ;
   assign coe10_cnt[3:0] = (count[3:0] + 11 ) > 14 ? count[3:0] - 4 :
			   count[3:0] + 11 ;
   
   
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
       begin
	  SigOut[(OWIDTH-1):0] <= {(OWIDTH){1'b0}};
       end
     else if (DataValid1 | DataValid2 | DataValid3)
       begin
	  SigOut[(OWIDTH-1):0] <= {(OWIDTH){DataValid1}} & SigOut1 |
				  {(OWIDTH){DataValid2}} & SigOut2 |
				  {(OWIDTH){DataValid3}} & SigOut3 ;
       end
   
   always @ (posedge CLK or posedge ARST)
     if (ARST)     
       begin
	  DataValid <= 1'b0 ;
       end
     else      
       begin
	  DataValid <= (DataValid1 | DataValid2 | DataValid3)  ;
       end

   
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
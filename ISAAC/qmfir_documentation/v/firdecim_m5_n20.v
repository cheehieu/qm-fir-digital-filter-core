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
// **  File        : firdecim_m5_n20.v                                          ** //
// **  Revision    : 2                                                          ** //
// **  Author      : kaylangu                                                   ** //
// **  Date        : October 23, 2008                                           ** //
// **  FileName    :                                                            ** //
// **  Notes       : Add Sync signal to synchronize filer with LkupTbl          ** //
// **                                                                           ** //
// **  File        : firdecim_m5_n20.v                                          ** //
// **  Revision    : 3                                                          ** //
// **  Author      : kaylangu                                                   ** //
// **  Date        : January 28, 2009                                           ** //
// **  FileName    :                                                            ** //
// **  Notes       : Remove Sync signal                                         ** //
// **                                                                           ** //
// **  File        : firdecim_m5_n20.v                                          ** //
// **  Revision    : 4                                                          ** //
// **  Author      : kaylangu                                                   ** //
// **  Date        : February 9, 2009                                           ** //
// **  FileName    :                                                            ** //
// **  Notes       : Remove shift registers for coefficients and replace with   ** //
// **                distributed ROMs                                           ** //
// **                                                                           ** //
// ******************************************************************************* //
`timescale 1 ns / 100 ps

module firdecim_m5_n20
  (/*AUTOARG*/
   // Outputs
   SigOut, DataValid,
   // Inputs
   CLK, ARST, InputValid, SigIn
   );

   //****************************************************************************//
   //*                         Declarations                                     *//
   //****************************************************************************//
   // DATA TYPE - INPUTS AND OUTPUTS
   output reg signed [31:0]  SigOut      ;
   output reg 		     DataValid   ;
   
   input 		     CLK         ;  // 60MHz Clock
   input 		     ARST        ;
   input 		     InputValid  ;
   
   input      signed [15:0]  SigIn       ;
  
   // DATA TYPE - REGISTERS
   reg [4:0] 		     count       ;
   reg [2:0] 		     accum_cnt   ;  //Counter to keep track of which
                                            //accumulator is being accessed.
   reg signed [15:0]         SigIn1      ;
   reg 			     InputValid0 ;
   reg signed [31:0]         mult        ;
   reg signed [31:0]         accum1      ;  //First accumulator
   reg signed [31:0]         accum2      ;  //Second accumulator
   reg signed [31:0]         accum3      ;  //Third accumulator
   reg signed [31:0]         accum4      ;  //Fourth accumulator
   reg signed [15:0] 	     coef        ;  //Coefficient to be used in the
                                            //multiplier.

   // DATA TYPE - NETS
   wire 		     valid       ;
   wire 		     valid1      ;
   wire 		     valid2      ;
   wire 		     valid3      ;
   wire 		     valid4      ;
   wire [4:0] 		     coef_cnt;

   
   //****************************************************************************//
   //*                           Input Buffers                                  *//
   //****************************************************************************//
   always @ (posedge CLK or posedge ARST)
     if (ARST)     InputValid0 <= 1'b0 ;
     else          InputValid0 <= InputValid ;

   always @ (posedge CLK or posedge ARST)
     if (ARST)     SigIn1[15:0] <= {(16){1'b0}} ;
     else          SigIn1[15:0] <= SigIn[15:0];
   
   
   //****************************************************************************//
   //*                   Coefficient Rotation / Selector                        *//
   //****************************************************************************//
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       begin
	  coef[15:0] <= 16'b0;
       end
     else
       begin
	  case (coef_cnt[4:0])
	    5'b00000: coef[15:0] <= 16'sb1111_1111_1011_1000;
	    5'b00001: coef[15:0] <= 16'sb1111_1111_1000_0110;
	    5'b00010: coef[15:0] <= 16'sb1111_1111_0110_1110;
	    5'b00011: coef[15:0] <= 16'sb1111_1111_1011_1110;
	                              
	    5'b00100: coef[15:0] <= 16'sb0000_0000_1011_0011;
	    5'b00101: coef[15:0] <= 16'sb0000_0010_0110_1101;
	    5'b00110: coef[15:0] <= 16'sb0000_0100_1100_0101;
	    5'b00111: coef[15:0] <= 16'sb0000_0111_0101_0101;
	                              
	    5'b01000: coef[15:0] <= 16'sb0000_1001_1000_0111;
	    5'b01001: coef[15:0] <= 16'sb0000_1010_1100_1101;
	    5'b01010: coef[15:0] <= 16'sb0000_1010_1100_1101;
	    5'b01011: coef[15:0] <= 16'sb0000_1001_1000_0111;
	                              
	    5'b01100: coef[15:0] <= 16'sb0000_0111_0101_0101;
	    5'b01101: coef[15:0] <= 16'sb0000_0100_1100_0101;
	    5'b01110: coef[15:0] <= 16'sb0000_0010_0110_1101;
	    5'b01111: coef[15:0] <= 16'sb0000_0000_1011_0011;
	                              
	    5'b10000: coef[15:0] <= 16'sb1111_1111_1011_1110;
	    5'b10001: coef[15:0] <= 16'sb1111_1111_0110_1110;
	    5'b10010: coef[15:0] <= 16'sb1111_1111_1000_0110;
	    5'b10011: coef[15:0] <= 16'sb1111_1111_1011_1000;

	    default: coef[15:0] <= 16'sb1111_1111_1011_1000;
	  endcase
       end
   
   
   //****************************************************************************//
   //*                           Counters                                       *//
   //****************************************************************************//
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       accum_cnt[2:0] <= {(3){1'b0}} ;
     else
       accum_cnt[2:0] <= (InputValid  & ~InputValid0) ?
                         0:
                         (accum_cnt == 5) ? (5)
                           : accum_cnt[2:0] + 1 ;
   
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       count[4:0] <= {(5){1'b0}} ;
     else if (InputValid & ~InputValid0)
       count[4:0] <= (count[4:0] == 19) ? 0
                     : count[4:0] + 1 ;

   assign coef_cnt[4:0] =  count[4:0] == 0 ?
			   5*accum_cnt[2:0] - 1 :
			   ( count[4:0] + 5*accum_cnt[2:0] - 1) > 19 ?
			   count[4:0] + 5*accum_cnt[2:0] - 21   :
			   count[4:0] + 5*accum_cnt[2:0] - 1;
   

   //****************************************************************************//
   //*                         Multiplier - Accumulator                         *//
   //****************************************************************************//
    always @ (posedge CLK or posedge ARST)
      if (ARST)     mult[31:0] <= {(32){1'b0}} ;
      else          mult[31:0] <= coef* SigIn1 ;

   always @ (posedge CLK or posedge ARST)
     if (ARST)
       accum1[31:0] <= {(32){1'b0}} ;
     else if (accum_cnt[2:0] == 2)
       accum1[31:0] <= (count == 1) ? mult
                       : mult[31:0] + accum1[31:0] ;
   
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       accum2[31:0] <= {(32){1'b0}} ;
     else if (accum_cnt[2:0] == 3)
       accum2[31:0] <= (count == 16) ? mult
                       :  mult[31:0] + accum2[31:0] ;
   
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       accum3[31:0] <= {(32){1'b0}} ;
     else if (accum_cnt[2:0] == 4)
       accum3[31:0] <= (count == 11) ? mult
                       :  mult[31:0] + accum3[31:0] ;
   
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       accum4[31:0] <= {(32){1'b0}} ;
     else if (accum_cnt[2:0] == 0)
       accum4[31:0] <= (count == 7) ? mult
                       : mult[31:0] + accum4[31:0] ;
   
   
   //****************************************************************************//
   //*                      Output Buffers                                      *//
   //****************************************************************************//
   assign valid1 = (count[4:0] == 1)  & (accum_cnt == 1) ;
   assign valid2 = (count[4:0] == 16) & (accum_cnt == 1) ;
   assign valid3 = (count[4:0] == 11) & (accum_cnt == 1) ;
   assign valid4 = (count[4:0] == 6)  & (accum_cnt == 1) ;
   
   assign valid = valid1 | valid2 | valid3 | valid4 ;
   
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       SigOut[31:0] <= {(32){1'b0}} ;
     else if (valid)
       SigOut[31:0] <= (accum1[31:0] & {(32){ valid1 }}) |
                       (accum2[31:0] & {(32){ valid2 }}) |
                       (accum3[31:0] & {(32){ valid3 }}) |
                       (accum4[31:0] & {(32){ valid4 }}) ;
   
   always @ (posedge CLK or posedge ARST)
     if (ARST)     DataValid <= 1'b0 ;
     else          DataValid <= valid;
   

endmodule // firdecim_m5_n20
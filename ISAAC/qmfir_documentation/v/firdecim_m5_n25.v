// ******************************************************************************* //
// **                    General Information                                    ** //
// ******************************************************************************* //
// **  Module             : firdecim_m5_n25.v                                   ** //
// **  Project            : ISAAC NEWTON                                        ** //
// **  Author             : Kayla Nguyen                                        ** //
// **  First Release Date : February 12, 2009                                   ** //
// **  Description        : Polyphase Decimation Filter                         ** //
// **                       M = 5, L = 25                                       ** //
// ******************************************************************************* //
// **                     Revision History                                      ** //
// ******************************************************************************* //
// **                                                                           ** //
// **  File        : firdecim_m5_n25.v                                          ** //
// **  Revision    : 1                                                          ** //
// **  Author      : kaylangu                                                   ** //
// **  Date        : February 12, 2009                                          ** //
// **  FileName    :                                                            ** //
// **  Notes       : Modification from firdecim_m5_n20                          ** //
// **                                                                           ** //
// ******************************************************************************* //
`timescale 1 ns / 100 ps

module firdecim_m5_n25
  (/*AUTOARG*/
   // Outputs
   SigOut, DataValid,
   // Inputs
   CLK, ARST, InputValid, SigIn
   );

   //****************************************************************************//
   //*                         Declarations                                     *//
   //****************************************************************************//
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
   reg [4:0] 			     count;
   reg [2:0] 			     accum_cnt;  //Counter to keep track of which
                                                 //accumulator is being accessed.
   reg signed [(IWIDTH-1):0] 	     SigIn1;   
   reg signed [(IWIDTH-1):0] 	     SigIn2;
   
   reg 				     InputValid0;
   reg signed [(ACCUMWIDTH-1):0]     mult;
   reg signed [(ACCUMWIDTH-1):0]     accum1;  //First accumulator
   reg signed [(ACCUMWIDTH-1):0]     accum2;  //Second accumulator
   reg signed [(ACCUMWIDTH-1):0]     accum3;  //Third accumulator
   reg signed [(ACCUMWIDTH-1):0]     accum4;  //Fourth accumulator
   reg signed [(ACCUMWIDTH-1):0]     accum5;  //Fifth accumulator
   reg signed [15:0] 		     coef;    //Coefficient to be used in the
                                              //multiplier.

   // DATA TYPE - NETS
   wire 			     valid;
   wire 			     valid1;
   wire 			     valid2;
   wire 			     valid3;
   wire 			     valid4;
   wire 			     valid5;
   
   wire [4:0] 			     coef_cnt;

   
   //****************************************************************************//
   //*                           Input Buffers                                  *//
   //****************************************************************************//
   always @ (posedge CLK or posedge ARST)
     if (ARST)     
       begin
	  InputValid0 <= 1'b0 ;
	  SigIn1[(IWIDTH-1):0] <= {(IWIDTH){1'b0}};
	  SigIn2[(IWIDTH-1):0] <= {(IWIDTH){1'b0}};
       end
     else 
       begin
          InputValid0 <= InputValid ;
	  SigIn1[(IWIDTH-1):0] <= SigIn[(IWIDTH-1):0];
	  SigIn2[(IWIDTH-1):0] <= SigIn1[(IWIDTH-1):0];
       end
   
   
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
	    5'b00000: coef[15:0] <= 16'sb0000000000111010;//1111_1111_1110_1100
	    5'b00001: coef[15:0] <= 16'sb0000000000100101;//1111_1111_1011_1010
	    5'b00010: coef[15:0] <= 16'sb1111111111101100;//1111_1111_0111_0010
	    5'b00011: coef[15:0] <= 16'sb1111111101110100;//1111_1111_0001_1011
	    5'b00100: coef[15:0] <= 16'sb1111111011100100;//1111_1110_1110_1011
	    5'b00101: coef[15:0] <= 16'sb1111111010010000;//1111_1111_0001_0111
	    5'b00110: coef[15:0] <= 16'sb1111111011101000;//1111_1111_1110_0011
	    5'b00111: coef[15:0] <= 16'sb0000000001000110;//0000_0001_0110_1001
	    5'b01000: coef[15:0] <= 16'sb0000001010111001;//0000_0011_1001_1101
	    5'b01001: coef[15:0] <= 16'sb0000010111101000;//0000_0110_0010_1001
	    5'b01010: coef[15:0] <= 16'sb0000100100100000;//0000_1000_1001_0100
	    5'b01011: coef[15:0] <= 16'sb0000101110000110;//0000_1010_0100_1110
	    5'b01100: coef[15:0] <= 16'sb0000110001101010;//0000_1010_1111_0000
	    5'b01101: coef[15:0] <= 16'sb0000101110000110;//0000_1010_0100_1110    
	    5'b01110: coef[15:0] <= 16'sb0000100100100000;//0000_1000_1001_0100
	    5'b01111: coef[15:0] <= 16'sb0000010111101000;//0000_0110_0010_1001
	    5'b10000: coef[15:0] <= 16'sb0000001010111001;//0000_0011_1001_1101
	    5'b10001: coef[15:0] <= 16'sb0000000001000110;//0000_0001_0110_1001
	    5'b10010: coef[15:0] <= 16'sb1111111011101000;//1111_1111_1110_0011
	    5'b10011: coef[15:0] <= 16'sb1111111010010000;//1111_1111_0001_0111
	    5'b10100: coef[15:0] <= 16'sb1111111011100100;//1111_1110_1110_1011
	    5'b10101: coef[15:0] <= 16'sb1111111101110100;//1111_1111_0001_1011
	    5'b10110: coef[15:0] <= 16'sb1111111111101100;//1111_1111_0111_0010
	    5'b10111: coef[15:0] <= 16'sb0000000000100101;//1111_1111_1011_1010
	    5'b11000: coef[15:0] <= 16'sb0000000000111010;//1111_1111_1110_1100
					  
	    default: coef[15:0] <= 16'sb0000000000111010;
	  endcase			  
       end				  


   //****************************************************************************//
   //*                           Counters                                       *//
   //****************************************************************************//
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       begin
	  accum_cnt[2:0] <= {(3){1'b0}} ;
       end     
     else
       begin
	  accum_cnt[2:0] <= (InputValid  & ~InputValid0) ?
                            0:
                            (accum_cnt == 5) ? (5)
                              : accum_cnt[2:0] + 1 ;
       end 
   
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       begin
	  count[4:0] <= {(5){1'b0}} ;
       end     
     else if (InputValid & ~InputValid0)
       begin 
	  count[4:0] <= (count[4:0] == 24) ? 0
			: count[4:0] + 1 ;
       end
   
   assign coef_cnt[4:0] =  count[4:0] == 0 & accum_cnt[2:0] == 0 ? 24 :
			   (count[4:0] + 5*accum_cnt[2:0] - 1) > 24 ?
			   count[4:0] + 5*accum_cnt[2:0] - 26   :
			   count[4:0] + 5*accum_cnt[2:0] - 1;
   

   //****************************************************************************//
   //*                         Multiplier - Accumulator                         *//
   //****************************************************************************//
    always @ (posedge CLK or posedge ARST)
      if (ARST)    
	begin
	   mult[(ACCUMWIDTH-1):0] <= {(ACCUMWIDTH){1'b0}} ;
	end
      else 
        begin
	   mult[(ACCUMWIDTH-1):0] <= coef* SigIn2 ;
	end
	   
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       accum1[(ACCUMWIDTH-1):0] <= {(ACCUMWIDTH){1'b0}} ;
     else if (accum_cnt[2:0] == 2)
       accum1[(ACCUMWIDTH-1):0] <= (count == 1) ? mult
                       : mult[(ACCUMWIDTH-1):0] + accum1[(ACCUMWIDTH-1):0] ;
   
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       accum2[(ACCUMWIDTH-1):0] <= {(ACCUMWIDTH){1'b0}} ;
     else if (accum_cnt[2:0] == 3)
       accum2[(ACCUMWIDTH-1):0] <= (count == 21) ? mult
                       :  mult[(ACCUMWIDTH-1):0] + accum2[(ACCUMWIDTH-1):0] ;
   
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       accum3[(ACCUMWIDTH-1):0] <= {(ACCUMWIDTH){1'b0}} ;
     else if (accum_cnt[2:0] == 4)
       accum3[(ACCUMWIDTH-1):0] <= (count == 16) ? mult
                       :  mult[(ACCUMWIDTH-1):0] + accum3[(ACCUMWIDTH-1):0] ;
   
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       accum4[(ACCUMWIDTH-1):0] <= {(ACCUMWIDTH){1'b0}} ;
     else if (accum_cnt[2:0] == 0)
       accum4[(ACCUMWIDTH-1):0] <= (count == 12) ? mult
                       : mult[(ACCUMWIDTH-1):0] + accum4[(ACCUMWIDTH-1):0] ;
   
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       accum5[(ACCUMWIDTH-1):0] <= {(ACCUMWIDTH){1'b0}} ;
     else if (accum_cnt[2:0] == 1)
       accum5[(ACCUMWIDTH-1):0] <= (count ==7) ? mult
                       : mult[(ACCUMWIDTH-1):0] + accum5[(ACCUMWIDTH-1):0] ;

   
   //****************************************************************************//
   //*                      Output Buffers                                      *//
   //****************************************************************************//
   assign valid1 = (count[4:0] == 1)  & (accum_cnt == 2) ;
   assign valid2 = (count[4:0] == 21) & (accum_cnt == 2) ;
   assign valid3 = (count[4:0] == 16) & (accum_cnt == 2) ;
   assign valid4 = (count[4:0] == 11) & (accum_cnt == 2) ;
   assign valid5 = (count[4:0] == 6)  & (accum_cnt == 2) ;
   
   assign valid = valid1 | valid2 | valid3 | valid4 | valid5 ;
   
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       begin
	  SigOut[(OWIDTH-1):0] <= {(OWIDTH){1'b0}} ;
       end     
     else if (valid)
       begin
	  SigOut[(OWIDTH-1):0] <= (accum1[(ACCUMWIDTH-1):0] & {(OWIDTH){ valid1 }}) |
				  (accum2[(ACCUMWIDTH-1):0] & {(OWIDTH){ valid2 }}) |
				  (accum3[(ACCUMWIDTH-1):0] & {(OWIDTH){ valid3 }}) |
				  (accum4[(ACCUMWIDTH-1):0] & {(OWIDTH){ valid4 }}) |
				  (accum5[(ACCUMWIDTH-1):0] & {(OWIDTH){ valid5 }}) ;
       end
   
   always @ (posedge CLK or posedge ARST)
     if (ARST)     
       begin
	  DataValid <= 1'b0 ;
       end
     else      
       begin
	  DataValid <= valid;
       end

endmodule // firdecim_m5_n25
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
// **  File        : firdecim_m2_n50.v                                          ** //
// **  Revision    : 2                                                          ** //
// **  Author      : kaylangu                                                   ** //
// **  Date        : October 23, 2008                                           ** //
// **  FileName    : firdecim_m2_n50.v                                          ** //
// **  Notes       : Add Sync signal to synchronize the filter with the LkupTbl ** //
// **                                                                           ** //
// **  File        : firdecim_m2_n50.v                                          ** //
// **  Revision    : 3                                                          ** //
// **  Author      : kaylangu                                                   ** //
// **  Date        : January 29, 2009                                           ** //
// **  FileName    : firdecim_m2_n50.v                                          ** //
// **  Notes       : Remove Sync signal                                         ** //
// **                                                                           ** //
// **  File        : firdecim_m2_n50.v                                          ** //
// **  Revision    : 4                                                          ** //
// **  Author      : kaylangu                                                   ** //
// **  Date        : February 9, 2009                                           ** //
// **  FileName    : firdecim_m2_n50.v                                          ** //
// **  Notes       : Remove shift registers for coefficients and replace with   ** //
// **                distributed ROMs                                           ** //
// **                                                                           ** //
// ******************************************************************************* //
`timescale 1 ns / 100 ps

module firdecim_m2_n50
  (/*AUTOARG*/
   // Outputs
   SigOut, DataValid,
   // Inputs
   CLK, ARST, InputValid, SigIn
   );


   //**************************************************************************//
   //*                     Declarations                                       *//
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
   reg [5:0] 			     count;
   reg [5:0] 			     count1;
   reg [4:0] 			     accum_cnt1;
   reg [4:0] 			     accum_cnt;  //Counter to keep track of which 
                                                 //accumulator is being accessed.
   
   reg 				     InputValid0;
   reg 				     InputValid1;
   
   reg signed [(IWIDTH-1):0] 	     SigIn1;
   reg signed [(IWIDTH-1):0] 	     SigIn2;
   
   reg signed [(ACCUMWIDTH-1):0]     mult;
   
   reg signed [(ACCUMWIDTH-1):0]     accum1;  //First accumulator
   reg signed [(ACCUMWIDTH-1):0]     accum2;  //Second accumulator
   reg signed [(ACCUMWIDTH-1):0]     accum3;  //Rhird accumulator
   reg signed [(ACCUMWIDTH-1):0]     accum4;  //Fourth accumulator
   reg signed [(ACCUMWIDTH-1):0]     accum5;  //Fifth accumulator
   reg signed [(ACCUMWIDTH-1):0]     accum6;  //Sixth accumulator
   reg signed [(ACCUMWIDTH-1):0]     accum7;  //Seventh accumulator
   reg signed [(ACCUMWIDTH-1):0]     accum8;  //Eigth accumulator
   reg signed [(ACCUMWIDTH-1):0]     accum9;  //Ninth accumulator
   reg signed [(ACCUMWIDTH-1):0]     accum10;  //Tenth accumulator
   reg signed [(ACCUMWIDTH-1):0]     accum11;  //Eleventh accumulator
   reg signed [(ACCUMWIDTH-1):0]     accum12;  //Twelve accumulator
   reg signed [(ACCUMWIDTH-1):0]     accum13;  //Thirteenth accumulator
   reg signed [(ACCUMWIDTH-1):0]     accum14;  //Fourteenth accumulator
   reg signed [(ACCUMWIDTH-1):0]     accum15;  //Fifteenth accumulator
   reg signed [(ACCUMWIDTH-1):0]     accum16;  //Sixteenth accumulator
   reg signed [(ACCUMWIDTH-1):0]     accum17;  //Seventeenth accumulator
   reg signed [(ACCUMWIDTH-1):0]     accum18;  //Eighteenth accumulator
   reg signed [(ACCUMWIDTH-1):0]     accum19;  //Ninteenth accumulator
   reg signed [(ACCUMWIDTH-1):0]     accum20;  //20th accumulator
   reg signed [(ACCUMWIDTH-1):0]     accum21;  //21st accumulator
   reg signed [(ACCUMWIDTH-1):0]     accum22;  //22nd accumulator
   reg signed [(ACCUMWIDTH-1):0]     accum23;  //23rd accumulator
   reg signed [(ACCUMWIDTH-1):0]     accum24;  //24th accumulator
   reg signed [(ACCUMWIDTH-1):0]     accum25;  //25th accumulator
   
   reg signed [15:0] 		     coef;
   
   // DATA TYPE - WIRES
   wire [5:0] 			     coef_cnt;
   
   wire 			     valid;
   wire 			     valid1;
   wire 			     valid2;
   wire 			     valid3;
   wire 			     valid4;
   wire 			     valid5;
   wire 			     valid6;
   wire 			     valid7;
   wire 			     valid8;
   wire 			     valid9;
   wire 			     valid10;
   wire 			     valid11;
   wire 			     valid12;
   wire 			     valid13;
   wire 			     valid14;
   wire 			     valid15;
   wire 			     valid16;
   wire 			     valid17;
   wire 			     valid18;
   wire 			     valid19;
   wire 			     valid20;
   wire 			     valid21;
   wire 			     valid22;
   wire 			     valid23;
   wire 			     valid24;
   wire 			     valid25;
   
   
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
          SigIn1[(IWIDTH-1):0] <= {(IWIDTH){1'b0}} ;
          SigIn2[(IWIDTH-1):0] <= {(IWIDTH){1'b0}};
       end
     else
       begin
          SigIn2[(IWIDTH-1):0] <= SigIn[(IWIDTH-1):0];
          SigIn1[(IWIDTH-1):0] <= SigIn2[(IWIDTH-1):0];
       end
   
   
   //**************************************************************************//
   //*                 Coefficient Rotation / Selector                        *//
   //**************************************************************************//
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       begin
	  coef[15:0] <= 16'd0;
       end
     else
       begin
	  case (coef_cnt[5:0])
	    6'b000000: coef[15:0] <= 16'sb1111111111010011;//0000_0000_0010_1010   
	    6'b000001: coef[15:0] <= 16'sb0000000001010100;//0000_0000_0001_0011	 
	    6'b000010: coef[15:0] <= 16'sb0000000001001110;//1111_1111_1010_0000	 
	    6'b000011: coef[15:0] <= 16'sb1111111111100011;//1111_1111_0011_1100	 
	    6'b000100: coef[15:0] <= 16'sb1111111110100110;//1111_1111_1000_1010	 
	    6'b000101: coef[15:0] <= 16'sb0000000000010111;//0000_0000_0100_1010	 
	    6'b000110: coef[15:0] <= 16'sb0000000010000101;//0000_0000_0110_1011	 
	    6'b000111: coef[15:0] <= 16'sb0000000000001011;//1111_1111_1010_1101	 
	    6'b001000: coef[15:0] <= 16'sb1111111101010011;//1111_1111_0100_1101	 
	    6'b001001: coef[15:0] <= 16'sb1111111110111111;//0000_0000_0010_0001	 
	    6'b001010: coef[15:0] <= 16'sb0000000011001111;//0000_0000_1110_1111	 
	    6'b001011: coef[15:0] <= 16'sb0000000010010011;//0000_0000_0010_1110	 
	    6'b001100: coef[15:0] <= 16'sb1111111100011110;//1111_1110_1101_1100	 
	    6'b001101: coef[15:0] <= 16'sb1111111011111100;//1111_1111_0101_0111	 
	    6'b001110: coef[15:0] <= 16'sb0000000011011100;//0000_0001_0011_1101	 
	    6'b001111: coef[15:0] <= 16'sb0000000110011010;//0000_0001_0101_0100	 
	    6'b010000: coef[15:0] <= 16'sb1111111101010110;//1111_1110_1101_1010	 
	    6'b010001: coef[15:0] <= 16'sb1111110110011111;//1111_1101_1100_0101	 
	    6'b010010: coef[15:0] <= 16'sb0000000000101111;//0000_0000_1011_1100	 
	    6'b010011: coef[15:0] <= 16'sb0000001101111011;//0000_0011_0111_1100	 
	    6'b010100: coef[15:0] <= 16'sb0000000011011010;//0000_0000_0100_1000	 
	    6'b010101: coef[15:0] <= 16'sb1111101010011111;//1111_1010_0111_0101	 
	    6'b010110: coef[15:0] <= 16'sb1111110001110000;//1111_1100_1111_1001	 
	    6'b010111: coef[15:0] <= 16'sb0000101100111110;//0000_1011_1001_0000	 
	    6'b011000: coef[15:0] <= 16'sb0001101011011010;//0001_1010_0110_1000	 
	    6'b011001: coef[15:0] <= 16'sb0001101011011010;//0001_1010_0110_1000	 
	    6'b011010: coef[15:0] <= 16'sb0000101100111110;//0000_1011_1001_0000	 
	    6'b011011: coef[15:0] <= 16'sb1111110001110000;//1111_1100_1111_1001	 
	    6'b011100: coef[15:0] <= 16'sb1111101010011111;//1111_1010_0111_0101	 
	    6'b011101: coef[15:0] <= 16'sb0000000011011010;//0000_0000_0100_1000	 
	    6'b011110: coef[15:0] <= 16'sb0000001101111011;//0000_0011_0111_1100	 
	    6'b011111: coef[15:0] <= 16'sb0000000000101111;//0000_0000_1011_1100	 
	    6'b100000: coef[15:0] <= 16'sb1111110110011111;//1111_1101_1100_0101	 
	    6'b100001: coef[15:0] <= 16'sb1111111101010110;//1111_1110_1101_1010	 
	    6'b100010: coef[15:0] <= 16'sb0000000110011010;//0000_0001_0101_0100	 
	    6'b100011: coef[15:0] <= 16'sb0000000011011100;//0000_0001_0011_1101	 
	    6'b100100: coef[15:0] <= 16'sb1111111011111100;//1111_1111_0101_0111	 
	    6'b100101: coef[15:0] <= 16'sb1111111100011110;//1111_1110_1101_1100	 
	    6'b100110: coef[15:0] <= 16'sb0000000010010011;//0000_0000_0010_1110	 
	    6'b100111: coef[15:0] <= 16'sb0000000011001111;//0000_0000_1110_1111	 
	    6'b101000: coef[15:0] <= 16'sb1111111110111111;//0000_0000_0010_0001	 
	    6'b101001: coef[15:0] <= 16'sb1111111101010011;//1111_1111_0100_1101	 
	    6'b101010: coef[15:0] <= 16'sb0000000000001011;//1111_1111_1010_1101	 
	    6'b101011: coef[15:0] <= 16'sb0000000010000101;//0000_0000_0110_1011	 
	    6'b101100: coef[15:0] <= 16'sb0000000000010111;//0000_0000_0100_1010	 
	    6'b101101: coef[15:0] <= 16'sb1111111110100110;//1111_1111_1000_1010	 
	    6'b101110: coef[15:0] <= 16'sb1111111111100011;//1111_1111_0011_1100	 
	    6'b101111: coef[15:0] <= 16'sb0000000001001110;//1111_1111_1010_0000	 
	    6'b110000: coef[15:0] <= 16'sb0000000001010100;//0000_0000_0001_0011	 
	    6'b110001: coef[15:0] <= 16'sb1111111111010011;//0000_0000_0010_1010	 

	    default: coef[15:0] <= 16'sb1111111111010011;//0000_0000_0010_1010;
	  endcase
       end


   //**************************************************************************//
   //*                         Counters                                       *//
   //**************************************************************************//
     always @ (posedge CLK or posedge ARST)                             
     if (ARST)     
       begin                                                  
	  count1[5:0] <= {(6){1'b0}} ; 
       end 
     else if (InputValid & ~InputValid1)   
       begin                             
	  count1[5:0] <= (count[5:0] == 49) ? 0     
			 : count[5:0] + 1 ;  
       end
   
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       begin
	  accum_cnt[4:0]  <= {(5){1'b0}} ;
	  accum_cnt1[4:0] <= {(5){1'b0}}    ;
	  count[5:0]      <= {(6){1'b0}}   ;
       end
     else
       begin
	  accum_cnt[4:0]  <= (InputValid  & ~InputValid0) ? 0:
                             (accum_cnt == 26) ? (26) 
                               : accum_cnt[4:0] + 1 ;
	  accum_cnt1[4:0] <= accum_cnt[4:0] ;
	  count[5:0]      <= count1[5:0] ;
       end
         
   assign coef_cnt[5:0] = count1[5:0] == 0 ?
			  2*accum_cnt[4:0] -1:
			  (count1[5:0] + 2*accum_cnt[4:0] - 1) > 49 ?
			  count1[5:0] + 2*accum_cnt[4:0] - 51  :
			  count1[5:0] + 2*accum_cnt[4:0] - 1;
   
   
   //**************************************************************************//
   //*                    Coefficient Rotation / Selector                     *//
   //**************************************************************************//
   always @ (posedge CLK or posedge ARST)
     if (ARST)     
       begin
	  mult[(ACCUMWIDTH-1):0] <= {(ACCUMWIDTH){1'b0}};
       end
     else 
       begin
          mult[(ACCUMWIDTH-1):0] <= coef * SigIn1;  // Signed multiplication
       end
	  
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       accum1[(ACCUMWIDTH-1):0] <= {(ACCUMWIDTH){1'b0}} ;
     else if (accum_cnt1[4:0] == 1)
       accum1[(ACCUMWIDTH-1):0] <= (count == 1) ? mult  
				   : mult[(ACCUMWIDTH-1):0] + accum1[(ACCUMWIDTH-1):0] ;
   
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       accum2[(ACCUMWIDTH-1):0] <= {(ACCUMWIDTH){1'b0}} ;
     else if (accum_cnt1[4:0] == 2)
       accum2[(ACCUMWIDTH-1):0] <= (count == 49) ? mult  
				   : mult[(ACCUMWIDTH-1):0] + accum2[(ACCUMWIDTH-1):0] ;
   
   
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       accum3[(ACCUMWIDTH-1):0] <= {(ACCUMWIDTH){1'b0}} ;
     else if (accum_cnt1[4:0] == 3)
       accum3[(ACCUMWIDTH-1):0] <= (count == 47) ? mult  
				   : mult[(ACCUMWIDTH-1):0] + accum3[(ACCUMWIDTH-1):0] ;
   
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       accum4[(ACCUMWIDTH-1):0] <= {(ACCUMWIDTH){1'b0}} ;
     else if (accum_cnt1[4:0] == 4)
       accum4[(ACCUMWIDTH-1):0] <= (count == 45) ? mult  
				   : mult[(ACCUMWIDTH-1):0] + accum4[(ACCUMWIDTH-1):0] ;
   
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       accum5[(ACCUMWIDTH-1):0] <= {(ACCUMWIDTH){1'b0}} ;
     else if (accum_cnt1[4:0] == 5)
       accum5[(ACCUMWIDTH-1):0] <= (count == 43) ? mult  
				   : mult[(ACCUMWIDTH-1):0] + accum5[(ACCUMWIDTH-1):0] ;
   
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       accum6[(ACCUMWIDTH-1):0] <= {(ACCUMWIDTH){1'b0}} ;
     else if (accum_cnt1[4:0] == 6)
       accum6[(ACCUMWIDTH-1):0] <= (count == 41) ? mult  
                             : mult[(ACCUMWIDTH-1):0] + accum6[(ACCUMWIDTH-1):0] ;

   always @ (posedge CLK or posedge ARST)
     if (ARST)
       accum7[(ACCUMWIDTH-1):0] <= {(ACCUMWIDTH){1'b0}} ;
     else if (accum_cnt1[4:0] == 7)
       accum7[(ACCUMWIDTH-1):0] <= (count == 39) ? mult  
				   : mult[(ACCUMWIDTH-1):0] + accum7[(ACCUMWIDTH-1):0] ;
   
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       accum8[(ACCUMWIDTH-1):0] <= {(ACCUMWIDTH){1'b0}} ;
     else if (accum_cnt1[4:0] == 8)
       accum8[(ACCUMWIDTH-1):0] <= (count == 37) ? mult  
				   : mult[(ACCUMWIDTH-1):0] + accum8[(ACCUMWIDTH-1):0] ;
   
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       accum9[(ACCUMWIDTH-1):0] <= {(ACCUMWIDTH){1'b0}} ;
     else if (accum_cnt1[4:0] ==9)
       accum9[(ACCUMWIDTH-1):0] <= (count == 35) ? mult  
				   : mult[(ACCUMWIDTH-1):0] + accum9[(ACCUMWIDTH-1):0] ;
   
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       accum10[(ACCUMWIDTH-1):0] <= {(ACCUMWIDTH){1'b0}} ;
     else if (accum_cnt1[4:0] ==10)
       accum10[(ACCUMWIDTH-1):0] <= (count == 33) ? mult  
				    : mult[(ACCUMWIDTH-1):0] + accum10[(ACCUMWIDTH-1):0] ;
   
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       accum11[(ACCUMWIDTH-1):0] <= {(ACCUMWIDTH){1'b0}} ;
     else if (accum_cnt1[4:0] == 11)
       accum11[(ACCUMWIDTH-1):0] <= (count == 31) ? mult  
				    :  mult[(ACCUMWIDTH-1):0] + accum11[(ACCUMWIDTH-1):0] ;
   
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       accum12[(ACCUMWIDTH-1):0] <= {(ACCUMWIDTH){1'b0}} ;
     else if (accum_cnt1[4:0] == 12)
       accum12[(ACCUMWIDTH-1):0] <= (count == 29) ? mult  
				    :  mult[(ACCUMWIDTH-1):0] + accum12[(ACCUMWIDTH-1):0] ;
   
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       accum13[(ACCUMWIDTH-1):0] <= {(ACCUMWIDTH){1'b0}} ;
     else if (accum_cnt1[4:0] == 13)
       accum13[(ACCUMWIDTH-1):0] <= (count == 27) ? mult  
				    :  mult[(ACCUMWIDTH-1):0] + accum13[(ACCUMWIDTH-1):0] ;
   
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       accum14[(ACCUMWIDTH-1):0] <= {(ACCUMWIDTH){1'b0}} ;
     else if (accum_cnt1[4:0] == 14)
       accum14[(ACCUMWIDTH-1):0] <= (count == 25) ? mult  
				    :  mult[(ACCUMWIDTH-1):0] + accum14[(ACCUMWIDTH-1):0] ;
   
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       accum15[(ACCUMWIDTH-1):0] <= {(ACCUMWIDTH){1'b0}} ;
     else if (accum_cnt1[4:0] == 15)
       accum15[(ACCUMWIDTH-1):0] <= (count == 23) ? mult  
				    :  mult[(ACCUMWIDTH-1):0] + accum15[(ACCUMWIDTH-1):0] ;
   
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       accum16[(ACCUMWIDTH-1):0] <= {(ACCUMWIDTH){1'b0}} ;
     else if (accum_cnt1[4:0] == 16)
       accum16[(ACCUMWIDTH-1):0] <= (count == 21) ? mult  
				    :  mult[(ACCUMWIDTH-1):0] + accum16[(ACCUMWIDTH-1):0] ;

   always @ (posedge CLK or posedge ARST)
     if (ARST)
       accum17[(ACCUMWIDTH-1):0] <= {(ACCUMWIDTH){1'b0}} ;
     else if (accum_cnt1[4:0] == 17)
       accum17[(ACCUMWIDTH-1):0] <= (count == 19) ? mult  
				    :  mult[(ACCUMWIDTH-1):0] + accum17[(ACCUMWIDTH-1):0] ;
   
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       accum18[(ACCUMWIDTH-1):0] <= {(ACCUMWIDTH){1'b0}} ;
     else if (accum_cnt1[4:0] ==18)
       accum18[(ACCUMWIDTH-1):0] <= (count == 17) ? mult  
				    :  mult[(ACCUMWIDTH-1):0] + accum18[(ACCUMWIDTH-1):0] ;
   
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       accum19[(ACCUMWIDTH-1):0] <= {(ACCUMWIDTH){1'b0}} ;
     else if (accum_cnt1[4:0] == 19)
       accum19[(ACCUMWIDTH-1):0] <= (count == 15) ? mult      
				    :  mult[(ACCUMWIDTH-1):0] + accum19[(ACCUMWIDTH-1):0] ;
   
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       accum20[(ACCUMWIDTH-1):0] <= {(ACCUMWIDTH){1'b0}} ;
     else if (accum_cnt1[4:0] == 20)
       accum20[(ACCUMWIDTH-1):0] <= (count == 13) ? mult  
				    : mult[(ACCUMWIDTH-1):0] + accum20[(ACCUMWIDTH-1):0] ;
   
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       accum21[(ACCUMWIDTH-1):0] <= {(ACCUMWIDTH){1'b0}} ;
     else if (accum_cnt1[4:0] == 21)
       accum21[(ACCUMWIDTH-1):0] <= (count == 11) ? mult  
				    : mult[(ACCUMWIDTH-1):0] + accum21[(ACCUMWIDTH-1):0] ;
   
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       accum22[(ACCUMWIDTH-1):0] <= {(ACCUMWIDTH){1'b0}} ;
     else if (accum_cnt1[4:0] == 22)
       accum22[(ACCUMWIDTH-1):0] <= (count == 9) ? mult  
				    :  mult[(ACCUMWIDTH-1):0] + accum22[(ACCUMWIDTH-1):0] ;
   
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       accum23[(ACCUMWIDTH-1):0] <= {(ACCUMWIDTH){1'b0}} ;
     else if (accum_cnt1[4:0] == 23)
       accum23[(ACCUMWIDTH-1):0] <= (count == 7) ? mult  
				    :  mult[(ACCUMWIDTH-1):0] + accum23[(ACCUMWIDTH-1):0] ;
   
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       accum24[(ACCUMWIDTH-1):0] <= {(ACCUMWIDTH){1'b0}} ;
     else if (accum_cnt1[4:0] == 24)
       accum24[(ACCUMWIDTH-1):0] <= (count == 5) ? mult  
				    :  mult[(ACCUMWIDTH-1):0] + accum24[(ACCUMWIDTH-1):0] ;
   
   always @ (posedge CLK or posedge ARST)
     if (ARST)
       accum25[(ACCUMWIDTH-1):0] <= {(ACCUMWIDTH){1'b0}} ;
     else if (accum_cnt1[4:0] == 0)
       accum25[(ACCUMWIDTH-1):0] <= (count == 4) ? mult  
				    :  mult[(ACCUMWIDTH-1):0] + accum25[(ACCUMWIDTH-1):0] ;
   
   
   //**************************************************************************//
   //*                         Output Buffers                                 *//
   //**************************************************************************//
   assign valid1  = (count[5:0] == 1)  & (accum_cnt1 == 1) ;
   assign valid2  = (count[5:0] == 49) & (accum_cnt1 == 1) ;
   assign valid3  = (count[5:0] == 47) & (accum_cnt1 == 1) ;
   assign valid4  = (count[5:0] == 45) & (accum_cnt1 == 1) ;
   assign valid5  = (count[5:0] == 43) & (accum_cnt1 == 1) ;
   assign valid6  = (count[5:0] == 41) & (accum_cnt1 == 1) ;
   assign valid7  = (count[5:0] == 39) & (accum_cnt1 == 1) ;
   assign valid8  = (count[5:0] == 37) & (accum_cnt1 == 1) ;
   assign valid9  = (count[5:0] == 35) & (accum_cnt1 == 1) ;
   assign valid10 = (count[5:0] == 33) & (accum_cnt1 == 1) ;
   assign valid11 = (count[5:0] == 31) & (accum_cnt1 == 1) ;
   assign valid12 = (count[5:0] == 29) & (accum_cnt1 == 1) ;
   assign valid13 = (count[5:0] == 27) & (accum_cnt1 == 1) ;
   assign valid14 = (count[5:0] == 25) & (accum_cnt1 == 1) ;
   assign valid15 = (count[5:0] == 23) & (accum_cnt1 == 1) ;
   assign valid16 = (count[5:0] == 21) & (accum_cnt1 == 1) ;
   assign valid17 = (count[5:0] == 19) & (accum_cnt1 == 1) ;
   assign valid18 = (count[5:0] == 17) & (accum_cnt1 == 1) ;
   assign valid19 = (count[5:0] == 15) & (accum_cnt1 == 1) ;
   assign valid20 = (count[5:0] == 13) & (accum_cnt1 == 1) ;
   assign valid21 = (count[5:0] == 11) & (accum_cnt1 == 1) ;
   assign valid22 = (count[5:0] == 9)  & (accum_cnt1 == 1) ;
   assign valid23 = (count[5:0] == 7)  & (accum_cnt1 == 1) ;
   assign valid24 = (count[5:0] == 5)  & (accum_cnt1 == 1) ;
   assign valid25 = (count[5:0] == 3)  & (accum_cnt1 == 1) ;

   assign valid =  valid1  | valid2  | valid3  | valid4  | valid5  | valid6  | 
                   valid7  | valid8  | valid9  | valid10 | valid11 | valid12 | 
                   valid13 | valid14 | valid15 | valid16 | valid17 | valid18 | 
                   valid19 | valid20 | valid21 | valid22 | valid23 | valid24 |
                   valid25;

   always @ (posedge CLK or posedge ARST)
     if (ARST)
       SigOut[(OWIDTH-1):0] <= {(OWIDTH){1'b0}} ;
     else if (valid)
       SigOut[(OWIDTH-1):0] <= (accum1[(ACCUMWIDTH-1):0]  & {(OWIDTH){ valid1  }}) |
			       (accum2[(ACCUMWIDTH-1):0]  & {(OWIDTH){ valid2  }}) |
			       (accum3[(ACCUMWIDTH-1):0]  & {(OWIDTH){ valid3  }}) |
			       (accum4[(ACCUMWIDTH-1):0]  & {(OWIDTH){ valid4  }}) |
			       (accum5[(ACCUMWIDTH-1):0]  & {(OWIDTH){ valid5  }}) |
			       (accum6[(ACCUMWIDTH-1):0]  & {(OWIDTH){ valid6  }}) |
			       (accum7[(ACCUMWIDTH-1):0]  & {(OWIDTH){ valid7  }}) |
			       (accum8[(ACCUMWIDTH-1):0]  & {(OWIDTH){ valid8  }}) |
			       (accum9[(ACCUMWIDTH-1):0]  & {(OWIDTH){ valid9  }}) |
			       (accum10[(ACCUMWIDTH-1):0] & {(OWIDTH){ valid10 }}) |
			       (accum11[(ACCUMWIDTH-1):0] & {(OWIDTH){ valid11 }}) |
			       (accum12[(ACCUMWIDTH-1):0] & {(OWIDTH){ valid12 }}) |
			       (accum13[(ACCUMWIDTH-1):0] & {(OWIDTH){ valid13 }}) |
			       (accum14[(ACCUMWIDTH-1):0] & {(OWIDTH){ valid14 }}) |
			       (accum15[(ACCUMWIDTH-1):0] & {(OWIDTH){ valid15 }}) |
			       (accum16[(ACCUMWIDTH-1):0] & {(OWIDTH){ valid16 }}) |
			       (accum17[(ACCUMWIDTH-1):0] & {(OWIDTH){ valid17 }}) |
			       (accum18[(ACCUMWIDTH-1):0] & {(OWIDTH){ valid18 }}) |
			       (accum19[(ACCUMWIDTH-1):0] & {(OWIDTH){ valid19 }}) |
			       (accum20[(ACCUMWIDTH-1):0] & {(OWIDTH){ valid20 }}) |
			       (accum21[(ACCUMWIDTH-1):0] & {(OWIDTH){ valid21 }}) |
			       (accum22[(ACCUMWIDTH-1):0] & {(OWIDTH){ valid22 }}) |
			       (accum23[(ACCUMWIDTH-1):0] & {(OWIDTH){ valid23 }}) |
			       (accum24[(ACCUMWIDTH-1):0] & {(OWIDTH){ valid24 }}) |
			       (accum25[(ACCUMWIDTH-1):0] & {(OWIDTH){ valid25 }}) ;
   
   always @ (posedge CLK or posedge ARST)
     if (ARST)     DataValid <= 1'b0 ;
     else          DataValid <= valid;
   
   
endmodule  //firdecim_m2_n50
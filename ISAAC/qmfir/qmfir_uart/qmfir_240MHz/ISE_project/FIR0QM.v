// ******************************************************************************* //
// **                    General Information                                    ** //
// ******************************************************************************* //
// **  Module             : FIR0QM.v                                            ** //
// **  Project            : ISAAC NEWTON                                        ** //
// **  Author             : Kayla Nguyen                                        ** //
// **  First Release Date : February 9, 2009                                    ** //
// **  Description        : FIR0 and QM together                                ** //
// ******************************************************************************* //
// **                     Revision History                                      ** //
// ******************************************************************************* //
// **                                                                           ** //
// **  File        : FIR0QM.v                                                   ** //
// **  Revision    : 1                                                          ** //
// **  Author      : kaylangu                                                   ** //
// **  Date        : February 9, 2009                                           ** //
// **  FileName    :                                                            ** //
// **  Notes       : Initial Release for SMAP demo                              ** //
// **                                                                           ** //
// ******************************************************************************* //
`timescale 1ns/100ps

module FIR0QM(/*AUTOARG*/
   // Outputs
   Real1, Real2, Real3, Imag1, Imag2, Imag3, OutputValid, outValid,
   dsp_outr, dsp_outi,
   // Inputs
   clk, rst, freq, freq1, freq2, freq3, newFreq, InputValid, dsp_in0,
   dsp_in1, dsp_in2, dsp_in3
   );

   //**************************************************************************//
   //*                       Declarations                                     *//
   //**************************************************************************//
   // DATA TYPE - PARAMETERS
   parameter IWIDTH = 8;
   parameter OWIDTH = 16;
   
   
   // DATA TYPE - INPUTS AND OUTPUTS
   input                          clk;
   input 			  rst;
   input [6:0] 			  freq;
   input [6:0] 			  freq1;
   input [6:0] 			  freq2;
   input [6:0] 			  freq3;
   input 			  newFreq;
   input 			  InputValid;
   input signed [(IWIDTH-1):0] 	  dsp_in0;
   input signed [(IWIDTH-1):0] 	  dsp_in1;
   input signed [(IWIDTH-1):0] 	  dsp_in2;
   input signed [(IWIDTH-1):0] 	  dsp_in3;
   
   output signed [(OWIDTH-1):0]   Real1;
   output signed [(OWIDTH-1):0]   Real2;
   output signed [(OWIDTH-1):0]   Real3;
   output signed [(OWIDTH-1):0]   Imag1;
   output signed [(OWIDTH-1):0]   Imag2;
   output signed [(OWIDTH-1):0]   Imag3;
   output 			  OutputValid;
     
        // FIR0
   output 			  outValid;
   output signed [(OWIDTH-1):0]   dsp_outr;
   output signed [(OWIDTH-1):0]   dsp_outi;
   
   // DATA TYPE - REGISTERS
   reg 				  outValid_1d;
   reg 				  outValid_2d;

   
   //**************************************************************************//
   //*                           Buffers                                      *//
   //**************************************************************************//
   /* always @ (posedge clk or posedge rst)
     if (rst)
       begin
	  outValid_1d <= 1'b0;
	  outValid_2d <= 1'b0;
       end
     else
       begin
	  outValid_1d <= outValid;
	  outValid_2d <= outValid_1d;
       end*/

   
   //**************************************************************************//
   //*                         Submodules                                     *//
   //**************************************************************************//
   firdecim_m4_n12_wrap FIR0_module
     (//input
      .clk(clk),
      .rst(rst),
      .dsp_in0(dsp_in0),
      .dsp_in1(dsp_in1),
      .dsp_in2(dsp_in2),
      .dsp_in3(dsp_in3),
      .freq(freq),
      .newFreq(newFreq),
      .inValid(InputValid),
      //output
      .dsp_outr(dsp_outr),
      .dsp_outi(dsp_outi),
      .outValid(outValid)
      );

   QM QM
     (//input
      .CLK(clk),
      .ARST(rst),
      .ConstantR(dsp_outr),
      .ConstantI(dsp_outi),
      .InputValid(outValid),  
      .K1(freq1),
      .K2(freq2),
      .K3(freq3),
      //output
      .Real1(Real1),
      .Real2(Real2),
      .Real3(Real3),
      .Imag1(Imag1),
      .Imag2(Imag2),
      .Imag3(Imag3),
      .OutputValid(OutputValid)
      );
   
  
endmodule // FIR0QM

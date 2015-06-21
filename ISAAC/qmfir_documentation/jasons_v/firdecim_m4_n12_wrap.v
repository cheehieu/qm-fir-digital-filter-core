// ******************************************************************************* //
// **                    General Information                                    ** //
// ******************************************************************************* //
// **  Module             : firdecim_m4_n12_wrap.v                              ** //
// **  Project            : ISAAC Newton / SMAP                                 ** //
// **  Author             : Kayla Nguyen                                        ** //
// **  First Release Date : February 9, 2009                                    ** //
// **  Description        : Wrapper for Real and Imaginary FIR0 with frequency  ** //
// **                       tunning                                             ** //
// ******************************************************************************* //
// **                     Revision History                                      ** //
// ******************************************************************************* //
// **                                                                           ** //
// **  File        : FIR0_wrap.v                                                ** //
// **  Revision    : 1                                                          ** //
// **  Author      : kaylangu                                                   ** //
// **  Date        : February 9, 2009                                           ** //
// **  FileName    :                                                            ** //
// **  Notes       : Initial Release for SMAP demo                              ** //
// **                                                                           ** //
// **  File        : firdecim_m4_n12_wrap.v                                     ** //
// **  Revision    : 1                                                          ** //
// **  Author      : kaylangu                                                   ** //
// **  Date        : February , 2009                                           ** //
// **  FileName    :                                                            ** //
// **  Notes       : change for 12 taps                                         ** //
// **                                                                           ** //
// ******************************************************************************* //
`timescale 1ns/100ps

module firdecim_m4_n12_wrap (/*AUTOARG*/
   // Outputs
   dsp_outr, dsp_outi, outValid,
   // Inputs
   dsp_in0, dsp_in1, dsp_in2, dsp_in3, freq, newFreq, clk, rst,
   inValid
   );
   
   //**************************************************************************//
   //*                       Declarations                                     *//
   //**************************************************************************//
   // DATA TYPE - PARAMETERS
   parameter OWIDTH = 16;
   parameter IWIDTH = 8;
   parameter COEFWIDTH = 16;
   
   // DATA TYPE - INPUTS AND OUTPUTS
   output signed [(OWIDTH-1):0]  dsp_outr;
   output signed [(OWIDTH-1):0]  dsp_outi;
   output 			 outValid;
   
   input signed [(IWIDTH-1):0] 	 dsp_in0;
   input signed [(IWIDTH-1):0] 	 dsp_in1;
   input signed [(IWIDTH-1):0] 	 dsp_in2;
   input signed [(IWIDTH-1):0] 	 dsp_in3;
   
   input [6:0] 			 freq;
   input 			 newFreq;
   
   input 			 clk;
   input 			 rst;
   input 			 inValid;
   
   // DATA TYPE - WIRES
   wire signed [(COEFWIDTH-1):0] er,ei;
   wire 			 new_e;
   
   
   //**************************************************************************//
   //*                          Submodules                                    *//
   //**************************************************************************//
   firdecim_m4_n12_freqcalc firdecim_m4_n12_freqcalc
     (.clk(clk),
      .rst(rst),
      .freq(freq),
      .newFreq(newFreq),
      .er(er),
      .ei(ei),
      .new_e(new_e)
      );
   

   firdecim_m4_n12 RealFIR0 
     (.clk(clk),
      .rst(rst),
      .inValid(inValid),
      .dsp_in0(dsp_in0),
      .dsp_in1(dsp_in1),
      .dsp_in2(dsp_in2),
      .dsp_in3(dsp_in3),
      .ein(er),
      .new_e(new_e),
      .dsp_out(dsp_outr),
      .outValid(outValid)
      );
   
   firdecim_m4_n12 ImagFIR0 
     (.clk(clk),
      .rst(rst),
      .inValid(inValid),
      .dsp_in0(dsp_in0),
      .dsp_in1(dsp_in1),
      .dsp_in2(dsp_in2),
      .dsp_in3(dsp_in3),
      .ein(ei),
      .new_e(new_e),
      .dsp_out(dsp_outi)
      );

endmodule // firdecim_m4_n12_wrap


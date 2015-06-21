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
// **  File        : QM_FIR.v                                                   ** //
// **  Revision    : 2                                                          ** //
// **  Author      : kaylangu                                                   ** //
// **  Date        : February 9, 2009                                           ** //
// **  FileName    :                                                            ** //
// **  Notes       : Revise for 240MHZ implementation                           ** //
// **                                                                           ** //
// ******************************************************************************* //
`timescale 1 ns / 100 ps

module QM_FIR(/*AUTOARG*/
   // Outputs
   RealOut1, RealOut2, RealOut3, ImagOut1, ImagOut2, ImagOut3,
   DataValid,
   // Inputs
   CLK, ARST, InputValid, dsp_in0, dsp_in1, dsp_in2, dsp_in3, freq,
   newFreq, freq1, freq2, freq3
   );


   //*****************************************************************************//
   //*                        Declarations                                       *//
   //*****************************************************************************//
   // DATA TYPE - PARAMETERS
   parameter OWIDTH = 16;
   parameter IWIDTH = 8;
   parameter ACCUMWIDTH = 32;
   
   // DATA TYPE - INPUTS AND OUTPUTS
   output signed [(OWIDTH-1):0]      RealOut1, RealOut2, RealOut3;
   output signed [(OWIDTH-1):0]      ImagOut1, ImagOut2, ImagOut3;
   output 			     DataValid;
      
   input 			     CLK;
   input 			     ARST;
   input 			     InputValid;
   input signed [(IWIDTH-1):0] 	     dsp_in0;
   input signed [(IWIDTH-1):0] 	     dsp_in1;
   input signed [(IWIDTH-1):0] 	     dsp_in2;
   input signed [(IWIDTH-1):0] 	     dsp_in3;
   input [6:0] 			     freq;
   input 			     newFreq;
   input [6:0] 			     freq1;
   input [6:0] 			     freq2;
   input [6:0] 			     freq3;
   
   
   // DATA TYPE - WIRES
   wire 			     OutputValid_QM;
   wire signed [(OWIDTH-1):0] 	     Real1, Real2, Real3;
   wire signed [(OWIDTH-1):0] 	     Imag1, Imag2, Imag3;
   

   //*****************************************************************************//
   //*                           Submodules                                      *//
   //*****************************************************************************//
   //Quadrature Modulation and FIR0
   FIR0QM FIR0QM
     (//Inputs
      .clk(CLK),
      .rst(ARST),
      .freq(freq),
      .freq1(freq1),
      .freq2(freq2),
      .freq3(freq3),
      .newFreq(newFreq),
      .InputValid(InputValid),
      .dsp_in0(dsp_in0),
      .dsp_in1(dsp_in1),
      .dsp_in2(dsp_in2),
      .dsp_in3(dsp_in3),
      //Outputs
      .Real1(Real1),
      .Real2(Real2),
      .Real3(Real3),
      .Imag1(Imag1),
      .Imag2(Imag2),
      .Imag3(Imag3),
      .OutputValid(OutputValid_QM)
      );   

   //Firdecim 1st channel Real Filter
   firdecim firdecimR1
     (//Inputs
      .CLK         (CLK),
      .ARST        (ARST),
      .InputValid  (OutputValid_QM),
      .SigIn       (Real1),
      //Outputs
      .SigOut      (RealOut1),
      .DataValid   (DataValid)
      );

   //Firdecim 1st channel Imaginary Filter
   firdecim firdecimI1
     (//Inputs
      .CLK         (CLK),
      .ARST        (ARST),
      .InputValid  (OutputValid_QM),
      .SigIn       (Imag1),
      //Outputs
      .SigOut      (ImagOut1)
      );

   //Firdecim noise channel Real Filter
   firdecim firdecimR2
     (//Inputs
      .CLK         (CLK),
      .ARST        (ARST),
      .InputValid  (OutputValid_QM),
      .SigIn       (Real2),
      //Outputs
      .SigOut      (RealOut2)
      );

   //Firdecim noise channel Imaginary Filter
   firdecim firdecimI2
     (//Inputs
      .CLK         (CLK),
      .ARST        (ARST),
      .InputValid  (OutputValid_QM),
      .SigIn       (Imag2),
      //Outputs
      .SigOut      (ImagOut2)
      );

   //Firdecim 2nd channel Real Filter
   firdecim firdecimR3
     (//Inputs
      .CLK         (CLK),
      .ARST        (ARST),
      .InputValid  (OutputValid_QM),
      .SigIn       (Real3),
      //Outputs
      .SigOut      (RealOut3)
      );

   //Firdecim 2nd channel Imaginary Filter
   firdecim firdecimI3
     (//Inputs
      .CLK         (CLK),
      .ARST        (ARST),
      .InputValid  (OutputValid_QM),
      .SigIn       (Imag3),
      //Outputs
      .SigOut      (ImagOut3)
      );

endmodule // QM_FIR

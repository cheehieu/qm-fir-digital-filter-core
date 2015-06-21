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
// **  File        : firdecim.v                                                 ** //
// **  Revision    : 2                                                          ** //
// **  Author      : kaylangu                                                   ** //
// **  Date        : February 9, 2009                                           ** //
// **  FileName    :                                                            ** //
// **  Notes       : Remove Sync signal                                         ** //
// **                                                                           ** //
// ******************************************************************************* //
`timescale 1 ns / 100 ps

module firdecim
  (/*AUTOARG*/
   // Outputs
   SigOut, DataValid, DataValid1, DataValid2, SigOut1, SigOut2,
   // Inputs
   CLK, ARST, InputValid, SigIn
   );

   
   //******************************************************************************//
   //*                     Declarations                                           *//
   //******************************************************************************//
   // DATA TYPE - PARAMETERS
   parameter OWIDTH = 16;
   parameter ACCUMWIDTH = 32;
   parameter IWIDTH = 16;
   
   // DATA TYPE - INPUTS AND OUTPUTS
   output signed [(OWIDTH-1):0]     SigOut ;
   output signed [(ACCUMWIDTH-1):0] SigOut1;
   output signed [(ACCUMWIDTH-1):0] SigOut2;
   output 			    DataValid;
   output 			    DataValid1;
   output 			    DataValid2;
   
   input 			    CLK;
   input 			    ARST;
   input 			    InputValid;
   input signed [(IWIDTH-1):0] 	    SigIn;

   // DATA TYPE - WIRES
   wire signed [(ACCUMWIDTH-1):0]   SigOut_tmp;
   


   //******************************************************************************//
   //*                    Output Buffers                                          *//
   //******************************************************************************//
   assign SigOut[(OWIDTH-1):0] = SigOut_tmp[(ACCUMWIDTH-3):(ACCUMWIDTH-OWIDTH-2)];


   //******************************************************************************//
   //*                    Submodules                                              *//
   //******************************************************************************//
   firdecim_m5_n15 firdecim1
     (//Inputs
      .CLK        (CLK),
      .ARST       (ARST),
      .InputValid (InputValid),
      .SigIn      (SigIn[(IWIDTH-1):0]),
      //Outputs
      .DataValid  (DataValid1),
      .SigOut     (SigOut1[(ACCUMWIDTH-1):0])
      );

   firdecim_m5_n25 firdecim2
     (// Inputs
      .CLK        (CLK),
      .ARST       (ARST),
      .InputValid (DataValid1),
      .SigIn      (SigOut1[(ACCUMWIDTH-3):(ACCUMWIDTH-OWIDTH-2)]),
      // Outputs
      .DataValid  (DataValid2),
      .SigOut     (SigOut2[(ACCUMWIDTH-1):0])
      );

   firdecim_m2_n50 firdecim3
     (// Inputs
      .CLK        (CLK),
      .ARST       (ARST),
      .InputValid (DataValid2),
      .SigIn      (SigOut2[(ACCUMWIDTH-3):(ACCUMWIDTH-OWIDTH-2)]),
      // Outputs
      .DataValid  (DataValid),
      .SigOut     (SigOut_tmp[(ACCUMWIDTH-1):0])
      );


endmodule // firdecim

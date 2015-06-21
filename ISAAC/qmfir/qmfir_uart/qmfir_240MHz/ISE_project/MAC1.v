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
// **                                                                           ** //
// **  File        : MAC1.v                                                     ** //
// **  Revision    : 2                                                          ** //
// **  Author      : kaylangu                                                   ** //
// **  Date        : October 23, 2008                                           ** //
// **  Notes       : Added Sync Signal to synchronize the MAC                   ** //
// **                                                                           ** //
// ******************************************************************************* //
`timescale 1 ns / 100 ps

module MAC1
  (/*AUTOARG*/
   // Outputs
   OutData, output_Valid,
   // Inputs
   CLK, ARST, input_Valid, initialize, InData, filterCoef
   );


   //**************************************************************************//
   //*                         Declarations                                   *//
   //**************************************************************************//
   // DATA TYPE - INPUTS AND OUTPUTS
   input                               CLK                     ;  // 60MHz Clock
   input                               ARST                    ;
   input                               input_Valid             ;
   input                               initialize              ;
   input   signed [(15):0] 	       InData, filterCoef      ;
//   input 			       Sync;
   
   output  signed [(31):0] 	       OutData                 ;
   output                              output_Valid            ;
   
   // DATA TYPE - REGISTERS
   reg     signed [(31):0] 	       mult            ;
   reg signed [31:0] 		       accum;
   
   reg                                 input_Valid0            ;
   reg                                 initialize1             ;
   
   reg                                 output_Valid_1          ;
   
   wire                                output_Valid            ;
   reg [3:0] 			       count                   ;
   
   // DATA TYPE - WIRES
   wire    signed [(31):0] 	       accum_tmp               ;
   wire [3:0] 			       taps                    ;
   

//   assign  taps = (15 == 15) ? 0 : (15 - 15 + 15) ;


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
     if (ARST)     mult[(31):0] <=  {(31){1'b0}} ;
     else          mult[(31):0] <=  filterCoef*InData  ;
   
   assign  accum_tmp[(31):0] =   mult[(31):0] + accum[(31):0];
    
   // Accumulator 
   always @(posedge CLK or posedge ARST)// or initialize)
     if (ARST)       accum[(31):0] <=  {(32){1'b0}} ;
     else            accum[(31):0] <=  (initialize1) ?
				       mult[31:0] :
				       (input_Valid0 ? accum_tmp[31:0]
					: accum[31:0]) ;

   //**************************************************************************//
   //*                            Counters                                    *//
   //**************************************************************************//
   always @ (posedge CLK or posedge ARST)
     if (ARST )     count[3:0] <=  {(4){1'b0}}  ;
     else           count[3:0] <= initialize ?
                                  0 :
                                  input_Valid0 + count[3:0] ;


   //**************************************************************************//
   //*                           Output Buffers                               *//
   //**************************************************************************//
   always @(posedge CLK or posedge ARST)
     if (ARST)     output_Valid_1 <=  1'b0 ;
     else          output_Valid_1 <=  (count[3:0]==(14))   ;
   
   assign  output_Valid            = output_Valid_1 & (count[3:0]==0) ;
   assign  OutData[31:0]           = accum[31:0]                          ;
   
   
endmodule //MAC1
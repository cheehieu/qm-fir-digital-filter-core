/////////////////////////////////////////////////////////////////////
////                                                             ////
////  FIFO 4 entries deep                                        ////
////                                                             ////
////                                                             ////
////  Author: Rudolf Usselmann                                   ////
////          rudi@asics.ws                                      ////
////                                                             ////
////                                                             ////
////  Downloaded from: http://www.opencores.org/cores/sasc/      ////
////                                                             ////
/////////////////////////////////////////////////////////////////////
////                                                             ////
//// Copyright (C) 2000-2002 Rudolf Usselmann                    ////
////                         www.asics.ws                        ////
////                         rudi@asics.ws                       ////
////                                                             ////
//// This source file may be used and distributed without        ////
//// restriction provided that this copyright statement is not   ////
//// removed from the file and that any derivative work contains ////
//// the original copyright notice and the associated disclaimer.////
////                                                             ////
////     THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY     ////
//// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED   ////
//// TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS   ////
//// FOR A PARTICULAR PURPOSE. IN NO EVENT SHALL THE AUTHOR      ////
//// OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,         ////
//// INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES    ////
//// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE   ////
//// GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR        ////
//// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF  ////
//// LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT  ////
//// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT  ////
//// OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE         ////
//// POSSIBILITY OF SUCH DAMAGE.                                 ////
////                                                             ////
/////////////////////////////////////////////////////////////////////

//  CVS Log
//
//  $Id: sasc_fifo4.v,v 1.1.1.1 2002/09/16 16:16:41 rudi Exp $
//
//  $Date: 2002/09/16 16:16:41 $
//  $Revision: 1.1.1.1 $
//  $Author: rudi $
//  $Locker:  $
//  $State: Exp $
//
// Change History:
//               $Log: sasc_fifo4.v,v $
//               Revision 1.1.1.1  2002/09/16 16:16:41  rudi
//               Initial Checkin
//
//
//
//
//
//

`timescale 1ns / 100ps

// 4 entry deep fast fifo
module sasc_fifo4(/*AUTOARG*/
   // Outputs
   dout, full, empty,
   // Inputs
   clk, rst_n, clr, din, we, re
   );

input           clk, rst_n;
input           clr;
input   [7:0]   din;
input           we;
output  [7:0]   dout;
input           re;
output          full, empty;


////////////////////////////////////////////////////////////////////
//
// Local Wires
//

reg     [7:0]   mem[0:3];
reg     [1:0]   wp;
reg     [1:0]   rp;
wire    [1:0]   wp_p1;
wire    [1:0]   rp_p1;
wire            full, empty;
reg             gb;

//   wire [7:0]   mem0 = mem[0];
//   wire [7:0]   mem1 = mem[1];
//   wire [7:0]   mem2 = mem[2];
//   wire [7:0]   mem3 = mem[3];

////////////////////////////////////////////////////////////////////
//
// Misc Logic
//

always @(posedge clk or negedge rst_n)
        if(!rst_n)      wp <=  2'h0;
        else
        if(clr)         wp <=  2'h0;
        else
        if(we)          wp <=  wp_p1;

assign wp_p1 = wp + 2'h1;

always @(posedge clk or negedge rst_n)
        if(!rst_n)      rp <=  2'h0;
        else
        if(clr)         rp <=  2'h0;
        else
        if(re)          rp <=  rp_p1;

assign rp_p1 = rp + 2'h1;

// Fifo Output
assign  dout = mem[ rp ];

// Fifo Input 
always @(posedge clk)
        if(we)     mem[ wp ] <=  din;

// Status
assign empty = (wp == rp) & !gb;
assign full  = (wp == rp) &  gb;

// Guard Bit ...
always @(posedge clk)
        if(!rst_n)                      gb <=  1'b0;
        else
        if(clr)                         gb <=  1'b0;
        else
        if((wp_p1 == rp) & we)          gb <=  1'b1;
        else
        if(re)                          gb <=  1'b0;

endmodule



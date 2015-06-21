// Asynchronous Reset Synchronizer

module reset (/*AUTOARG*/
   // Outputs
   arst_n,
   // Inputs
   PORn, BRSTn, clk
   );

   output    arst_n;

   input     PORn;
   input     BRSTn;
   
   input     clk;
   
   reg [1:0] rst_sync;

   assign    arst_n = rst_sync[0];
   
   always @ (posedge clk or negedge PORn)
     if (~PORn)
       rst_sync[1:0] <= 2'b00;
     else
       rst_sync[1:0] <= {BRSTn, rst_sync[1]};
   
endmodule // reset

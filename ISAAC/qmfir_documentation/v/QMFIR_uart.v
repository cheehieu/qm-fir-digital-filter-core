`include "timescale.v"


module QMFIR_uart (/*AUTOARG*/
   // Outputs
   uart_mem_i, uart_reg_i,
   // Inputs
   clk, arst_n, uart_dout, uart_addr, uart_mem_we, uart_mem_re,
   reg_we
   );

   input 		     clk;
   input 		     arst_n;

   input [23:0]              uart_dout;      //Data from UART
   input [13:0] 	     uart_addr;      //Address from UART
   input 		     uart_mem_we;    //Write enable from UART
   input 		     uart_mem_re;    //Read enable from UART
   input 		     reg_we;         //Write register from UART

   output 		     uart_mem_i;     //Memory data to UART
   output 		     uart_reg_i;     //Register data to UART
   

   wire 		     arst;
   

   assign arst = ~arst_n;
      
   
endmodule // QMFIR_uart

`timescale 1ns / 100ps

module model_uart (/*AUTOARG*/
   // Outputs
   tx,
   // Inputs
   rx
   );

   output tx;
   input  rx;

   parameter default_period = 17361; // 57600 baud rate
   parameter start          = 1'b0;
   parameter stop           = 1'b1;
   
   integer   period;

   reg       tx;
   reg       tx_active;
   reg       rx_active;
   
   initial
     begin
        period = default_period;
        tx = stop;
        tx_active = 0;
        rx_active = 1;
     end
   
   tskSendWord(16'hDE);
   
  
   task tskSendWord;
      input [15:0] data;
      begin
         tskSendByte(data[15:8]);
         tskSendByte(data[7:0]);
      end
   endtask // tskSendWord
   
   task tskRcvWord;
      input [15:0] data;
      reg [7:0]    lsb;
      reg [7:0]    msb;
      begin
         tskRcvByte(msb[7:0]);
         tskRcvByte(lsb[7:0]);
         if (data[15:0]!=={msb[7:0],lsb[7:0]})
           $display ("%d... Error: UART expected data %h, was %h",
                     $stime, data, {msb[7:0],lsb[7:0]});
      end
   endtask // tskSendWord
   
   task tskSendByte;
      input [7:0] data;
      integer     i;
      begin
         tx_active = 1;
         tx = start;
         for (i=0;i<8;i=i+1)
           #period tx = data[i];
         #period tx = stop;
         #period;
         tx_active = 0;
      end
   endtask // tskSendByte

   task tskRcvByte;
      output [7:0] data;
      reg [7:0]    data;
      integer      i;
      begin
         wait (rx===stop);
         wait (rx===start);
         rx_active = 1;
         #(period*0.5) for (i=0;i<8;i=i+1)
           #period data[i] = rx;
         #period if (rx!==stop)
           $display ("%d... Error: No STOP on UART", $stime);
         rx_active = 0;
      end
   endtask // tskRcvByte
   
endmodule // model_uart

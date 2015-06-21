`timescale 1ns / 100ps

module QMFIR_uart_top(/*AUTOARG*/
   // Outputs
   uart_tx,
   // Inputs
   uart_rx, clk, arst_n
   );

   output         uart_tx;
   input          uart_rx;
   
   input 	  clk;
   input 	  arst_n;

   wire 	  arst_n;
   wire [15:0] 	  MEMDAT;
   
   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire			reg_we;			// From uart_ of QMFIR_uart_if.v
   wire [13:0]		uart_addr;		// From uart_ of QMFIR_uart_if.v
   wire [31:0]		uart_dout;		// From uart_ of QMFIR_uart_if.v
   wire			uart_mem_re;		// From uart_ of QMFIR_uart_if.v
   wire			uart_mem_we;		// From uart_ of QMFIR_uart_if.v
   // End of automatics
   wire [23:0] 		uart_mem_i;
   reg [23:0] 		uart_reg_i;    //combinatory
   
   //iReg
   wire [15:0] 		ESCR;
   wire [15:0] 		WPTR;
   wire [15:0] 		ICNT;
   wire [15:0] 		FREQ;
   wire [15:0] 		OCNT;
   wire [15:0] 		FCNT;
   
   wire [31:0] 		firin;
   
   //bram out
   wire [15:0] 		MEMDATR1;
   wire [15:0] 		MEMDATI1;
   wire [15:0] 		MEMDATR2;
   wire [15:0] 		MEMDATI2;
   wire [15:0] 		MEMDATR3;
   wire [15:0] 		MEMDATI3;
   
   //bram in
   wire [6:0] 		mem_addrr1;
   wire [6:0] 		mem_addri1;
   wire [6:0] 		mem_addrr2;
   wire [6:0] 		mem_addri2;
   wire [6:0] 		mem_addrr3;
   wire [6:0] 		mem_addri3;
   
   wire [13:0] 		bramin_addr;
   
   assign arst = ~arst_n;
   
   
   QMFIR_uart_if uart_(/*AUTOINST*/
		       // Outputs
		       .uart_dout	(uart_dout[31:0]),
		       .uart_addr	(uart_addr[13:0]),
		       .uart_mem_we	(uart_mem_we),
		       .uart_mem_re	(uart_mem_re),
		       .reg_we		(reg_we),
		       .uart_tx		(uart_tx),
		       // Inputs
		       .uart_mem_i	(uart_mem_i[23:0]),
		       .uart_reg_i	(uart_reg_i[23:0]),
		       .clk		(clk),
		       .arst_n		(arst_n),
		       .uart_rx		(uart_rx));   


   BRAM_larg bramin_(//outputs
		     .doutb(firin), //32 bit
		     //inputs
		     .clka(clk),
		     .clkb(clk),
		     .addra(bramin_addr), //14 bit
		     .addrb(FCNT[13:0]), //14 bit
		     .dina(uart_dout),  //32 bit
		     .wea(uart_mem_we));
   
   QM_FIR QM_FIR(//outputs
		 .RealOut1               (RealOut1),
		 .RealOut2               (RealOut2), 
		 .RealOut3               (RealOut2), 
		 .ImagOut1               (ImagOut1), 
		 .ImagOut2               (ImagOut2), 
		 .ImagOut3               (ImagOut3),
		 .DataValid              (DataValid),
		 //inputs
		 .CLK                    (clk), 
		 .ARST                   (arst), 
		 .InputValid             (ESCR[3]), 
		 .dsp_in0                (firin[31:24]), 
		 .dsp_in1                (firin[23:16]), 
		 .dsp_in2                (firin[15:8]), 
		 .dsp_in3                (firin[7:0]), 
		 .freq                   (ESCR[15]),
		 .newFreq                (ESCR[6:0]));

   iReg ireg_ (//outputs
	       .ESCR(ESCR),
	       .WPTR(WPTR),
	       .ICNT(ICNT),
	       .FREQ(FREQ),
	       .OCNT(OCNT),
	       .FCNT(FCNT),
	       //inputs
	       .clk(clk),
	       .arst(arst),
	       .idata(uart_dout),
	       .iaddr(uart_addr),
	       .iwe(reg_we),
	       .FIR_WE(DataValid),
	       .WFIFO_WE(uart_mem_we)
	        );
   
   BRAM real1_ (//outputs
		.doutb(MEMDATR1[15:0]),
		//inputs
		.clka(clk),
		.clkb(clk),
		.addra(WPTR[9:0]),
		.addrb(mem_addrr1),
		.dina(RealOut1),
		.wea(DataValid));
   
   BRAM imag1_ (//outputs
		.doutb(MEMDATI1[15:0]),
		//inputs
		.clka(clk),
		.clkb(clk),
		.addra(WPTR[9:0]),
		.addrb(mem_addri1),
		.dina(ImagOut1),
		.wea(DataValid));
   
   BRAM real2_ (//outputs
		.doutb(MEMDATR2[15:0]),
		//inputs
		.clka(clk),
		.clkb(clk),
		.addra(WPTR[9:0]),
		.addrb(mem_addrr2),
		.dina(RealOut2),
		.wea(DataValid));

   BRAM imag2_ (//outputs
		.doutb(MEMDATI2[15:0]),
		//inputs
		.clka(clk),
		.clkb(clk),
		.addra(WPTR[9:0]),
		.addrb(mem_addri2),
		.dina(ImagOut2),
		.wea(DataValid));

   BRAM real3_ (//outputs
		.doutb(MEMDATR3[15:0]),
		//inputs
		.clka(clk),
		.clkb(clk),
		.addra(WPTR[9:0]),
		.addrb(mem_addrr3),
		.dina(RealOut3),
		.wea(DataValid));

   BRAM imag3_ (//outputs
		.doutb(MEMDATI3[15:0]),
		//inputs
		.clka(clk),
		.clkb(clk),
		.addra(WPTR[9:0]),
		.addrb(mem_addri3),
		.dina(ImagOut3),
		.wea(DataValid));
   
   // BRAM in interface
      assign bramin_addr[13:0] = {(14){uart_mem_we}} & uart_addr[13:0];

   
   
   //iReg interface
   always @ (/*AS*/ESCR or FREQ or ICNT or OCNT or WPTR or uart_addr)
     case (uart_addr[2:0])
       3'b000: uart_reg_i = {8'd0, ESCR[15:0]};
       3'b001: uart_reg_i = {8'd0, WPTR[15:0]};
       3'b010: uart_reg_i = {8'd0, ICNT[15:0]};
       3'b011: uart_reg_i = {8'd0, FREQ[15:0]};
       3'b100: uart_reg_i = {8'd0, OCNT[15:0]};
       default: uart_reg_i = 24'hDEA;
     endcase // case (uart_addr[2:0])
   
   
   // BRAM out interface
   //read address
   assign mem_addrr1[6:0] = uart_addr[13:11] == 3'h1 ? uart_addr[6:0] : 7'b111_1111;
   assign mem_addri1[6:0] = uart_addr[13:11] == 3'h2 ? uart_addr[6:0] : 7'b111_1111;
   assign mem_addrr2[6:0] = uart_addr[13:11] == 3'h3 ? uart_addr[6:0] : 7'b111_1111;
   assign mem_addri2[6:0] = uart_addr[13:11] == 3'h4 ? uart_addr[6:0] : 7'b111_1111;
   assign mem_addrr3[6:0] = uart_addr[13:11] == 3'h5 ? uart_addr[6:0] : 7'b111_1111;
   assign mem_addri3[6:0] = uart_addr[13:11] == 3'h6 ? uart_addr[6:0] : 7'b111_1111;
   //read data
   assign MEMDAT[15:0] = MEMDATR1 | MEMDATR2 | MEMDATR3 | 
			 MEMDATI1 | MEMDATI2 | MEMDATI3 ;
   assign uart_mem_i[23:0] = {8'h0, MEMDAT[15:0]};
   


     
endmodule // QMFIR_uart_top

 
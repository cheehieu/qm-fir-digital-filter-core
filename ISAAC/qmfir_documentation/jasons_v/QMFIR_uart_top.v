`timescale 1ns / 100ps

module QMFIR_uart_top(/*AUTOARG*/
   // Outputs
   uart_tx,
   // Inputs
   uart_rx, clk, arst_n
   );

 //  output [3:0]   cnt;
   output         uart_tx;
   input          uart_rx;
   
   input          clk;
   input          arst_n;

   wire           arst_n;
   wire [15:0]    MEMDAT;
   
   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire			reg_we;			// From uart_ of QMFIR_uart_if.v
   wire [13:0]		uart_addr;		// From uart_ of QMFIR_uart_if.v
   wire [31:0]		uart_dout;		// From uart_ of QMFIR_uart_if.v
   wire			uart_mem_re;		// From uart_ of QMFIR_uart_if.v
   wire			uart_mem_we;		// From uart_ of QMFIR_uart_if.v
   // End of automatics
   wire [23:0]          uart_mem_i;
   reg [23:0]           uart_reg_i;    //combinatory
   
   //iReg
   wire [15:0]          ESCR;
   wire [15:0]          WPTR;
   wire [15:0]          ICNT;
   wire [15:0]          FREQ;
   wire [15:0]          OCNT;
   wire [15:0]          FCNT;
   
   wire [31:0]          firin;
   
   //bram out
   wire [15:0]          MEMDATR1;
   wire [15:0]          MEMDATI1;
   wire [15:0]          MEMDATR2;
   wire [15:0]          MEMDATI2;
   wire [15:0]          MEMDATR3;
   wire [15:0]          MEMDATI3;
   
   wire [15:0]          RealOut1;
   wire [15:0]          RealOut2;
   wire [15:0]          RealOut3;
   wire [15:0]          ImagOut1;
   wire [15:0]          ImagOut2;
   wire [15:0]          ImagOut3;

   
   reg [2:0]            uart_addr_d1;
   
   
   //bram in
   wire [9:0]           mem_addr1;
   wire [9:0]           mem_addr2;
   wire [9:0]           mem_addr3;
   
   wire [11:0]          bramin_addr;

   // qmfir
   reg                  START;
   wire 		DataValid;
   
        // chipscope
   /*reg [31:0] counter;
        wire [35:0] CONTROL_BUS;
        wire [15:0] DATA;
        wire [7:0] TRIG;*/
        
        //CHIPSCOPE
        /*always @ (posedge clk)
        counter = counter + 1;
        
        assign cnt = counter[31:28];
        
        icon i_icon
                 (.CONTROL0(CONTROL_BUS));
        
        assign DATA=counter[15:0];
        assign TRIG = counter[7:0];
        
        ila ila_
                (.CONTROL(CONTROL_BUS),
                .CLK(clk),
                .TRIG0(TRIG),
                .DATA(DATA));*/
        
        
        // CORE

	
   assign arst = ~arst_n ;
   assign arst1 = ESCR[0];
   
   
   
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
               .idata(uart_dout[15:0]),
               .iaddr(uart_addr),
               .iwe(reg_we),
               .FIR_WE(DataValid),
               .WFIFO_WE(uart_mem_we)
                );
                
   BRAM_larg bramin_(//outputs
                     .doutb(firin), //32 bit
                     //inputs
                     .clka(clk),
                     .clkb(clk),
                     .addra(bramin_addr[11:0]), //12 bit
                     .addrb(FCNT[11:0]), //12 bit
                     .dina(uart_dout),  //32 bit
                     .wea(uart_mem_we));

   QM_FIR QM_FIR(//outputs
                 .RealOut1               (RealOut1),
                 .RealOut2               (RealOut2), 
                 .RealOut3               (RealOut3), 
                 .ImagOut1               (ImagOut1), 
                 .ImagOut2               (ImagOut2), 
                 .ImagOut3               (ImagOut3),
                 .DataValid              (DataValid),
                 //inputs
                 .CLK                    (clk), 
                 .ARST                   (arst1), 
                 .InputValid             (START), 
                 .dsp_in0                (firin[31:24]), 
                 .dsp_in1                (firin[23:16]), 
                 .dsp_in2                (firin[15:8]), 
                 .dsp_in3                (firin[7:0]), 
                 .newFreq                (FREQ[14]),
                 .freq                   (FREQ[6:0]));

   BRAM BRAM1_ (//outputs
		.doutb({MEMDATI1[15:0],MEMDATR1[15:0]}),
		//inputs
		.clka(clk),
		.clkb(clk),
		.addra(WPTR[6:0]),
		.addrb(mem_addr1[6:0]),
		.dina({ImagOut1[15:0],RealOut1[15:0]}),
		.wea(DataValid));
   
   BRAM BRAM2_ (//outputs
		.doutb({MEMDATI2[15:0],MEMDATR2[15:0]}),
		//inputs
		.clka(clk),
		.clkb(clk),
		.addra(WPTR[6:0]),
		.addrb(mem_addr2[6:0]),
		.dina({ImagOut2[15:0],RealOut2[15:0]}),
		.wea(DataValid));
   
   BRAM BRAM3_ (//outputs
		.doutb({MEMDATI3[15:0],MEMDATR3[15:0]}),
		//inputs
		.clka(clk),
		.clkb(clk),
		.addra(WPTR[6:0]),
		.addrb(mem_addr3[6:0]),
		.dina({ImagOut3[15:0],RealOut3[15:0]}),
		.wea(DataValid));

/*   BRAM imag2_ (//outputs
		.doutb(MEMDATI2[15:0]),
		//inputs
		.clka(clk),
		.clkb(clk),
		.addra(WPTR[6:0]),
		.addrb(mem_addri2[6:0]),
		.dina(ImagOut2),
		.wea(DataValid));

   BRAM real3_ (//outputs
		.doutb(MEMDATR3[15:0]),
		//inputs
		.clka(clk),
		.clkb(clk),
		.addra(WPTR[6:0]),
		.addrb(mem_addrr3[6:0]),
		.dina(RealOut3),
		.wea(DataValid));

   BRAM imag3_ (//outputs
		.doutb(MEMDATI3[15:0]),
		//inputs
		.clka(clk),
		.clkb(clk),
		.addra(WPTR[6:0]),
		.addrb(mem_addri3[6:0]),
		.dina(ImagOut3),
		.wea(DataValid));*/
   
   always @ (posedge clk or posedge arst)
     if (arst !=  1'b0)
       START <= 1'b0;
     else
       START <= ESCR[3];
   
   
   // BRAM in interface
      assign bramin_addr[11:0] = {(12){uart_mem_we}} & uart_addr[11:0];
   
   //iReg interface
   always @ (/*AS*/ESCR or FCNT or FREQ or ICNT or OCNT or WPTR
	     or uart_addr)
     case (uart_addr[2:0])
       3'h1: uart_reg_i = {uart_addr[7:0], ESCR[15:0]};
       3'h2: uart_reg_i = {uart_addr[7:0], WPTR[15:0]};
       3'h3: uart_reg_i = {uart_addr[7:0], ICNT[15:0]};
       3'h4: uart_reg_i = {uart_addr[7:0], FREQ[15:0]};
       3'h5: uart_reg_i = {uart_addr[7:0], OCNT[15:0]};
       3'h6: uart_reg_i = {uart_addr[7:0], FCNT[15:0]};
       default: uart_reg_i = {uart_addr[7:0],16'hDEAD};
     endcase // case (uart_addr[2:0])
   
   // BRAM out interface
   //read address
   assign mem_addr1[6:0] = ((uart_addr[13:11] == 3'h1) | (uart_addr[13:11] == 3'h2)) ? uart_addr[6:0] : 7'b111_1111;
   assign mem_addr2[6:0] = ((uart_addr[13:11] == 3'h3) | (uart_addr[13:11] == 3'h4)) ? uart_addr[6:0] : 7'b111_1111;
   assign mem_addr3[6:0] = ((uart_addr[13:11] == 3'h5) | (uart_addr[13:11] == 3'h6)) ? uart_addr[6:0] : 7'b111_1111;
   
   always @ (posedge clk or posedge arst)
     if (arst)
       uart_addr_d1[2:0] <= 3'd0;
     else
       uart_addr_d1[2:0] <= uart_addr[13:11];
   
   //read data
   assign MEMDAT[15:0] = (MEMDATR1[15:0] & {16{uart_addr[13:11] == 3'h1}})| 
			 (MEMDATI1[15:0] & {16{uart_addr[13:11] == 3'h2}})| 
			 (MEMDATR2[15:0] & {16{uart_addr[13:11] == 3'h3}})| 
			 (MEMDATI2[15:0] & {16{uart_addr[13:11] == 3'h4}}) | 
			 (MEMDATR3[15:0] & {16{uart_addr[13:11] == 3'h5}}) | 
			 (MEMDATI3[15:0] & {16{uart_addr[13:11] == 3'h6}});
   
   assign uart_mem_i[23:0] = {1'b0,uart_addr[13:11],uart_addr[3:0], MEMDAT[15:0]};
   

     
endmodule // QMFIR_uart_top

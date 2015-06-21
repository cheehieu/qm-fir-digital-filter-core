// ******************************************************************************* //
// **                    General Information                                    ** //
// ******************************************************************************* //
// **  Module             : iReg.v                                              ** //
// **  Project            : ISAAC NEWTON                                        ** //
// **  Author             : Kayla Nguyen                                        ** //
// **  First Release Date : August 5, 2008                                      ** //
// **  Description        : Internal Register for Newton core                   ** //
// ******************************************************************************* //
// **                     Revision History                                      ** //
// ******************************************************************************* //
// **                                                                           ** //
// **  File        : iReg.v                                                     ** //
// **  Revision    : 1                                                          ** //
// **  Author      : kaylangu                                                   ** //
// **  Date        : August 5, 2008                                             ** //
// **  FileName    :                                                            ** //
// **  Notes       : Initial Release for ISAAC demo                             ** //
// **                                                                           ** //
// **  File        : iReg.v                                                     ** //
// **  Revision    : 2                                                          ** //
// **  Author      : kaylangu                                                   ** //
// **  Date        : August 19, 2008                                            ** //
// **  FileName    :                                                            ** //
// **  Notes       : 1. Register 0 functional modification                      ** //
// **                2. Bit ReOrdering function change to for loop              ** //
// **                3. Register 1 and Register 2 counter modify to use         ** //
// **                   Write Enable bits                                       ** //
// **                                                                           ** //
// **  File        : iReg.v                                                     ** //
// **  Revision    : 3                                                          ** //
// **  Author      : kaylangu                                                   ** //
// **  Date        : October 23, 2008                                           ** //
// **  FileName    :                                                            ** //
// **  Notes       : Change interrupt signal to be only one clock long          ** //
// **                                                                           ** //
// ******************************************************************************* //
`timescale 1 ns / 100 ps

module iReg
  (/*AUTOARG*/
   // Outputs
   ESCR, WPTR, ICNT, FREQ, OCNT, FCNT,
   // Inputs
   clk, arst, idata, iaddr, iwe, FIR_WE, WFIFO_WE
   );
   
   
   //**************************************************************************//
   //*                         Declarations                                   *//
   //**************************************************************************//
   // DATA TYPE - PARAMETERS
   parameter         r0setclr      = 15;        // Register 0 set/clr bit
   
   parameter         initWM        = 8'h60;
//   parameter         ModuleVersion = 2;
              
   // DATA TYPE - INPUTS AND OUTPUTS
   input             clk;          // 100MHz Clock from BUS                                   
   input             arst;         // Asynchronous Reset (positive logic)
   input [15:0]      idata;
   input [13:0]      iaddr;
   input 	     iwe;
   input 	     FIR_WE;
   input 	     WFIFO_WE;
        
   output [15:0]     ESCR;
   output [15:0]     WPTR;
   output [15:0]     ICNT;
   output [15:0]     FREQ;
   output [15:0]     OCNT;
   output [15:0]     FCNT;

                                                                                                                           
   // DATA TYPE - INTERNAL REG
   reg               OVFL_MSK;     // Overflow Mask
   reg               WMI_MSK;      // WMI Mask
   reg               OVFL;         // Overflow for CPTR
   reg               WMI;          // Watermark Interrupt
   reg [15:0]        ICNT;         // Counts the numbers of inputs
   reg [7:0] 	     OCNT_WM;      // Output counter watermark
   reg [7:0] 	     OCNT_int;     // Counts the numbers of outputs
   reg 		     FIR_WE_dly1;
   reg [10:0] 	     CPTR;
   reg [15:0] 	     FCNT;
   reg 		     SYNC;
      
//   reg 		     iReg_intr_d1;
//   reg 		     iReg_intr_1d;
   
   reg [6:0] 	     FREQ_int;
   reg 		     NEWFREQ;
   reg 		     START;
   
   
   // DATA TYPE - INTERNAL WIRES
   wire              setclr;
      
   wire 	     reg0w;
   wire 	     reg1w;
   wire 	     reg2w;
   wire 	     reg3w;
   wire 	     reg4w;
   
   
 
   //**************************************************************************//
   //*                             REG 1                                      *//
   //**************************************************************************//
   assign setclr = reg0w & idata[r0setclr];
   assign reg0w = (iaddr[2:0] == 3'h1) & iwe;
   
   always @ (posedge clk or posedge arst)  
     if (arst != 1'b0)
       OVFL_MSK <= 1'b0;
     else if (reg0w & idata[10])
       OVFL_MSK <= idata[r0setclr];
   
   always @ (posedge clk or posedge arst)  
     if (arst != 1'b0)
       WMI_MSK <= 1'b0;
     else if (reg0w & idata[9]) 
       WMI_MSK <= idata[r0setclr];
   
   always @ (posedge clk or posedge arst)  
     if (arst != 1'b0)
       OVFL <= 1'b0;     
     else if (CPTR[10] == 1'b1)    // BRAM pointer overflows
       OVFL <= 1'b1;
     else if (reg0w & idata[2])
       OVFL <= idata[r0setclr];

   always @ (posedge clk or posedge arst)
     if (arst != 1'b0)
       START <= 1'b0;
     else if (reg0w & idata[3])
       START <= idata[r0setclr];
     else if (WMI | (FCNT[11:0] == 12'b1111_1111_1110))
       START <= 1'b0;
     else
       START <= START;
   
   always @ (posedge clk or posedge arst)
     if  (arst != 1'b0)
       FIR_WE_dly1 <= 1'b0;
     else
       FIR_WE_dly1 <= FIR_WE;  
    
   always @ (posedge clk or posedge arst)
     if (arst != 1'b0)
       WMI <= 1'b0;
     else if (FIR_WE_dly1 & (OCNT_int[7:0] == OCNT_WM[7:0])) // Output counter overflows       
       WMI <= 1'b1;
     else if (reg0w & idata[1])
       WMI <= idata[r0setclr];

   always @ (posedge clk or posedge arst)
     if (arst != 1'b0)
       SYNC <= 1'b0;
     else if (reg0w & idata[0])
       SYNC <= idata[r0setclr];
   

   // Read out
   assign ESCR[15:0]  = {setclr, 4'd0, OVFL_MSK, WMI_MSK, 5'd0, START, 
			 OVFL, WMI, SYNC};   

   
   //**************************************************************************//
   //*                             REG 2                                      *//
   //**************************************************************************//
   /*always @ (posedge clk or posedge arst)
     if (arst != 1'b0)
       SPTR[9:0] <= 10'd0;
     else if (Bus2IP_WrCE[1])
       SPTR[9:0] <= idata[25:16];*/

   assign reg1w = (iaddr[2:0] == 3'h2) & iwe;
   
   always @ (posedge clk or posedge SYNC)
     if (SYNC != 1'b0)
       CPTR[10:0] <= 11'd0;
     else if (OVFL == 1'b1)
       CPTR[10] <= 1'b0;
//     else if (SYNC)
//       CPTR[10:0] <= 11'd0;     
     else
       CPTR[10:0] <= CPTR[10:0] + FIR_WE; //Pointer to BRAM address
   
   // Readout
   assign WPTR[15:0] = {6'd0, CPTR[9:0]};
   
   
   //**************************************************************************//
   //*                             REG 3                                      *//
   //**************************************************************************//
   assign reg2w = (iaddr[2:0] == 3'h3) & iwe;
   
   always @ (posedge clk or posedge arst)
     if (arst != 1'b0)
       ICNT[15:0] <= 16'd0;
     else if (reg2w)
       ICNT[15:0] <= idata[15:0];
     else              
       ICNT[15:0] <= ICNT[15:0] + WFIFO_WE;
   
   
   //**************************************************************************//
   //*                             REG 4                                      *//
   //**************************************************************************//
   assign reg3w = (iaddr[2:0] == 3'h4) & iwe;
   assign setclrf = reg3w & idata[7];
   
   always @ (posedge clk or posedge arst)
     if (arst != 1'b0)
       FREQ_int[6:0] <= 7'h41;  //Resets to frequency 65MHz
     else if (setclrf)
       FREQ_int[6:0] <= idata[6:0];

   always @ (posedge clk or posedge arst)
     if (arst != 1'b0)
       NEWFREQ <= 1'b0;
     else if (reg3w )
       NEWFREQ <= idata[14];

   assign FREQ[15:0] = {1'b0, NEWFREQ, 6'd0, setclrf, FREQ_int[6:0]};
   
   
   //**************************************************************************//
   //*                             REG 5                                      *//
   //**************************************************************************//
   assign reg4w = (iaddr[2:0] == 3'h5) & iwe;
   
   always @ (posedge clk or posedge arst)
     if (arst != 1'b0)
       OCNT_WM[7:0] <= initWM;
     else if (reg4w)
       OCNT_WM[7:0] <= idata[15:8];
   
   always @ (posedge clk or posedge arst)
     if (arst != 1'b0)
       OCNT_int[7:0] <= 8'd0;
     else if (reg4w)
       OCNT_int[7:0] <= idata[7:0];
     else                              
       OCNT_int[7:0] <= OCNT_int[7:0] + FIR_WE;
   
   // Read out
   assign OCNT[15:0] = {OCNT_WM[7:0], OCNT_int[7:0]};
   
   //**************************************************************************//
   //*                             REG 6                                      *//
   //**************************************************************************//   
   assign reg5w = (iaddr[2:0] == 3'h6) & iwe;
   
   always @ (posedge clk or posedge arst)
     if (arst != 1'b0)
       FCNT[15:0] <= 16'd0;
     else if (reg5w)
       FCNT[15:0] <= idata[15:0];
     else if (START)
       FCNT[15:0] <= FCNT[15:0] + 1;   
   
   
   //**************************************************************************//
   //*                           Read Out                                     *//
   //**************************************************************************//
   //always @ (/*AS*/Bus2IP_RdCE or ESCR or ICNT or OCNT or WPTR)
     /*begin
        IP2Bus_Data_int[31:0] = 32'b0;
        case (1'b1)
          Bus2IP_RdCE[0]   : IP2Bus_Data_int[31:0] = ESCR[31:0];
          Bus2IP_RdCE[1]   : IP2Bus_Data_int[31:0] = WPTR[31:0];
          Bus2IP_RdCE[2]   : IP2Bus_Data_int[31:0] = ICNT[31:0];
          Bus2IP_RdCE[3]   : IP2Bus_Data_int[31:0] = OCNT[31:0];
        endcase // case (1'b1)
     end*/

//   assign iReg2IP_RdAck = |Bus2IP_RdCE[0:3];
//   assign IP2Bus_WrAck  = |Bus2IP_WrCE[0:3];

endmodule // iReg

module datapath(clock, reset, stop, in_data, run, opcode, clear,
		R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, R8out, R9out, R10out, R11out, R12out, R13out, R14out, R15out,
		R0in, R1in, R2in, R3in, R4in, R5in, R6in, R7in, R8in, R9in, R10in, R11in, R12in, R13in, R14in, R15in,
		PCout, read, write, BAout, Rin, Rout, Gra, Grb, Grc, CONN_in, MARin, MDRin, HIin, LOin, Yin, jal_flag, R15jal,
		Zin, ZLowIn, ZHighIn, PCin, IRin, incPC, InPortIn, OutPortIn, HIout, LOout, ZLowOut, ZHighOut, MDRout, Cout, InPortOut, Mdatain);
     input wire clock, reset, stop;
     input wire [31:0] in_data, Mdatain;
     output wire [31:0] run;   

     input wire clear;
     wire [63:0] C_Register_Out;
     input wire [4:0] opcode;

     // these wires also feed into the 32 to 5 encoder
     // declaring the input and output wires to the 16 32-bit registers
     input wire R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, R8out, R9out, R10out, R11out, R12out, R13out, R14out, R15out;
     input wire R0in, R1in, R2in, R3in, R4in, R5in, R6in, R7in, R8in, R9in, R10in, R11in, R12in, R13in, R14in, R15in;
    
     input wire PCout, read, write, BAout, Rin, Rout, Gra, Grb, Grc, CONN_in, MARin, MDRin, HIin, LOin, Yin, jal_flag, R15jal,
        Zin, ZHighIn, ZLowIn, PCin, IRin, incPC, InPortIn, OutPortIn, HIout, LOout, ZLowOut, ZHighOut, MDRout, Cout, InPortOut;
        
     // declare wires into the bus multiplexer
     wire [31:0] BusMuxIn_R0, BusMuxIn_R1, BusMuxIn_R2, 
               BusMuxIn_R3, BusMuxIn_R4, BusMuxIn_R5, 
               BusMuxIn_R6, BusMuxIn_R7, BusMuxIn_R8, 
               BusMuxIn_R9, BusMuxIn_R10, BusMuxIn_R11, 
               BusMuxIn_R12, BusMuxIn_R13, BusMuxIn_R14, 
               BusMuxIn_R15;
     
     wire [31:0] IRdata, BusMuxIn_HI, BusMuxIn_LO, 
               BusMuxIn_Zhigh, BusMuxIn_Zlow, BusMuxIn_PC, 
               BusMuxIn_MDR, BusMuxIn_InPort, RamDataOut,
               Yout, d_pc, MARout, BusMuxOut, C_sign_extended,
               OutPortOut;

    /*
         R0-R7: General Purpose Reg
         R8: Return Address Reg
         R9: Stack Pointer (SP)
         R10-R13: Arguement Registers
         R14-15: Return Value Registers
    */
     
    // this hasn't been declared yet
     regR0 R0 (BAout, clear, clock, R0in, BusMuxOut, BusMuxIn_R0); //input signal is always 0 for R0 (special reg)
     reg32 R1 (clear, clock, R1in, BusMuxOut, BusMuxIn_R1);
     reg32 R2 (clear, clock, R2in, BusMuxOut, BusMuxIn_R2);    
     reg32 R3 (clear, clock, R3in, BusMuxOut, BusMuxIn_R3);  
     reg32 R4 (clear, clock, R4in, BusMuxOut, BusMuxIn_R4);  
     reg32 R5 (clear, clock, R5in, BusMuxOut, BusMuxIn_R5);  
     reg32 R6 (clear, clock, R6in, BusMuxOut, BusMuxIn_R6);  
     reg32 R7 (clear, clock, R7in, BusMuxOut, BusMuxIn_R7);  
     reg32 R8 (clear, clock, R8in, BusMuxOut, BusMuxIn_R8);  
     reg32 R9 (clear, clock, R9in, BusMuxOut, BusMuxIn_R9);  
     reg32 R10 (clear, clock, R10in, BusMuxOut, BusMuxIn_R10);  
     reg32 R11 (clear, clock, R11in, BusMuxOut, BusMuxIn_R11);  
     reg32 R12 (clear, clock, R12in, BusMuxOut, BusMuxIn_R12);  
     reg32 R13 (clear, clock, R13in, BusMuxOut, BusMuxIn_R13);  
     reg32 R14 (clear, clock, R14in, BusMuxOut,  BusMuxIn_R14);  
     reg32 R15 (clear, clock, R15jal, BusMuxOut,  BusMuxIn_R15); 

     reg32 HI (clear, clock, HIin, BusMuxOut, BusMuxIn_HI); 
     reg32 LO (clear, clock, LOin, BusMuxOut, BusMuxIn_LO);
     reg32 ZHigh (clear, clock, Zin, C_Register_Out[63:32], BusMuxIn_Zhigh);
     reg32 ZLow (clear, clock, Zin, C_Register_Out[31:0], BusMuxIn_Zlow);

     reg32 Y (clear, clock, Yin, BusMuxOut, Yout);
     reg32 InPort (clear, clock, InPortIn, in_data, BusMuxIn_InPort); 
     reg32 OutPort (clear, clock, OutPortIn, BusMuxOut, OutPortOut);

     reg32_PC PC (clear, clock, incPC, PCin, BusMuxOut, BusMuxIn_PC);

     reg32 IR (clear, clock, IRin, BusMuxOut, IRdata);
	  
     mdr MDR (.clk(clock), .clr(clear), .read(read), .MDRin(MDRin), .BusMuxOut(BusMuxOut), .Mdatain(Mdatain), .Q(BusMuxIn_MDR));

     bus myBus (
          // “out” signals (which cause one input to drive the bus): (from the encoder)
          .R0out   (R0out),
          .R1out   (R1out),
          .R2out   (R2out),
          .R3out   (R3out),
          .R4out   (R4out),
          .R5out   (R5out),
          .R6out   (R6out),
          .R7out   (R7out),
          .R8out   (R8out),
          .R9out   (R9out),
          .R10out  (R10out),
          .R11out  (R11out),
          .R12out  (R12out),
          .R13out  (R13out),
          .R14out  (R14out),
          .R15out  (R15out),
          .HIout   (HIout),
          .LOout   (LOout),
          .ZHighOut(ZHighOut),
          .ZLowOut (ZLowOut),
          .PCout   (PCout),
          .MDRout  (MDRout),
          .InPortOut(InPortOut),
          .Cout    (Cout),

          // “in” data lines to the mux
          .BusMuxIn_R0   (BusMuxIn_R0),
          .BusMuxIn_R1   (BusMuxIn_R1),
          .BusMuxIn_R2   (BusMuxIn_R2),
          .BusMuxIn_R3   (BusMuxIn_R3),
          .BusMuxIn_R4   (BusMuxIn_R4),
          .BusMuxIn_R5   (BusMuxIn_R5),
          .BusMuxIn_R6   (BusMuxIn_R6),
          .BusMuxIn_R7   (BusMuxIn_R7),
          .BusMuxIn_R8   (BusMuxIn_R8),
          .BusMuxIn_R9   (BusMuxIn_R9),
          .BusMuxIn_R10  (BusMuxIn_R10),
          .BusMuxIn_R11  (BusMuxIn_R11),
          .BusMuxIn_R12  (BusMuxIn_R12),
          .BusMuxIn_R13  (BusMuxIn_R13),
          .BusMuxIn_R14  (BusMuxIn_R14),
          .BusMuxIn_R15  (BusMuxIn_R15),
          .BusMuxIn_HI   (BusMuxIn_HI),
          .BusMuxIn_LO   (BusMuxIn_LO),
          .BusMuxIn_Zhigh(BusMuxIn_Zhigh),
          .BusMuxIn_Zlow (BusMuxIn_Zlow),
          .BusMuxIn_PC   (BusMuxIn_PC),
          .BusMuxIn_MDR  (BusMuxIn_MDR),
          .BusMuxIn_InPort(BusMuxIn_InPort),
          .C_sign_extended(C_sign_extended),
          .BusMuxOut(BusMuxOut)                   
     );

    alu myAlu (
          .A(Yout),
          .B(BusMuxOut),
          .clock(clock),
          .clear(clear),
          .opcode(opcode),
          .C(C_Register_Out)
     );
    
endmodule
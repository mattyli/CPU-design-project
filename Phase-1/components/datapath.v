module DataPath(clock, reset, stop, in_data, run);
    input wire clock, reset, stop;
    input wire [31:0] in_data;
    output wire [31:0] run;

    wire clear;

    // declaring the input and output wires to the 16 32-bit registers
    wire R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, R8out, R9out, R10out, R11out, R12out, R13out, R14out, R15out;
    wire R0in, R1in, R2in, R3in, R4in, R5in, R6in, R7in, R8in, R9in, R10in, R11in, R12in, R13in, R14in, R15in;

    wire PCin, PCout, MARin, MDRin, MDRout, InPortIn, InPortOut, OutPortIn, OutPortOut, HIin, HIout, LOin, LOout,
         IRin;
    
    // PCout, read, write, BAout, Rin, Rout, Gra, Grb, Grc, CONN_in, MARin, MDRin, HIin, LOin, Yin, jal_flag, R15jal,
    //     Zin, PCin, IRin, incPC, InPortIn, OutPortIn, HIout, LOout, ZLowOut, ZHighOut, MDRout, Cout, InPortOut;

    /*
         R0-R7: General Purpose Reg
         R8: Return Address Reg
         R9: Stack Pointer (SP)
         R10-R13: Arguement Registers
         R14-15: Return Value Registers
    */
    
endmodule
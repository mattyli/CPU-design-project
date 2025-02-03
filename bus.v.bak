/*
    Per the figure the bus consists of two modules
        - 32-5 encoder
            - only the first 23 signals are used
        - 32-1 multiplexers
*/


module bus (
    // ports from encoder (following convention from the figure)
    input R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, R8out, R9out, R10out, R11out, R12out, R13out, R14out, R15out,
    input HIout, LOout, ZHighOut, ZLowOut, PCout, MDRout, InPortOut, Cout, 

    // ports coming into mux
    input [31:0] BusMuxIn_R0, BusMuxIn_R1, BusMuxIn_R2, BusMuxIn_R3, BusMuxIn_R4, BusMuxIn_R5, BusMuxIn_R6, BusMuxIn_R7, BusMuxIn_R8, BusMuxIn_R9, BusMuxIn_R10, BusMuxIn_R11, BusMuxIn_R12, BusMuxIn_R13, BusMuxIn_R14, BusMuxIn_R15,
    input [31:0] BusMuxIn_HI, BusMuxIn_LO, BusMuxIn_Zhigh, BusMuxIn_Zlow, BusMuxIn_PC, BusMuxIn_MDR, BusMuxIn_InPort, C_sign_extended,
    output [31:0] BusMuxOut,

    wire [4:0] encoder_out
);
    /*
        creating an instance of the 32-5 encoder
        input is the *out registers
        output should be a 
    */
    encoder32_5 encoder (
        .encoder_in(R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, R8out, R9out, R10out, R11out, R12out, R13out, R14out, R15out,
                    HIout, LOout, ZHighOut, ZLowOut, PCout, MDRout, InPortOut, Cout),
        .encoder_out(encoder_out)
    );
    
    // even though we have a 32-1 mux, only 24 signals are used
    mux32_1 mux(
        .in_0(BusMuxIn_R0),
        .in_1(BusMuxIn_R1),
        .in_2(BusMuxIn_R2),
        .in_3(BusMuxIn_R3),
        .in_4(BusMuxIn_R4),
        .in_5(BusMuxIn_R5),
        .in_6(BusMuxIn_R6),
        .in_7(BusMuxIn_R7),
        .in_8(BusMuxIn_R8),
        .in_9(BusMuxIn_R9),
        .in_10(BusMuxIn_R10),
        .in_11(BusMuxIn_R11),
        .in_12(BusMuxIn_R12),
        .in_13(BusMuxIn_R13),
        .in_14(BusMuxIn_R14),
        .in_15(BusMuxIn_R15),
        .in_16(BusMuxIn_HI),
        .in_17(BusMuxIn_LO),
        .in_18(BusMuxIn_Zhigh),
        .in_19(BusMuxIn_Zlow),
        .in_20(BusMuxIn_PC),
        .in_21(BusMuxIn_MDR),
        .in_22(BusMuxIn_InPort),
        .in_23(C_sign_extended),
        .select(encoder_out),
        .mux_out(BusMuxOut)
    );
    
endmodule
//Defining a memory data register
//Phase 1 Report Document, Page 5 Figure 4

module mdr (
        clk,    //clock signal
        clr,    //clear signal
        read,   //read signal
        MDRin,  //Write and enable signals
        BusMuxOut,  //Data sent by the bus mux
        MDatain,    //Data from memory
        D, //input D after MUX
        Q   //Output Q
    );

    input wire clk, clr, read, MRin, BusMuxOut, MDatain;
    input wire [31:0]D;
    output reg [31:0]Q;

    mux2_1 mdmux (
        .in_0 (BusMuxOut),
        .in_1 (MDatain),
        .select (read),
        .out (D)
    );

    reg32 MDR (
        .clr(clr),
        .clk(clk),
        .enable(MDRin),
        .D(D),
        .Q(Q)
    );
    
endmodule
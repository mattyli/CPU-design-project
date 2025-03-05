//Defining a memory data register
//Phase 1 Report Document, Page 5 Figure 4

module mdr (
        clk,    //clock signal
        clr,    //clear signal
        read,   //read signal
        MDRin,  //Write and enable signals
        BusMuxOut,  //Data sent by the bus mux
        Mdatain,    //Data from memory
        D, //input D after MUX
        Q   //Output Q
    );

    input wire clk, clr, read, MDRin;
	input wire [31:0] Mdatain, BusMuxOut;
    input wire [31:0]D;
    output wire [31:0]Q;

    mux2_1 mdmux (
        .in_0 (Mdatain),
        .in_1 (BusMuxOut),
        .select (read),
        .mux_out (D)
    );

    reg32 MDR (
        .clear(clr),
        .clock(clk),
        .enable(MDRin),
        .D(D),
        .Q(Q)
    );
    
endmodule
module CON_FF(
    input wire [31:0] IR, BusMuxOut,
    input wire CON_In,
    output reg CON_Out
);

    wire [1:0] C2;
    assign C2 = IR[20:19];                  // C2 field from Figure 7, page 5
    
endmodule
module reg64 (
    clr,
    clk,
    enable,
    D,
    Qhi,
    Qlo
);
    input clr, clk, enable;
    input wire [63:0]D;         // D is 64 bit input (so after multiplication)
    output reg [31:0]Qhi, Qlo;  // Qhi stores 32 MSB, Qlo stores 32 LSB

    always @(posedge clk) begin
        if (clr)                // if clear is asserted, clear the two registers
            Qhi <= 0;
            Qlo <= 0;
        else if (enable)
            Qhi <= D[63:32];    // 32 MSB
            Qlo <= D[31:0];     // 32 LSB      

    end
    
    
endmodule
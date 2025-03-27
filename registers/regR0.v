module regR0 #(parameter q0 = 0) (
    input wire clear, clock, enable, BAout,
    input wire [31:0] D,   // Input D (from BusMuxOut)
    output reg [31:0] Q    // Output Q (into BusMuxIn)
);

    reg [31:0] tmp_reg; 

    initial tmp_reg = q0;  // Initialize tmp_reg to q0

    always @(posedge clock) begin
        if (clear) 
            Q <= 32'b0;               // If clear is high, set Q to 0
        else if (BAout) 
            Q <= 32'b0;               // If BAout is high, set Q to 0
        else if (enable) 
            tmp_reg <= D;            // If enable is high, load value from D into tmp_reg
        else
            Q <= tmp_reg;            // Otherwise, maintain current value of tmp_reg
    end

endmodule
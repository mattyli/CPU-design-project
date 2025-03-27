module mar(
    input wire clk,
    input wire clr,
    input wire MARin,
    input wire [31:0] BusMuxOut,
    output reg [7:0] addr
    );

    always @(posedge clk) begin
        if (clr) 
				addr <= 0;
        
        else if (MARin) 
				addr <= BusMuxOut[7:0]; 

    end


endmodule
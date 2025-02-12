module shr32 (a, num_shift, result);
    input wire signed[31:0] a;
    input wire [4:0] num_shift;
    output reg signed[31:0] result;
		
	 always @(*) begin
		result = a >> num_shift;
	 end
endmodule
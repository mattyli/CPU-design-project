module rol32 (a, num_shift, result);
    input wire [31:0] a;
    input wire [31:0] num_shift;
    output reg[31:0] result;

	 always @(*) begin
		result = (a << num_shift) | (a >>(32 - num_shift));
	 end
	 
endmodule
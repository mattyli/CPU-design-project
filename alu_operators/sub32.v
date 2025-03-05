module sub32(a, b, carry_in, sum, carry_out);
    input wire signed [31:0] a,b;
	input wire carry_in;
	output wire signed [31:0] sum;
	output wire carry_out;
	wire [31:0] inverted;

    negate32 neg(.a(b), .result(inverted));
    add32 add(.a(a), .b(inverted), .carry_in(carry_in), .sum(sum), .carry_out(carry_out));
	
endmodule
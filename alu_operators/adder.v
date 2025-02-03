/*
    Carry look ahead (CLA) adder implementation
    start by implementing one CLA cell
        - then 4, 16, 32
        - this is just for cleanliness
*/

module cla_32_bit(a, b, carry_in, sum, carry_out);
    input wire [31:0] a,b;
	input wire carry_in;
	output wire [31:0] sum;
	output wire carry_out;
	wire carry_1;
	
	cla16bit cla1 (.a(a[15:0]), .b(b[15:0]), .sum(sum[15:0]), .carry_in(carry_in), .carry_out(carry_1));
	cla16bit cla2 (.a(a[31:16]), .b(b[31:16]), .sum(sum[31:16]), .carry_in(carry_1), .carry_out(carry_out));
endmodule

module cla_16_bit(a, b, carry_in, sum, carry_out);
    input wire [15:0] a,b;
	input wire carry_in;
	output wire [15:0] sum;
	output wire carry_out;
	wire carry_1, carry_2, carry_3;
	
	cla4bit cla1 (.a(a[3:0]), .b(b[3:0]), .sum(sum[3:0]), .carry_in(carry_in), .carry_out(carry_1));
	cla4bit cla2 (.a(a[7:4]), .b(b[7:4]), .sum(sum[7:4]), .carry_in(carry_1), .carry_out(carry_2));
	cla4bit cla3 (.a(a[11:8]), .b(b[11:8]), .sum(sum[11:8]), .carry_in(carry_2), .carry_out(carry_3));
	cla4bit cla4 (.a(a[15:12]), .b(b[15:12]), .sum(sum[15:12]), .carry_in(carry_3), .carry_out(carry_out));
endmodule

module cla_4_bit(a, b, carry_in, sum, carry_out);
    input wire[3:0] a, b,                           // since we're adding two 4 bit numbers
    input wire carry_in;                            // this stays the same
    output wire[3:0] sum,                           // 4 bit so 4 sums 
    output wire carry_out;                          // the carry from the MSB
    wire carry_1, carry_2, carry_3;

    cla cla1 (.a(a[0]), .b(b[0]), .sum(s[0]), .carry_in(carry_in), .carry_out(carry_1));
	cla cla2 (.a(a[1]), .b(b[1]), .s(s[1]), .carry_in(carry_1), .carry_out(carry_2));
	cla cla3 (.a(a[2]), .b(b[2]), .s(s[2]), .carry_in(carry_2), .carry_out(carry_3));
	cla cla4 (.a(a[3]), .b(b[3]), .s(s[3]), .carry_in(carry_3), .carry_out(carry_out));
endmodule

// based on this: https://www.geeksforgeeks.org/carry-look-ahead-adder/
module cla(a, b, carry_in, sum, carry_out);
    input wire a, b, carry_in;
    output wire sum, carry_out;

    wire a_xor_b, a_and_b, out_and_carry
    assign a_xor_b = ((a) ^ (b))                        // a XOR b
    assign a_and_b = ((a) & (b))                        // a AND b
    assign out_and_carry = ((carry_in) & (a_xor_b)) 
    assign sum = ((carry_in) ^ (a_xor_b))
    assign carry_out = ((a_and_b) | (out_and_carry))

endmodule
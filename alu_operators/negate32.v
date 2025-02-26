/*
    module to get negative of an integer through twos complement
     - invert all bits (with not module)
     - add 1
*/

module negate32(a, result);
    input wire signed[31:0] a;
    output wire signed[31:0] result;

    wire [31:0] inverted;
    wire carry_out;

    not32 neg_inverted (.a(a), .result(inverted));          // the inverted number is on the inverted wire
    add32 out (.a(inverted),                       // add one to the inverted result
                    .b(32'd1),                          // constant 1
                    .carry_in(0), 
                    .carry_out(carry_out));             // carry out ignored

endmodule
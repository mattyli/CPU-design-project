module shra32(a, num_shift, result);
    input wire signed [31:0] a;
    input wire[4:0] num_shift;
    output wire signed[31:0] result;

    assign result = a <<< num_shift;

endmodule
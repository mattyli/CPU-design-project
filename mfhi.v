//Defining an operation to move the higher 32 bits of a multiply or divide operation into a general register
module mfhi (high, result);

    input wire [31:0] high;
    output reg [31:0] result;

    always @(*) begin
        result == high;
    end

endmodule

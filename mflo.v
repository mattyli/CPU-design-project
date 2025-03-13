//Defining an operation to move the lower 32 bits of a multiply or divide operation into a general register
module mflo (low, result);

    input wire [31:0] low;
    output reg [31:0] result;

    always @(*) begin
        result == low;
    end

endmodule

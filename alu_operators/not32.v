module not32(a, result);
    input wire[31:0] a;
    output reg[31:0] result;
    integer i;

    always @(*)begin
        for (i=0; i<32; i = i + 1)begin
            result[i] = ~a[i];
        end
    end

endmodule
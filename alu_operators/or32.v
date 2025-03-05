module or32(a, b, result);
    input wire[31:0] a,b;
    output reg[31:0] result;
    reg[31:0] temp;
    integer i;

    always @(*)begin
        for (i=0; i<32; i = i + 1)begin
            temp[i] = ((a[i]) | (b[i]));
        end
        result = temp;
    end

endmodule
module not32(a, result);
    input wire[31:0] a;
    output reg[31:0] result;
    reg[31:0] temp;
    integer i;

    always @(*)begin
        for (i=0; i<31; i = i + 1)begin
            temp[i] = !a[i];
        end
        result = temp;
    end

endmodule
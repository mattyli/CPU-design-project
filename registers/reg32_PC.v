module reg32_PC #(parameter q0 = 0) (
    clear, 
    clock,
    incPC,
    enable,
    instruct_PC,
    PC
);

input wire clear, clock, incPC, enable;
input wire [31:0] instruct_PC;
output reg [31:0] PC;

initial PC = q0;

always @(posedge clock) begin
    if (clear) 
        PC <= 0;
    //else if (incPC == 1 && enable == 1)
    //    PC <= PC + 4;
    else if (enable == 1)
        PC <= instruct_PC;
end

endmodule 
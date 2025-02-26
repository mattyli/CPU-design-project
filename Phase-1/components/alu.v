`timescale 1ns/10ps

module alu(A, B, clock, clear, opcode, C);
    input wire [31:0] A, B;                         // 32 bit inputs (could make this variable)
    input wire clock, clear;                       
    input wire [4:0] opcode;                        // control signal that will determine which operation
    output reg [63:0] C;                            // 64 bit output

    // wires for 32 bit results
    wire [31:0] add32_result, sub32_result, and32_result, or32_result, xor32_result, nor32_result, neg32_result,
                not32_result, shr32_result, shl32_result, shra32_result, ror32_result, rol32_result;
	 wire add32_carryout, sub32_carryout;
    wire [63:0] mul64_result, div64_result; 
    
    // opcodes as specified in the CPU spec document
    parameter   
        nop       = 5'b11010,  // No-operation
        add       = 5'b00011,  // Addition
        sub       = 5'b00100,  // Subtraction
        mul       = 5'b10000,  // Multiplication
        div       = 5'b01111,  // Division
        shr       = 5'b01001,  // Shift right
        shl       = 5'b01011,  // Shift left
        shra      = 5'b01010,  // Shift right arithmetic
        ror       = 5'b00111,  // Rotate right
        rol       = 5'b01000,  // Rotate left
        logic_and = 5'b00101,  // Logical AND
        logic_or  = 5'b00110,  // Logical OR
        logic_neg = 5'b10001,  // Negate (2’s complement)
        logic_xor = 5'b01101,  // Logical XOR (not explicitly listed but assuming similar pattern)
        logic_nor = 5'b01110,  // Logical NOR
        logic_not = 5'b10010;  // NOT (1’s complement)

    // Phase 1 Operations
    negate32 alu_neg(.a(A), .result(neg32_result));
    not32 alu_not(.a(A), .result(not32_result));

    rol32 alu_rol(.a(A), .num_shift(B), .result(rol32_result));
    ror32 alu_ror(.a(A), .num_shift(B), .result(ror32_result));
    shl32 alu_shl(.a(A), .num_shift(B), .result(shl32_result));
    shr32 alu_shr(.a(A), .num_shift(B), .result(shr32_result));
    // shla32 alu_shla(.a(A), .num_shift(B), .result(shla32_result));
    shra32 alu_shra(.a(A), .num_shift(B), .result(shra32_result));

    and32 alu_and(.a(A), .b(B), .result(and32_result));
    or32 alu_or(.a(A), .b(B), .result(or32_result));
    xor32 alu_xor(.a(A), .b(B), .result(xor32_result));

    add32 alu_add(.a(A), .b(B), .carry_in(1'd0), .sum(add32_result), .carry_out(add32_carryout));
    sub32 alu_sub(.a(A), .b(B), .carry_in(1'd0), .sum(sub32_result), .carry_out(sub32_carryout));
    
    multiply32 alu_mul(.multiplicand(A), .multiplier(B), .product(mul64_result));
    divide32 alu_div(.divisor(A), .dividend(B), .quotient(div64_result));

    always @(*) begin
        case(opcode)
            add: begin
                C[31:0] = add32_result;
                C[63:32] = {32{add32_result[31]}};                // need to sign extend this based on the MSB of add32
            end

            sub: begin
                C[31:0] = sub32_result;
                C[63:32] = {32{sub32_result[31]}}; 
            end

            mul: begin
                C[63:0] = mul64_result[63:0];
            end

            div: begin
                C[63:0] = div64_result[63:0];
            end
            logic_and: begin
                C[31:0] = and32_result;
                C[63:32] = 32'b0;
            end
            logic_or: begin
                C[31:0] = or32_result;
                C[63:32] = 32'b0;
            end
            logic_neg: begin
                C[31:0] = neg32_result;
                C[63:32] = 32'b0;
            end
            logic_xor: begin
                C[31:0] = xor32_result;
                C[63:32] = 32'b0;
            end
            logic_nor: begin
                C[31:0] = nor32_result;
                C[63:32] = 32'b0;
            end
            logic_not: begin
                C[31:0] = nor32_result;
                C[63:32] = 32'b0;
            end
            shr: begin
                C[31:0] = shr32_result;
                C[63:32] = 32'b0;
            end
            shl: begin
                C[31:0] = shl32_result;
                C[63:32] = 32'b0;
            end
            shra: begin
                C[31:0] = shra32_result;
                C[63:32] = 32'b0;
            end
            // shla: begin
            //     C[31:0] = shla32_result;
            // end
            ror: begin
                C[31:0] = ror32_result;
                C[63:32] = 32'b0;
            end
            rol: begin
                C[31:0] = rol32_result;
                C[63:32] = 32'b0;
            end
        endcase
    end
    
endmodule
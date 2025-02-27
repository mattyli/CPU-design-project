/* 
    divisor M, dividend Q (Q/M)
    non restoring division that uses the circuit on Computer Architecture: Part 3 pg 8

    * note on signed division Computer Architecture: Part 3 Page 12


*/ 

module divide32(divisor, dividend, quotient);
    input wire signed [31:0] divisor, dividend;
    output reg signed [63:0] quotient;

    integer i;
    reg signed [31:0] dividend_register, divisor_register;
    reg signed [63:0] AQ;
    reg sign; 

    always @(*) begin
        sign = dividend[31] ^ divisor[31];  

        if (dividend[31])
            dividend_register = -dividend;
        else
            dividend_register = dividend;

        if (divisor[31])
            divisor_register = -divisor;
        else
            divisor_register = divisor;


        AQ = {32'd0, dividend_register};


        for (i = 0; i < 32; i = i + 1) begin
            AQ = AQ << 1;  // Left shift AQ

  
            if (AQ[63] == 1'b1)
                AQ[63:32] = AQ[63:32] + divisor_register;  // A = A + M
            else
                AQ[63:32] = AQ[63:32] - divisor_register;  // A = A - M


            if (AQ[63] == 1'b1)
                AQ[0] = 1'b0;
            else
                AQ[0] = 1'b1;
        end


        // if (AQ[63] == 1'b1) 
        //     quotient = {AQ[63:32]+divisor_register, AQ[31:0]};
        // else
        //     quotient = {AQ[63:32]+divisor_register, AQ[31:0]};  // A = A + M

        // Apply correct sign to quotient
        if (sign)
            quotient = -{AQ[63:32], AQ[31:0]};
        else
            quotient = {AQ[63:32], AQ[31:0]};
    end
endmodule



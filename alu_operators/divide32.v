/* 
    divisor M, dividend Q (Q/M)
    non restoring division that uses the circuit on Computer Architecture: Part 3 pg 8

    * note on signed division Computer Architecture: Part 3 Page 12


*/ 
//module divide32(divisor, dividend, quotient);
//    input wire signed [31:0] divisor, dividend;                             // may have signed operations
//    output reg signed [63:0] quotient;                                      // since we have 32x32 bit multiplication, may need 64 bits
//                                                                            // signed KWD necessary so verilog knows we're operating in twos complement
//    integer i;                                                              // looping variable
//    reg signed [31:0] dividend_register, divisor_register;                                     // need 32 + 1 bit because of the extra 0 pre-pended
//    reg signed [63:0] AQ;                                                   // initialize to 0, need 64 + 1 bits because of the 
//
//    
//
//    always @(*) begin
//        // negating the divisor and dividend in case they are negative
//        if (dividend[31])
//            dividend_register = -dividend;
//        else
//            dividend_register = dividend;
//        
//        if (divisor[31])
//            divisor_register = -divisor;      
//        else
//            divisor_register = divisor;
//
//        // load the combined A/Q register
//        AQ = {32'd0, dividend_register};                            // A is n+1 bits (33)
//        
//        // Step 1:
//        for (i=0; i<32; i=i+1) begin
//            AQ = AQ << 1;            // left shift AQ
//
//            // Use MSB to check sign
//            if (AQ[63]==1'b1)
//                // A is less than 0
//                AQ[63:32] = AQ[63:32] + divisor_register;           // A = A + M
//            else
//                // A is greater or equal to 0
//                AQ[63:32] = AQ[63:32] - divisor_register;
//            
//            if (AQ[63]==1'b1)
//                AQ[0] = 1'b0;
//            else
//                AQ[0] = 1'b1;
//        end
//        
//        // Step 2: Ensuring positive remainder
//        if (AQ[63]==1'b1) 
//            quotient = {AQ[63:32] + divisor_register, AQ[31:0]};               // A = A + M
//        else
//            quotient = {AQ[63:32], AQ[31:0]};                                   // assign the final answer
//    end


//endmodule

module divide32(divisor, dividend, quotient);
    input wire signed [31:0] divisor, dividend;
    output reg signed [63:0] quotient;

    integer i;
    reg signed [31:0] dividend_register, divisor_register;
    reg signed [63:0] AQ;
    reg sign;  // Keep track of quotient's sign

    always @(*) begin
        // Determine sign of quotient
        sign = dividend[31] ^ divisor[31];  // XOR: If signs differ, quotient should be negative

        // Convert to absolute values
        if (dividend[31])
            dividend_register = -dividend;
        else
            dividend_register = dividend;

        if (divisor[31])
            divisor_register = -divisor;
        else
            divisor_register = divisor;

        // Initialize AQ
        AQ = {32'd0, dividend_register};

        // Non-Restoring Division Algorithm
        for (i = 0; i < 32; i = i + 1) begin
            AQ = AQ << 1;  // Left shift AQ

            // Perform subtraction or addition based on sign of A
            if (AQ[63] == 1'b1)
                AQ[63:32] = AQ[63:32] + divisor_register;  // A = A + M
            else
                AQ[63:32] = AQ[63:32] - divisor_register;  // A = A - M

            // Set LSB of Q based on A's sign
            if (AQ[63] == 1'b1)
                AQ[0] = 1'b0;
            else
                AQ[0] = 1'b1;
        end

        // Remainder correction: Ensure remainder has the same sign as dividend
        if (AQ[63] == 1'b1) 
            AQ[63:32] = AQ[63:32] + divisor_register;  // A = A + M

        // Apply correct sign to quotient
        if (sign)
            quotient = -{AQ[63:32], AQ[31:0]};  // Negate quotient if needed
        else
            quotient = {AQ[63:32], AQ[31:0]};
    end
endmodule

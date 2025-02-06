/*
implementation of booths algorithm (for bit pair recoding) for quick multiplication
- need n+1 adder, and right shift to be implemented
- need to be able to handle signed multiplication
- need the MUX
    - which mux?
    - doing bit pair recoding, need to right shift 2x

 https://onq.queensu.ca/content/enforced/1002651-ELEC374W25/Computer%20Arithmetic,%20Part%202.pdf?ou=1002651

 from this: 
    - 000, 111 --> 0 * Multiplicand
    - 001, 010 --> +1 * Multiplicand
    - 101, 110 --> -1 * Multiplicand
    - 011 --> +2 * Multiplicand
    - 100 --> -2 * Multiplicand

 need to shift multiplicand (left)
            x x x x x x x x
        x x x x x x x x 0 0 
    x x x x x x x x 0 0 0 0 
            
*/

module multiply32(multiplicand, multiplier, product);
    input wire signed [31:0] multiplicand, multiplier;          // may have signed operations
    output reg signed [63:0] product;                           // since we have 32x32 bit multiplication, may need 64 bits
                                                                // signed KWD necessary so verilog knows we're operating in twos complement
    // registers required for multiplicand and multiplier since they are initially just wires (can't store anything)
    integer i;                                          // looping variable
    reg signed [31:0] multiplicand_register;            
    reg signed [32:0] multiplier_register;              // need 32 + 1 bit because of the extra 0 appended
    reg [2:0] pair_pattern;                             // first two bits, plus the one immediately right of the LSB
    reg signed [63:0] partial_product;                  // initialize to 0

    

    always @(*) begin
        multiplicand_register = multiplicand;
        partial_product = 64'b0;
        multiplier_register = (multiplier << 1);        // left shift adds the trailing 0

        for (i=0; i<16; i = i+1) begin
            pair_pattern = multiplier_register[2:0]

            case (pair_pattern)
            3'b001, 3'b010: partial_product = partial_product + multiplicand_register;    // +1 * M
            3'b101, 3'b110: partial_product = partial_product - multiplicand_register;    // -1 * M
            3'b011: partial_product = partial_product + (multiplicand_register <<< 1);    // +2 * M, left (arithmetic) shift achieves doubling effect
            3'b100: partial_product = partial_product - (multiplicand_register <<< 1);    // -2 * M
            endcase
            
            multiplicand_register = multiplicand_register <<< 2;    // shift left, because addition of the multiplicands is off set by 2
            multiplier_register = multiplier_register >>> 2;        // shift (arithmetic) right 
        end
        product = partial_product;
    end


endmodule
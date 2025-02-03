/*
implementation of booths algorithm (for bit pair recoding) for quick multiplication
- need n+1 adder, and right shift to be implemented
- need to be able to handle signed multiplication
- need the MUX
    - which mux?
    - doing bit pair recoding, need to right shift 2x
*/

module multiply(q, m, product);
    input wire[31:0] q, m;
    output reg[31:0] product;

    reg [31:0] A;                   // the A register

    integer n;                      // to count how many shifts to do 
endmodule
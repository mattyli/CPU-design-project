module SAE(
    input wire Gra, Grb, Grc, Rin, Rout, BAout,
    input wire [31:0] IR,
    output wire R0in, R1in, R2in, R3in, R4in, R5in, R6in, R7in, R8in, R9in, R10in, R11in, R12in, R13in, R14in, R15in,
    output wire R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, R8out, R9out, R10out, R11out, R12out, R13out, R14out, R15out,
    output wire [31:0] C_sign_extended
    );
    // declare internal module wires
    wire [3:0] Ra, Rb, Rc;                  // wires to get bits from the INSTRUCTION
    assign Ra = IR[26:23];
    assign Rb = IR[22:19];
    assign Rc = IR[18:15];

    wire [3:0] Gra_and, Grb_and, Grc_and;               // wires to carry and results from the AND gates to the OR gate
    assign Gra_and = Gra == 1 ? 4'b1111 : 4'b0000;      // need to extend the 
    assign Grb_and = Grb == 1 ? 4'b1111 : 4'b0000;
    assign Grc_and = Grc == 1 ? 4'b1111 : 4'b0000;

    wire [3:0] decoder_in;
	 wire [15:0] decoder_out;
    assign decoder_in = (Ra & Gra_and) | (Rb & Grb_and) | (Rc & Grc_and);

    decoder4_16 myDecoder(.in(decoder_in), .out(decoder_out));

    wire Rout_or;
    assign Rout_or = Rout | BAout;

    assign R0in = decoder_out[0] & Rin;
    assign R1in = decoder_out[1] & Rin;
    assign R2in = decoder_out[2] & Rin;
    assign R3in = decoder_out[3] & Rin;
    assign R4in = decoder_out[4] & Rin;
    assign R5in = decoder_out[5] & Rin;
    assign R6in = decoder_out[6] & Rin;
    assign R7in = decoder_out[7] & Rin;
    assign R8in = decoder_out[8] & Rin;
    assign R9in = decoder_out[9] & Rin;
    assign R10in = decoder_out[10] & Rin;
    assign R11in = decoder_out[11] & Rin;
    assign R12in = decoder_out[12] & Rin;
    assign R13in = decoder_out[13] & Rin;
    assign R14in = decoder_out[14] & Rin;
    assign R15in = decoder_out[15] & Rin;

    assign R0out = decoder_out[0] & Rout_or;
    assign R1out = decoder_out[1] & Rout_or;
    assign R2out = decoder_out[2] & Rout_or;
    assign R3out = decoder_out[3] & Rout_or;
    assign R4out = decoder_out[4] & Rout_or;
    assign R5out = decoder_out[5] & Rout_or;
    assign R6out = decoder_out[6] & Rout_or;
    assign R7out = decoder_out[7] & Rout_or;
    assign R8out = decoder_out[8] & Rout_or;
    assign R9out = decoder_out[9] & Rout_or;
    assign R10out = decoder_out[10] & Rout_or;
    assign R11out = decoder_out[11] & Rout_or;
    assign R12out = decoder_out[12] & Rout_or;
    assign R13out = decoder_out[13] & Rout_or;
    assign R14out = decoder_out[14] & Rout_or;
    assign R15out = decoder_out[15] & Rout_or;

    // handle sign extension of the C_reg (from the 18th bit according to Fig 4. page 3 of the CPU doc)
    assign C_sign_extended = IR[17] == 1 ? {14'b11111111111111, IR[17:0]} : {14'b0, IR[17:0]};

endmodule
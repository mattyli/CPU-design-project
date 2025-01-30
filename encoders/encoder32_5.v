// selects the active input and outputs the 5 bit binary indexer
// refer to CPU doc Fig. 3 "A typical bus"

module encoder32_5 (
    input wire [31:0]encoder_in;
    output reg[4:0]encoder_out;
);
    always @(encoder_in) begin
        if(encoder_in[31]==1) encoder_out=5'b11111;				// here down (unused)
		else if (encoder_in[30]==1) encoder_out=5'b11110;
		else if (encoder_in[29]==1) encoder_out=5'b11101;
		else if (encoder_in[28]==1) encoder_out=5'b11100;
		else if (encoder_in[27]==1) encoder_out=5'b11011;
		else if (encoder_in[26]==1) encoder_out=5'b11010;
		else if (encoder_in[25]==1) encoder_out=5'b11001;
		else if (encoder_in[24]==1) encoder_out=5'b11000;		// here up (unused)
		else if (encoder_in[23]==1) encoder_out=5'b10111;
		else if (encoder_in[22]==1) encoder_out=5'b10110;
		else if (encoder_in[21]==1) encoder_out=5'b10101;
		else if (encoder_in[20]==1) encoder_out=5'b10100;
		else if (encoder_in[19]==1) encoder_out=5'b10011;
		else if (encoder_in[18]==1) encoder_out=5'b10010;
		else if (encoder_in[17]==1) encoder_out=5'b10001;
		else if (encoder_in[16]==1) encoder_out=5'b10000;
		else if (encoder_in[15]==1) encoder_out=5'b01111;
		else if (encoder_in[14]==1) encoder_out=5'b01110;
		else if (encoder_in[13]==1) encoder_out=5'b01101;
		else if (encoder_in[12]==1) encoder_out=5'b01100;
		else if (encoder_in[11]==1) encoder_out=5'b01011;
		else if (encoder_in[10]==1) encoder_out=5'b01010;
		else if (encoder_in[9]==1) encoder_out=5'b01001;
		else if (encoder_in[8]==1) encoder_out=5'b01000;
		else if (encoder_in[7]==1) encoder_out=5'b00111;
		else if (encoder_in[6]==1) encoder_out=5'b00110;
		else if (encoder_in[5]==1) encoder_out=5'b00101;
		else if (encoder_in[4]==1) encoder_out=5'b00100;
		else if (encoder_in[3]==1) encoder_out=5'b00011;
		else if (encoder_in[2]==1) encoder_out=5'b00010;
		else if (encoder_in[1]==1) encoder_out=5'b00001;
		else encoder_out=5'b00000;					
	end
endmodule
module regR0(BAout, clr, clk, enable, D, Q);
	input wire BAout, clr, clk, enable;
	input wire [31:0] D;
	output wire [31:0] Q;

	reg [31:0] regout;
	
	always @(posedge clk) begin
		if (clr)
			regout <= 0;
		else if (enable) 
            regout <= D;
	end
    
	assign Q = BAout ? 32'b0 : regout;

endmodule
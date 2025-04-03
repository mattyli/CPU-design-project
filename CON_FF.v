module CON_FF (
    input [31:0] IR,
    input [31:0] BusMuxOut,
    input wire CON_In,
    output reg CON_Out
);
    wire [1:0] IRin;
    wire nor_bus, msb_bus;
	 reg D;


    initial CON_Out <= 0;

    assign IRin = IR[20:19];

    //Nor gate all bus inputs
    assign nor_bus = BusMuxOut == 0 ? 1'b1 : 1'b0;

    //Get MSB of bus
    assign msb_bus = BusMuxOut[31];

    //2 to 4 decoder and value a
    always @(*) begin
        case(IRin)
            2'b00: D = nor_bus;
            2'b01: D = ~nor_bus;
            2'b10: D = ~msb_bus;
            2'b11: D = msb_bus;
        endcase
    end
    always @(CON_In) begin
        CON_Out <= D;
    end
endmodule
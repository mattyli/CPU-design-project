`timescale 1ns/1ps
// Mem addr #2
module load_tb1;
    reg clock, clear;
    reg read, write;
    reg Gra, Grb, Grc, BAout;
    reg CONN_in, InPortIn, OutPortIn;
    reg Rin, HIin, LOin, Zin, incPC, MARin, MDRin, Yin, IRin, PCin;
    reg Rout, HIout, LOout,ZLowOut, ZHighOut, MDRout, Cout, InPortOut, PCout;
    reg[4:0] opcode;
    reg[31:0] in_data;

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

    parameter   Default = 4'b0000, Reg_load1a = 4'b0001, Reg_load1b = 4'b0010, Reg_load2a = 4'b0011,
                Reg_load2b = 4'b0100, Reg_load3a = 4'b0101, Reg_load3b = 4'b0110, T0 = 4'b0111,
                T1 = 4'b1000, T2 = 4'b1001, T3 = 4'b1010, T4 = 4'b1011, T5 = 4'b1100, T6 = 4'b1101, T7 = 4'b1110;

    reg [3:0] Present_state = Default;


    datapath DUT (
        .clock(clock),
        .clear(clear),
        .read(read),
        .write(write),
        .BAout(BAout),
        .Rin(Rin),
        .Rout(Rout),
        .Gra(Gra),
        .Grb(Grb),
        .Grc(Grc),
        .CONN_in(CONN_in),
        .MARin(MARin),
        .MDRin(MDRin),
        .HIin(HIin),
        .LOin(LOin),
        .Yin(Yin),
        .Zin(Zin),
        .PCin(PCin),
        .IRin(IRin),
        .incPC(incPC),
        .InPortIn(InPortIn),
        .OutPortIn(OutPortIn),
        .HIout(HIout),
        .LOout(LOout),
        .ZLowOut(ZLowOut),
        .ZHighOut(ZHighOut),
        .MDRout(MDRout),
        .Cout(Cout),
        .InPortOut(InPortOut),
        .PCout(PCout), 
        .opcode(opcode),
        .in_data(in_data)
    );

    initial clock = 0;
    always #5 clock = ~clock;

    always@(posedge clock) begin
        case (Present_state)
            Default     : #40 Present_state = Reg_load1a;
            Reg_load1a  : #40 Present_state = Reg_load1b;
            Reg_load1b  : #40 Present_state = Reg_load2a;
            Reg_load2a  : #40 Present_state = Reg_load2b;
            Reg_load2b  : #40 Present_state = Reg_load3a;
            Reg_load3a  : #40 Present_state = Reg_load3b;
            Reg_load3b  : #40 Present_state = T0;
            T0          : #40 Present_state = T1;
            T1          : #40 Present_state = T2;
            T2          : #40 Present_state = T3;
            T3          : #40 Present_state = T4;
            T4          : #40 Present_state = T5;
            T5          : #40 Present_state = T6;
            T6          : #40 Present_state = T7;
        endcase
    end

	always @(Present_state) begin
		case (Present_state)
			Default : begin
				CONN_in = 0;
				MDRin = 0;
				MARin = 0;
				read = 0;
				write = 0;
				HIin = 0;
				LOin = 0;
				Yin = 0;
				Zin = 0;
				PCin = 0;
				IRin = 0;
				incPC = 0;
				InPortIn = 0;
				OutPortIn = 0;
				HIout = 0;
				LOout = 0;
				ZHighOut = 0;
				ZLowOut = 0;
				PCout = 0;
				MDRout = 0;
				InPortOut = 0;
				Cout = 0;
				BAout = 0;
				Gra = 0;
				Grb = 0;
				Grc = 0;
				Rin = 0;
				Rout = 0;
				in_data = 0;
				opcode = 0;
        		clear = 0;
			end
            Reg_load1a: begin
                #10 in_data <= 32'h54; InPortIn <= 1;
                #15 in_data <= 32'hx; InPortIn <= 0;
            end
            Reg_load1b: begin
                #10 InPortOut <= 1; MARin <= 1;
                #15 InPortOut <= 0; MARin <= 0;
            end
            Reg_load2a: begin
                #10 in_data <= 32'h97; InPortIn <= 1;
                #15 in_data <= 32'hx; InPortIn <= 0;
            end
            Reg_load2b: begin
                #10 InPortOut <= 1; MDRin <= 1;
                #15 InPortOut <= 0; MDRin <= 0;
            end
            Reg_load3a: begin
                #10 write <= 1; in_data <= 32'h0; InPortIn <= 1;
                #15 write <= 0; InPortIn <= 0;
            end
            Reg_load3b: begin
                // #10 InPortOut <= 1; PCin <= 1;
                // #15 InPortOut <= 0; PCin <= 0;
            end
            T0: begin 
                #10 PCout <= 1; MARin <= 1; Zin <= 1; incPC = 1; //PC placed onto bus. PC addr gets sent to MAR,  
                #15 PCout <= 0; MARin <= 0; Zin <= 0; incPC = 0;
            end
            T1: begin
                #10 ZLowOut <= 1; PCin <= 1; read <= 1; MDRin <= 1;
                #15 ZLowOut <= 0; PCin <= 0; read <= 0; MDRin <= 0;
            end
            T2: begin
                #10 MDRout <= 1; IRin <= 1;
                #15 MDRout <= 0; IRin <= 0;
            end
            T3: begin
                #10 Grb = 1; BAout <= 1; Yin <= 1;
                #15 Grb = 0; BAout <= 0; Yin <= 0;
            end
            T4: begin
                #10 Cout <= 1; Zin <= 1; opcode = add;
                #15 Cout <= 0; Zin <= 0; opcode = nop;
            end
            T5: begin
                #10 ZLowOut <= 1; MARin <= 1;
                #15 ZLowOut <= 0; MARin <= 0;
            end
            T6: begin
                #10 read <= 1; MDRin <= 1;
                #15 read <= 0; MDRin <= 0;
            end
            T7: begin
                #10 MDRout <= 1; Gra <= 1; Rin <= 1;
                #15 MDRout <= 0; Gra <= 0; Rin <= 0;
            end

        endcase
    end

endmodule
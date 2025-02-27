//Testbench does the following operation
//Add R4, R3, R7
// R6 holds 30 R7 holds 25

`timescale 1ns/10ps
module rol_tb;
    reg clock, clear;
    reg R0in, R1in, R2in, R3in, R4in, R5in, R6in, R7in, R8in, R9in, R10in, R11in, R12in, R13in, R14in, R15in;
    reg HIin, LOin, Zin, incPC, MARin, MDRin, read, InPortIn, Yin, IRin, PCin;
    reg R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, R8out, R9out, R10out, R11out, R12out, R13out, R14out, R15out;
    reg HIout, LOout,ZLowOut, ZHighOut, MDRout, Cout, InPortOut, PCout;
    reg[4:0] opcode;
    reg[31:0] Mdatain;

    parameter   Default = 4'b0000, Reg_load1a = 4'b0001, Reg_load1b = 4'b0010, Reg_load2a = 4'b0011,
                Reg_load2b = 4'b0100, Reg_load3a = 4'b0101, Reg_load3b = 4'b0110, T0 = 4'b0111,
                T1 = 4'b1000, T2 = 4'b1001, T3 = 4'b1010, T4 = 4'b1011, T5 = 4'b1100;

    reg[3:0] Present_state = Default;

    datapath DUT(
        .clear(clear),
        .clock(clock),
        .R0in(R0in),
        .R1in(R1in),
        .R2in(R2in),
        .R3in(R3in),
        .R4in(R4in),
        .R5in(R5in),
        .R6in(R6in),
        .R7in(R7in),
        .R8in(R8in),
        .R9in(R9in),
        .R10in(R10in),
        .R11in(R11in),
        .R12in(R12in),
        .R13in(R13in),
        .R14in(R14in),
        .R15in(R15in),
        .PCin(PCin),
        .HIin(HIin),
        .LOin(LOin),
        .Zin(Zin),
        .incPC(incPC),
        .MARin(MARin),
        .MDRin(MDRin),
        .read(read),
        .InPortIn(InPortIn),
        .Yin(Yin),
        .opcode(opcode),
        .Mdatain(Mdatain),

        .R0out(R0out),
        .R1out(R1out),
        .R2out(R2out),
        .R3out(R3out),
        .R4out(R4out),
        .R5out(R5out),
        .R6out(R6out),
        .R7out(R7out),
        .R8out(R8out),
        .R9out(R9out),
        .R10out(R10out),
        .R11out(R11out),
        .R12out(R12out),
        .R13out(R13out),
        .R14out(R14out),
        .R15out(R15out),
        .PCout(PCout),
        .HIout(HIout),
        .LOout(LOout),
        .ZHighOut(ZHighOut),
        .ZLowOut(ZLowOut),
        .MDRout(MDRout),
        .InPortOut(InPortOut)
        );

    initial clock = 0;
    always #5 clock = ~clock;
	

    always @(posedge clock) begin
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
        endcase
    end

    always @(Present_state) begin
        case(Present_state)
            Default: begin
					clear <= 1;
                    R1in <= 0;
                    R2in <= 0;
                    R3in <= 0;
                    R4in <= 0;
                    R5in <= 0;
                    R6in <= 0;
                    R7in <= 0;
                    R8in <= 0;
                    R9in <= 0;
                    R10in <= 0;
                    R11in <= 0;
                    R12in <= 0;
                    R13in <= 0;
                    R14in <= 0;
                    R15in <= 0;
                    HIin <= 0;
                    LOin <= 0;
                    Mdatain <= 32'b0;
                    R1out <= 0;
                    R2out <= 0;
                    R3out <= 0;
                    R4out <= 0;
                    R5out <= 0;
                    R6out <= 0;
                    R7out <= 0;
                    R8out <= 0;
                    R9out <= 0;
                    R10out <= 0;
                    R11out <= 0;
                    R12out <= 0;
                    R13out <= 0;
                    R14out <= 0;
                    R15out <= 0;
                    HIout <= 0;
                    LOout <= 0;
                    PCout <= 0;
                    ZHighOut <= 0;
                    ZLowOut <= 0;
                    MDRout <= 0;
                    InPortOut <= 0;
                    InPortIn <= 0;
                    Cout <= 0;
                    incPC <= 0;
                    MARin <= 0;
                    MDRin <= 0;
                    read <= 0;
                    IRin <= 0;
                    PCin <= 0;
                    opcode <= 5'b11010;
            end
            Reg_load1a: begin
				clear <= 0;
                Mdatain <= 32'b1111001000110100010101100000000;
                #10 read <= 1; MDRin <= 1;
                #10 read <= 0; MDRin <= 0;
            end
            Reg_load1b: begin
                #10 MDRout <= 1; R3in <= 1;
                #10 MDRout <= 0; R3in <= 0; //Load R6 with value 30 from MDR
            end
            Reg_load2a: begin 
                Mdatain <= 32'b0100;
                #10 read <= 1; MDRin <= 1;
                #10 read <= 0; MDRin <= 0;
            end
            Reg_load2b: begin
                #10 MDRout <= 1; R7in <= 1; //Load R7 with value 25 from MDR
                #10 MDRout <= 0; R7in <= 0;
            end
            Reg_load3a: begin
                Mdatain = 32'b0;
                #10 read <= 1; MDRin <= 1; 
                #10 read <= 0; MDRin <= 0;
            end
            Reg_load3b: begin
                #10 MDRout <= 1; R4in <= 1; //Initialize R8 with value 0
                #10 MDRout <= 0; R4in <= 0;
            end

            T0: begin
                #10
                incPC <= 1; MARin <= 1;     //Mock instruction fetch
                PCout <= 1; //Zin <= 1;
                #15
                incPC <= 0; MARin <= 0;
                PCout <= 0; //Zin <= 0;
            end
            T1: begin
                #10 
                PCin <= 1; read <= 1;
                MDRin <= 1; Mdatain <= 5'b01000;
                #15 
                PCin <= 0; read <= 0;
                MDRin <= 0; Mdatain <= 0;
            end
            T2: begin 
                #10 
                MDRout <= 1; IRin <= 1;
                #15
                MDRout <= 0; IRin <= 0;
            end
            T3: begin
                #10 
                R3out <= 1; Yin <= 1;
                #15 
                R3out <= 0; Yin <= 0;
            end
            T4: begin
                R7out <= 1; opcode <= 5'b01000; Zin <= 1;
                #25 R7out <= 0; Zin <= 0; 
            end
            T5: begin 
                #10
                ZLowOut <= 1; R4in <= 1;
                #15
                ZLowOut <= 0; R4in <= 0;
            end               
        endcase
    end
endmodule
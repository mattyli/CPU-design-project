//ori R5, R6, 0x95
`timescale 1ns/10ps
module ori_tb;
    reg clock, clear;
    reg R0in, R1in, R2in, R3in, R4in, R5in, R6in, R7in, R8in, R9in, R10in, R11in, R12in, R13in, R14in, R15in;
    reg HIin, LOin, Zin, incPC, MARin, MDRin, read, InPortIn, Yin, IRin, PCin;
    reg R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, R8out, R9out, R10out, R11out, R12out, R13out, R14out, R15out;
    reg HIout, LOout,ZLowOut, ZHighOut, MDRout, Cout, InPortOut, PCout;
    reg Gra, Grb, Grc, Rin, Rout, BAout;
    reg [4:0] opcode;
    reg [31:0] Mdatain;

    parameter   Default = 4'b0000, Load_R6 = 4'b0001, T0 = 4'b0010, T1 = 4'b0011,
                T2 = 4'b0100, T3 = 4'b0101, T4 = 4'b0110, T5 = 4'b0111;

    reg[3:0] Present_state = Default;

    datapath DUT(
        .clear(clear),
        .clock(clock),
        .R0in(R0in), .R1in(R1in), .R2in(R2in), .R3in(R3in), .R4in(R4in), .R5in(R5in), .R6in(R6in), .R7in(R7in),
        .R8in(R8in), .R9in(R9in), .R10in(R10in), .R11in(R11in), .R12in(R12in), .R13in(R13in), .R14in(R14in), .R15in(R15in),
        .PCin(PCin), .HIin(HIin), .LOin(LOin), .Zin(Zin), .incPC(incPC), .MARin(MARin), .MDRin(MDRin),
        .read(read), .InPortIn(InPortIn), .Yin(Yin), .opcode(opcode), .Mdatain(Mdatain),
        .R0out(R0out), .R1out(R1out), .R2out(R2out), .R3out(R3out), .R4out(R4out), .R5out(R5out), .R6out(R6out), .R7out(R7out),
        .R8out(R8out), .R9out(R9out), .R10out(R10out), .R11out(R11out), .R12out(R12out), .R13out(R13out),
        .R14out(R14out), .R15out(R15out), .PCout(PCout), .HIout(HIout), .LOout(LOout),
        .ZHighOut(ZHighOut), .ZLowOut(ZLowOut), .MDRout(MDRout), .InPortOut(InPortOut),
        .Gra(Gra), .Grb(Grb), .Grc(Grc), .Rin(Rin), .Rout(Rout), .BAout(BAout)
    );

    initial clock = 0;
    always #5 clock = ~clock;

    always @(posedge clock) begin
        case (Present_state)
            Default     : #40 Present_state = Load_R6;
            Load_R6     : #40 Present_state = T0;
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
                clear <= 1; opcode <= 5'b11010;
                R6in <= 0; R6out <= 0; IRin <= 0; Yin <= 0;
                ZLowOut <= 0; Gra <= 0; Rin <= 0;
                Grb <= 0; Rout <= 0; Cout <= 0; Zin <= 0;
                PCout <= 0; PCin <= 0; read <= 0; MDRin <= 0; MDRout <= 0;
                incPC <= 0; MARin <= 0; Mdatain <= 32'b0;
            end
            Load_R6: begin
                clear <= 0; Mdatain <= 32'h00000000;
                #10 read <= 1; MDRin <= 1;
                #10 read <= 0; MDRin <= 0;
                #10 MDRout <= 1; R6in <= 1;
                #10 MDRout <= 0; R6in <= 0;
            end
            T0: begin
                #10 PCout <= 1; MARin <= 1; incPC <= 1;
                #15 PCout <= 0; MARin <= 0; incPC <= 0;
            end
            T1: begin
                Mdatain <= 32'b10110_0101_0110_000000000000100101; // ori R5, R6, 0x95
                #10 read <= 1; MDRin <= 1;
                #15 read <= 0; MDRin <= 0;
            end
            T2: begin
                #10 MDRout <= 1; IRin <= 1;
                #15 MDRout <= 0; IRin <= 0;
            end
            T3: begin
                #10 Grb <= 1; Rout <= 1; Yin <= 1;
                #15 Grb <= 0; Rout <= 0; Yin <= 0;
            end
            T4: begin
                #10 Cout <= 1; opcode <= 5'b10110; Zin <= 1;
                #15 Cout <= 0; Zin <= 0;
            end
            T5: begin
                #10 ZLowOut <= 1; Gra <= 1; Rin <= 1;
                #15 ZLowOut <= 0; Gra <= 0; Rin <= 0;
            end
        endcase
    end
endmodule

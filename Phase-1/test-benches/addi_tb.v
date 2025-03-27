`timescale 1ns/10ps
module addi_tb;
    reg clock, clear;
    reg PCout, MDRout, IRin, IncPC, Zin, ZLowOut;
    reg MARin, PCin, read, MDRin;
    reg Gra, Grb, Rin, Rout, Cout;
    reg [4:0] opcode;
    reg [31:0] Mdatain;
    
    parameter Default = 4'b0000, T0 = 4'b0001, T1 = 4'b0010, T2 = 4'b0011,
              T3 = 4'b0100, T4 = 4'b0101, T5 = 4'b0110;

    reg [3:0] Present_state = Default;

    datapath DUT (
        .clock(clock),
        .clear(clear),
        .PCout(PCout), .MDRout(MDRout), .IRin(IRin), .incPC(IncPC),
        .Zin(Zin), .ZLowOut(ZLowOut), .MARin(MARin), .PCin(PCin), 
        .read(read), .MDRin(MDRin), .Gra(Gra), .Grb(Grb), .Rout(Rout), .Rin(Rin), .Cout(Cout), 
        .opcode(opcode),
        .Mdatain(Mdatain)
        // add other ports as needed (Rin/Rout flags, etc.)
    );

    initial clock = 0;
    always #10 clock = ~clock;

    always @(posedge clock)
        case (Present_state)
            Default : #40 Present_state = T0;
            T0 : #40 Present_state = T1;
            T1 : #40 Present_state = T2;
            T2 : #40 Present_state = T3;
            T3 : #40 Present_state = T4;
            T4 : #40 Present_state = T5;
        endcase

    always @(Present_state) begin
        case (Present_state)
            Default: begin
                clear <= 1; PCout <= 0; MDRout <= 0; IRin <= 0; IncPC <= 0; Zin <= 0;
                ZLowOut <= 0; MARin <= 0; PCin <= 0; read <= 0; MDRin <= 0;
                Gra <= 0; Grb <= 0; Rin <= 0; Rout <= 0; Cout <= 0;
                Mdatain <= 32'h00000000; // dummy
                opcode <= 5'b10100; // addi opcode
            end
            T0: begin
                clear <= 0;
                PCout <= 1; MARin <= 1; IncPC <= 1;
                #20 PCout <= 0; MARin <= 0; IncPC <= 0;
            end
            T1: begin
                read <= 1; MDRin <= 1;
                // This value would be read from RAM; using for clarity
                Mdatain <= 32'b10100_00000_00110_1111111111111001; // addi R5, R6, -7
                #20 read <= 0; MDRin <= 0;
            end
            T2: begin
                MDRout <= 1; IRin <= 1;
                #20 MDRout <= 0; IRin <= 0;
            end
            T3: begin
                Grb <= 1; Rout <= 1; Yin <= 1;
                #20 Grb <= 0; Rout <= 0; Yin <= 0;
            end
            T4: begin
                Cout <= 1; opcode <= 5'b10100; Zin <= 1; // ADDI
                #20 Cout <= 0; Zin <= 0;
            end
            T5: begin
                ZLowOut <= 1; Gra <= 1; Rin <= 1;
                #20 ZLowOut <= 0; Gra <= 0; Rin <= 0;
            end
        endcase
    end
endmodule

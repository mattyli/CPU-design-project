//ld R4, 0x54 (Case 1)
//TO CHANGE FOR Case 2:
//Mdatain <= 32'b00010_0110_00010_0000000001100011; // ld R6, 0x63(R2)
//Mdatain <= 32'h00000046;
`timescale 1ns/10ps
module ld_tb;

  reg clock, clear;
  reg PCout, ZLowOut, MDRout, IRin, MARin, PCin, IncPC;
  reg read, MDRin, Yin, Zin, BAout, Cout;
  reg Gra, Grb, Rin, Rout;
  reg [31:0] Mdatain;
  reg [4:0] opcode;

  reg [3:0] Present_state;
  parameter Default = 4'b0000, T0 = 4'b0001, T1 = 4'b0010, T2 = 4'b0011,
            T3 = 4'b0100, T4 = 4'b0101, T5 = 4'b0110, T6 = 4'b0111, T7 = 4'b1000;

  datapath DUT (
    .clock(clock), .clear(clear),
    .PCout(PCout), .ZLowOut(ZLowOut), .MDRout(MDRout), .IRin(IRin),
    .MARin(MARin), .PCin(PCin), .incPC(IncPC), .read(read), .MDRin(MDRin),
    .Yin(Yin), .Zin(Zin), .BAout(BAout), .Cout(Cout),
    .Gra(Gra), .Grb(Grb), .Rin(Rin), .Rout(Rout),
    .opcode(opcode), .Mdatain(Mdatain)
  );

  initial clock = 0;
  always #10 clock = ~clock;

  always @(posedge clock) begin
    case (Present_state)
      Default: #40 Present_state = T0;
      T0: #40 Present_state = T1;
      T1: #40 Present_state = T2;
      T2: #40 Present_state = T3;
      T3: #40 Present_state = T4;
      T4: #40 Present_state = T5;
      T5: #40 Present_state = T6;
      T6: #40 Present_state = T7;
    endcase
  end

  always @(Present_state) begin
    case (Present_state)
      Default: begin
        clear <= 1;
        PCout <= 0; ZLowOut <= 0; MDRout <= 0; IRin <= 0;
        MARin <= 0; PCin <= 0; IncPC <= 0;
        read <= 0; MDRin <= 0; Yin <= 0; Zin <= 0;
        BAout <= 0; Cout <= 0;
        Gra <= 0; Grb <= 0; Rin <= 0; Rout <= 0;
        Mdatain <= 32'h00000000;
        opcode <= 5'b00000;  // Can be anything, overridden by IR
      end

      T0: begin
        PCout <= 1; MARin <= 1; IncPC <= 1; Zin <= 1;
        #15 PCout <= 0; MARin <= 0; IncPC <= 0; Zin <= 0;
      end

      T1: begin
        read <= 1; MDRin <= 1;
        Mdatain <= 32'b00010_0100_0000000001010100; // ld R4, 0x54 (opcode=00010)
        #15 read <= 0; MDRin <= 0;
      end

      T2: begin
        MDRout <= 1; IRin <= 1;
        #15 MDRout <= 0; IRin <= 0;
      end

      T3: begin
        Grb <= 1; BAout <= 1; Yin <= 1;
        #15 Grb <= 0; BAout <= 0; Yin <= 0;
      end

      T4: begin
        Cout <= 1; Zin <= 1;
        #15 Cout <= 0; Zin <= 0;
      end

      T5: begin
        ZLowOut <= 1; MARin <= 1;
        #15 ZLowOut <= 0; MARin <= 0;
      end

      T6: begin
        read <= 1; MDRin <= 1;
        Mdatain <= 32'h00000097; // RAM[0x54] = 0x97
        #15 read <= 0; MDRin <= 0;
      end

      T7: begin
        MDRout <= 1; Gra <= 1; Rin <= 1;
        #15 MDRout <= 0; Gra <= 0; Rin <= 0;
      end
    endcase
  end

endmodule

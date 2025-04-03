/*
    swap these instructions as necessary for the different branch cases
    brzr R1, 27 : instruction = 0x9880001B
    brnz R1, 27 : instruction = 0x9888001B
    brpl R1, 27 : instruction = 0x9890001B
    brmi R1, 27 : instruction = 0x9898001B
    if branch should see PC + 1 + C extended = 0 + 1 + 27 = 8 (in PC Q), else see PC Q = 1
    
    MODIFY LINE 84 IN RAM.HEX to SEE CHANGES
    load R1, 0(83)          # added some number to line 84 in ram.hex
    0x00800053

    registers default initialize to 0

    TO RUN DIFFERENT TEST BENCHES:

    - Paste branch instruction hex into ram.hex [0]
    - modify line 84 in ram.hex [84]
    - run
*/

`timescale 1ns/1ps

module brzr_tb;
    reg clock, clear;
    reg read, write;
    reg Gra, Grb, Grc, BAout;
    reg CONN_in, InPortIn, OutPortIn;
    reg Rin, HIin, LOin, Zin, incPC, MARin, MDRin, Yin, IRin, PCin;
    reg Rout, HIout, LOout,ZLowOut, ZHighOut, MDRout, Cout, InPortOut, PCout;
    reg[4:0] opcode;
    reg[31:0] in_data;
    reg latched_branch_flag;


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

    parameter   Default = 5'b00000, REG_load1a = 5'b00001, REG_load1b = 5'b00010, REG_load1c = 5'b00011,
                REG_load1d = 5'b00100, REG_load1e = 5'b00101, REG_load1f = 5'b00110, REG_load1g = 5'b00111,
                T0 = 5'b01000, T1 = 5'b01001, T2 = 5'b01010, T3 = 5'b01011, T4 = 5'b01100,  T5 = 5'b01101, T6 = 5'b01110,
                T7 = 5'b01111; //,  = 5'b10000; //, T7 = 5'b10001;

    parameter BRZR = 32'h9880001B, BRNZ = 32'h9888001B, BRPL = 32'h9890001B, BRMI = 32'h9898001B;

    reg [4:0] Present_state = Default;


    datapath DUT (
        .clock(clock),
        .clear(clear),
        .read(read),
        .write(write),
        .BAout(BAout),
        .Rin(Rin),              // Rin feeds into the SAE module and selects the appropriate register, how to select R4...
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


    // states to the FSM for loading RAM with the memory and R1 register
    always@(posedge clock) begin
        case (Present_state)
            Default     : #40 Present_state = REG_load1a;       // 0
            REG_load1a  : #40 Present_state = REG_load1b;       // 1
            REG_load1b  : #40 Present_state = REG_load1c;       // 2
            REG_load1c  : #40 Present_state = T0;       // 1
            T0          : #40 Present_state = T1;       
            T1          : #40 Present_state = T2;               // 8
            T2          : #40 Present_state = T3;               // 9
            T3          : #40 Present_state = T4;
            // T3a         : #40 Present_state = T4;               // 10
            T4          : #40 Present_state = T5;               // 11
            T5          : #40 Present_state = T6;               // 12
            T6          : #40 Present_state = T7;               // 13
        endcase
    end

    // do ld R4, 0x54 (addr=0x54, value=0x97)
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

            // load the load R1 instruction
            REG_load1a: begin
                #10 in_data <= 32'h0x00800053; InPortIn <= 1;                           // LOAD INSTRUCTION             
                #15 in_data <= 32'hx; InPortIn <= 0;
            end

            // InPort drives the bus, IR register picks up the command from the bus
            REG_load1b: begin
                #10 InPortOut <= 1; IRin <= 1;                         
                #15 InPortOut <= 0; IRin <= 0;
            end
            
            // DO SOMEHTING
            REG_load1c: begin
                #10 Cout <= 1; Gra <= 1; Rin <= 1;
                #15 Cout <= 0; Gra <= 0; Rin <= 0;
            end

            // PROGRAM START
            // instruction fetch (from RAM) and PC increment (PC should initially be 0)
            T0: begin 
                #10 PCout <= 1; MARin <= 1; Zin <= 1; incPC = 1;        // assert PCout, put address on the bus and store in the MAR, then update the PC by 1 (by asserting the signal)
                #15 PCout <= 0; MARin <= 0; Zin <= 0; incPC = 0;
            end

            // load instruction from RAM and gate to the MDR, gate new PC value into the PC Register
            T1: begin
                #10 ZLowOut <= 1; PCin <= 1; read <= 1; MDRin <= 1;     // PC takes value from ZLow, MDR reads data from the address loaded into the MAR
                #15 ZLowOut <= 0; PCin <= 0; read <= 0; MDRin <= 0;
            end

            // move to the instruction register
            T2: begin
                #10 MDRout <= 1; IRin <= 1;                             // MDR value from the bus is put onto the bus and transferred to the Instruction Reg. (IR)
                #15 MDRout <= 0; IRin <= 0;
            end

            T3: begin
                #10 Gra <= 1; Rout <= 1; 
                #15 Gra <= 0; Rout <= 0;  latched_branch_flag = DUT.branch_flag; // ← BLOCKING assignment
                #5 CONN_in <=1;
                #5 CONN_in <=0;

            end
            
            // T3a: begin
            //     #10 CONN_in = 1;   // CON_FF evaluates while BusMuxOut = R1 = 0
            //     #15 CONN_in = 0;
            // end
            
            T4: begin
                #10 PCout <= 1; Yin <= 1;
                #15 PCout <= 0; Yin <= 0;
            end

            T5: begin
                #10 Cout <= 1; Zin <= 1;  opcode = add;             
                #15 Cout <= 0; Zin <= 0;  opcode = nop;
            end

            // T6: begin
            //     if (latched_branch_flag) begin
            //         $display("Branch taken → PC updated to PC + 1 + C");
            //         #10 ZLowOut <= 1; PCin <= 1;
            //         #15 ZLowOut <= 0; PCin <= 0;
            //     end else begin
            //         $display("Branch not taken → PC remains at PC + 1");
            //     end
            // end

            T6: begin
                #10 ZLowOut <= 1; PCin <= 1;                           // Transfer address from ZLow to the MARin (0x54)
                #15 ZLowOut <= 0; PCin <= 0;                           // deassert signals
            end

        endcase
    end

endmodule
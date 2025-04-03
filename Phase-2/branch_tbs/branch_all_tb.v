`timescale 1ns/1ps

module branch_all_tb;
    reg clock = 0, clear = 0;

    // Control Signals
    reg read, write, Gra, Grb, Grc, BAout;
    reg CONN_in, InPortIn, OutPortIn;
    reg Rin, HIin, LOin, Zin, incPC, MARin, MDRin, Yin, IRin, PCin;
    reg Rout, HIout, LOout, ZLowOut, ZHighOut, MDRout, Cout, InPortOut, PCout;
    reg [4:0] opcode;
    reg [31:0] in_data;

    // Clock generator
    always #5 clock = ~clock;

    // Branch instruction constants
    parameter BRZR = 32'h9880001B;
    parameter BRNZ = 32'h9888001B;
    parameter BRPL = 32'h9890001B;
    parameter BRMI = 32'h9898001B;

    parameter TEST_BRZR = 2'b00, TEST_BRNZ = 2'b01, TEST_BRPL = 2'b10, TEST_BRMI = 2'b11;
    reg [1:0] test_mode = TEST_BRZR;

    reg [4:0] state = 0;

    // Output monitoring
    wire [31:0] PC;
    assign PC = DUT.BusMuxIn_PC;

    // DUT
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

    // Instruction + register preload generator
    reg [31:0] branch_instruction;
    reg [31:0] preload_value;

    task load_instruction(input [31:0] instr);
        begin
            in_data <= instr; InPortIn <= 1;
            #15 InPortIn <= 0;
        end
    endtask

    task latch_instruction;
        begin
            #10 InPortOut <= 1; IRin <= 1;
            #15 InPortOut <= 0; IRin <= 0;
        end
    endtask

    task branch_sequence;
        begin
            // Evaluate condition
            #10 Gra = 1; Rout = 1;
            #15 Gra = 0; Rout = 0;

            #10 CONN_in = 1;
            #15 CONN_in = 0;

            // Calculate PC + 1 + C
            #10 PCout = 1; Yin = 1;
            #15 PCout = 0; Yin = 0;

            #10 Cout = 1; Zin = 1; opcode = 5'b00011; // add
            #15 Cout = 0; Zin = 0; opcode = 5'b11010; // nop

            // Load into PC (if CON_FF true)
            #10 ZLowOut = 1; PCin = 1;
            #15 ZLowOut = 0; PCin = 0;
        end
    endtask

    task run_test;
        begin
            clear = 1; #10 clear = 0;

            // Set instruction and preload R1 value
            case (test_mode)
                TEST_BRZR: begin branch_instruction = BRZR; preload_value = 32'h08800000; end
                TEST_BRNZ: begin branch_instruction = BRNZ; preload_value = 32'h08800004; end
                TEST_BRPL: begin branch_instruction = BRPL; preload_value = 32'h08800004; end
                TEST_BRMI: begin branch_instruction = BRMI; preload_value = 32'h088000FC; end
            endcase

            // 1. Load R1 using ldi
            load_instruction(preload_value);
            latch_instruction();
            #10 Gra = 1; Rin = 1;
            #15 Gra = 0; Rin = 0;

            // 2. Load branch instruction
            load_instruction(branch_instruction);
            latch_instruction();

            // 3. Run branch FSM
            branch_sequence();

            // 4. Show result
            $display("==== TEST %s ====", test_mode == 2'b00 ? "BRZR" :
                                             test_mode == 2'b01 ? "BRNZ" :
                                             test_mode == 2'b10 ? "BRPL" : "BRMI");
            $display("R1 = %h, Final PC = %h", DUT.BusMuxIn_R1, PC);
            $display("");
        end
    endtask

    // Initial test sequence
    initial begin
        #20;

        run_test(); test_mode = TEST_BRNZ; #100;
        run_test(); test_mode = TEST_BRPL; #100;
        run_test(); test_mode = TEST_BRMI; #100;

        $stop;
    end
endmodule

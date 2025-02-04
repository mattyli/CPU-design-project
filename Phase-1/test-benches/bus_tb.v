/*
  test bench for the for the bus
*/

`timescale 1ns/1ps

module bus_tb;
  // -----------------------------
  //  Wires and Regs for the Test
  // -----------------------------
  reg  clk, clr;
  
  // "Out" signals that go to the bus’s 32-5 encoder:
  reg  R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out;
  reg  R8out, R9out, R10out, R11out, R12out, R13out, R14out, R15out;
  reg  HIout, LOout, ZHighOut, ZLowOut, PCout, MDRout, InPortOut, Cout;

  // Enables for writing into R0 and R1 (the “reg32” modules)
  reg  R0_enable, R1_enable;

  // We will only instantiate 2 registers here, R0 and R1. 
  // If you have more registers, that’s fine, but for the demo we’ll do two.
  wire [31:0] R0_Q;
  wire [31:0] R1_Q;

  // 24 bus inputs actually used (the rest are unconnected/unused in this demo)
  // We only connect R0_Q and R1_Q to BusMuxIn_R0 and BusMuxIn_R1, plus 
  // a constant input on C_sign_extended so we can load from that.
  wire [31:0] BusMuxOut;
  reg  [31:0] C_sign_extended;  // used as a “constant” input to the bus

  // ---------------------------------
  //  Instantiate the reg32 modules
  // ---------------------------------
  reg32 r0 (
    .clr(clr),
    .clk(clk),
    .enable(R0_enable),
    .D(BusMuxOut),    // data from the bus
    .Q(R0_Q)          // goes to BusMuxIn_R0
  );

  reg32 r1 (
    .clr(clr),
    .clk(clk),
    .enable(R1_enable),
    .D(BusMuxOut),    // data from the bus
    .Q(R1_Q)          // goes to BusMuxIn_R1
  );

  // ---------------------------------
  //  Instantiate the bus module
  // ---------------------------------
  bus myBus (
    // “out” signals (which cause one input to drive the bus):
    .R0out   (R0out),
    .R1out   (R1out),
    .R2out   (R2out),
    .R3out   (R3out),
    .R4out   (R4out),
    .R5out   (R5out),
    .R6out   (R6out),
    .R7out   (R7out),
    .R8out   (R8out),
    .R9out   (R9out),
    .R10out  (R10out),
    .R11out  (R11out),
    .R12out  (R12out),
    .R13out  (R13out),
    .R14out  (R14out),
    .R15out  (R15out),
    .HIout   (HIout),
    .LOout   (LOout),
    .ZHighOut(ZHighOut),
    .ZLowOut (ZLowOut),
    .PCout   (PCout),
    .MDRout  (MDRout),
    .InPortOut(InPortOut),
    .Cout    (Cout),

    // “in” data lines to the mux
    .BusMuxIn_R0   (R0_Q),
    .BusMuxIn_R1   (R1_Q),
    // The rest are not used in this demo
    .BusMuxIn_R2   (32'b0),
    .BusMuxIn_R3   (32'b0),
    .BusMuxIn_R4   (32'b0),
    .BusMuxIn_R5   (32'b0),
    .BusMuxIn_R6   (32'b0),
    .BusMuxIn_R7   (32'b0),
    .BusMuxIn_R8   (32'b0),
    .BusMuxIn_R9   (32'b0),
    .BusMuxIn_R10  (32'b0),
    .BusMuxIn_R11  (32'b0),
    .BusMuxIn_R12  (32'b0),
    .BusMuxIn_R13  (32'b0),
    .BusMuxIn_R14  (32'b0),
    .BusMuxIn_R15  (32'b0),
    .BusMuxIn_HI   (32'b0),
    .BusMuxIn_LO   (32'b0),
    .BusMuxIn_Zhigh(32'b0),
    .BusMuxIn_Zlow (32'b0),
    .BusMuxIn_PC   (32'b0),
    .BusMuxIn_MDR  (32'b0),
    .BusMuxIn_InPort(32'b0),
    // We’ll drive this with a reg in the test bench
    .C_sign_extended(C_sign_extended),
    // Output of the bus mux
    .BusMuxOut(BusMuxOut)
  );

  // ------------------------
  //  Generate a clock
  // ------------------------
  initial clk = 0;
  always #5 clk = ~clk;  // 10 ns period => 100 MHz

  // -----------
  //  Test Steps
  // -----------
  initial begin
    // Initialize control signals
    clr         = 1;  // reset/clear
    R0_enable   = 0;
    R1_enable   = 0;
    R0out       = 0;
    R1out       = 0;
    R2out       = 0;  // not used
    R3out       = 0;
    R4out       = 0;
    R5out       = 0;
    R6out       = 0;
    R7out       = 0;
    R8out       = 0;
    R9out       = 0;
    R10out      = 0;
    R11out      = 0;
    R12out      = 0;
    R13out      = 0;
    R14out      = 0;
    R15out      = 0;
    HIout       = 0;
    LOout       = 0;
    ZHighOut    = 0;
    ZLowOut     = 0;
    PCout       = 0;
    MDRout      = 0;
    InPortOut   = 0;
    Cout        = 0;
    C_sign_extended = 32'h0000_0000;

    // Let reset propagate for a couple of clock edges
    @(posedge clk);
    @(posedge clk);
    clr = 0;  // de-assert reset

    $display("=== Start transferring a value from C_sign_extended -> R0 -> R1 ===");

    // STEP 1: Put a known value on C_sign_extended and drive the bus from 'Cout'
    C_sign_extended = 32'hAABB_CCDD;
    Cout           = 1;       // select the constant input for the bus
    R0_enable      = 1;       // enable writing into R0
    @(posedge clk);           // wait one rising edge

    // Now R0 should contain 0xAABB_CCDD
    R0_enable      = 0;       // turn off write to R0
    Cout           = 0;       // stop driving the bus from the constant

    @(posedge clk);
    // STEP 2: Transfer from R0 to R1 via the bus
    // R0 should drive the bus, so set R0out=1
    R0out          = 1;
    R1_enable      = 1;
    @(posedge clk);

    // Now R1 should contain the same 0xAABB_CCDD
    R1_enable      = 0;
    R0out          = 0;

    // need this clock edge to allow the movment over the bus
    @(posedge clk);

    // Display final contents
    $display("R0 = 0x%08h", R0_Q);
    $display("R1 = 0x%08h", R1_Q);

    // Check correctness
    if (R1_Q === 32'hAABB_CCDD)
      $display("SUCCESS: R1 got the correct value from R0!");
    else
      $display("ERROR: R1 expected 0xAABB_CCDD but got 0x%08h", R1_Q);

    // Done
    $finish;
  end

endmodule

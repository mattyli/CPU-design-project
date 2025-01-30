// defining a 32 bit register
// refer to Phase 1 doc page 3, figure 2

module reg32 #(parameter q0 = 0) (
    clr,            // clear signal
    clk,            // clock signal
    enable,         // write/enable signal
    D,              // input D (from BusMuxOut)
    Q);               // output Q (into BusMuxIn)

    input wire clr, clk, enable;
    input wire [31:0]D;             // wire (connects to Bus)
    output reg [31:0]Q;             // register (actually stores something)

    always @(posedge clk) begin
      if (clr) Q <= 0;              // if clear, set the output to 0
      else if (enable) Q <= D;      // if enable, set the output to whatever came from the bus (D)
    end
endmodule

// https://stackoverflow.com/questions/33459048/what-is-the-difference-between-reg-and-wire-in-a-verilog-module

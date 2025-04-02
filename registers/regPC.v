module regPC #(parameter q0 = 0) (
    clear,            // clear signal
    clock,            // clock signal
    enable,         // write/enable signal
    D,              // input D (from BusMuxOut)
    Q);               // output Q (into BusMuxIn)

    input wire clear, clock, enable;
    input wire [31:0]D;             // wire (connects to Bus)
    output reg [31:0]Q;             // register (actually stores something)
    initial Q = q0;                 // set the intial value of the register to 0
    always @(posedge clock) begin
      if (clear) Q <= 0;              // if clear, set the output to 0
      else if (enable) Q <= D;      // if enable, set the output to whatever came from the bus (D)
    end
endmodule

// https://stackoverflow.com/questions/33459048/what-is-the-difference-between-reg-and-wire-in-a-verilog-module

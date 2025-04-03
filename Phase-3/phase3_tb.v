// Running the simulation outlined in CPU_Phase3

`timescale 1ns/1ps

module phase3_tb;
    //Inputs
    reg clock; 
    reg [31:0] InPortData;
    //Outputs
    reg reset, stop; 
    //wire clear;
    wire run;

    phase_3_datapath DUT (
    .run(run),
    .clk(clock),
    .reset(reset),
    .stop(stop),
    //.clr(clear),
    .InPortData(InPortData)
);

    initial begin
	    #2 clock = 0; reset = 1; stop = 0; InPortData = 0;
        #2 reset = 0;
        #2 stop = 0;
		  
	end
    always
        #2 clock = ~clock;
endmodule
// Running the simulation outlined in CPU_Phase3

`timescale 1ns/1ps

module phase3_tb.v;
    //Inputs
    reg clock; 
    reg [31:0] InPortData;
    //Outputs
    reg reset, stop; 
    //wire clear;
    wire run;

    datapath DUT (
    .run(run),
    .clk(clock),
    .reset(reset),
    .stop(stop),
    //.clr(clear),
    .InPortData(InPortData)
);

    initial begin
	    #5 clock = 0; reset = 1; stop = 0; InPortData = 0;
        #5 reset = 0;
        #5 stop = 0;
		  
	end
    always
        #5 clock = ~clock;
endmodule
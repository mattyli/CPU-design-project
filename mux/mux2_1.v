module mux2_1 (
    in_0,
    in_1,
    select,
    mux_out  
);

    input wire [31:0] din_0, in_1; 
    input wire select;
    output reg [31:0] mux_out;

    always@(*)  begin
        if(select) mux_out <= in_0;
        else mux_out <= in_1;

    end 
    
endmodule

module mux2_1 (
    BusMuxOut,
    Mdatain,
    select,
    mux_out  
);

    input wire [31:0] BusMuxOut, Mdatain; 
    input wire select;
    output reg [31:0] mux_out;

    always@(*)  begin
        if(select) mux_out <= Mdatain;
        else mux_out <= BusMuxOut;

    end 
    
endmodule

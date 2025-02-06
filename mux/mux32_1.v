
module mux32_1(in_0, in_1, in_2, in_3, in_4, in_5, in_6, in_7, in_8, in_9, in_10, in_11, in_12, in_13, in_14, in_15, 
                in_16, in_17, in_18, in_19, in_20, in_21, in_22, in_23, in_24, in_25, in_26, in_27, in_28, in_29, in_30, in_31,
                select,
                mux_out
    );

    input wire[31:0] in_0, in_1, in_2, in_3, in_4, in_5, in_6, in_7, in_8, in_9, in_10, in_11, in_12, in_13, in_14, in_15, in_16, in_17, in_18, in_19, in_20, in_21, in_22, in_23, in_24, in_25, in_26, in_27, in_28, in_29, in_30, in_31;               // each wire is 32 bits
    input wire[4:0] select;         // select signal from the 32-5 encoder (hence 5 bits for the wire = 32 possible combos)
    output reg[31:0] mux_out;       // reg necessary because of verilog conventions

    // select the correct input and set it to the output based on the select signal
    always@(*) begin
        if (select == 5'd0) mux_out <= in_0;            // in_0
        else if (select == 5'd1) mux_out <= in_1;
        else if (select == 5'd2) mux_out <= in_2;
        else if (select == 5'd3) mux_out <= in_3;
        else if (select == 5'd4) mux_out <= in_4;
        else if (select == 5'd5) mux_out <= in_5;
        else if (select == 5'd6) mux_out <= in_6;
        else if (select == 5'd7) mux_out <= in_7;
        else if (select == 5'd8) mux_out <= in_8;
        else if (select == 5'd9) mux_out <= in_9;
        else if (select == 5'd10) mux_out <= in_10;
        else if (select == 5'd11) mux_out <= in_11;
        else if (select == 5'd12) mux_out <= in_12;
        else if (select == 5'd13) mux_out <= in_13;
        else if (select == 5'd14) mux_out <= in_14;
        else if (select == 5'd15) mux_out <= in_15;
        else if (select == 5'd16) mux_out <= in_16;
        else if (select == 5'd17) mux_out <= in_17;
        else if (select == 5'd18) mux_out <= in_18;
        else if (select == 5'd19) mux_out <= in_19;
        else if (select == 5'd20) mux_out <= in_20;
        else if (select == 5'd21) mux_out <= in_21;
        else if (select == 5'd22) mux_out <= in_22;
        else if (select == 5'd23) mux_out <= in_23;
        else if (select == 5'd24) mux_out <= in_24;
        else if (select == 5'd25) mux_out <= in_25;
        else if (select == 5'd26) mux_out <= in_26;
        else if (select == 5'd27) mux_out <= in_27;
        else if (select == 5'd28) mux_out <= in_28;
        else if (select == 5'd29) mux_out <= in_29;
        else if (select == 5'd30) mux_out <= in_30;
        else if (select == 5'd31) mux_out <= in_31;     // in_31 
        else mux_out = 0; // Default case
        
    end

endmodule
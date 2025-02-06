
module mux32_1(in_0, in_1, in_2, in_3, in_4, in_5, in_6, in_7, in_8, in_9, in_10, in_11, in_12, in_13, in_14, in_15, 
                in_16, in_17, in_18, in_19, in_20, in_21, in_22, in_23, in_24, in_25, in_26, in_27, in_28, in_29, in_30, in_31,
                select,
                mux_out
    );

    input wire[31:0];               // each wire is 32 bits
    input wire[4:0] select;         // select signal from the 32-5 encoder (hence 5 bits for the wire = 32 possible combos)
    output reg[31:0] mux_out;       // reg necessary because of verilog conventions

    // select the correct input and set it to the output based on the select signal
    always@(*) begin
        if (select == 5d'0) mux_out <= in_0;
        else if (select == 5d'1) mux_out <= in_1;
        else if (select == 5d'2) mux_out <= in_2;
        else if (select == 5d'3) mux_out <= in_3;
        else if (select == 5d'4) mux_out <= in_4;
        else if (select == 5d'5) mux_out <= in_5;
        else if (select == 5d'6) mux_out <= in_6;
        else if (select == 5d'7) mux_out <= in_7;
        else if (select == 5d'8) mux_out <= in_8;
        else if (select == 5d'9) mux_out <= in_9;
        else if (select == 5d'10) mux_out <= in_10;
        else if (select == 5d'11) mux_out <= in_11;
        else if (select == 5d'12) mux_out <= in_12;
        else if (select == 5d'13) mux_out <= in_13;
        else if (select == 5d'14) mux_out <= in_14;
        else if (select == 5d'15) mux_out <= in_15;
        else if (select == 5d'16) mux_out <= in_16;
        else if (select == 5d'17) mux_out <= in_17;
        else if (select == 5d'18) mux_out <= in_18;
        else if (select == 5d'19) mux_out <= in_19;
        else if (select == 5d'20) mux_out <= in_20;
        else if (select == 5d'21) mux_out <= in_21;
        else if (select == 5d'22) mux_out <= in_22;
        else if (select == 5d'23) mux_out <= in_23;
        else if (select == 5d'24) mux_out <= in_24;
        else if (select == 5d'25) mux_out <= in_25;
        else if (select == 5d'26) mux_out <= in_26;
        else if (select == 5d'27) mux_out <= in_27;
        else if (select == 5d'28) mux_out <= in_28;
        else if (select == 5d'29) mux_out <= in_29;
        else if (select == 5d'30) mux_out <= in_30;
        else if (select == 5d'31) mux_out <= in_31;
        else mux_out = 0; // Default case
        
    end

endmodule
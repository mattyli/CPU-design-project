module ram (
        input wire clk,
        input wire [7:0] addr,
        inout wire [31:0] data,
        input wire write,
        input wire read
);
    reg [31:0] = mem [511:0]
    reg [31:0] = tmp_data

    always @(posedge clk) begin
        if (write & !read)
            mem[addr] <= data;
    end

    always @(posedge clk) begin
        if (read & !write)
            tmp_data <= mem[addr];
    end

    assign data = read & !write ? tmp_data : 32'bZZZZZZZZ

endmodule
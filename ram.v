module ram (
        input wire clk,
        input wire [8:0] addr,          // modified because this is supposed to be 9 bits
        input wire [31:0] data_in,
        input wire write,
        input wire read,
        output wire [31:0] data_out
);
    reg [31:0] mem [511:0];

    initial $readmemh("ram.hex", mem);

    assign data_out = (write || !read) ? 32'bz : mem[addr]; 

    always @(posedge clk) begin
        if (write)
            mem[addr] = data_in;
            $writememh("ram.hex", mem);
    end
endmodule
module regfile #(
    parameter WIDTH = 32,
    parameter CAPACITY = 64)(
    input wire clk, rst,
    input wire [WIDTH-1:0] data_wr,
    input wire [7:0] addr_wr, addr_rda, addr_rdb, addr_rdc, addr_rdd,
    output wire [WIDTH-1:0] data_rd, data_a, data_b, data_c, data_d
);
    reg [WIDTH-1:0] mem [CAPACITY-1:0];

    always @(posedge clk, negedge rst) begin
        if (!rst) begin
            // mem[WIDTH-1:0] = 0;
        end else begin
            mem[addr_wr] = data_wr;
        end
    end

    assign data_rd = mem[addr_wr];
    assign data_a = mem[addr_rda];
    assign data_b = mem[addr_rdb];
    assign data_c = mem[addr_rdc];
    assign data_d = mem[addr_rdd];
endmodule

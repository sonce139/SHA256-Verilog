module register #(
    parameter  WIDTH = 32)(
    input wire  [WIDTH-1:0] in,
    input wire clk, rst,
    output wire [WIDTH-1:0] out
);
    d_ff ff [WIDTH-1:0] (   .d(in),
                            .clk(clk),
                            .clr(rst),
                            .q(out),
                            .qBar()
    );
endmodule

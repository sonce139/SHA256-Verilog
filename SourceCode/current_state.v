module current_state (
    input wire [3:0] in,
    input wire clk, rst,
    output wire [3:0] out
);
    d_ff ff [3:0] ( .d(in),
                    .clk(clk),
                    .clr(rst),
                    .q(out)
    );
endmodule

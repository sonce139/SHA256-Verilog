module ch (
    input wire [31:0] e, f, g,
    output wire [31:0] out
);
    assign out = (e & f) ^ (~e & g);
endmodule

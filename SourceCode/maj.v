module maj (
    input wire [31:0] a, b, c,
    output wire [31:0] out
);
    assign out = (a & b) ^ (a & c) ^ (b & c);
endmodule

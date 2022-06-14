module rotr #(
    parameter bit)(
    input wire [31:0] in,
    output wire [31:0] out
);
    assign out = { in[bit-1:0], in[31:bit] };
endmodule

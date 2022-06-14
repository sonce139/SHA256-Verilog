module shr #(
    parameter bit)(
    input wire [31:0] in,
    output wire [31:0] out
);
    assign out = { {bit{1'b0}}, in[31:bit] };
endmodule

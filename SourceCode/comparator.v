module comparator (
    input wire [7:0] a, b,
    output wire g, e, l
);
    assign g = a > b ? 1'b1 : 1'b0;
    assign e = a == b ? 1'b1 : 1'b0;
    assign l = a < b ? 1'b1 : 1'b0;
endmodule


module usigma0 (
    input wire [31:0] in,
    output wire [31:0] out
);
    wire [31:0] rsl [2:0];

    rotr #(2) inst_0 (in, rsl[0]);
    rotr #(13) inst_1 (in, rsl[1]);
    rotr #(22) inst_2 (in, rsl[2]);

    assign out = rsl[0] ^ rsl[1] ^ rsl[2];  
endmodule

module usigma1 (
    input wire [31:0] in,
    output wire [31:0] out
);
    wire [31:0] rsl [2:0];

    rotr #(6) inst_0 (in, rsl[0]);
    rotr #(11) inst_1 (in, rsl[1]);
    rotr #(25) inst_2 (in, rsl[2]);

    assign out = rsl[0] ^ rsl[1] ^ rsl[2];  
endmodule

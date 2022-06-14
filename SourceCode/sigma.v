module sigma0 (
    input wire [31:0] in,
    output wire [31:0] out
);
    wire [31:0] rsl [2:0];

    rotr #(7) inst_0 (in, rsl[0]);
    rotr #(18) inst_1 (in, rsl[1]);
    shr #(3) inst_2 (in, rsl[2]);

    assign out = rsl[0] ^ rsl[1] ^ rsl[2];  
endmodule

module sigma1 (
    input wire [31:0] in,
    output wire [31:0] out
);
    wire [31:0] rsl [2:0];

    rotr #(17) inst_0 (in, rsl[0]);
    rotr #(19) inst_1 (in, rsl[1]);
    shr #(10) inst_2 (in, rsl[2]);

    assign out = rsl[0] ^ rsl[1] ^ rsl[2];  
endmodule

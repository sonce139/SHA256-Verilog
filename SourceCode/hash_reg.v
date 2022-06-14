module hash_reg (
    input wire [255:0] in,
    input wire clk,
    output wire [255:0] out
);
    reg[255:0] hash_val;
    
    always @(posedge clk) begin
        hash_val = {hash_val[255:224] + in[255:224],
                    hash_val[223:192] + in[223:192],
                    hash_val[191:160] + in[191:160],
                    hash_val[159:128] + in[159:128],
                    hash_val[127:96] + in[127:96],
                    hash_val[95:64] + in[95:64],
                    hash_val[63:32] + in[63:32],
                    hash_val[31:0] + in[31:0] };
    end

    assign out = hash_val;
endmodule
module Output (
    input wire [3:0] in,
    output reg padding_en, core_rst, core_en, load_hash_val, initial_hash_val, load_blocks_num, len_hi_lo_sel, data_len_sel, done
);
    always@ (in) begin
        padding_en      = 1'b0;
        core_rst        = 1'b0;
        core_en         = 1'b0;
        load_hash_val   = 1'b0;
        initial_hash_val= 1'b0;
        load_blocks_num = 1'b0;
        len_hi_lo_sel   = 1'b0;
        data_len_sel    = 1'b0;
        done            = 1'b0;

        case (in)
            4'd0: begin
                padding_en = 1'b1;
            end
            4'd1: begin
                padding_en = 1'b1;
            end
            4'd2: begin
                core_rst = 1'b1;
                load_blocks_num = 1'b1;
            end
            4'd3: begin
                len_hi_lo_sel = 1'b0;
                data_len_sel = 1'b1;
            end
            4'd4: begin
                len_hi_lo_sel = 1'b1;
                data_len_sel = 1'b1;
            end
            4'd5: begin
                initial_hash_val = 1'b1;
                load_hash_val = 1'b1;
            end
            4'd6: begin
                // pre-synthesis

                // post-synthesis
                // core_en = 1'b1;
            end
            4'd7: begin
                core_en = 1'b1; 
            end
            4'd8: begin
                load_hash_val = 1'b1;
            end
            4'd9: begin
                done = 1'b1;
            end
            default: begin
            end
        endcase
    end
endmodule
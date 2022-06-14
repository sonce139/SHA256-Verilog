module SHA256 (
    input wire start, rst, clk, data_valid,
    input wire [7:0] in,
    output wire [255:0] result,
    output wire done
);
    wire padding_en, core_rst, core_en, load_hash_val, initial_hash_val, load_blocks_num, len_hi_lo_sel, data_len_sel, finish_loop, is_zero;

    control_unit inst0 (    .start(start),
                            .rst(rst),
                            .clk(clk),
                            .data_valid(data_valid),
                            .is_zero(is_zero),
                            .finish_loop(finish_loop),
                            .padding_en(padding_en),
                            .core_rst(core_rst),
                            .core_en(core_en),
                            .load_hash_val(load_hash_val),
                            .initial_hash_val(initial_hash_val),
                            .load_blocks_num(load_blocks_num),
                            .len_hi_lo_sel(len_hi_lo_sel),
                            .data_len_sel(data_len_sel),
                            .done(done)
    );
    datapath inst1 (    .message(in),
                        .data_valid(data_valid),
                        .clk(clk),
                        .rst(rst),
                        .padding_en(padding_en),
                        .core_rst(core_rst),
                        .core_en(core_en),
                        .load_hash_val(load_hash_val),
                        .initial_hash_val(initial_hash_val),
                        .load_blocks_num(load_blocks_num),
                        .len_hi_lo_sel(len_hi_lo_sel),
                        .data_len_sel(data_len_sel),
                        .finish_loop(finish_loop),
                        .is_zero(is_zero),
                        .result(result),
                        .done(done)
    );
endmodule

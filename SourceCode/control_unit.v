module control_unit(
    input wire start, rst, clk, data_valid, is_zero, finish_loop,
    output wire padding_en, core_rst, core_en, load_hash_val, initial_hash_val, load_blocks_num, len_hi_lo_sel, data_len_sel, done
);
    wire [3:0] q, qNext;

    next_state inst0 (  .in(q),
                        .start(start),
                        .data_valid(data_valid),
                        .is_zero(is_zero),
                        .finish_loop(finish_loop),
                        .out(qNext)
    );
    current_state inst1 (   .in(qNext),
                            .clk(clk),
                            .rst(rst),
                            .out(q)
    );
    Output inst2 (  .in(q),
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
endmodule

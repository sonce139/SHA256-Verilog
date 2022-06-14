module datapath (
    input wire clk,
    input wire [7:0] message,
    input wire padding_en, rst, core_rst, core_en, load_hash_val, initial_hash_val, load_blocks_num, len_hi_lo_sel, data_len_sel, data_valid, done,
    output wire finish_loop, is_zero,
    output wire [255:0] result
);
    wire[31:0] padded_message;
    wire [7:0] b, e;
    wire [4:0] addr_rd;
    wire [1:0] blocks_num, block_index;

    padding inst0 ( .data_valid(data_valid),
                    .data_len_sel(data_len_sel),
                    .clk(clk),
                    .rst(rst),
                    .en(padding_en),
                    .select(len_hi_lo_sel),
                    .addr_rd(addr_rd),
                    .data(message),
                    .blocks_num(blocks_num),
                    .padded_message(padded_message)
    );

    core inst1 (    .rst(core_rst),
                    .en(core_en),
                    .clk(clk),
                    .load_hash_val(load_hash_val),
                    .initial_hash_val(initial_hash_val),
                    .done(done),
                    .padded_message(padded_message),
                    .finish_loop(finish_loop),
                    .addr(addr_rd),
                    .hash_val(result)
    );

    counter #(2) inst2 (    .clk(clk),
                            .in(blocks_num + 2'b1),
                            .D(1'b1),
                            .en(finish_loop),
                            .load(load_blocks_num),
                            .rst(rst),
                            .out(block_index)
    );

    assign is_zero = ~(block_index[1] | block_index[0]);
endmodule
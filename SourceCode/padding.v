module padding (
	input wire en, data_valid, data_len_sel, clk, rst, select,
	input wire [4:0] addr_rd,
	input wire [7:0] data,
	output wire [1:0] blocks_num,
	output wire[31:0] padded_message
);
	wire [7:0] a, b, d, e, count_out;
	wire [15:0] count_a;

	// pre-synthesis
	counter count (	.clk(clk),
					.en(en),
					.rst(1'b0),
					.out(count_out),
					.D(1'b0),
					.load(rst),
					.in(8'hff)
	);
	// post-synthesis
	// counter count (	.clk(clk),
	// 				.en(data_valid),
	// 				.rst(rst),
	// 				.out(count_out),
	// 				.D(1'b0),
	// 				.load(1'b0),
	// 				.in(8'hff)
	// );

	comparator comp(.a(count_out),
					.b(8'd55),
					.g(blocks_num[0])
	);

	assign count_a = { 5'b0, count_out, 3'b0 };
	assign a = data_valid ? data : 8'b10000000; 
	assign b = data_len_sel == 0 ? a : (select == 0 ? count_a[15:8] : count_a[7:0]);
	assign d = blocks_num[0] ? (select == 0 ? 8'd126 : 8'd127) : (select == 0 ? 8'd62 : 8'd63);
	assign e = data_len_sel == 0 ? count_out : d;

	Regfile_8to32b RF(	.addr_rd(addr_rd), 
						.clk(clk),
						.addr_wr(e),
						.rst(rst),
						.data(b),
						.data_rd(padded_message)
	);

	assign blocks_num[1] = 1'b0;
endmodule

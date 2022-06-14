module core (
	input wire en, clk, rst, load_hash_val, initial_hash_val, done,
	input wire [31:0] padded_message,
	output wire [255:0] hash_val,
	output wire finish_loop,
	output wire [4:0] addr
);
	reg [255:0] result;
	wire [255:0] digest_in, digest_out, H0;
	wire [31:0] Wi, Ki;
	wire [7:0] index;
	wire over_15;

	assign H0 = { 32'h6a09e667, 32'hbb67ae85, 32'h3c6ef372, 32'ha54ff53a, 32'h510e527f, 32'h9b05688c, 32'h1f83d9ab, 32'h5be0cd19 };

	counter inst0 (	.in(8'b10000000),
					.D(1'b0), 
					.en(en),
					.load(1'b0), 
					.rst(rst),
					.clk(clk), 
					.out(index)
	);
	assign addr = index[6] ? index[4:0] + 5'd16 : index[4:0];

	comparator inst1 (	.a(8'd63),
						.b({ 2'b0, index[5:0] }),
						.e(finish_loop)
	);
	comparator inst2 (	.a(8'd15),
						.b({ 2'b0, index[5:0] }),
						.l(over_15)
	);

	K inst3 (	.in(index[5:0]),
				.out(Ki)
	);
	message_scheduler inst4 (	.over_15(over_15),
								.clk(clk & en),
								.padded_message(padded_message),
								.W(Wi)
	);

	assign digest_in = initial_hash_val ? H0 : result;
	hash_computation inst5 (	.clk(clk),
							.select_value(load_hash_val),
							.Wi(Wi),
							.Ki(Ki),
							.digest_in(digest_in),
							.digest_out(digest_out)
	);

	always @(posedge load_hash_val) begin
		result = initial_hash_val ? H0 : {	result[255:224] + digest_out[255:224],
											result[223:192] + digest_out[223:192],
											result[191:160] + digest_out[191:160],
											result[159:128] + digest_out[159:128],
											result[127:96] + digest_out[127:96],
											result[95:64] + digest_out[95:64],
											result[63:32] + digest_out[63:32],
											result[31:0] + digest_out[31:0]};
	end
	assign hash_val = result;
endmodule

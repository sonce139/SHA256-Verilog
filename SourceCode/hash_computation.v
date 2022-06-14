
module hash_computation (
	input wire clk, select_value,
	input wire [31:0] Wi, Ki, 
	input wire [255:0] digest_in,
	output wire [255:0]	digest_out
);	
	reg [31:0] a, b, c, d, e, f, g, h;
	wire [31:0]	maj_rsl, ch_rsl, usig0, usig1, w0, w1, w2, w3, w4, w5, ai, bi, ci, di, ei, fi, gi, hi;

	// pipeline register
	// reg [31:0] stage1_reg [4:0];
	// reg [31:0] stage2_reg [2:0];
	// reg [31:0] stage3_reg [1:0];

	// reg [31:0] stage1_b, stage1_c, stage1_d, stage1_f, stage1_g, stage1_h;
	// reg [31:0] stage2_b, stage2_c, stage2_d, stage2_f, stage2_g, stage2_h;
	// reg [31:0] stage3_b, stage3_c, stage3_d, stage3_f, stage3_g, stage3_h;

	usigma0 inst0 (	.in(a),
					.out(usig0)
	);
	usigma1 inst1 (	.in(e),
					.out(usig1)
	);
	maj inst2 (	.a(a),
				.b(b),
				.c(c),
				.out(maj_rsl)
	);
	ch inst3 (	.e(e),
				.f(f),
				.g(g),
				.out(ch_rsl)
	);

	assign w0 = Ki + usig1;
	assign w1 = Wi + ch_rsl;
	assign w2 = h + usig0;
	assign w3 = h + d;

	assign w4 = w0 + w1;
	assign w5 = w2 + maj_rsl;

	assign ai = w4 + w5;
	assign bi = a;
	assign ci = b;
	assign di = c;
	assign ei = w4 + w3;
	assign fi = e;
	assign gi = f;
	assign hi = g;

	always@ (posedge clk) begin
		a <= select_value ? digest_in[255:224] 	: ai;
		b <= select_value ? digest_in[223:192] 	: bi;
		c <= select_value ? digest_in[191:160] 	: ci;
		d <= select_value ? digest_in[159:128] 	: di;
		e <= select_value ? digest_in[127:96] 	: ei;
		f <= select_value ? digest_in[95:64] 	: fi;
		g <= select_value ? digest_in[63:32] 	: gi;
		h <= select_value ? digest_in[31:0] 	: hi;

		// pipeline
		// a <= select_value ? digest_in[255:224] 	: stage3_reg[0];
		// b <= select_value ? digest_in[223:192] 	: stage3_b;
		// c <= select_value ? digest_in[191:160] 	: stage3_c;
		// d <= select_value ? digest_in[159:128] 	: stage3_d;
		// e <= select_value ? digest_in[127:96] 	: stage3_reg[1];
		// f <= select_value ? digest_in[95:64] 	: stage3_f;
		// g <= select_value ? digest_in[63:32] 	: stage3_g;
		// h <= select_value ? digest_in[31:0] 	: stage3_h;

		// // stage 1
		// stage1_reg[0] <= Ki + usig1;
		// stage1_reg[1] <= Wi + ch_rsl;
		// stage1_reg[2] <= maj_rsl;
		// stage1_reg[3] <= h + usig0;
		// stage1_reg[4] <= h + d;
		// stage1_b <= a;
		// stage1_c <= b;
		// stage1_d <= c;
		// stage1_f <= e;
		// stage1_g <= f;
		// stage1_h <= g;

		// // stage 2
		// stage2_reg[0] <= stage1_reg[0] + stage1_reg[1];
		// stage2_reg[1] <= stage1_reg[2] + stage1_reg[3];
		// stage2_reg[2] <= stage1_reg[4];
		// stage2_b <= stage1_b;
		// stage2_c <= stage1_c;
		// stage2_d <= stage1_d;
		// stage2_f <= stage1_f;
		// stage2_g <= stage1_g;
		// stage2_h <= stage1_h;

		// // stage 3
		// stage3_reg[0] <= stage2_reg[0] + stage2_reg[1];
		// stage3_reg[1] <= stage2_reg[0] + stage2_reg[2];
		// stage3_b <= stage2_b;
		// stage3_c <= stage2_c;
		// stage3_d <= stage2_d;
		// stage3_f <= stage2_f;
		// stage3_g <= stage2_g;
		// stage3_h <= stage2_h;
	end
	
	assign digest_out = {a, b, c, d, e, f, g, h};
endmodule

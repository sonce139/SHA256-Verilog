module counter #(
	parameter n = 8) (
	input wire [n-1:0] in,
	input wire D, en, load, rst, clk,
	output wire [n-1:0] out,
	output wire cout
);

	wire [n-1:0] Dout, Din;
	wire [n-2:0] Cout;
	
	HAS has0 (	.D(D),
				.Q(out[0]),
				.Cin(en),
				.Dout(Dout[0]),
				.Cout(Cout[0])
	);
	HAS has_n_1 (  	.D(D),
					.Q(out[n-1]),
					.Cin(Cout[n-2]),
					.Dout(Dout[n-1]),
					.Cout(cout)
	);
	
	generate
		genvar i;
		for (i=1; i<n-1; i=i+1) begin: HAS
			HAS has_i (	 	.Dout(Dout[i]),
							.Cout(Cout[i]),
							.D(D),
							.Q(out[i]),
							.Cin(Cout[i-1])
			);
		end 
		
		for (i=0; i<n; i=i+1) begin: MUX
			Mux2_1Bit mux_i (  .Y(Din[i]),
									   	   .D0(Dout[i]),
									       .D1(in[i]),
									       .S(load)
			);
		end
		
		for (i=0; i<n; i=i+1) begin: DFF
			d_ff dff_i (	 .d(Din[i]),
								    .clk(clk),
								    .q(out[i]),
								    .clr(rst)
			);
		end
	endgenerate
endmodule

module HAS (
	input wire D, Q, Cin,
	output wire Dout, Cout
);
	
	wire QBar, DBar, w1, w2;
	
	not n0 (QBar, Q);
	not n1 (DBar, D);
	
	and a0 (w1, D, Cin, QBar);
	and a1 (w2, Q, Cin, DBar);
	
	xor x0 (Dout, Q, Cin);
	or o0 (Cout, w1, w2);
endmodule

module Mux2_1Bit(
	input wire D0, D1, S,
	output wire Y
);

	wire Sbar, w0, w1;
	
	not n0 (Sbar, S);
	and a0 (w0, Sbar, D0);
	and a1 (w1, S, D1);
	
	or (Y, w0, w1);
endmodule

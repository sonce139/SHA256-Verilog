module d_ff (
	input wire d, clk, clr,
	output wire q, qBar
);
	wire clrBar, Sbar, Rbar, S, R;
	
	not n0 (clrBar, clr);
	
	nand na0 (Sbar, Rbar, S);
	nand na1 (S, Sbar, clrBar, clk);
	nand na2 (R, Rbar, clk, S);
	nand na3 (Rbar, R, clrBar, d);
	
	nand na4 (q, S, qBar);
	nand na5 (qBar, q, R, clrBar);
endmodule
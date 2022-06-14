
module mux2 #(parameter n = 32) (Out, InA, InB, Select);
	input 	[n-1:0]	InA, InB;
	input					Select;
	output 	[n-1:0]	Out;
	
	assign Out = Select ? InB : InA;
	
endmodule

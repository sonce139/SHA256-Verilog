module message_scheduler(
  input wire over_15, clk,
  input wire [31:0] padded_message,
  output wire [31:0] W
);
  wire [31:0] sig0, sig1;
  reg [31:0] Reg [15:0];

  // pipeline register
  // wire [31:0] stage1_reg [1:0];
  // wire [31:0] stage2_reg;
  // wire [31:0] stage3_reg;

  sigma0 inst0 (  .in(Reg[1]),
                  .out(sig0)
  );
  sigma1 inst1 (  .in(Reg[14]),
                  .out(sig1)
  );  

  assign W = over_15 ? sig1 + Reg[9] + sig0 + Reg[0] : padded_message;

  always @(posedge clk) begin 
    Reg[15] <= W;

    Reg[14] <= Reg[15];
    Reg[13] <= Reg[14];
    Reg[12] <= Reg[13];
    Reg[11] <= Reg[12];
    Reg[10] <= Reg[11];
    Reg[9] <= Reg[10];
    Reg[8] <= Reg[9];
    Reg[7] <= Reg[8];
    Reg[6] <= Reg[7];
    Reg[5] <= Reg[6];
    Reg[4] <= Reg[5];
    Reg[3] <= Reg[4];
    Reg[2] <= Reg[3];
    Reg[1] <= Reg[2];
    Reg[0] <= Reg[1];
  end

  // pipeline
  // // stage 1
  // assign stage1_reg[0] = sig1 + Reg9;
  // assign stage1_reg[1] = sig0 + Reg0;

  // // stage 2
  // assign stage2_reg = stage1_reg[0] + stage1_reg[1];

  // // stage 3
  // assign stage3_reg = stage2_reg;

endmodule

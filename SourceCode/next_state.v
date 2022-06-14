module next_state(
    input wire [3:0] in,
    input wire start, data_valid, is_zero, finish_loop,
    output wire [3:0] out
);
    assign out =    in == 4'd0 ? (start ? 4'd1 : 4'd0) :
                    in == 4'd1 ? (data_valid ? 4'd1 : 4'd2) :
                    in == 4'd2 ? 4'd3 :
                    in == 4'd3 ? 4'd4 :
                    in == 4'd4 ? 4'd5 :
                    in == 4'd5 ? 4'd6 :
                    in == 4'd6 ? 4'd7 :
                    in == 4'd7 ? (finish_loop ? 4'd8 : 4'd7) :
                    in == 4'd8 ? (is_zero ? 4'd9 : 4'd6) :
                    in == 4'd9 ? 4'd0 : 4'd0;
endmodule

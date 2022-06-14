`timescale 1ps/1ps

module Testbench ();
    localparam period = 2;

    integer messagesFile, resultsFile, i;
    reg [1024:0] message;
    reg [7:0] ch;

    reg clk, data_valid, start, rst;
    wire [255:0] result;
    wire done;

    initial begin
        clk = 0;
        start = 1;
        rst = 1;
        data_valid = 0;

        messagesFile = $fopen("messages.txt", "r");
        if (messagesFile == 0) begin
            $finish;
        end

        resultsFile = $fopen("hardware_results.txt", "wb");
        if (resultsFile == 0) begin
            $finish;
        end

        #period;
        rst = 0;
        data_valid = 1;

        fork
            begin
                #period;
                start = 0;
            end
            
            begin
                $fscanf(messagesFile, "%s", message);
                for (i = 127; i >= 0; i = i - 1) begin
                    if (message[(8 * i) + : 8] != 8'b0) begin
                        ch = message[(8 * i) + : 8];
                        #period;
                    end
                end    
                data_valid = 0;            
            end
        join
    end

    always@ (clk) begin
        #(period/2) clk <= ~clk;
    end

    always@ (posedge done) begin
        for (i = 63; i >= 0; i = i - 1) begin
            $fwrite(resultsFile, "%h", result[(4 * i) + : 4]);    
        end
        $fwrite(resultsFile, "\n");    

        if ($feof(messagesFile)) begin
            #period;
            $fclose(messagesFile);
            $fclose(resultsFile);
            $finish;
        end

        #(period);
        rst = 1;
        start = 1;

        #period;
        rst = 0;

        fork 
            begin
                #period;
                start = 0;
            end

            begin
                data_valid = 1;
                $fscanf(messagesFile, "%s", message);
                for (i = 127; i >= 0; i = i - 1) begin
                    if (message[(8 * i) + : 8] != 8'b0) begin
                        ch = message[(8 * i) + : 8];
                        #period;
                    end
                end
                data_valid = 0;    
            end
        join
    end

    SHA256 inst0 (  .start(start),
                    .clk(clk),
                    .rst(rst),
                    .data_valid(data_valid),
                    .in(ch),
                    .result(result),
                    .done(done)
    );
endmodule

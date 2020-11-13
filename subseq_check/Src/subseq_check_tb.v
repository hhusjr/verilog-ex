`timescale 1ns / 1ps

module subseq_check_tb;
    reg clk, rst, x;
    wire z;
    wire [2:0] state;
        
    always begin
        #10;
        clk = ~clk;
    end
    
    initial begin
        #20;
        x = 1;
        #20;
        x = 0;
        #20;
        x = 0;
        #20;
        x = 1;
        #20;
        x = 0;
        #20;
        x = 0;
        #20;
        x = 1;
        #20;
        x = 0;
        #20;
        x = 0;
        #20;
        x = 0;
        #20;
        x = 1;
        #20;
        x = 0;
        #20;
        x = 0;
        #20;
        x = 0;
        #20;
        x = 1;
        #20;
        x = 0;
        #20;
        x = 0;
        #20;
        x = 0;
        #20;
        x = 1;
        #20;
        x = 0;
        #20;
        x = 0;
        #20;
        x = 0;
        #20;
        x = 1;
        #20;
        x = 0;
        #20;
        x = 0;
        #20;
        x = 0;
        #20;
        x = 1;
        #20;
        x = 0;
        #20;
        x = 0;
        #20;
        x = 0;
        #20;
        x = 1;
        #20;
        x = 0;
        #20;
        x = 1;
        #20;
        x = 0;
        #20;
        x = 0;
        #20;
        x = 1;
        #20;
        x = 0;
    end
    
    initial begin
        clk = 0;
        rst = 1;
        #15;
        rst = 0;
    end
    
    subseq_check m(clk, x, y, rst, state);
endmodule

`timescale 1ns / 1ps

module blocking_tb;
    wire [3:0] b1, c1, b2, c2;
    reg [3:0] a;
    reg clk;
    
    initial begin
        clk = 0;
        forever #50 clk = ~clk;
    end
    
    initial begin
        a = 4'h3;
        #100 a = 4'h7;
        #100 a = 4'hf;
        #100 a = 4'ha;
        #100 a = 4'h2;
    end
    
    blocking m0(.clk(clk), .a(a), .b(b1), .c(c1));
    non_blocking m1(.clk(clk), .a(a), .b(b2), .c(c2));
endmodule

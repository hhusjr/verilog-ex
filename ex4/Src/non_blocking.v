`timescale 1ns / 1ps

module non_blocking(clk, a, b, c);
    output reg [3:0] b, c;
    input [3:0] a;
    input clk;
    always @(posedge clk) b <= a;
    always @(posedge clk) c <= b;
endmodule
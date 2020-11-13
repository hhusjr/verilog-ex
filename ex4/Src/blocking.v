`timescale 1ns / 1ps

module blocking(clk, a, b, c);
    output reg [3:0] b, c;
    input [3:0] a;
    input clk;
    always @(posedge clk) begin
        b = a;
        c = b;
    end
endmodule
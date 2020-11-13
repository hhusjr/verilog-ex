`timescale 1ns / 1ps

module divider(clkin, rst, clkout);
    input clkin, rst;
    output reg clkout;
    
    always @(posedge clkin) begin
        if (!rst) clkout <= 0;
        else clkout <= ~clkout;
    end
endmodule

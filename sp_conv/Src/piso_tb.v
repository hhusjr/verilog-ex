`timescale 1ns / 1ps

module piso_tb;
    reg sclk, rst, d_en;
    reg [3:0] data;
    wire sda, scl;
    wire [3:0] state;
    
    // Clock
    initial begin
        sclk = 0;
    end
    
    always begin
        #100;
        sclk = ~sclk;
    end
    
    // Reset
    initial begin
        rst = 1;
        #250;
        rst = 0;
    end
    
    // Input data
    initial begin
        d_en = 0;
        #250;
        data = 4'b1101;
        d_en = 1;
        #200;
        d_en = 0;
        #10000;
        data = 4'b0100;
        d_en = 1;
        #200;
        d_en = 0;
        #10000;
        data = 4'b1011;
        d_en = 1;
        #200;
        d_en = 0;
    end
    
    piso ps(.sclk(sclk), .rst(rst), .d_en(d_en), .data(data), .scl(scl), .sda(sda), .state(state));
endmodule

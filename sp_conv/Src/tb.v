`timescale 1ns / 1ps

module tb;
    reg sclk, rst, d_en;
    reg [3:0] data;
    wire [3:0] st;
    wire sda, scl, rx;
    wire [3:0] dataout;
    
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
        
        data = 0;
        while (1) begin
            data = data + 1;
            d_en = 1;
            $display("Sent: %d", data);
            #200;
            d_en = 0;
            #10000;
            
            if (data == 4'b1111) $stop;
        end
    end
    
    always @(posedge rx) begin
        $display("Received: %d", dataout);
    end
    
    piso ps(.sclk(sclk), .rst(rst), .d_en(d_en), .data(data), .scl(scl), .sda(sda));
    sipo sp(.sda(sda), .scl(scl), .rst(rst), .data(dataout), .rx(rx));
endmodule

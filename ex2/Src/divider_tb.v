`timescale 1ns / 1ps

module divider_tb;
    reg rst, clkin;
    
    initial begin
        clkin = 1;
        rst = 0;
        #5 rst = 1;
    end
    
    always begin
        #2;
        clkin = ~clkin;
    end
    
    divider m(
        .clkin(clkin),
        .clkout(clkout),
        .rst(rst)
    );
endmodule

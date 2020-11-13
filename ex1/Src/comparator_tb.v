`timescale 1ns / 1ps

module comparator_tb;
    reg [8:0] i, j;
    wire is_gt;
    
    initial begin: blk
        for (i = 0; i < 256; i = i + 1) begin
            for (j = 0; j < 256; j = j + 1) begin
                #5;
            end
        end
    end
    
    comparator_8b m(.a(i), .b(j), .c(is_gt));
endmodule

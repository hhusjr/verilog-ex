`timescale 1ns / 1ps

module period_wave_tb;
    reg F10M, RST;
    wire FW;
    
    initial begin
        F10M = 0;
        RST = 1;
        #75;
        RST = 0;
    end
    
    always begin
        #50;
        F10M = ~F10M;
    end
    
    period_wave m(
        .F10M(F10M),
        .RST(RST),
        .FW(FW)
    );
endmodule

`timescale 1ns / 1ps

module period_wave(F10M, RST, FW);
    input F10M, RST;
    output reg FW;
    reg [8:0] count;
    always @(posedge F10M) begin
        if (RST || count == 499) begin
            FW <= 0;
            count <= 0;
        end else begin
            FW <= count >= 200 && count <= 299;
            count <= count + 1;
        end
    end
endmodule

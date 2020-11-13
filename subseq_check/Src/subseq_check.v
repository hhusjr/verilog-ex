`timescale 1ns / 1ps

`define S0   1
`define S1   2
`define S2   3
`define S3   4
`define S4   5
`define S5   6

module subseq_check(clk, x, z, rst, state);
    input clk, x, rst;
    output reg z;
    output state;
    
    reg [2:0] state;
    reg [2:0] next_state;
    
    always @(*) begin
        case (state)
            `S0: next_state =  x ? `S1 : `S0;
            `S1: next_state = ~x ? `S2 : `S1;
            `S2: next_state = ~x ? `S3 : `S1;
            `S3: next_state =  x ? `S4 : `S0;
            `S4: next_state = ~x ? `S5 : `S1;
            `S5: next_state = ~x ? `S3 : `S1;
            default: next_state = `S0;
        endcase
    end
    
    always @(*) begin
        z = state == `S5;
    end
    
    always @(posedge clk) begin
        if (rst) begin
            state <= `S0;
        end else begin
            state <= next_state;
        end
    end
endmodule

`timescale 1ns / 1ps

// Serial to Parallel
// 串行数据转并行数据
module sipo(scl, sda, data, rst, rx);
    // 状态定义
    parameter S_BIT0 = 0;
    parameter S_BIT1 = 1;
    parameter S_BIT2 = 2;    
    parameter S_BIT3 = 3;     
    parameter S_STOP = 4;
    
    input scl, sda, rst;
    output data, rx;
    reg [3:0] data;
    reg [3:0] state, next_state;
    reg rx, rcv;
    
    // 判断数据传输是否已经开始/结束
    always @(negedge rst) begin
        rcv <= 0;
    end
    always @(negedge sda) begin
        if (scl == 1) rcv = 1;
    end
    always @(posedge sda) begin
        if (scl == 1) rcv = 0;
    end
    
    // 状态转换组合逻辑（计算下一个状态）
    always @(*) begin
        case (state)
            S_BIT0:  next_state = rcv ? S_BIT1 : S_BIT0;            
            S_BIT1:  next_state = S_BIT2;   
            S_BIT2:  next_state = S_BIT3;            
            S_BIT3:  next_state = S_STOP;       
            S_STOP:  next_state = !rcv ? S_BIT0 : S_STOP;
            default: next_state = S_BIT0;
        endcase
    end
    
    // 状态转换时序逻辑
    always @(posedge scl) begin
        state <= rst ? S_BIT0 : next_state;
    end
    
    // 输出行为时序逻辑
    always @(posedge scl) begin
        case (state)
            S_BIT0: if (rcv) begin
                data[0] <= sda;
                rx <= 0;
            end
            S_BIT1: data[1] <= sda;
            S_BIT2: data[2] <= sda;
            S_BIT3: data[3] <= sda;
            S_STOP: rx <= 1;
        endcase
    end
endmodule

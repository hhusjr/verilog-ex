`timescale 1ns / 1ps

// Parallel to Serial
// 并行数据转串行数据
module piso(rst, data, sclk, d_en, scl, sda);
    // 状态定义
    parameter S_READY = 0;
    parameter S_BEGIN = 1;
    parameter S_BIT0  = 2; 
    parameter S_BIT1  = 3;    
    parameter S_BIT2  = 4;    
    parameter S_BIT3  = 5;    
    parameter S_STOP  = 6;    
    parameter S_END   = 7;    

    input rst, data, sclk, d_en;
    output scl, sda;
    
    wire [3:0] data;
    reg scl, sda;
    reg [3:0] dbuf;
    reg [3:0] state, next_state;
    
    // 产生串行输出时钟信号
    always @(posedge sclk) begin
        scl <= rst ? 1 : ~scl;
    end
    
    // 使能端上升沿时，将数据输入到DATA Buffer寄存器缓冲
    // 防止串行输出过程中数据被更改或产生竞争冒险
    always @(posedge d_en) begin
        dbuf <= data;
    end
    
    // 状态转换组合逻辑（计算下一个状态）
    always @(*) begin
        case (state)
            S_READY: next_state = d_en ? S_BEGIN : S_READY;            
            S_BEGIN: next_state = scl ? S_BIT0 : S_BEGIN;            
            S_BIT0:  next_state = !scl ? S_BIT1 : S_BIT0;            
            S_BIT1:  next_state = !scl ? S_BIT2 : S_BIT1;            
            S_BIT2:  next_state = !scl ? S_BIT3 : S_BIT2;            
            S_BIT3:  next_state = !scl ? S_STOP : S_BIT3;            
            S_STOP:  next_state = !scl ? S_END : S_STOP;
            S_END:   next_state = scl ? S_READY : S_END;
            default:  next_state = S_READY;
        endcase
    end
    
    // 输出行为时序逻辑
    always @(negedge sclk) begin
        if (!rst) begin
            case (state)
                S_BEGIN: if (scl)  sda <= 0;
                S_BIT0:  if (!scl) sda <= dbuf[0];
                S_BIT1:  if (!scl) sda <= dbuf[1];
                S_BIT2:  if (!scl) sda <= dbuf[2];
                S_BIT3:  if (!scl) sda <= dbuf[3];
                S_STOP:  if (!scl) sda <= 0;
                S_END:   if (scl)  sda <= 1;
                default:  sda <= 1;
            endcase
        end else begin
            sda <= 1;
        end
    end
    
    // 状态转换时序逻辑
    always @(negedge sclk) begin
        state <= rst ? S_READY : next_state;
    end
endmodule

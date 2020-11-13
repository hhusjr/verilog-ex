`timescale 1ns / 1ps

// Parallel to Serial
// ��������ת��������
module piso(rst, data, sclk, d_en, scl, sda);
    // ״̬����
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
    
    // �����������ʱ���ź�
    always @(posedge sclk) begin
        scl <= rst ? 1 : ~scl;
    end
    
    // ʹ�ܶ�������ʱ�����������뵽DATA Buffer�Ĵ�������
    // ��ֹ����������������ݱ����Ļ��������ð��
    always @(posedge d_en) begin
        dbuf <= data;
    end
    
    // ״̬ת������߼���������һ��״̬��
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
    
    // �����Ϊʱ���߼�
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
    
    // ״̬ת��ʱ���߼�
    always @(negedge sclk) begin
        state <= rst ? S_READY : next_state;
    end
endmodule

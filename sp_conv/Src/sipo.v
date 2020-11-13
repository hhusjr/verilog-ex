`timescale 1ns / 1ps

// Serial to Parallel
// ��������ת��������
module sipo(scl, sda, data, rst, rx);
    // ״̬����
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
    
    // �ж����ݴ����Ƿ��Ѿ���ʼ/����
    always @(negedge rst) begin
        rcv <= 0;
    end
    always @(negedge sda) begin
        if (scl == 1) rcv = 1;
    end
    always @(posedge sda) begin
        if (scl == 1) rcv = 0;
    end
    
    // ״̬ת������߼���������һ��״̬��
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
    
    // ״̬ת��ʱ���߼�
    always @(posedge scl) begin
        state <= rst ? S_BIT0 : next_state;
    end
    
    // �����Ϊʱ���߼�
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

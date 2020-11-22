`timescale 1ns / 1ps

module eeprom_wr(
    data,
    rst,
    clk,
    rd,
    wr,
    addr,
    sda,
    scl,
    ack
);
    // �˿ڶ���
    input [7:0] data;
    input rst;
    input clk;
    input rd, wr;
    input [10:0] addr;
    inout sda;
    output reg scl;
    output reg ack;
    
    // ״̬����
    parameter IDLE = 0;
    parameter START = 1;
    parameter WRITE_CTRL = 2;
    parameter WRITE_CTRL_ACK = 3;
    parameter WRITE_ADDR = 4;
    parameter WRITE_ADDR_ACK = 5;
    parameter WRITE_DATA = 6;
    parameter WRITE_DATA_ACK = 7;
    parameter READ_CTRL = 8;
    parameter READ_CTRL_ACK = 7;
    parameter READ_DATA = 9;
    parameter END = 10;
    
    // ������Ĵ�������
    reg [3:0] state;
    reg [3:0] next_state;
    reg [3:0] count;
    reg rd_en, wr_en;
    reg bus_ctrl;
    reg [7:0] sda_buf;
    
    // ����
    assign sda = bus_ctrl ? sda_buf[7] : 1'bz;
    
    // ״̬ת���߼�
    wire enter_start = scl & (rd | wr);
    
    // �Ƿ�����
    parameter DISABLED = 1'b0; // ����
    parameter ENABLED = 1'b1; // ����
    
    // ����SCL�ź�
    always @(negedge clk or negedge rst) begin
        scl <= !rst ? 0 : ~scl;
    end
    
    // ״̬������߼�
    always @(posedge clk) begin
        bus_ctrl = ENABLED;
        case (state)
            
        endcase
    end
    
    // ��һ��״̬����߼�����
    always @(*) begin
        case (state)
            IDLE: next_state = enter_start ? WRITE_CTRL : IDLE;
            WRITE_CTRL: next_state = (count == 7) ? WRITE_CTRL_ACK : WRITE_CTRL;
            WRITE_CTRL_ACK: next_state = WRITE_ADDR;
            WRITE_ADDR: next_state = (count == 7) ? WRITE_ADDR_ACK : WRITE_ADDR;
            WRITE_ADDR_ACK: next_state = rd_en ? READ_CTRL : WRITE_DATA;
            WRITE_DATA: next_state = (count == 7) ? WRITE_DATA_ACK : WRITE_DATA;
            WRITE_DATA_ACK: next_state = END;
            READ_CTRL: next_state = (count == 7) ? READ_CTRL_ACK : READ_CTRL;
            READ_CTRL_ACK: next_state = END;
            END: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end
    
    // ״̬ת��
    always @(posedge clk or negedge rst) begin
        state <= !rst ? IDLE : next_state;
    end
endmodule

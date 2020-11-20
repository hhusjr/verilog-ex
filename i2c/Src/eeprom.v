`timescale 1ns / 1ps

// ���п��õ�����ɱ��ֻ���洢��
//  ʹ��I2CЭ��ͨѶ
module eeprom(sda, scl, rst);
    // �˿ڶ���
    inout sda;
    input scl;
    input rst;
    
    // ״̬����
    parameter IDLE     = 8'b00000001; // ����״̬
    parameter CTRL     = 8'b00000010; // ����״̬
    parameter CTRL_ACK = 8'b00000100; // ����״̬ȷ��
    parameter ADDR     = 8'b00001000; // ��ַ����
    parameter ADDR_ACK = 8'b00010000; // ��ַ����ȷ��
    parameter DATA     = 8'b00100000; // �����������
    parameter DATA_ACK = 8'b01000000; // �������ȷ��
    
    // �Ƿ�����
    parameter DISABLED = 1'b0; // ����
    parameter ENABLED = 1'b1; // ����
    
    // ��д״̬
    parameter WR = 1'b0; // д
    parameter RD = 1'b1; // ��

    // �Ĵ�������
    wire [7:0] mem_out;
    reg [7:0] mem_in;
    reg mem_en;
    reg [7:0] sda_buf;
    reg out_flg;
    reg [7:0] state;
    reg [7:0] next_state;
    reg [3:0] count;
    reg [7:0] ctrl;
    reg [10:0] addr;
    reg en, read_en;
    
    // DRAM�ڴ�
    dist_mem_gen_0 mem(
        .clk(scl),
        .d(mem_in),
        .a(addr),
        .we(mem_en),
        .spo(mem_out)
    );
    
    // SDAΪ˫�����ߣ���Ҫָ���������
    assign sda = out_flg ? sda_buf[7] : 1'bz;
    
    // ����Ƿ�������ֹͣ
    always @(negedge sda or negedge rst) begin
        if (!rst) begin
            en <= DISABLED;
            read_en <= DISABLED;
        end else if (scl) begin
            en <= ENABLED;
            read_en <= en ? ENABLED : DISABLED;
        end
    end
    always @(posedge sda) begin
        if (scl) en <= DISABLED;
    end
    
    // ״̬��ת���߼�
    always @(*) begin
        if (!en) next_state = IDLE;
        else begin
            case (state)
                IDLE: next_state = en ? CTRL : IDLE;
                CTRL: next_state = count == 7 ? CTRL_ACK : CTRL;
                CTRL_ACK: next_state = (ctrl[0] == WR) ? ADDR : DATA;
                ADDR: next_state = count == 10 ? ADDR_ACK : ADDR;
                ADDR_ACK: next_state = read_en ? CTRL : DATA;
                DATA: next_state = count == 7 ? DATA_ACK : DATA;
                DATA_ACK: next_state = IDLE;
                default: next_state = IDLE;
            endcase
        end
    end
    
    // ״̬��ʱ��
    always @(negedge scl or negedge rst) begin
        state <= !rst ? IDLE : next_state;
    end
   
    // ״̬������߼�
    always @(negedge scl or negedge rst) begin
        sda_buf <= 0;
        out_flg <= DISABLED;
        count <= 0;
        mem_en <= DISABLED;
        if (rst) begin
            (* full_case *) case (state)
                CTRL: begin
                    ctrl <= {ctrl[6:0], sda};
                    count <= count + 1;
                    out_flg <= count == 7;
                end
                ADDR: begin
                    addr <= {addr[9:0], sda};
                    count <= count + 1;
                    out_flg <= count == 10;
                end
                DATA: begin
                    if (ctrl[0] == WR) begin
                        mem_in <= {mem_in[6:0], sda};
                        out_flg <= count == 7;
                    end else if (ctrl[0] == RD) begin
                        sda_buf <= count == 0 ? mem_out : {sda_buf[6:0], 1'b0};
                        out_flg <= ENABLED;
                    end
                    count <= count + 1;
                end
                DATA_ACK: mem_en <= ENABLED;
            endcase
        end
    end
endmodule

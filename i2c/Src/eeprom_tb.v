`timescale 1ns / 1ps

module eeprom_tb;
    reg scl, sdi, rst;
    reg en_in;
    wire sda;
    wire sdo;
    assign sda = en_in ? sdi : 1'bz;
    assign sdo = !en_in ? sda : 1'bz;
    eeprom m(.scl(scl), .sda(sda), .rst(rst));
    
    initial begin
        rst = 1;
        #10;
        rst = 0;
        #10;
        rst = 1;
    end
    
    initial begin
        scl = 1;
        #50;
        forever #50 scl = ~scl;
    end
    
    initial begin
        en_in = 1;
        // �����ź�
        sdi = 1;
        #50;
        sdi = 0;
        #75;
        // ���ƴ�
        en_in = 1;
        send_byte(8'b10100000);
        // �ȴ�Ӧ��λ
        en_in = 0;
        send_bit(1'b1);
        // EEPROM�洢��Ԫ��ַ
        en_in = 1;
        send_addr(10'b1000000000);
        // �ȴ�Ӧ��λ
        en_in = 0;
        send_bit(1'b1);
        // ����λ
        en_in = 1;
        send_byte(8'b10101010);
        // �ȴ�Ӧ��λ
        en_in = 0;
        send_bit(1'b1);
        // ����ֹͣ�ź�
        en_in = 1;
        sdi = 0;
        #50;
        sdi = 1;
        
        // ��
        #50;
        en_in = 1;
        // �����ź�
        sdi = 1;
        #50;
        sdi = 0;
        #50;
        // ���ƴ�
        en_in = 1;
        send_byte(8'b10100001);
        // �ȴ�Ӧ��λ
        en_in = 0;
        send_bit(1'b1);
        // EEPROM�洢��Ԫ��ַ
        en_in = 1;
        send_byte(10'b1000000000);
        // �ȴ�Ӧ��λ
        en_in = 0;
        send_bit(1'b1);
        // �����ź�
        sdi = 1;
        #50;
        sdi = 0;
        #50;
        // ���ƴ�
        en_in = 1;
        send_byte(8'b10100001);
        // �ȴ�Ӧ��λ
        en_in = 0;
        send_bit(1'b1);
        // �������
        en_in = 0;
        #800;
        // ����ֹͣ�ź�
        en_in = 1;
        sdi = 0;
        #50;
        sdi = 1;
    end
    
    task send_bit;
    input bit;
    begin
        sdi = bit;
        #100;
    end
    endtask
    
    task send_byte;
    input [7:0] byte;
    begin: sb
        reg [3:0] i;
        for (i = 8; i != 0; i = i - 1) send_bit(byte[i - 1]);
    end
    endtask
    
    task send_addr;
    input [10:0] addr;
    begin: sb
        reg [3:0] i;
        for (i = 11; i != 0; i = i - 1) send_bit(addr[i - 1]);
    end
    endtask
endmodule

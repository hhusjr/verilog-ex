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
        // 启动信号
        sdi = 1;
        #50;
        sdi = 0;
        #75;
        // 控制串
        en_in = 1;
        send_byte(8'b10100000);
        // 等待应答位
        en_in = 0;
        send_bit(1'b1);
        // EEPROM存储单元地址
        en_in = 1;
        send_addr(10'b1000000000);
        // 等待应答位
        en_in = 0;
        send_bit(1'b1);
        // 数据位
        en_in = 1;
        send_byte(8'b10101010);
        // 等待应答位
        en_in = 0;
        send_bit(1'b1);
        // 产生停止信号
        en_in = 1;
        sdi = 0;
        #50;
        sdi = 1;
        
        // 读
        #50;
        en_in = 1;
        // 启动信号
        sdi = 1;
        #50;
        sdi = 0;
        #50;
        // 控制串
        en_in = 1;
        send_byte(8'b10100001);
        // 等待应答位
        en_in = 0;
        send_bit(1'b1);
        // EEPROM存储单元地址
        en_in = 1;
        send_byte(10'b1000000000);
        // 等待应答位
        en_in = 0;
        send_bit(1'b1);
        // 启动信号
        sdi = 1;
        #50;
        sdi = 0;
        #50;
        // 控制串
        en_in = 1;
        send_byte(8'b10100001);
        // 等待应答位
        en_in = 0;
        send_bit(1'b1);
        // 获得数据
        en_in = 0;
        #800;
        // 产生停止信号
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

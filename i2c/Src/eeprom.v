`timescale 1ns / 1ps

// 串行可用电擦除可编程只读存储器
//  使用I2C协议通讯
module eeprom(sda, scl, rst);
    // 端口定义
    inout sda;
    input scl;
    input rst;
    
    // 状态定义
    parameter IDLE     = 8'b00000001; // 空闲状态
    parameter CTRL     = 8'b00000010; // 控制状态
    parameter CTRL_ACK = 8'b00000100; // 控制状态确认
    parameter ADDR     = 8'b00001000; // 地址输入
    parameter ADDR_ACK = 8'b00010000; // 地址输入确认
    parameter DATA     = 8'b00100000; // 数据输入输出
    parameter DATA_ACK = 8'b01000000; // 数据输出确认
    
    // 是否启用
    parameter DISABLED = 1'b0; // 禁用
    parameter ENABLED = 1'b1; // 启用
    
    // 读写状态
    parameter WR = 1'b0; // 写
    parameter RD = 1'b1; // 读

    // 寄存器定义
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
    
    // DRAM内存
    dist_mem_gen_0 mem(
        .clk(scl),
        .d(mem_in),
        .a(addr),
        .we(mem_en),
        .spo(mem_out)
    );
    
    // SDA为双向总线，需要指定输入输出
    assign sda = out_flg ? sda_buf[7] : 1'bz;
    
    // 检测是否启动或停止
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
    
    // 状态机转移逻辑
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
    
    // 状态机时序
    always @(negedge scl or negedge rst) begin
        state <= !rst ? IDLE : next_state;
    end
   
    // 状态机输出逻辑
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

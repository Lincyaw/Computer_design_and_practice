`timescale 1ns / 1ps
module minisys(
    input fpga_rst,
    input fpga_clk
    );
    
    wire [31:0]read_data;
    wire [31:0]address;
    wire [31:0]write_data; 
    wire Memwrite;
    wire clock;
    wire [2:0]NPCModeSel;
    reg [31:0]PC;
    wire [31:0]Instruction;
    wire [1:0]zerog;
    wire [31:0]Npc;
    wire [31:0]PC4;
    wire [2:0]RegModeSel;
    wire [4:0]WriteAddr;
    wire [31:0]WD_ALU;
    wire [31:0]WD_DMRD;
    wire [31:0]WD_PC4;
    wire [31:0]WD;
    wire WDsel;
    wire [1:0]zero_g;
    wire [3:0]ALUop;
    wire [2:0]ALU_MODESEL;
    wire Sign_Sel;
    wire [31:0]Regdata1;
    wire [31:0]Regdata2;
    wire [31:0] answer;
    wire [31:0] OP_1;
    wire [31:0] OP_2;
    wire [31:0] EXTEND;


    wire [31:0]debug_wb_pc;
    wire debug_wb_rf_wen;
    wire [4:0] debug_wb_rf_wnum;
    wire[31:0] debug_wb_rf_wdata;

    assign debug_wb_pc = PC;
    assign debug_wb_rf_wen = WDsel;
    assign debug_wb_rf_wnum = WriteAddr;
    assign debug_wb_rf_wdata = WD;

    always@(negedge clock)
    begin
        PC = fpga_rst ? 0 : Npc;
    end

    ifetc32 U9(
    clock,
    PC,
    Instruction
    );

    cpuclk0 U0(
    fpga_clk,
    clock
    );


    dmemory32 U1(
    read_data,
    answer,
    Instruction,
    Memwrite,
    clock
    );
    
    NPC U2(
    clock,
    NPCModeSel,
    PC,
    EXTEND,
    Instruction,
    zerog,
    Npc,
    PC4
    );


    reg_mux U3(
    RegModeSel,
    Instruction[20:16],
    Instruction[15:11],
    WriteAddr,
    answer,
    read_data,
    PC4,
    WD,
    WDsel
    );


    regfile U4(
    clock,
    Instruction[20:16],
    Regdata1,
    Instruction[15:11],
    Regdata2,
    WriteAddr,
    WD,
    WDsel
    );



    ALU_mux U5(
    ALU_MODESEL,
    Regdata1,
    Regdata2,
    Instruction[10:6],
    EXTEND,
    OP_1,
    OP_2
    );

    executs32 U6(
    ALUop,
    OP_1,
    OP_2,
    answer,
    zerog
    ); 

    extend U7(
    Instruction[15:0],
    Sign_Sel,
    EXTEND
    );
    

    control32 U8(
    clock,
    Instruction,
    zero_g,
    ALUop,
    ALU_MODESEL,
    RegModeSel,
    NPCModeSel,
    Memwrite,
    Sign_Sel
    );

endmodule




// minisys:
//          cpuclk.v   ʱ��Դ
//                  ���23MHzʱ��Ƶ��
//          dmemory.v  ���ݴ洢��
//                  ����ip��
//          ifetch.v   ָ��洢��
//                  ����ip��
//          executs.v  ALU
//                  ���������,����������
//                  ������,zero��־λ
//          regfile.v  �Ĵ�����
//                  ������Ĵ���1ѡ���ź�,�Ĵ���1���,������Ĵ���1������
//                  ������Ĵ���2ѡ���ź�,�Ĵ���2���,������Ĵ���2������
//                  ����д�Ĵ���3ѡ���ź�,�Ĵ���3���,д�Ĵ���3������
//          extend.v   16λ��չ��32λ
//                  ����16λ��
//                  ���32λ���޷�����չ���з�����չ


//������    1. ���Ƶ�Ԫ
//          2. NPC


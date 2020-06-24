`timescale 1ns / 1ps
module minisys(
    input fpga_rst,
    input fpga_clk,
        output [31:0]debug_wb_pc,
    output debug_wb_rf_wen,
    output [4:0] debug_wb_rf_wnum,
    output[31:0] debug_wb_rf_wdata
    );
    wire [31:0]read_data;
    wire Memwrite;
    wire clock;
    wire [2:0]NPCModeSel;
    wire [31:0]PC;
    wire [31:0]Instruction;
    wire [1:0]zerog;
    wire [31:0]Npc;
    wire [31:0]PC4;
    wire [2:0]RegModeSel;
    wire [4:0]WriteAddr;
    wire [31:0]WD;
    wire WDsel;
    wire [3:0]ALUop;
    wire [2:0]ALU_MODESEL;
    wire Sign_Sel;
    wire [31:0]Regdata1;
    wire [31:0]Regdata2;
    wire [31:0] answer;
    wire [31:0] OP_1;
    wire [31:0] OP_2;
    wire [31:0] EXTEND;
    wire [31:0] reg31;
    wire IRWr;
//    wire [31:0]debug_wb_pc;
//    wire debug_wb_rf_wen;
//    wire [4:0] debug_wb_rf_wnum;
//    wire[31:0] debug_wb_rf_wdata;

    //assign debug_wb_pc = PC;
    assign debug_wb_rf_wen = WDsel;
    assign debug_wb_rf_wnum = WriteAddr;
    assign debug_wb_rf_wdata = WD;



    ifetc32 U9(
    clock,
    IRWr,
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
    Regdata2,
    Memwrite,
    clock
    );
    
    NPC U2(
    clock,
    fpga_rst,
    NPCModeSel,
    PC,
    Regdata1,
    Instruction,
    zerog,
    Npc,
    PC4
    );


    reg_mux U3(
    RegModeSel,
    zerog,
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
    fpga_rst,
    Instruction[25:21],
    Regdata1,
    Instruction[20:16],
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
    clock,
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
    fpga_rst,
    Instruction,
    Npc,
    PC,
    ALUop,
    ALU_MODESEL,
    RegModeSel,
    NPCModeSel,
    Memwrite,
    Sign_Sel,
    IRWr,
    debug_wb_pc
    );

endmodule




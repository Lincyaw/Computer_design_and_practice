`timescale 1ns / 1ps
`include "para.v"
module control32(
    input clk,
    input [31:0]instruction,
    input [1:0]zero_g,
    output [3:0]ALUop,
    output [2:0]ALU_MODESEL,
    output [1:0]reg_mux_mode,
    output [2:0]NPC_SEL,
    output Memwrite,
    output Sign_Sel
    );


    wire op = instruction[31:26];
    wire rs = instruction[25:21];
    wire rt = instruction[20:16];
    wire rd = instruction[15:10];
    wire shamt = instruction[10:6];
    wire funct = instruction[5:0];
    wire imm16 = instruction[15:0];
    wire imm26 = instruction[25:0];

    reg [3:0] ALU;
    assign ALUop = ALU;
    reg [1:0]reg_mux_temp;
    assign reg_mux_mode = reg_mux_temp;
    reg [2:0]ALU_MODE;
    assign ALU_MODESEL = ALU_MODE;
    reg [2:0]NPC_MODE;
    assign NPC_SEL = NPC_MODE;
    reg WriteMemory;
    assign Memwrite = WriteMemory;
    reg Sel_Sign;
    assign Sign_Sel = Sel_Sign;

    always @ *
    begin
        case(op)
        6'b000000:
            begin
                case (funct)
                    `ins_add:  begin ALU = `ADD;  reg_mux_temp = `REG_MODE0; ALU_MODE = `ALU_MODE0; NPC_MODE = `Normal; WriteMemory = 0; Sel_Sign = 0; end
                    `ins_addu: begin ALU = `ADD;  reg_mux_temp = `REG_MODE0; ALU_MODE = `ALU_MODE0; NPC_MODE = `Normal; WriteMemory = 0; Sel_Sign = 0; end 
                    `ins_sub:  begin ALU = `SUB;  reg_mux_temp = `REG_MODE0; ALU_MODE = `ALU_MODE0; NPC_MODE = `Normal; WriteMemory = 0; Sel_Sign = 0; end
                    `ins_subu: begin ALU = `SUB;  reg_mux_temp = `REG_MODE0; ALU_MODE = `ALU_MODE0; NPC_MODE = `Normal; WriteMemory = 0; Sel_Sign = 0; end
                    `ins_and:  begin ALU = `AND;  reg_mux_temp = `REG_MODE0; ALU_MODE = `ALU_MODE0; NPC_MODE = `Normal; WriteMemory = 0; Sel_Sign = 0; end
                    `ins_or:   begin ALU = `OR;   reg_mux_temp = `REG_MODE0; ALU_MODE = `ALU_MODE0; NPC_MODE = `Normal; WriteMemory = 0; Sel_Sign = 0; end
                    `ins_xor:  begin ALU = `XOR;  reg_mux_temp = `REG_MODE0; ALU_MODE = `ALU_MODE0; NPC_MODE = `Normal; WriteMemory = 0; Sel_Sign = 0; end
                    `ins_nor:  begin ALU = `NOR;  reg_mux_temp = `REG_MODE0; ALU_MODE = `ALU_MODE0; NPC_MODE = `Normal; WriteMemory = 0; Sel_Sign = 0; end
                    `ins_slt:  begin ALU = `SUB;  reg_mux_temp = zero_g==`SMALLER?`REG_MODE1:`REG_MODE2; ALU_MODE = `ALU_MODE0; NPC_MODE = `Normal; WriteMemory = 0; Sel_Sign = 0; end
                    `ins_sltu: begin ALU = `SUB;  reg_mux_temp = zero_g==`SMALLER?`REG_MODE1:`REG_MODE2; ALU_MODE = `ALU_MODE0; NPC_MODE = `Normal; WriteMemory = 0; Sel_Sign = 0; end
                    `ins_sll:  begin ALU = `SLL;  reg_mux_temp = `REG_MODE0; ALU_MODE = `ALU_MODE1; NPC_MODE = `Normal; WriteMemory = 0; Sel_Sign = 0; end
                    `ins_srl:  begin ALU = `SRL;  reg_mux_temp = `REG_MODE0; ALU_MODE = `ALU_MODE1; NPC_MODE = `Normal; WriteMemory = 0; Sel_Sign = 0; end
                    `ins_sra:  begin ALU = `SRA;  reg_mux_temp = `REG_MODE0; ALU_MODE = `ALU_MODE1; NPC_MODE = `Normal; WriteMemory = 0; Sel_Sign = 0; end
                    `ins_sllv: begin ALU = `SLL;  reg_mux_temp = `REG_MODE0; ALU_MODE = `ALU_MODE0; NPC_MODE = `Normal; WriteMemory = 0; Sel_Sign = 0; end
                    `ins_srlv: begin ALU = `SRL;  reg_mux_temp = `REG_MODE0; ALU_MODE = `ALU_MODE0; NPC_MODE = `Normal; WriteMemory = 0; Sel_Sign = 0; end
                    `ins_srav: begin ALU = `SRA;  reg_mux_temp = `REG_MODE0; ALU_MODE = `ALU_MODE0; NPC_MODE = `Normal; WriteMemory = 0; Sel_Sign = 0; end
                    `ins_jr:begin NPC_MODE = `Jr; reg_mux_temp = `REG_MODE6; WriteMemory = 0; end //jr不需要考虑ALU的运算情况, 因为用不到
                endcase
            end
        `ins_addi:  begin ALU = `ADD;  reg_mux_temp = `REG_MODE3; ALU_MODE = `ALU_MODE2; NPC_MODE = `Normal; WriteMemory = 0; Sel_Sign = 1; end
        `ins_addiu: begin ALU = `ADD;  reg_mux_temp = `REG_MODE3; ALU_MODE = `ALU_MODE2; NPC_MODE = `Normal; WriteMemory = 0; Sel_Sign = 1; end
        `ins_andi:  begin ALU = `AND;  reg_mux_temp = `REG_MODE3; ALU_MODE = `ALU_MODE2; NPC_MODE = `Normal; WriteMemory = 0; Sel_Sign = 0; end
        `ins_ori:   begin ALU = `OR;   reg_mux_temp = `REG_MODE3; ALU_MODE = `ALU_MODE2; NPC_MODE = `Normal; WriteMemory = 0; Sel_Sign = 0; end
        `ins_xori:  begin ALU = `XOR;  reg_mux_temp = `REG_MODE3; ALU_MODE = `ALU_MODE2; NPC_MODE = `Normal; WriteMemory = 0; Sel_Sign = 0; end
        `ins_sltiu: begin ALU = `SUB;  reg_mux_temp = zero_g==`SMALLER?`REG_MODE1:`REG_MODE2; ALU_MODE = `ALU_MODE2; NPC_MODE = `Normal; WriteMemory = 0; Sel_Sign = 0; end
        `ins_lui:   begin ALU = `SLL;  reg_mux_temp = `REG_MODE3; ALU_MODE = `ALU_MODE3; NPC_MODE = `Normal; WriteMemory = 0; Sel_Sign = 0; end //将立即数左移16位
        `ins_lw:    begin ALU = `ADD;  reg_mux_temp = `REG_MODE4; ALU_MODE = `ALU_MODE2; NPC_MODE = `Normal; WriteMemory = 0; Sel_Sign = 1; end   //还需要加一个选择器 选择是有符号拓展还是无符号拓展
        `ins_sw:    begin ALU = `ADD;  reg_mux_temp = `REG_MODE6; ALU_MODE = `ALU_MODE2; NPC_MODE = `Normal; WriteMemory = 1; Sel_Sign = 1; end
        `ins_beq:   begin ALU = `SUB;  reg_mux_temp = `REG_MODE6; ALU_MODE = `ALU_MODE0; NPC_MODE = `Beq;    WriteMemory = 0; Sel_Sign = 1; end
        `ins_bne:   begin ALU = `SUB;  reg_mux_temp = `REG_MODE6; ALU_MODE = `ALU_MODE0; NPC_MODE = `Bne;    WriteMemory = 0; Sel_Sign = 1; end
        `ins_bgtz:  begin ALU = `SUB;  reg_mux_temp = `REG_MODE6; ALU_MODE = `ALU_MODE0; NPC_MODE = `Bgtz;   WriteMemory = 0; Sel_Sign = 1; end
        `ins_j:     begin reg_mux_temp = `REG_MODE6; NPC_MODE = `J_Jal; WriteMemory = 0; Sel_Sign = 0; end 
        `ins_jal:   begin reg_mux_temp = `REG_MODE5; NPC_MODE = `J_Jal; WriteMemory = 0; Sel_Sign = 0; end//regmode5是把{PC+4}写到$31里
        endcase
    end
endmodule
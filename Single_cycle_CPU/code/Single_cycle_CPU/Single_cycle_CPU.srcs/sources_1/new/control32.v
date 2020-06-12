`timescale 1ns / 1ps
`include "para.v"
module control32(
    input clk,
    input [31:0]instruction,
    input [1:0]zero_g,
    output [3:0]ALUop,
    output [2:0]ALU_MODESEL,
    output [2:0]reg_mux_mode,
    output [2:0]NPC_SEL,
    output Memwrite,
    output Sign_Sel
    );


    wire [5:0]op = instruction[31:26];
    wire [4:0]rs = instruction[25:21];
    wire [4:0]rt = instruction[20:16];
    wire [4:0]rd = instruction[15:10];
    wire [4:0]shamt = instruction[10:6];
    wire [5:0]funct = instruction[5:0];
    wire [15:0]imm16 = instruction[15:0];
    wire [25:0]imm26 = instruction[25:0];

    reg [3:0] ALU;
    assign ALUop = ALU;
    reg [2:0]reg_mux_temp;
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
                    `ins_sll:  begin 
                        if(instruction[31:0]==0)
                        begin
                            NPC_MODE = `Normal; WriteMemory = 0; reg_mux_temp = `REG_MODE6;
                        end
                        else
                        begin
                            ALU = `SLL;  reg_mux_temp = `REG_MODE0; ALU_MODE = `ALU_MODE1; NPC_MODE = `Normal; WriteMemory = 0; Sel_Sign = 0; 
                        end
                    end
                    `ins_srl:  begin ALU = `SRL;  reg_mux_temp = `REG_MODE0; ALU_MODE = `ALU_MODE1; NPC_MODE = `Normal; WriteMemory = 0; Sel_Sign = 0; end
                    `ins_sra:  begin ALU = `SRA;  reg_mux_temp = `REG_MODE0; ALU_MODE = `ALU_MODE1; NPC_MODE = `Normal; WriteMemory = 0; Sel_Sign = 0; end
                    `ins_sllv: begin ALU = `SLL;  reg_mux_temp = `REG_MODE0; ALU_MODE = `ALU_MODE0; NPC_MODE = `Normal; WriteMemory = 0; Sel_Sign = 0; end
                    `ins_srlv: begin ALU = `SRL;  reg_mux_temp = `REG_MODE0; ALU_MODE = `ALU_MODE0; NPC_MODE = `Normal; WriteMemory = 0; Sel_Sign = 0; end
                    `ins_srav: begin ALU = `SRA;  reg_mux_temp = `REG_MODE0; ALU_MODE = `ALU_MODE0; NPC_MODE = `Normal; WriteMemory = 0; Sel_Sign = 0; end
                    `ins_jr:begin NPC_MODE = `Jr; reg_mux_temp = `REG_MODE6; WriteMemory = 0; end //jr不需要考虑ALU的运算情况, 因为用不到
                    default:    begin NPC_MODE = `Normal; WriteMemory = 0; reg_mux_temp = `REG_MODE6;end
                endcase
            end
        `ins_addi:  begin ALU = `ADD;  reg_mux_temp = `REG_MODE3; ALU_MODE = `ALU_MODE2; NPC_MODE = `Normal; WriteMemory = 0; Sel_Sign = 1; end
        `ins_addiu: begin ALU = `ADD;  reg_mux_temp = `REG_MODE3; ALU_MODE = `ALU_MODE2; NPC_MODE = `Normal; WriteMemory = 0; Sel_Sign = 1; end
        `ins_andi:  begin ALU = `AND;  reg_mux_temp = `REG_MODE3; ALU_MODE = `ALU_MODE2; NPC_MODE = `Normal; WriteMemory = 0; Sel_Sign = 0; end
        `ins_ori:   begin ALU = `OR;   reg_mux_temp = `REG_MODE3; ALU_MODE = `ALU_MODE2; NPC_MODE = `Normal; WriteMemory = 0; Sel_Sign = 0; end
        `ins_xori:  begin ALU = `XOR;  reg_mux_temp = `REG_MODE3; ALU_MODE = `ALU_MODE2; NPC_MODE = `Normal; WriteMemory = 0; Sel_Sign = 0; end
        `ins_sltiu: begin ALU = `SUB;  reg_mux_temp = zero_g==`SMALLER?`REG_MODE1:`REG_MODE2; ALU_MODE = `ALU_MODE2; NPC_MODE = `Normal; WriteMemory = 0; Sel_Sign = 0; end
        `ins_lui:   begin ALU = `SLL;  reg_mux_temp = `REG_MODE3; ALU_MODE = `ALU_MODE3; NPC_MODE = `Normal; WriteMemory = 0; Sel_Sign = 0; end //将立即数左移16位
        `ins_lw:    begin ALU = `ADD;  reg_mux_temp = `REG_MODE7; ALU_MODE = `ALU_MODE2; NPC_MODE = `Normal; WriteMemory = 0; Sel_Sign = 1; end   
        `ins_sw:    begin ALU = `ADD;  reg_mux_temp = `REG_MODE6; ALU_MODE = `ALU_MODE2; NPC_MODE = `Normal; WriteMemory = 1; Sel_Sign = 1; end
        `ins_beq:   begin ALU = `SUB;  reg_mux_temp = `REG_MODE6; ALU_MODE = `ALU_MODE0; NPC_MODE = `Beq;    WriteMemory = 0; Sel_Sign = 1; end
        `ins_bne:   begin ALU = `SUB;  reg_mux_temp = `REG_MODE6; ALU_MODE = `ALU_MODE0; NPC_MODE = `Bne;    WriteMemory = 0; Sel_Sign = 1; end
        `ins_bgtz:  begin ALU = `SUB;  reg_mux_temp = `REG_MODE6; ALU_MODE = `ALU_MODE0; NPC_MODE = `Bgtz;   WriteMemory = 0; Sel_Sign = 1; end
        `ins_j:     begin reg_mux_temp = `REG_MODE6; NPC_MODE = `J_Jal; WriteMemory = 0; Sel_Sign = 0; end 
        `ins_jal:   begin reg_mux_temp = `REG_MODE5; NPC_MODE = `J_Jal; WriteMemory = 0; Sel_Sign = 0; end//regmode5是把{PC+4}写到$31里
        default:    begin NPC_MODE = `Normal; WriteMemory = 0; reg_mux_temp = `REG_MODE6; end
        endcase
    end
endmodule
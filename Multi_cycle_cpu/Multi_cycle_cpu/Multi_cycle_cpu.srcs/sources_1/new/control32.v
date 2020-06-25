`timescale 1ns / 1ps
`include "para.v"

module control32(
    input clk,
    input rst,
    input [31:0]instruction,
    input [31:0]NPC,
    output reg[31:0]PC_curr,
    output reg[3:0]ALUop,
    output reg[2:0]ALU_MODESEL,
    output reg[2:0]reg_mux_mode,
    output reg[2:0]NPC_SEL,
    output reg Memwrite,
    output reg Sign_Sel,
    output reg IRWrsel,
    output [31:0]PC_pre
    );


    wire [5:0]op = instruction[31:26];
    wire [4:0]rs = instruction[25:21];
    wire [4:0]rt = instruction[20:16];
    wire [4:0]rd = instruction[15:10];
    wire [4:0]shamt = instruction[10:6];
    wire [5:0]funct = instruction[5:0];
    wire [15:0]imm16 = instruction[15:0];
    wire [25:0]imm26 = instruction[25:0];
    reg select_npc=0;
    reg [2:0]curr_state=0;
    reg [2:0]next_state;
    assign PC_pre = op==`ins_jal?NPC:PC_curr;

always@(negedge clk)
begin
    PC_curr <= rst?0:(select_npc?NPC:PC_curr);
end




always@ *
begin
    case(curr_state)
        `sifetch:        begin next_state=`sidecode;                             end
        `sidecode:
        begin 
            case(op)
            6'b000000:   begin next_state = (funct==`ins_jr)?`sifetch:`sexecute; end
            `ins_j:      begin next_state = `sifetch;                            end
            `ins_jal:    begin next_state = `swb;                                end
            default:     begin next_state = `sexecute;                           end
            endcase
        end
        `sexecute: 
        begin 
            case(op)
            `ins_beq:    next_state = `sifetch;
            `ins_bne:    next_state = `sifetch;
            `ins_lw:     next_state = `smem;
            `ins_sw:     next_state = `smem;
            default:     next_state = `swb;
            endcase
        end
        `smem:     
        begin 
            case(op)
            `ins_lw:     next_state = `swb;
            `ins_sw:     next_state = `sifetch;
            default:     next_state = `sifetch;
            endcase
        end
        `swb:    begin   next_state = `sifetch; end 
        default: begin   next_state = `sifetch; end
    endcase
end


always@(posedge clk)
begin
    curr_state <= rst?0:next_state;
end

reg flag = 0;
always@*
begin
    case (curr_state)
        `sifetch:  
        begin 
            IRWrsel=1;
            select_npc = !flag?0:1;
            flag = !flag?1:flag;
            reg_mux_mode = `REG_MODE6; //²»Ð´¼Ä´æÆ÷
            Memwrite = 0;
        end
        `sidecode:
        begin 
            IRWrsel=0; 
            reg_mux_mode = `REG_MODE6; //²»Ð´¼Ä´æÆ÷
            Memwrite = 0;
            select_npc=0;
            case(op)
            6'b000000:  begin  NPC_SEL = (funct==`ins_jr)?`Jr:`Normal; end
            `ins_j:     begin  NPC_SEL = `J_Jal;  end 
            `ins_jal:   begin  NPC_SEL = `J_Jal;  end
            default:    begin  NPC_SEL = `Normal; end
            endcase
        end
        `sexecute: 
        begin 
            IRWrsel=0; 
            select_npc=0;
            reg_mux_mode = `REG_MODE6; //²»Ð´¼Ä´æÆ÷
            Memwrite = 0;
            case(op)
            6'b000000:
                begin
                    case (funct)
                        `ins_add:  begin ALUop = `ADD;  ALU_MODESEL = `ALU_MODE0;end
                        `ins_addu: begin ALUop = `ADD;  ALU_MODESEL = `ALU_MODE0;end 
                        `ins_sub:  begin ALUop = `SUB;  ALU_MODESEL = `ALU_MODE0;end
                        `ins_subu: begin ALUop = `SUB;  ALU_MODESEL = `ALU_MODE0;end
                        `ins_and:  begin ALUop = `AND;  ALU_MODESEL = `ALU_MODE0;end
                        `ins_or:   begin ALUop = `OR;   ALU_MODESEL = `ALU_MODE0;end
                        `ins_xor:  begin ALUop = `XOR;  ALU_MODESEL = `ALU_MODE0;end
                        `ins_nor:  begin ALUop = `NOR;  ALU_MODESEL = `ALU_MODE0;end
                        `ins_slt:  begin ALUop = `SLT;  ALU_MODESEL = `ALU_MODE0;end
                        `ins_sltu: begin ALUop = `SUB;  ALU_MODESEL = `ALU_MODE0;end
                        `ins_sll:  begin ALUop = `SLL;  ALU_MODESEL = `ALU_MODE1;end
                        `ins_srl:  begin ALUop = `SRL;  ALU_MODESEL = `ALU_MODE1;end
                        `ins_sra:  begin ALUop = `SRA;  ALU_MODESEL = `ALU_MODE1;end
                        `ins_sllv: begin ALUop = `SLL;  ALU_MODESEL = `ALU_MODE0;end
                        `ins_srlv: begin ALUop = `SRL;  ALU_MODESEL = `ALU_MODE0;end
                        `ins_srav: begin ALUop = `SRA;  ALU_MODESEL = `ALU_MODE0;end
                        default:   begin end
                    endcase
                end
            `ins_addi:  begin ALUop = `ADD; ALU_MODESEL = `ALU_MODE2; Sign_Sel = 1; end
            `ins_addiu: begin ALUop = `ADD; ALU_MODESEL = `ALU_MODE2; Sign_Sel = 1; end
            `ins_andi:  begin ALUop = `AND; ALU_MODESEL = `ALU_MODE2; Sign_Sel = 0; end
            `ins_ori:   begin ALUop = `OR;  ALU_MODESEL = `ALU_MODE2; Sign_Sel = 0; end
            `ins_xori:  begin ALUop = `XOR; ALU_MODESEL = `ALU_MODE2; Sign_Sel = 0; end
            `ins_sltiu: begin ALUop = `SUB; ALU_MODESEL = `ALU_MODE2; Sign_Sel = 0; end
            `ins_lui:   begin ALUop = `SLL; ALU_MODESEL = `ALU_MODE3; Sign_Sel = 0; end //½«Á¢¼´Êý×óÒÆ16Î»
            `ins_lw:    begin ALUop = `ADD; ALU_MODESEL = `ALU_MODE2; Sign_Sel = 1; end   
            `ins_sw:    begin ALUop = `ADD; ALU_MODESEL = `ALU_MODE2; Sign_Sel = 1; end
            `ins_beq:   begin ALUop = `SUB; ALU_MODESEL = `ALU_MODE0; NPC_SEL = `Beq; Sign_Sel = 1; select_npc=0;end
            `ins_bne:   begin ALUop = `SUB; ALU_MODESEL = `ALU_MODE0; NPC_SEL = `Bne; Sign_Sel = 1; select_npc=0;end
            `ins_bgtz:  begin ALUop = `SLT; ALU_MODESEL = `ALU_MODE4; NPC_SEL = `Bgtz;Sign_Sel = 1; select_npc=0;end
            default:    begin select_npc=0; end
            endcase
        end
        `smem:     
        begin 
            IRWrsel=0; 
            select_npc=0;
            reg_mux_mode = `REG_MODE6; //²»Ð´¼Ä´æÆ÷
            Memwrite = op==`ins_sw?1:0;
        end

        `swb:      
        begin 
            IRWrsel=0; 
            select_npc=0;
                   case(op)
                    6'b000000:
                        begin
                            case (funct)
                                `ins_slt:  begin reg_mux_mode = `REG_MODE2; end
                                `ins_sltu: begin reg_mux_mode = `REG_MODE2; end
                                `ins_sll:  begin reg_mux_mode = instruction[31:0]==0?`REG_MODE6:`REG_MODE0; end
                                `ins_jr:   begin reg_mux_mode = `REG_MODE6; end
                                default:   begin reg_mux_mode = `REG_MODE0;end
                            endcase
                        end
                    `ins_sltiu: begin  reg_mux_mode = `REG_MODE1;  end
                    `ins_lw:    begin  reg_mux_mode = `REG_MODE4;  end   
                    `ins_sw:    begin  reg_mux_mode = `REG_MODE6;  end
                    `ins_beq:   begin  reg_mux_mode = `REG_MODE6;  end
                    `ins_bne:   begin  reg_mux_mode = `REG_MODE6;  end
                    `ins_bgtz:  begin  reg_mux_mode = `REG_MODE6;  end
                    `ins_j:     begin  reg_mux_mode = `REG_MODE6;  end 
                    `ins_jal:   begin  reg_mux_mode = `REG_MODE5;  end//regmode5ÊÇ°Ñ{PC+4}Ð´µ½$31Àï
                    default:    begin  reg_mux_mode = `REG_MODE3; end
                    endcase
        end
        default: begin select_npc=0; end
    endcase
end

endmodule








`timescale 1ns / 1ps
`include "para.v"

module control32(
    input clk,
    input rst,
    input [31:0]instruction,
    input [31:0]NPC,
    input [1:0]zero_g,
    output [31:0]PC_curr,
    output [3:0]ALUop,
    output [2:0]ALU_MODESEL,
    output [2:0]reg_mux_mode,
    output [2:0]NPC_SEL,
    output Memwrite,
    output Sign_Sel,
    output IRWrsel,
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

    reg [3:0] ALU;
    assign ALUop = ALU;
    reg [2:0]reg_mux_temp=`REG_MODE6;
    assign reg_mux_mode = reg_mux_temp;
    reg [2:0]ALU_MODE;
    assign ALU_MODESEL = ALU_MODE;
    reg [2:0]NPC_MODE = `Normal;
    assign NPC_SEL = NPC_MODE;
    reg WriteMemory;
    assign Memwrite = WriteMemory;
    reg Sel_Sign;
    assign Sign_Sel = Sel_Sign;
    reg IRWr;
    assign IRWrsel = IRWr;
    reg [31:0]PC_previous=0;
    assign PC_pre = PC_previous;





reg [2:0]curr_state=0;
reg [2:0]next_state;


reg [31:0]PC;
assign PC_curr = PC;

always@(negedge clk)
begin
    if(rst)
    begin
        PC<=0;
    end
    else if(select_npc)
    begin
        PC <= NPC;
        PC_previous <= NPC;
    end
end




always@ *
begin
    case(curr_state)
        `sifetch: begin next_state=`sidecode; end
        `swait: begin next_state=`sifetch; end
        `sidecode:
        begin 
            case(op)
            6'b000000: begin if(funct==`ins_jr) begin next_state = `sifetch; end end//jr不需要考虑ALU的运算情况, 因为用不到
            `ins_j: begin next_state = `sifetch;end
            `ins_jal:next_state = `swb;
            default:    next_state = `sexecute;
            endcase
        end
        `sexecute: 
        begin 
            case(op)
            `ins_beq:    next_state = `sifetch;
            `ins_bne:   next_state = `sifetch;
            `ins_lw:    next_state = `smem;
            `ins_sw:   next_state = `smem;
            default:    next_state = `swb;
            endcase
        end
        `smem:     
        begin 
            case(op)
            `ins_lw:    next_state = `swb;
            `ins_sw:   next_state = `sifetch;
            default:    next_state = `sifetch;
            endcase
        end
        `swb:      
        begin 
            next_state = `sifetch;
        end
        default: begin next_state = `sifetch; end
    endcase
end


always@(posedge clk)
begin
    if(rst)
    begin
        curr_state <= 0;
    end
    else
    begin
        curr_state <= next_state;
    end
end

reg flag = 0;
always@*
begin
    case (curr_state)
        `sifetch:  
        begin 
            IRWr=1; 
            
            if(!flag)
            begin
                select_npc=0;
                flag=1;
            end
            else
            begin
                select_npc=1;
            end
            reg_mux_temp = `REG_MODE6; //不写寄存器
            WriteMemory = 0;
        end
        `swait:  
        begin 
            IRWr=0; 
            select_npc=0;
            reg_mux_temp = `REG_MODE6; //不写寄存器
            WriteMemory = 0;
        end
        `sidecode:
        begin 
            IRWr=0; 
            //select_npc=0;
            reg_mux_temp = `REG_MODE6; //不写寄存器
            WriteMemory = 0;
            case(op)
            6'b000000:
                begin
                    if(funct==`ins_jr) begin NPC_MODE = `Jr; end //jr不需要考虑ALU的运算情况, 因为用不到
                    else begin NPC_MODE = `Normal;select_npc=0;end
                end
            `ins_j:     begin  NPC_MODE = `J_Jal; select_npc=0; end 
            `ins_jal:   begin  NPC_MODE = `J_Jal; end//regmode5是把{PC+4}写到$31里
            default:    begin  NPC_MODE = `Normal;select_npc=0; end
            endcase
        end
        `sexecute: 
        begin 
            IRWr=0; 
            select_npc=0;
            reg_mux_temp = `REG_MODE6; //不写寄存器
            WriteMemory = 0;
            
            case(op)
            6'b000000:
                begin
                    case (funct)
                        `ins_add:  begin ALU = `ADD;  ALU_MODE = `ALU_MODE0;end
                        `ins_addu: begin ALU = `ADD;  ALU_MODE = `ALU_MODE0;end 
                        `ins_sub:  begin ALU = `SUB;  ALU_MODE = `ALU_MODE0;end
                        `ins_subu: begin ALU = `SUB;  ALU_MODE = `ALU_MODE0;end
                        `ins_and:  begin ALU = `AND;  ALU_MODE = `ALU_MODE0;end
                        `ins_or:   begin ALU = `OR;   ALU_MODE = `ALU_MODE0;end
                        `ins_xor:  begin ALU = `XOR;  ALU_MODE = `ALU_MODE0;end
                        `ins_nor:  begin ALU = `NOR;  ALU_MODE = `ALU_MODE0;end
                        `ins_slt:  begin ALU = `SUB;  ALU_MODE = `ALU_MODE0;end
                        `ins_sltu: begin ALU = `SUB;  ALU_MODE = `ALU_MODE0;end
                        `ins_sll:  begin ALU = `SLL;  ALU_MODE = `ALU_MODE1;end
                        `ins_srl:  begin ALU = `SRL;  ALU_MODE = `ALU_MODE1;end
                        `ins_sra:  begin ALU = `SRA;  ALU_MODE = `ALU_MODE1;end
                        `ins_sllv: begin ALU = `SLL;  ALU_MODE = `ALU_MODE0;end
                        `ins_srlv: begin ALU = `SRL;  ALU_MODE = `ALU_MODE0;end
                        `ins_srav: begin ALU = `SRA;  ALU_MODE = `ALU_MODE0;end
                        default:   begin end
                    endcase
                end
            `ins_addi:  begin ALU = `ADD; ALU_MODE = `ALU_MODE2; Sel_Sign = 1; end
            `ins_addiu: begin ALU = `ADD; ALU_MODE = `ALU_MODE2; Sel_Sign = 1; end
            `ins_andi:  begin ALU = `AND; ALU_MODE = `ALU_MODE2; Sel_Sign = 0; end
            `ins_ori:   begin ALU = `OR;  ALU_MODE = `ALU_MODE2; Sel_Sign = 0; end
            `ins_xori:  begin ALU = `XOR; ALU_MODE = `ALU_MODE2; Sel_Sign = 0; end
            `ins_sltiu: begin ALU = `SUB; ALU_MODE = `ALU_MODE2; Sel_Sign = 0; end
            `ins_lui:   begin ALU = `SLL; ALU_MODE = `ALU_MODE3; Sel_Sign = 0; end //将立即数左移16位
            `ins_lw:    begin ALU = `ADD; ALU_MODE = `ALU_MODE2; Sel_Sign = 1; end   
            `ins_sw:    begin ALU = `ADD; ALU_MODE = `ALU_MODE2; Sel_Sign = 1; end
            `ins_beq:   begin ALU = `SUB; ALU_MODE = `ALU_MODE0; NPC_MODE = `Beq; Sel_Sign = 1; select_npc=0;end
            `ins_bne:   begin ALU = `SUB; ALU_MODE = `ALU_MODE0; NPC_MODE = `Bne; Sel_Sign = 1; select_npc=0;end
            `ins_bgtz:  begin ALU = `SUB; ALU_MODE = `ALU_MODE0; NPC_MODE = `Bgtz;Sel_Sign = 1; select_npc=0;end
            default:    begin select_npc=0; end
            endcase
        end
        `smem:     
        begin 
            IRWr=0; 
            select_npc=0;
            reg_mux_temp = `REG_MODE6; //不写寄存器
            case (op)
             `ins_sw:  begin WriteMemory = 1; end
                default: WriteMemory = 0;
            endcase
        end

        `swb:      
        begin 
            IRWr=0; 
            select_npc=0;
                   case(op)
                    6'b000000:
                        begin
                            case (funct)
                                `ins_slt:  begin reg_mux_temp = zero_g==`SMALLER?`REG_MODE1:`REG_MODE2; end
                                `ins_sltu: begin reg_mux_temp = zero_g==`SMALLER?`REG_MODE1:`REG_MODE2; end
                                `ins_sll:  begin 
                                    if(instruction[31:0]==0)
                                    begin
                                        reg_mux_temp = `REG_MODE6;
                                    end
                                    else
                                    begin
                                        reg_mux_temp = `REG_MODE0;  
                                    end
                                end
                                `ins_jr:   begin  reg_mux_temp = `REG_MODE6; end //jr不需要考虑ALU的运算情况, 因为用不到
                                default:    begin  reg_mux_temp = `REG_MODE0;end
                            endcase
                        end
                    `ins_sltiu: begin   reg_mux_temp = zero_g==`SMALLER?`REG_MODE1:`REG_MODE2;  end
                    `ins_lw:    begin  reg_mux_temp = `REG_MODE4;  end   
                    `ins_sw:    begin  reg_mux_temp = `REG_MODE6;  end
                    `ins_beq:   begin  reg_mux_temp = `REG_MODE6;  end
                    `ins_bne:   begin  reg_mux_temp = `REG_MODE6;  end
                    `ins_bgtz:  begin  reg_mux_temp = `REG_MODE6;  end
                    `ins_j:     begin  reg_mux_temp = `REG_MODE6;  end 
                    `ins_jal:   begin  reg_mux_temp = `REG_MODE5;  end//regmode5是把{PC+4}写到$31里
                    default:    begin  reg_mux_temp = `REG_MODE3; end
                    endcase
        end
        default: begin select_npc=0; end
    endcase
end




//    always @ *
//    begin
//        case(op)
//        6'b000000:
//            begin
//                case (funct)
//                    `ins_add:  begin ALU = `ADD;  reg_mux_temp = `REG_MODE0; ALU_MODE = `ALU_MODE0; NPC_MODE = `Normal; WriteMemory = 0; Sel_Sign = 0; end
//                    `ins_addu: begin ALU = `ADD;  reg_mux_temp = `REG_MODE0; ALU_MODE = `ALU_MODE0; NPC_MODE = `Normal; WriteMemory = 0; Sel_Sign = 0; end 
//                    `ins_sub:  begin ALU = `SUB;  reg_mux_temp = `REG_MODE0; ALU_MODE = `ALU_MODE0; NPC_MODE = `Normal; WriteMemory = 0; Sel_Sign = 0; end
//                    `ins_subu: begin ALU = `SUB;  reg_mux_temp = `REG_MODE0; ALU_MODE = `ALU_MODE0; NPC_MODE = `Normal; WriteMemory = 0; Sel_Sign = 0; end
//                    `ins_and:  begin ALU = `AND;  reg_mux_temp = `REG_MODE0; ALU_MODE = `ALU_MODE0; NPC_MODE = `Normal; WriteMemory = 0; Sel_Sign = 0; end
//                    `ins_or:   begin ALU = `OR;   reg_mux_temp = `REG_MODE0; ALU_MODE = `ALU_MODE0; NPC_MODE = `Normal; WriteMemory = 0; Sel_Sign = 0; end
//                    `ins_xor:  begin ALU = `XOR;  reg_mux_temp = `REG_MODE0; ALU_MODE = `ALU_MODE0; NPC_MODE = `Normal; WriteMemory = 0; Sel_Sign = 0; end
//                    `ins_nor:  begin ALU = `NOR;  reg_mux_temp = `REG_MODE0; ALU_MODE = `ALU_MODE0; NPC_MODE = `Normal; WriteMemory = 0; Sel_Sign = 0; end
//                    `ins_slt:  begin ALU = `SUB;  reg_mux_temp = zero_g==`SMALLER?`REG_MODE1:`REG_MODE2; ALU_MODE = `ALU_MODE0; NPC_MODE = `Normal; WriteMemory = 0; Sel_Sign = 0; end
//                    `ins_sltu: begin ALU = `SUB;  reg_mux_temp = zero_g==`SMALLER?`REG_MODE1:`REG_MODE2; ALU_MODE = `ALU_MODE0; NPC_MODE = `Normal; WriteMemory = 0; Sel_Sign = 0; end
//                    `ins_sll:  begin 
//                        if(instruction[31:0]==0)
//                        begin
//                            NPC_MODE = `Normal; WriteMemory = 0; reg_mux_temp = `REG_MODE6;
//                        end
//                        else
//                        begin
//                            ALU = `SLL;  reg_mux_temp = `REG_MODE0; ALU_MODE = `ALU_MODE1; NPC_MODE = `Normal; WriteMemory = 0; Sel_Sign = 0; 
//                        end
//                    end
//                    `ins_srl:  begin ALU = `SRL;  reg_mux_temp = `REG_MODE0; ALU_MODE = `ALU_MODE1; NPC_MODE = `Normal; WriteMemory = 0; Sel_Sign = 0; end
//                    `ins_sra:  begin ALU = `SRA;  reg_mux_temp = `REG_MODE0; ALU_MODE = `ALU_MODE1; NPC_MODE = `Normal; WriteMemory = 0; Sel_Sign = 0; end
//                    `ins_sllv: begin ALU = `SLL;  reg_mux_temp = `REG_MODE0; ALU_MODE = `ALU_MODE0; NPC_MODE = `Normal; WriteMemory = 0; Sel_Sign = 0; end
//                    `ins_srlv: begin ALU = `SRL;  reg_mux_temp = `REG_MODE0; ALU_MODE = `ALU_MODE0; NPC_MODE = `Normal; WriteMemory = 0; Sel_Sign = 0; end
//                    `ins_srav: begin ALU = `SRA;  reg_mux_temp = `REG_MODE0; ALU_MODE = `ALU_MODE0; NPC_MODE = `Normal; WriteMemory = 0; Sel_Sign = 0; end
//                    `ins_jr:begin NPC_MODE = `Jr; reg_mux_temp = `REG_MODE6; WriteMemory = 0; end //jr不需要考虑ALU的运算情况, 因为用不到
//                    default:    begin NPC_MODE = `Normal; WriteMemory = 0; reg_mux_temp = `REG_MODE6;end
//                endcase
//            end
//        `ins_addi:  begin ALU = `ADD;  reg_mux_temp = `REG_MODE3; ALU_MODE = `ALU_MODE2; NPC_MODE = `Normal; WriteMemory = 0; Sel_Sign = 1; end
//        `ins_addiu: begin ALU = `ADD;  reg_mux_temp = `REG_MODE3; ALU_MODE = `ALU_MODE2; NPC_MODE = `Normal; WriteMemory = 0; Sel_Sign = 1; end
//        `ins_andi:  begin ALU = `AND;  reg_mux_temp = `REG_MODE3; ALU_MODE = `ALU_MODE2; NPC_MODE = `Normal; WriteMemory = 0; Sel_Sign = 0; end
//        `ins_ori:   begin ALU = `OR;   reg_mux_temp = `REG_MODE3; ALU_MODE = `ALU_MODE2; NPC_MODE = `Normal; WriteMemory = 0; Sel_Sign = 0; end
//        `ins_xori:  begin ALU = `XOR;  reg_mux_temp = `REG_MODE3; ALU_MODE = `ALU_MODE2; NPC_MODE = `Normal; WriteMemory = 0; Sel_Sign = 0; end
//        `ins_sltiu: begin ALU = `SUB;  reg_mux_temp = zero_g==`SMALLER?`REG_MODE1:`REG_MODE2; ALU_MODE = `ALU_MODE2; NPC_MODE = `Normal; WriteMemory = 0; Sel_Sign = 0; end
//        `ins_lui:   begin ALU = `SLL;  reg_mux_temp = `REG_MODE3; ALU_MODE = `ALU_MODE3; NPC_MODE = `Normal; WriteMemory = 0; Sel_Sign = 0; end //将立即数左移16位
//        `ins_lw:    begin ALU = `ADD;  reg_mux_temp = `REG_MODE4; ALU_MODE = `ALU_MODE2; NPC_MODE = `Normal; WriteMemory = 0; Sel_Sign = 1; end   
//        `ins_sw:    begin ALU = `ADD;  reg_mux_temp = `REG_MODE6; ALU_MODE = `ALU_MODE2; NPC_MODE = `Normal; WriteMemory = 1; Sel_Sign = 1; end
//        `ins_beq:   begin ALU = `SUB;  reg_mux_temp = `REG_MODE6; ALU_MODE = `ALU_MODE0; NPC_MODE = `Beq;    WriteMemory = 0; Sel_Sign = 1; end
//        `ins_bne:   begin ALU = `SUB;  reg_mux_temp = `REG_MODE6; ALU_MODE = `ALU_MODE0; NPC_MODE = `Bne;    WriteMemory = 0; Sel_Sign = 1; end
//        `ins_bgtz:  begin ALU = `SUB;  reg_mux_temp = `REG_MODE6; ALU_MODE = `ALU_MODE0; NPC_MODE = `Bgtz;   WriteMemory = 0; Sel_Sign = 1; end
//        `ins_j:     begin reg_mux_temp = `REG_MODE6; NPC_MODE = `J_Jal; WriteMemory = 0; Sel_Sign = 0; end 
//        `ins_jal:   begin reg_mux_temp = `REG_MODE5; NPC_MODE = `J_Jal; WriteMemory = 0; Sel_Sign = 0; end//regmode5是把{PC+4}写到$31里
//        default:    begin NPC_MODE = `Normal; WriteMemory = 0; reg_mux_temp = `REG_MODE6; end
//        endcase
//    end
endmodule








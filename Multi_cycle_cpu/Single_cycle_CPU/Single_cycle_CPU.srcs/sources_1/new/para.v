`define STATE_INIT 3'd0
`define STATE_IDLE 3'd1
`define STATE_WRIT 3'd2
`define STATE_READ 3'd3
`define STATE_WORK 3'd4
`define STATE_RETU 3'd5      //参数后面不能有分号
`define ADD 4'd1
`define SUB 4'd2
`define SLL 4'd3
`define SRL 4'd4
`define SRA 4'd5
`define AND 4'd6
`define OR 4'd7
`define XOR 4'd8
`define NOR 4'd9

`define Jr 3'd0
`define J_Jal 3'd1
`define Beq 3'd2
`define Bgtz 3'd3
`define Bne 3'd3
`define Normal 3'd4

`define ins_add 6'b100000
`define ins_addu 6'b100001
`define ins_sub 6'b100010
`define ins_subu 6'b100011
`define ins_and 6'b100100
`define ins_or 6'b100101
`define ins_xor 6'b100110
`define ins_nor 6'b100111
`define ins_slt 6'b101010
`define ins_sltu 6'b101011
`define ins_sll 6'b000000
`define ins_srl 6'b000010
`define ins_sra 6'b000011
`define ins_sllv 6'b000100
`define ins_srlv 6'b000110
`define ins_srav 6'b000111
`define ins_jr 6'b001000
`define ins_addi 6'b001000
`define ins_addiu 6'b001001
`define ins_andi 6'b001100
`define ins_ori 6'b001101
`define ins_xori 6'b001110
`define ins_sltiu 6'b001011
`define ins_lui 6'b001111
`define ins_lw 6'b100011
`define ins_sw 6'b101011
`define ins_beq 6'b000100
`define ins_bne 6'b000101
`define ins_bgtz 6'b000111
`define ins_j 6'b000010
`define ins_jal 6'b000011


`define REG_MODE0 3'b00
`define REG_MODE1 3'b01
`define REG_MODE2 3'b10
`define REG_MODE3 3'b11
`define REG_MODE4 3'b100
`define REG_MODE5 3'b101
`define REG_MODE6 3'b110
`define REG_MODE7 3'b111


`define EQUAL 2'b00
`define GREATER 2'b01
`define SMALLER 2'b10

`define ALU_MODE0 3'b00
`define ALU_MODE1 3'b01
`define ALU_MODE2 3'b10
`define ALU_MODE3 3'b11
`define ALU_MODE4 3'b100
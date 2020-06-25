`timescale 1ns / 1ps
`include "para.v"
module ALU_mux(
    input [2:0]ALU_MODE,
    input [31:0]RF_RD1,
    input [31:0]RF_RD2,
    input [4:0]IM_10_6,
    input [31:0]EXTEND,
    output reg[31:0]OP_1,
    output reg[31:0]OP_2
    );
    always@*
    begin
        case(ALU_MODE)
        `ALU_MODE0: begin OP_1 = RF_RD1; OP_2 = RF_RD2; end
        `ALU_MODE1: begin OP_1 = IM_10_6; OP_2 = RF_RD2; end
        `ALU_MODE2: begin OP_1 = RF_RD1; OP_2 = EXTEND; end
        `ALU_MODE3: begin OP_1 = 32'h10; OP_2 = EXTEND; end
        `ALU_MODE4: begin OP_1 = RF_RD1; OP_2 = 32'b0; end
        endcase
    end
endmodule

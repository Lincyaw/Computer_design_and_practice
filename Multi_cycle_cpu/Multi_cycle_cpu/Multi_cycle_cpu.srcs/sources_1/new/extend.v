`timescale 1ns / 1ps
module extend(
    input [15:0]imm16,
    input Sign_Sel,
    output [31:0]ext
    );

    wire [31:0]imm32_s;
    wire [31:0]imm32_u;

    assign ext = Sign_Sel ? imm32_s : imm32_u;
    assign imm32_u = {16'h0000,imm16};
    assign imm32_s = (imm16[15]==1)?{16'hffff,imm16}:{16'h0000,imm16};

endmodule

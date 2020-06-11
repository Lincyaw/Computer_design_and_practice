`timescale 1ns / 1ps
module extend(
    input [15:0]imm16,
    input Sign_Sel,
    output [31:0]ext
    );

    reg [31:0]imm32_s;
    reg [31:0]imm32_u;

    assign ext = Sign_Sel ? imm32_s : imm32_u;

    always @*
    begin
        imm32_u = {16'h0000,imm16};
        if (imm16[15]==1) begin
            imm32_s = {16'hffff,imm16};
        end
        else
        begin
            imm32_s = {16'h0000,imm16};
        end
    end
endmodule

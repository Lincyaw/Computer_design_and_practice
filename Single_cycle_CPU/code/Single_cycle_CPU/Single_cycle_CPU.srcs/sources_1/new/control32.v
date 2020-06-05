`timescale 1ns / 1ps
module control32(
    input clk,
    input [31:0]instruction
    );


    wire op = instruction[31:26];
    wire rs = instruction[25:21];
    wire rt = instruction[20:16];
    wire rd = instruction[15:10];
    wire shamt = instruction[10:6];
    wire funct = instruction[5:0];
    wire imm16 = instruction[15:0];
    wire imm26 = instruction[25:0];


    always @ *
    begin
        case(op)
        6'b000000:
            begin
                
            end
        6'b001000:
            begin
                
            end
        endcase
    end
endmodule
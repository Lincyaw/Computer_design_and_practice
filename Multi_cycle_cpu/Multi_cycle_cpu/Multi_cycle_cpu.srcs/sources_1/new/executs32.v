`timescale 1ns / 1ps
`include "para.v"
module executs32(
    input clk,
    input [3:0]ALUop,
    input [31:0]first,
    input [31:0]second,
    output reg[31:0]answer,
    output [1:0]zerog
    ); 

reg [31:0]ans;


always@(posedge clk)
begin
    answer <= ans;
end


assign zerog = ans==0?`EQUAL:((ans[31]==0)?`GREATER:`SMALLER);

always@*
begin
    case (ALUop)
        `ADD:
            ans = first+second;
        `SUB:
            ans = first-second;
        `SLT:
            ans = ($signed(first)) < ($signed(second)) ? 32'hffffffff:32'h1;
        `SLL:
            ans = second<<first;
        `SRL:
            ans = second>>first;
        `SRA:
            ans = ($signed(second))>>>first;
        `AND:
            ans = first&second;
        `OR:
            ans = first|second;
        `XOR:
            ans = first^second;
        `NOR:
            ans = ~(first|second);
    endcase
end


endmodule



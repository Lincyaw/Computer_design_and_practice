`timescale 1ns / 1ps
`include "para.v"
module executs32(
    input clk,
    input [3:0]ALUop,
    input [31:0]first,
    input [31:0]second,
    output [31:0]answer,
    output [1:0]zero
    ); 

reg [31:0]ans;
reg [31:0]anst;
assign answer = ans;

always@(posedge clk)
begin
    anst <= ans;
end



reg [1:0]zerog;
assign zero = zerog;
always@*
begin
    if (ans==0) begin
        zerog = `EQUAL;
    end
    else if(ans>0)
    begin
        zerog = `GREATER;
    end
    else
    begin
        zerog = `SMALLER;
    end
end

always@*
begin
    case (ALUop)
        `ADD:
            ans = first+second;
        `SUB:
        begin
            ans = first-second;
        end
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



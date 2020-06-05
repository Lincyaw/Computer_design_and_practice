`timescale 1ns / 1ps
`include "para.v"
module executs32(
    input [3:0]op,
    input [31:0]first,
    input [31:0]second,
    output [31:0]answer,
    output zero
    ); 

reg [31:0]ans;
assign answer = ans;
reg zerog;
assign zero = zerog;
always@*
begin
    if (ans==0) begin
        zerog = 1;
    end
    else begin
        zerog = 0;
    end
    case (op)
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
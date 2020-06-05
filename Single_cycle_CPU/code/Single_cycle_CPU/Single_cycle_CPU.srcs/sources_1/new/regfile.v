`timescale 1ns / 1ps
module regfile(
    input clk,

    input [4:0]rd1,
    input rd1sel,
    output [31:0]Regdata1,

    input [4:0]rd2,
    input rd2sel,
    output [31:0]Regdata2,

    input [4:0]WriteAddr,
    input [31:0]WD,
    input WDsel
    );



    reg memread1;
    reg memread2;
    reg memwrite;
    reg [31:0] imem[31:0]; //32

always @(posedge clk)   begin
    memread1 <= rd1sel;
    memread2 <= rd2sel;
    memwrite <= WDsel;
end

assign Regdata1 = memread1 ? imem[rd1] : 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;
assign Regdata2 = memread2 ? imem[rd2] : 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;

always @(posedge clk)   begin
    if(memwrite)    begin
        imem[WriteAddr] <= WD;
    end
end

    


endmodule

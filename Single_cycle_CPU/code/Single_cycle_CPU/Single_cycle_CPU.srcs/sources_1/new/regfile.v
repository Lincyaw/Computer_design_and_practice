`timescale 1ns / 1ps
module regfile(
    input clk,

    input [4:0]rd1,
    output [31:0]Regdata1,

    input [4:0]rd2,
    output [31:0]Regdata2,

    input [4:0]WriteAddr,
    input [31:0]WD,
    input WDsel
    );

    reg memwrite;
    reg [31:0] imem[31:0]; //32

always @(posedge clk)   begin
    memwrite <= WDsel;
end

assign Regdata1 = imem[rd1];
assign Regdata2 = imem[rd2];

always @(posedge clk)   begin
    if(memwrite)    begin
        imem[WriteAddr] <= WD;
    end
end

    


endmodule

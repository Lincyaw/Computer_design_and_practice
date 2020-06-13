`timescale 1ns / 1ps
module regfile(
    input clk,
    input fpga_rst,
    input [4:0]rd1,
    output [31:0]Regdata1,

    input [4:0]rd2,
    output [31:0]Regdata2,

    input [4:0]WriteAddr,
    input [31:0]WD,
    input WDsel
    );
    reg [31:0] imem[31:0]; //32

integer i=0; //be careful, i should be integer!
assign Regdata1 = imem[rd1];
assign Regdata2 = imem[rd2];

always @(posedge clk)   
begin
    if(WDsel)    
    begin
        imem[WriteAddr] <= WD;
    end
    if(fpga_rst)
    begin
        for(i = 0;i <= 31;i = i+1)
        begin
            imem[i]<=0;
        end
    end
end

    


endmodule

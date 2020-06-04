module programrom(
    input clock,
    input [31:0]address
    );
    wire clk;
    assign clk = !clock; // 因为使用芯片的固有延迟，RAM 的地址
//线来不及在时钟上升沿准备好, 使得时钟上升沿数据读出有误，
//所以采用反相时钟，使得读出数据比地址准备好要晚大约半个时钟，从而得到正确地址。


////分配 64KB ROM，
//prgrom instmem(
//    .clka(clock), // input wire clka
//    .addra(PC[15:2]), // input wire [13 : 0] addra
//    .douta(Instruction) // output wire [31 : 0] douta
//);

endmodule
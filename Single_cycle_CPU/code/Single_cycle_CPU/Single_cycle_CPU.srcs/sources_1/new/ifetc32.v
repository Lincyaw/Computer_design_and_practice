module ifetc32(
    input clock,
    input [31:0]PC,
    output [31:0]Instruction
    );

    //∑÷≈‰ 64KB ROM£¨
    prgrom instmem(
        .clka(clock), // input wire clka
        .addra(PC[15:2]), // input wire [13 : 0] addra
        .douta(Instruction) // output wire [31 : 0] douta
    );

endmodule
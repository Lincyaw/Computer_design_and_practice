module ifetc32(
    input clock,
    input IRWr,
    input [31:0]PC,
    output reg[31:0]IR
    );

    wire [31:0]Instruction;
    prgrom instmem(
        .clka(clock), // input wire clka
        .addra(PC[15:2]), // input wire [13 : 0] addra
        .douta(Instruction) // output wire [31 : 0] douta
    );
    always@(posedge clock)
    begin
        IR <= IRWr?Instruction:IR;
    end

endmodule
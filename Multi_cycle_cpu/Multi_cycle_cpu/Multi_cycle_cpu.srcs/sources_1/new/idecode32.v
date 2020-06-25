`timescale 1ns / 1ps
module NPC(
    input clk,
    input rst,
    input [2:0]ModeSel,
    input [31:0]PC,
    input [31:0]Offset,
    input [31:0]Instruction,
    input [1:0]zerog,
    output reg[31:0]Npc
    );
    wire [31:0] pc_ext;
    

    extend U1(
    Instruction[15:0],
    1'b1,
    pc_ext
    );


    always @*
    begin
        if(rst)
        begin
            Npc = 0;
        end
        else
        begin
            case (ModeSel)
            `Jr:begin
                Npc = Offset;
            end
            `J_Jal:begin
                Npc = {4'b0,Instruction[25:0],2'b0};
            end
            `Beq:begin
                Npc = zerog == `EQUAL? PC+(pc_ext<<2) : PC+4;
            end
            `Bne:begin
                Npc = zerog == `EQUAL? PC+4 : PC+(pc_ext<<2);
            end
            `Bgtz:begin
                Npc = zerog == `GREATER? PC+(pc_ext<<2):PC+4;
            end
            `Normal: Npc = PC+4;
        endcase
        end
        
    end
endmodule
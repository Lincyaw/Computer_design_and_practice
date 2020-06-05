`timescale 1ns / 1ps
module NPC(
    input clk,
    input [2:0]ModeSel,
    input [31:0]PC,
    input [31:0]Offset,
    input zero,
    output [31:0]Npc
    );
    reg [31:0] pc_t;
    assign Npc = pc_t;
    always @(posedge clk)
    begin
        case (ModeSel)
            `Jr:begin
                pc_t <= Offset;
            end
            `J_Jal:begin
                pc_t <= {4'b0,PC[25:0],2'b0};
            end
            `Beq_Bne_Bgtz:begin
                pc_t <= {14'b0,PC[15:0],2'b0};
            end
            default: pc_t <= PC+4;
        endcase
    end
endmodule
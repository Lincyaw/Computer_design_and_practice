`timescale 1ns / 1ps
module NPC(
    input clk,
    input [2:0]ModeSel,
    input [31:0]PC,
    input [31:0]Offset,
    input [31:0]Instruction,
    input [1:0]zerog,
    output [31:0]Npc,
    output [31:0]PC4
    );
    reg [31:0] pc_t;
    assign Npc = pc_t;
    reg [31:0]pc4temp;
    assign PC4 = pc4temp;
    wire [31:0] pc_ext;
    

    extend U1(
    Instruction[15:0],
    1'b1,
    pc_ext
    );


    always @(posedge clk)
    begin
        pc4temp <= PC+4;
    end

    always @*
    begin
        case (ModeSel)
            `Jr:begin
                pc_t <= Offset;
            end
            `J_Jal:begin
                pc_t <= {4'b0,Instruction[25:0],2'b0};
            end
            `Beq:begin
                pc_t <= zerog == `EQUAL? PC+(pc_ext<<2)+4 : PC+4;
            end
            `Bne:begin
                pc_t <= zerog == `EQUAL? PC+4 : PC+(pc_ext<<2)+4;
            end
            `Bgtz:begin
                pc_t <= zerog == `GREATER? (pc_ext<<2)+4:PC+4;
            end
            `Normal: pc_t <= PC+4;
        endcase
    end
endmodule
`timescale 1ns / 1ps
`include "para.v"
module reg_mux(
    input [2:0]mode,
    input [1:0]zero_g,
    input [4:0]IMD20_16,
    input [4:0]IMD15_11,
    output [4:0]WriteAddr,
    input [31:0]WD_ALU,
    input [31:0]WD_DMRD,
    input [31:0]WD_PC4,
    output [31:0]WD,
    output WDsel
    );
    reg [4:0]Write;
    assign WriteAddr = Write;
    reg [31:0]WD_out;
    assign WD = WD_out;

    reg WD_sel;
    assign WDsel = WD_sel;
    always@*
    begin
        case(mode)
        `REG_MODE0: begin Write = IMD15_11; WD_out = WD_ALU; WD_sel = 1; end
        `REG_MODE1: begin Write = IMD20_16; WD_out = (zero_g==`SMALLER) ? 32'b1:32'b0; WD_sel = 1; end
        `REG_MODE2: begin Write = IMD15_11; WD_out = (zero_g==`SMALLER) ? 32'b1:32'b0; WD_sel = 1; end
        `REG_MODE3: begin Write = IMD20_16; WD_out = WD_ALU; WD_sel = 1; end
        `REG_MODE4: begin Write = IMD20_16; WD_out = WD_DMRD; WD_sel = 1; end 
        `REG_MODE5: begin Write = 5'b11111; WD_out = WD_PC4; WD_sel = 1; end  //$31
        `REG_MODE6: begin WD_sel = 0; end
        endcase
    end

endmodule

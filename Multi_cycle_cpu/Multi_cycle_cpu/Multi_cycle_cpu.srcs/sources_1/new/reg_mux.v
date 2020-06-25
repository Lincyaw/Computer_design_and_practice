`timescale 1ns / 1ps
`include "para.v"
module reg_mux(
    input [2:0]mode,
    input [1:0]zero_g,
    input [4:0]IMD20_16,
    input [4:0]IMD15_11,
    output reg[4:0]WriteAddr,
    input [31:0]WD_ALU,
    input [31:0]WD_DMRD,
    input [31:0]WD_PC4,
    output reg[31:0]WD,
    output reg WDsel
    );

    always@*
    begin
        case(mode)
        `REG_MODE0: begin WriteAddr = IMD15_11; WD = WD_ALU; WDsel = 1; end
        `REG_MODE1: begin WriteAddr = IMD20_16; WD = (zero_g==`SMALLER) ? 32'b1:32'b0; WDsel = 1; end
        `REG_MODE2: begin WriteAddr = IMD15_11; WD = (zero_g==`SMALLER) ? 32'b1:32'b0; WDsel = 1; end
        `REG_MODE3: begin WriteAddr = IMD20_16; WD = WD_ALU; WDsel = 1; end
        `REG_MODE4: begin WriteAddr = IMD20_16; WD = WD_DMRD; WDsel = 1; end 
        `REG_MODE5: begin WriteAddr = 5'b11111; WD = WD_PC4; WDsel = 1; end  //$31
        `REG_MODE6: begin WDsel = 0; end
        endcase
    end

endmodule

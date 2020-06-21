`timescale 1ns / 1ps
module cpuclk0(
    input clk_in1,
    output clk_out1
    );
    cpuclk UCLK(
        .clk_in1(clk_in1), 
        .clk_out1(clk_out1)
    );
endmodule


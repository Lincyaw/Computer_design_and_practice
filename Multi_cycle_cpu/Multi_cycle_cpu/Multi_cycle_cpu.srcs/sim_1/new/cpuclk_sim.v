//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/04 10:21:08
// Design Name: 
// Module Name: cpuclk_sim
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps
module cpuclk_sim( );
    // INPUT
    reg pclk = 0;
    //output
    wire clock;
    cpuclk UCLK(
        .clk_in1(pclk), 
        .clk_out1(clock)
    );
    
    always #5 pclk = ~pclk;
endmodule
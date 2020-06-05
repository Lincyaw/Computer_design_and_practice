`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/05 11:03:45
// Design Name: 
// Module Name: 16bit_extend_sim
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


module bit16_extend_sim(

    );
        reg [15:0]imm16;
    wire [31:0]sign_ext;
    wire [31:0]unsign_ext;
    
    extend test (
    imm16,
    sign_ext,
    unsign_ext
    );
    
    initial begin
    #100 imm16=16'h8000;
    #100 imm16=16'h06E0;
    
    end
endmodule

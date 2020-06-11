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
    reg sign_sel;
    wire [31:0]ext;
    
    extend test(
    imm16,
    sign_sel,
    ext
    );
    
    initial begin
    #100  begin imm16=16'h8000; sign_sel = 1;end
    #100  begin imm16=16'h8000; sign_sel = 0;end
     #100 begin imm16=16'h06E0;   sign_sel = 1;end
    #100 begin imm16=16'h06E0;   sign_sel = 0;end
    
    end
endmodule

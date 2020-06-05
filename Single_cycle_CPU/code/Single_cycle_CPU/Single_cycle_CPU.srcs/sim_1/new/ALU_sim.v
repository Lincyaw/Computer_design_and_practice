`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/05 09:35:22
// Design Name: 
// Module Name: ALU_sim
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
`define ADD 4'd1
`define SUB 4'd2
`define SLL 4'd3
`define SRL 4'd4
`define SRA 4'd5
`define AND 4'd6
`define OR 4'd7
`define XOR 4'd8
`define NOR 4'd9

module ALU_sim(

    );
    
    reg [31:0]val1;
    reg [31:0]val2;
    wire [31:0]answer;
    reg [3:0]op;
    wire zero;
    executs32 test(op,val1,val2,answer,zero);
    
    initial begin
    #100 begin op=`ADD;val1=32'd3;val2=32'd4; end  //7
    #100 begin op=`SUB;val1=32'd5;val2=32'd1; end  //4
    #100 begin op=`SUB;val1=32'd5;val2=32'd5; end  //4
    #100 begin op=`SLL;val1=32'b11;val2=32'b1101; end  //1101000
    #100 begin op=`SRL;val1=32'd5;val2=32'b1110010; end //11
    #100 begin op=`SRA;val1=32'd3;val2=32'h8000ffff; end  //f0001fff
    #100 begin op=`AND;val1=32'd5;val2=32'hf; end
    #100 begin op=`OR;val1=32'hff;val2=32'd1; end
    
    end
    
endmodule

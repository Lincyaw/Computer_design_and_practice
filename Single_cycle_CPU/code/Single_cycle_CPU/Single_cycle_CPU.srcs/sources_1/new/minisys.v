`timescale 1ns / 1ps
module minisys(

    );
endmodule




// minisys:
//          cpuclk.v   时钟源
//                  输出23MHz时钟频率
//          dmemory.v  数据存储器
//                  调用ip核
//          ifetch.v   指令存储器
//                  调用ip核
//          executs.v  ALU
//                  输入操作符,两个操作数
//                  输出结果,zero标志位
//          regfile.v  寄存器组
//                  输入读寄存器1选择信号,寄存器1编号,输出读寄存器1的数据
//                  输入读寄存器2选择信号,寄存器2编号,输出读寄存器2的数据
//                  输入写寄存器3选择信号,寄存器3编号,写寄存器3的数据
//          extend.v   16位拓展成32位
//                  输入16位数
//                  输出32位的无符号拓展和有符号拓展


//还少了    1. 控制单元
//          2. NPC


module programrom(
    input clock,
    input [31:0]address
    );
    wire clk;
    assign clk = !clock; // ��Ϊʹ��оƬ�Ĺ����ӳ٣�RAM �ĵ�ַ
//����������ʱ��������׼����, ʹ��ʱ�����������ݶ�������
//���Բ��÷���ʱ�ӣ�ʹ�ö������ݱȵ�ַ׼����Ҫ���Լ���ʱ�ӣ��Ӷ��õ���ȷ��ַ��


////���� 64KB ROM��
//prgrom instmem(
//    .clka(clock), // input wire clka
//    .addra(PC[15:2]), // input wire [13 : 0] addra
//    .douta(Instruction) // output wire [31 : 0] douta
//);

endmodule
start:
    lui   $5,0xFFFF          # let $28 = 0xFFFF0000 as the upper 16 bits of the port address
    ori   $28,$5,0xF000      # $28 port is the upper 20 bits of the system's I/O address
    lw   $5,0xC72($28)
	andi $9,$5,0x0020
	bne $9,$0,start         #sw21==1�����¶�
	andi $6,$5,0x0080        #��־λ, ���Ƿ�������
	andi $5,$5,0x0040
	bne $5,$0,square         #���������0,˵������ƽ����
	bne $6,$0,square         #���������0,˵������������,����������ǵ���ƽ��
	j finish
square: 
    lui   $1,0xFFFF          # let $28 = 0xFFFF0000 as the upper 16 bits of the port address
    ori   $28,$1,0xF000      # $28 port is the upper 20 bits of the system's I/O address
    lw   $1,0xC70($28)       # ��ȡ�������������
    andi $1,0xF              #ֻ�������4λ
    andi $2,0x0	             #���$2,��Ϊ����
	add  $2,$1,$2            #$2=$1+0 ��ʼ������

	andi $8,0x0              #���$8
	add  $8,$1,$8            # $8=$1+0,$8��Ϊ����
	#$2�����ж��Ǽӳ������Ǽ�0
	#$1�ǲ��ֻ�,Ҳ�����յĽ��
	#$3��ÿ�������ӵĳ���
    sll $1,$1,4             #����4λ,���λ�����������λ���Ǹ�����, �ö�������4λȥ���λ,$1��Ϊ���ֻ�
    andi $3,0x0              #���$3
	add  $3,$1,$3            # $3=$1+0,$3��Ϊÿ�μӵ���
	andi $4,0x0
	ori $4,0x000F           #��ʼ��$4Ϊ������,��Ϊ��4λ�˷�
	andi $1,0x0              #���$1

multi:
	andi $5,0x0
	andi $5,$2,0x1           #�ж�$2�����λ�ǲ���0
	beq $5,$0,zero           #��0�Ļ���ת
	#���������,��ôҪ��
	add $1,$1,$3             #����������
	j judge
zero:
	# ����һ�������и���0�Ĳ���
judge:
	srl $1,$1,0x1            #����һλ
	srl $2,$2,1              #����һλ
	srl $4,$4,1              #$4>>1
	beq $4,$0,cube         #����0�����
	j multi
cube:
	beq $6,$0,finish   #û������,�ͽ���
	bne $7,$0,finish   #�������һ����,�Ǿ�Ҳ����
	#�����$3��$2,���³�һ��
	andi $2,0x0
	or $2,$2,$8
	#��$1��$3, ���ڵ�$1��8λ��,$3��Ϊÿ�������ӵĶ���
	sll $1,$1,4  #����4λ
	andi $3,0x0
	or $3,$3,$1
	#�ٰ�$1���,��Ϊ���ֻ�
	andi $1,0x0
	#��$7�÷�0,��Ϊ��־λ
	ori $7,0xFFFF
	#Ȼ���ٴ����г˷�
	ori $4,0x000F
	j multi

finish:
	#andi $1,0xFFF
	sw $1,0xC60($28)         # write led
	sw $1,0x0($0)
	
reset:#sw21, ����
    lui   $5,0xFFFF          # let $28 = 0xFFFF0000 as the upper 16 bits of the port address
    ori   $28,$5,0xF000      # $28 port is the upper 20 bits of the system's I/O address
	lw   $5,0xC72($28)
	andi $5,$5,0x0020
    beq $5,$0,reset           #���û��sw21
    #������������
	
	andi $7,$7,0x0  #�ѱ�־λ$7���
	andi $1,$1,0x0  #��$1���
	sw $1,0xC60($28)
	sw $0,0x0($0)
	j start
    
    

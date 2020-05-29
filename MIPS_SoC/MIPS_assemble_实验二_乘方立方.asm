start:
    lui   $5,0xFFFF          # let $28 = 0xFFFF0000 as the upper 16 bits of the port address
    ori   $28,$5,0xF000      # $28 port is the upper 20 bits of the system's I/O address
    lw   $5,0xC72($28)
	andi $9,$5,0x0020
	bne $9,$0,start         #sw21==1则重新读
	andi $6,$5,0x0080        #标志位, 看是否按了立方
	andi $5,$5,0x0040
	bne $5,$0,square         #如果不等于0,说明按了平方乘
	bne $6,$0,square         #如果不等于0,说明按了立方乘,但是最初还是得先平方
	j finish
square: 
    lui   $1,0xFFFF          # let $28 = 0xFFFF0000 as the upper 16 bits of the port address
    ori   $28,$1,0xF000      # $28 port is the upper 20 bits of the system's I/O address
    lw   $1,0xC70($28)       # 读取拨盘上输入的数
    andi $1,0xF              #只保留最后4位
    andi $2,0x0	             #清空$2,作为乘数
	add  $2,$1,$2            #$2=$1+0 初始化乘数

	andi $8,0x0              #清空$8
	add  $8,$1,$8            # $8=$1+0,$8作为备份
	#$2用来判断是加乘数还是加0
	#$1是部分积,也是最终的结果
	#$3是每次用来加的乘数
    sll $1,$1,4             #左移4位,最高位是用来保存进位的那个东西, 让读进来的4位去最高位,$1作为部分积
    andi $3,0x0              #清空$3
	add  $3,$1,$3            # $3=$1+0,$3作为每次加的数
	andi $4,0x0
	ori $4,0x000F           #初始化$4为计数器,因为是4位乘法
	andi $1,0x0              #清空$1

multi:
	andi $5,0x0
	andi $5,$2,0x1           #判断$2的最低位是不是0
	beq $5,$0,zero           #是0的话跳转
	#如果不等于,那么要加
	add $1,$1,$3             #两个加起来
	j judge
zero:
	# 想象一下这里有个加0的操作
judge:
	srl $1,$1,0x1            #右移一位
	srl $2,$2,1              #右移一位
	srl $4,$4,1              #$4>>1
	beq $4,$0,cube         #等于0则结束
	j multi
cube:
	beq $6,$0,finish   #没按立方,就结束
	bne $7,$0,finish   #如果乘了一次了,那就也结束
	#否则把$3给$2,重新乘一遍
	andi $2,0x0
	or $2,$2,$8
	#把$1给$3, 现在的$1是8位的,$3作为每次用来加的东西
	sll $1,$1,4  #左移4位
	andi $3,0x0
	or $3,$3,$1
	#再把$1清空,作为部分积
	andi $1,0x0
	#把$7置非0,作为标志位
	ori $7,0xFFFF
	#然后再次运行乘法
	ori $4,0x000F
	j multi

finish:
	#andi $1,0xFFF
	sw $1,0xC60($28)         # write led
	sw $1,0x0($0)
	
reset:#sw21, 清零
    lui   $5,0xFFFF          # let $28 = 0xFFFF0000 as the upper 16 bits of the port address
    ori   $28,$5,0xF000      # $28 port is the upper 20 bits of the system's I/O address
	lw   $5,0xC72($28)
	andi $5,$5,0x0020
    beq $5,$0,reset           #如果没按sw21
    #这里加清零过程
	
	andi $7,$7,0x0  #把标志位$7清空
	andi $1,$1,0x0  #把$1清空
	sw $1,0xC60($28)
	sw $0,0x0($0)
	j start
    
    

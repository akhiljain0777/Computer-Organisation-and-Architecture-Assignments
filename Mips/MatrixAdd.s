# Akhil Jain (14CS10003)
# Shubham Jain (14CS10043) 
# Group no. 8
# Matrix Addition

	.text
	.globl main

main:

	move $fp,$sp
	subu $sp,$sp,12			# allocate space for s,m,n

	li $v0,4
	la $a0,prompt
	syscall				#print the prompt

	li $v0,5			#scan s
	syscall

	sw $v0,0($fp)			#store s


	li $v0,5			#scan m
	syscall		

	sw $v0,-4($fp)			#store m

	li $v0,5			#scan n
	syscall

	sw $v0,-8($fp)			#store n
	
	lw $t1,-4($fp)			
	multu $v0,$t1
	mflo $t1			#t1=m*n

	li $t0,4
	multu $t0,$t1
	mflo $t0			#t0=4*m*n

	subu $sp,$sp,$t0		#allocate space for array a
	addi $s0,$sp,4

	subu $sp,$sp,$t0		#allocate space for array b
	addi $s1,$sp,4

	subu $sp,$sp,$t0		#allocate space for array c
	addi $s2,$sp,4

	lw $t3,0($fp)
	li $t4,330			#constant a
	li $t5,100			#constant c
	li $t6,2303			#constant m
	
	li $t7,0			#i
	move $t8,$s0			#Ai
	move $t9,$t3			#Xn

	sw $t9,0($t8)			#A0=s
	add $t7,$t7,1			#i++
	add $t8,$t8,4			

loop:
	bge $t7,$t1,outofloop		#i>=m*n break

	multu $t4,$t9			
	mflo $t9
	add $t9,$t9,$t5
	div $t9,$t6
	mfhi $t9			#t9 = (a*X(n-1)+c)%m

	
	sw $t9,0($t8)			#Xn=t9

	add $t7,$t7,1			#i++
	add $t8,$t8,4
	
	j loop

outofloop:

	li $t7,0
	move $t8,$s1
	addi $t9,$t3,10

	sw $t9,0($t8)
	add $t7,$t7,1
	add $t8,$t8,4

loop2:					#populating b
	bge $t7,$t1,outofloop2

	multu $t4,$t9
	mflo $t9
	add $t9,$t9,$t5
	div $t9,$t6
	mfhi $t9

	
	sw $t9,0($t8)

	add $t7,$t7,1
	add $t8,$t8,4
	
	j loop2

outofloop2:

	li $v0,4			#printA
	la $a0,printA
	syscall	

	move $a0,$s0
	lw $a1,-4($fp)
	lw $a2,-8($fp)
	jal matPrint

	li $v0,4
	la $a0,printB
	syscall	

	move $a0,$s1
	lw $a1,-4($fp)
	lw $a2,-8($fp)
	jal matPrint			#printB

	move $a0,$s0
	move $a1,$s1
	move $a2,$s2
	lw $s6,-4($fp)
	lw $s7,-8($fp)
	jal matAddition			#C=A+B

	li $v0,4
	la $a0,printC
	syscall				#print C

	move $a0,$s2
	lw $a1,-4($fp)
	lw $a2,-8($fp)
	jal matPrint

	j exit
	

	.globl matPrint

matPrint:				#print Array

	li $s3,0
	move $s4,$a0
	multu $a1,$a2
	mflo $s5
	
printloop:

	bge $s3,$s5,outofprintloop

	li $v0,1
	lw $a0,0($s4)
	syscall

	li $v0,4
	la $a0,space
	syscall


	add $s3,$s3,1
	add $s4,$s4,4
	
	div $s3,$a2
	mfhi $s6
	beqz $s6,nextlinecall

	j printloop

nextlinecall:

	li $v0,4
	la $a0,nextline
	syscall
	j printloop
	

outofprintloop:

	li $v0,4
	la $a0,nextline
	syscall

	jr $ra



	.globl matAddition

matAddition:				# add array function

	li $t3,0
	move $t4,$a0
	move $t5,$a1
	move $t6,$a2
	multu $s6,$s7
	mflo $t7
	
addloop:

	bge $t3,$t7,outofaddloop

	lw $t0,0($t4)
	lw $t1,0($t5)
	
	add $t2,$t0,$t1
	
	sw $t2,0($t6)

	add $t3,$t3,1
	add $t4,$t4,4
	add $t5,$t5,4
	add $t6,$t6,4
	
	j addloop

outofaddloop:

	jr $ra



	
exit:				#exit
	li $v0,10
	syscall




	.data

prompt: .asciiz "Enter three positive integers s, m and n: \n"
space: .asciiz " "
nextline: .asciiz "\n"
printA: .asciiz "The content of A:-\n"
printB: .asciiz "The content of B:-\n"
printC: .asciiz "The content of C:-\n"



# Akhil Jain (14CS10003)
# Shubham Jain (14CS10043) 
# Group no. 8
# Fibonacci words


	.text
	.globl main

main:

	li $v0,4				#parameter for print string
	la $a0,prompt				#string prompt is to be printed
	syscall					#call print function

	move $fp,$sp
	subu $sp,$sp,4		

	li $v0,5				#scan integer
	syscall					#call scan function

	sw $v0,4($sp)

	move $a1,$sp				#storage for f(n-1)
	subu $sp,$sp,4				
	move $a2,$sp				#storage for f(n-2)
	subu $sp,$sp,4				
	move $a0,$sp				#storage for c
	lw $a3,0($fp)

	jal fibWord				#call fibWord Function

	j exit					#return 


	.text
	.globl fibWord


fibWord:
	li $s0,2				#s0=2 for base case
	addiu $fp,$fp,4				#store return address
	sw $ra,0($fp)				
	beq $a3,$s0,base			#go to base case 
	subu $a3,$a3,1				#a3=a3-1
	jal fibWord				#call function
	addi $a3,$a3,1				#a3=a3+1
	lw $t1,0($a2)				#updated f(n-1) and f(n-2)
	lw $t2,0($a1)				
	sw $t2,0($a2)				
	addu $t1,$t1,$t2			
	sw $t1,0($a1)
	li $t1,0
	lw $t2,0($a2)
	lw $t3,0($a1)
	move $t4,$a0
	subu $t5,$t4,$t3

Loop:
	bge $t1,$t2,outL			#t1<f(n-2)
	lb $t6,0($t4)
	sb $t6,0($t5)				#update C
	subu $t4,$t4,1
	subu $t5,$t5,1
	addu $t1,$t1,1
	j Loop

outL:
	move $s7,$a0

	li $v0,4				#parameter for print string
	la $a0,S				#string S is to be printed
	syscall					#call print function


	move $a0,$a3
	li $v0,1
	syscall


	li $v0,4				#parameter for print string
	la $a0,S_				#string S_ is to be printed
	syscall					#call print function

	move $a0,$s7

	li $t1,0
	lw $t2,0($a1)
	lw $t3,0($a2)
	add $t4,$t3,$t2
	move $t5,$a0


printLoop:					#print the string C
	bge $t1,$t4,outPL
	move $s7,$a0
	lb $a0,0($t5)
	li $v0,11
	syscall
	move $a0,$s7
	subu $t5,$t5,1
	addiu $t1,$t1,1
	j printLoop


outPL:
	move $s7,$a0
	li $v0,4				#parameter for print string
	la $a0,nL		    		#string \n is to be printed
	syscall					#call print function
	move $a0,$s7
	lw $ra,0($fp)
	subu $fp,$fp,4

	jr $ra


base:						#print the base case and return 
	li $s1,'0'
	sb $s1,0($a0) 
	li $s1,'1'
	sb $s1,-1($a0)
	li $s1,'0'
	sb $s1,-2($a0) 
	li $s1,1
	sw $s1,0($a2)
	li $s1,2
	sw $s1,0($a1)

	
	move $s7,$a0

	li $v0,4				#parameter for print string
	la $a0,S0					#string S0 is to be printed
	syscall					#call print function

	li $v0,4				#parameter for print string
	la $a0,S1			    #string S1 is to be printed
	syscall					#call print function


	li $v0,4				#parameter for print string
	la $a0,S2			    #string S2 is to be printed
	syscall					#call print function

	move $a0,$s7

	lw $ra,0($fp)				#restore ra
	subu $fp,$fp,4

	jr $ra					#return 

exit:						
	li $v0,10				#exit
	syscall


.data

	prompt: .asciiz  "Enter an integer m (no less than 2): "
	S: .asciiz "S["
	S_: .asciiz "] : "
	S0: .asciiz "S[0] : 0\n"
	S1: .asciiz "S[1] : 01\n"	
	S2: .asciiz "S[2] : 010\n"
	nL: .asciiz "\n"

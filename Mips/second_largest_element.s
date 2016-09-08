# Akhil Jain (14CS10003)
# Shubham Jain (14CS10043) 
# Group no. 8
# Second largest element of array


	.text
	.globl main
	
main:

	move $fp,$sp
	subu $sp,$sp,4 
	
	li $v0,4
	la $a0,prompt
	syscall
	
	li $v0,5
	syscall
	
	li $t0,1
	bleu $v0,$t0,Exception
	
	sw $v0,-4($fp)
	
	li $t0,4
	multu $v0,$t0
	mflo $t0
	
	subu $sp,$sp,$t0
	
	li $t0,0
	move $t1,$v0
	move $t2,$sp
	
ReadEl:
	
	bge $t0,$t1,Initial
	
	li $v0,4
	la $a0,scanEl
	syscall
	
	li $v0,5
	syscall
	
	sw $v0,0($t2)
	addiu $t2,$t2,4
	addiu $t0,$t0,1
	j ReadEl
	
Initial:
	lw $s2,0($sp)
	lw $s3,4($sp)
	bge $s2,$s3,Initial2
	lw $s1,0($sp)
	lw $s0,4($sp)
	j InitLoop

Initial2:
	lw $s0,0($sp)
	lw $s1,4($sp)
	
InitLoop:
	li $t0,2
	move $t2,$sp
	addiu $t2,$t2,8
	
Loop:
	bge $t0,$t1,Output
	lw $s2,0($t2)
	bge $s2,$s0,IF
	bge $s2,$s1,ELSEIF
	j Inc
	
IF:
	move $s1,$s0
	lw $s0,0($t2)
	j Inc
	
ELSEIF:
	lw $s1,0($t2)
	j Inc
	

Inc:
	addiu $t2,$t2,4
	addiu $t0,$t0,1
	j Loop
	
Output:
	li $v0,4
	la $a0,message
	syscall
	
	
	li $t0,0
	move $t2,$sp
	
printEl:
	bge $t0,$t1,Output2
	li $v0,1
	lw $a0,0($t2)
	syscall
	
	li $v0,4
	la $a0,comma
	syscall
	
	addiu $t2,$t2,4
	addiu $t0,$t0,1	
	
	j printEl
	
Output2:
	li $v0,4
	la $a0,message2
	syscall
	
	li $v0,1
	move $a0,$s1
	syscall
	
	li $v0,4
	la $a0,endPoint
	syscall
	j exit
	
	
Exception:
	li $v0,4
	la $a0,exceptionMsg
	syscall
	
	
exit:
	li $v0, 10 				#parameter to exit 
	syscall					#call exit function
		
	
	
	.data
prompt: .asciiz "Enter the count of elements to be read:\n"
scanEl: .asciiz "Enter the next element:\n"
message: .asciiz "The second number among ["
message2: .asciiz "] is "
endPoint: .asciiz ".\n"
comma: .asciiz ", "
exceptionMsg: .asciiz "The size of the array is less than 2\n"


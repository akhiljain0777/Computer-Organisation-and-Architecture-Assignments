	.text
	.globl main

main: 
	
	li $v0,4 			#parameter for syscall to print string
	la $a0,prompt		#the content of the string to print
	syscall				#calling the system to execute printing

	li $v0,5			#parameter for syscall to scan integer
	syscall				#calling the system to execute reading

	move $s0,$v0		#move the value read in v0 to s0 register
	li $s1,0			#load register s1 with value 0
	li $s2,1			#load register s2 with value 1

Loop:
	bgeu $s2,$s0,output 	#if i(s2) > = n(s0) exit the loop and got output section 
	remu $t0,$s0,$s2		#get t0 = (n%i)
	bnez $t0,Inc			#if (n%i is not equal to zero) goto increment area directly
	addu $s1,$s1,$s2		#do sum(s1) = sum(s1) + i(s2)

Inc:
	addi $s2,$s2,1			#i=i+1
	j Loop 					#jump to the beginning of the loop

output:
	move $a0,$s0			#a0 is the value of n
	li $v0,1				#parameter for syscall to print integer
	syscall					#function call for printing
	beq $s0,$s1,out0		#if n is not equal to sum goto out0 (is a perfect number logic)
	li $v0,4				#print string parameter for syscall
	la $a0,output1			#print "is not a perfect number"
	syscall					#call printing function
	j exit					#go to exit
	

out0:
	li $v0,4				#parameter for printing string
	la $a0,output0			#the string " is a perfect number"
	syscall					#call function to execute printing

exit:
	li $v0, 10 				#parameter to exit 
	syscall					#call exit function


	.data
prompt:  .asciiz "Enter a positive integer:\n "
output0: .asciiz " is a perfect number.\n"
output1: .asciiz " is not a perfect number.\n"
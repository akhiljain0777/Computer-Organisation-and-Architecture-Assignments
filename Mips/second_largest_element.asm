# Akhil Jain (14CS10003)
# Shubham Jain (14CS10043) 
# Group no. 8
# Second largest element of array


	.text
	.globl main
	
main:
	li $v0,4
	la $a0,prompt
	syscall
	
	li $v0,5
	syscall
	
	
	
	
	
	
	
	
	.data
prompt: .asciiz "Enter the count of elements to be read:\n"
message: .asciiz "The second number among ["
mesasge2: .asciiz "] is "
endpoint: .asciiz "."



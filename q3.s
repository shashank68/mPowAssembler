	.data
	str: .asciiz "Hello World!"

	.text
main:

	la $a0,str		#loading string into register
	
	.end

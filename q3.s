	.data
	str: .asciiz "Hello World!"

	.text
main:

	la 18,str		#loading string into register
	sc 4
	.end

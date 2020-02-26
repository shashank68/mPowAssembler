.data
array: .word 1 2 3 4 5 6 7 8 9 10
sum: .word 0
length: .word 10


.text

main:
addi 8, 0, 0
la 11, array
la 10, length
la 16, sum
lwz 10, 0(10)
addi 10, 10,-1
addi 9, 0, 0

loop:
cmp 7, 1, 9, 10
bca 0, 28, exit
cmp 7, 1, 0, 0
bca 0, 30, mul

return:
add 12,11,12
lwz 12, 0(12)
add 8, 8, 12
addi 9, 9, 1
cmp 7, 1, 0, 0
bca 0, 30, loop

mul:
addi 15, 0, 0
add 15, 9, 9
add 12, 15,15
cmp 7,1,0,0
bca 0,30,return

exit:
addi 5, 8, 0
stw 5, 0(16)


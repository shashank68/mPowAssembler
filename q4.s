  .data
  array: .word 1 2 3 4 5 6 7 8 9 10  #declaring the array
  length: .word 10                                     #length of the aarray
  sum: .word 0
  msg: .asciiz "The sum of the elements in array  is: "

  .text
main:
  addi 8,0,0
  la 11,array
  la 10,length
  addi 10,10,-1
  li 9,0,0

loop:
.  bgt $t1, $t2, exit
.  mul $t4, $t1, 4
  add 12,11,12
  lwz 12,0(12)
  add 8,8,12
  addi 9,9,1
.  j loop

exit:
  la 4,msg

  addi 5,8,0

  .end

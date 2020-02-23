  .data


  .text

main:
  addi 16,0,100
  stw 16,0(28)             #storing first constant

  addi 17,0,200
  stw 17,0(0)              #storing second constant

  add 18,16,17             #calculating the sum
  stw 18,400(0)            #storing the sum

  addi 4,0,18              #answer copied onto reg 4
  .end

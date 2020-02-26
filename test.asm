.data 
X: .word 5
.text
main:
    addi 6, 0, 8
    addi 5, 0, 10
    label:
        cmp 7, 1, 6, 5
        addi 6, 6, 1
        bca 5, 29, label
        

    
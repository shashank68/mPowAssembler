.data 
X: .word 5
.text
main:
    addi 5, 0, 8
    addi 31, 0, 31
    label:
        addi  6, 0, 8
        cmp 7, 1, 5, 6
        bca 4, 30, label

    
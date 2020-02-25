.data 
X: .word 5
.text
main:
    or 31, 31, 31
    xorr 2,7,9
    xorri 6,7,5
        lab:
    bca 3,4, lab
    
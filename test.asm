.data 
X: .word 5
.text
main:
    or 31, 31, 31
    bca 3,4, lable
        printf("ERROR:  %s is undefined!\n", functionName);
        return -1;


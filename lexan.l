%{
    #include<stdio.h>
    #include<string.h>
    #include<stdlib.h>
    #include<math.h>
    char instructionMatrix[100][100];
    int instrCount = 0;
    void convertbin(int , char*);
    void convertbincomp(char*);
    int pos[] = {6, 11, 16};
%}
reg ([0-9]|[12][0-9]|3[01])
twopow16 [+-]?([0-9]|[1-8][0-9]|9[0-9]|[1-8][0-9]{2}|9[0-8][0-9]|99[0-9]|[1-8][0-9]{3}|9[0-8][0-9]{2}|99[0-8][0-9]|999[0-9]|[12][0-9]{4}|3[01][0-9]{3}|32[0-6][0-9]{2}|327[0-5][0-9]|3276[0-7])|"-32768"
%%

"add"[ ]+{reg}[ ]*,[ ]*{reg}[ ]*,[ ]*{reg}[ \n]+ {
   
    char* temp = yytext;
    for(int n = 0; n < 3; n++) {
    }
    char* opcode = "011111";
    strcpy(instructionMatrix[instrCount], opcode);
    
    int stringctrl = 4;

    for(int count = 0; count < 3; count++) {
        int  instrctrl = pos[count];
        while(temp[stringctrl] == ' ' || temp[stringctrl] == ',') {
            stringctrl++;
        }
        char binregnum[6] = {0};

        if(temp[stringctrl + 1] ==  ' ' || temp[stringctrl+1] == ',' || temp[stringctrl+1] == '\0' || temp[stringctrl+1] == '\n') {
            convertbin((int)(temp[stringctrl]) - 48, binregnum);
            stringctrl++;
        } else{
            convertbin( ((int)(temp[stringctrl]) - 48) * 10 + (int)temp[stringctrl + 1] - 48, binregnum);
            stringctrl += 2;
        }
        strcat(instructionMatrix[instrCount], binregnum);
        /*for(; instrctrl < pos[count] + 5; instrctrl++) {
            instructionMatrix[instrCount][instrctrl] = binregnum[instrctrl - pos[count]];
        }*/
    }
    strcat(instructionMatrix[instrCount], "01000010100");
    puts(instructionMatrix[instrCount]);
    instrCount++;
}


"addi"[ ]+{reg}[ ]*,[ ]*{reg}[ ]*,[ ]*{twopow16}[ \n]+ {
   
    char* temp = yytext;
    for(int n = 0; n < 3; n++) {
    }
    char* opcode = "001110";
    strcpy(instructionMatrix[instrCount], opcode);
    
    int stringctrl = 5;

    for(int count = 0; count < 2; count++) {
        int  instrctrl = pos[count];
        while(temp[stringctrl] == ' ' || temp[stringctrl] == ',') {
            stringctrl++;
        }
        char binregnum[6] = {0};

        if(temp[stringctrl + 1] ==  ' ' || temp[stringctrl+1] == ',' || temp[stringctrl+1] == '\0') {
            convertbin((int)(temp[stringctrl]) - 48, binregnum);
            stringctrl++;
        } else{
            convertbin( ((int)(temp[stringctrl]) - 48) * 10 + (int)temp[stringctrl + 1] - 48, binregnum);
            stringctrl += 2;
        }
        strcat(instructionMatrix[instrCount], binregnum);
       
    }
    while(temp[stringctrl] == ' ' || temp[stringctrl] == ',') {
            stringctrl++;
    }
    int negativeflag = 0;
    if(temp[stringctrl] == '-') {
        negativeflag = 1;
        stringctrl++;
    }
    int count;
    for(count = 1; count <= 5; count++) {
        if(temp[stringctrl + count] ==  ' ' || temp[stringctrl+count] == ',' || temp[stringctrl+count] == '\0' || temp[stringctrl+count] == '\n'){
            break;
        }
    }
    int n = 0;
    for(int ctr = 0; ctr < count; ctr++) {
        n += (temp[stringctrl + ctr] - 48) * (int)(pow(10, count - ctr - 1));
    }
    char bin16num[16] = {0};
    if(negativeflag == 1) {
        convertbincomp(65536 - n, bin16num);
    } else {
        convertbincomp(n, bin16num);
    }
    strcat(instructionMatrix[instrCount], bin16num);
    puts(instructionMatrix[instrCount]);
}



\n {printf("\nA new line\n");}
".*"         ;
%%

int main(int arc, char **argv) {

    FILE* inputFile = fopen(argv[1], "r");
    yyin = inputFile;
    for(int i = 0; i < 100; i++) {
        for(int j = 0; j < 100; j++) {
            instructionMatrix[i][j] = 0;
        }
    }
    yylex();
    FILE* instrFp = fopen("instrfile.txt", "w");
    /*while(instrCount--)*/ {
        fputs(instructionMatrix[instrCount], instrFp);
    }
    fclose(inputFile);
    fclose(instrFp);
}

void convertbin(int n, char temp[]) {
    int i = 4;
    while(n) {
        temp[i--] = n % 2 + 48;
        n = n/2;

    }
    while(i >= 0) {
        temp[i] = '0';
        i--;
    }
}
void convertbincomp(int n, char temp[], int negflag) {
    
}


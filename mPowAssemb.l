%{
    #include<stdio.h>
    #include<string.h>
    #include<stdlib.h>
    #include<math.h>
    char instructionMatrix[100][100];
    int instrCount = 0;
    void convertbin(int , char*);
    void convertbincomp(int, char*, int);
    void convertbin6bit(int, char*);
    int pos[] = {6, 11, 16, 21, 26, 31};
%}
reg ([0-9]|[12][0-9]|3[01])
reg6bit ([0-9]|[1-5][0-9]|6[0-3])
sitwopow16 [+-]?([0-9]|[1-8][0-9]|9[0-9]|[1-8][0-9]{2}|9[0-8][0-9]|99[0-9]|[1-8][0-9]{3}|9[0-8][0-9]{2}|99[0-8][0-9]|999[0-9]|[12][0-9]{4}|3[01][0-9]{3}|32[0-6][0-9]{2}|327[0-5][0-9]|3276[0-7])|"-32768"
uitwopow16 ([0-9]|[1-8][0-9]|9[0-9]|[1-8][0-9]{2}|9[0-8][0-9]|99[0-9]|[1-8][0-9]{3}|9[0-8][0-9]{2}|99[0-8][0-9]|999[0-9]|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5])
%%

"add"[ ]+{reg}[ ]*,[ ]*{reg}[ ]*,[ ]*{reg}[ \n]+ {
    char* temp = yytext;
   
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
        
    }
    strcat(instructionMatrix[instrCount], "01000010100\n");
    puts(instructionMatrix[instrCount]);
    instrCount++;
}


"addi"[ ]+{reg}[ ]*,[ ]*{reg}[ ]*,[ ]*{sitwopow16}[ \n]+ {
    char* temp = yytext;
   
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
    char bin16num[17] = {0};
    if(negativeflag == 1) {
        convertbincomp(65536 - n, bin16num, negativeflag);
    } else {
        convertbincomp(n, bin16num, negativeflag);
    }
    strcat(instructionMatrix[instrCount], bin16num);
    strcat(instructionMatrix[instrCount], "\n");
    puts(instructionMatrix[instrCount]);
    instrCount++;
}


"addis"[ ]+{reg}[ ]*,[ ]*{reg}[ ]*,[ ]*{sitwopow16}[ \n]+ {
    char* temp = yytext;
    
    char* opcode = "001111";
    strcpy(instructionMatrix[instrCount], opcode);
    
    int stringctrl = 6;

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
    char bin16num[17] = {0};
    if(negativeflag == 1) {
        convertbincomp(65536 - n, bin16num, negativeflag);
    } else {
        convertbincomp(n, bin16num, negativeflag);
    }
    strcat(instructionMatrix[instrCount], bin16num);
    strcat(instructionMatrix[instrCount], "\n");
    puts(instructionMatrix[instrCount]);
    instrCount++;
}

"and"[ ]+{reg}[ ]*,[ ]*{reg}[ ]*,[ ]*{reg}[ \n]+ {
    char* temp = yytext;
    
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
       
    }
    strcat(instructionMatrix[instrCount], "00000111000\n");
    puts(instructionMatrix[instrCount]);
    instrCount++;
}


"subf"[ ]+{reg}[ ]*,[ ]*{reg}[ ]*,[ ]*{reg}[ \n]+ {
    char* temp = yytext;
    
    char* opcode = "011111";
    strcpy(instructionMatrix[instrCount], opcode);
    
    int stringctrl = 5;

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
        
    }
    strcat(instructionMatrix[instrCount], "00001010000\n");
    puts(instructionMatrix[instrCount]);
    instrCount++;
}


"andi"[ ]+{reg}[ ]*,[ ]*{reg}[ ]*,[ ]*{uitwopow16}[ \n]+ {
    char* temp = yytext;
    
    char* opcode = "011100";
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
    char bin16num[17] = {0};
    convertbincomp(n, bin16num, 0);
    strcat(instructionMatrix[instrCount], bin16num);
    strcat(instructionMatrix[instrCount], "\n");
    puts(instructionMatrix[instrCount]);
    instrCount++;
}

"ori"[ ]+{reg}[ ]*,[ ]*{reg}[ ]*,[ ]*{uitwopow16}[ \n]+ {
    char* temp = yytext;
    
    char* opcode = "011000";
    strcpy(instructionMatrix[instrCount], opcode);
    
    int stringctrl = 4;

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
    char bin16num[17] = {0};
    convertbincomp(n, bin16num, 0);
    strcat(instructionMatrix[instrCount], bin16num);
    strcat(instructionMatrix[instrCount], "\n");
    puts(instructionMatrix[instrCount]);
    instrCount++;
}


"or"[ ]+{reg}[ ]*,[ ]*{reg}[ ]*,[ ]*{reg}[ \n]+ {
    char* temp = yytext;
   
    char* opcode = "011111";
    strcpy(instructionMatrix[instrCount], opcode);
    
    int stringctrl = 3;

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
    }
    strcat(instructionMatrix[instrCount], "01101111000\n");
    puts(instructionMatrix[instrCount]);
    instrCount++;
}


"nand"[ ]+{reg}[ ]*,[ ]*{reg}[ ]*,[ ]*{reg}[ \n]+ {
    char* temp = yytext;
   
    char* opcode = "011111";
    strcpy(instructionMatrix[instrCount], opcode);
    
    int stringctrl = 5;

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
    }
    strcat(instructionMatrix[instrCount], "01110111000\n");
    puts(instructionMatrix[instrCount]);
    instrCount++;
}


"rlwinm"[ ]+{reg}[ ]*,[ ]*{reg}[ ]*,[ ]*{reg}[ ]*,[ ]*{reg}[ ]*,[ ]*{reg}[ \n]+ {
    char* temp = yytext;
   
    char* opcode = "010101";
    strcpy(instructionMatrix[instrCount], opcode);
    
    int stringctrl = 7;

    for(int count = 0; count < 5; count++) {
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
        
    }
    strcat(instructionMatrix[instrCount], "0\n");
    puts(instructionMatrix[instrCount]);
    instrCount++;
}

"sld"[ ]+{reg}[ ]*,[ ]*{reg}[ ]*,[ ]*{reg}[ \n]+ {
    char* temp = yytext;
   
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
    }
    strcat(instructionMatrix[instrCount], "00000110110\n");
    puts(instructionMatrix[instrCount]);
    instrCount++;
}


"srd"[ ]+{reg}[ ]*,[ ]*{reg}[ ]*,[ ]*{reg}[ \n]+ {
    char* temp = yytext;
   
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
    }
    strcat(instructionMatrix[instrCount], "10000110110\n");
    puts(instructionMatrix[instrCount]);
    instrCount++;
}


"srad"[ ]+{reg}[ ]*,[ ]*{reg}[ ]*,[ ]*{reg}[ \n]+ {
    char* temp = yytext;
   
    char* opcode = "011111";
    strcpy(instructionMatrix[instrCount], opcode);
    
    int stringctrl = 5;

    for(int count = 0; count < 3; count++) {
        int  instrctrl = pos[count];
        while(temp[stringctrl] == ' ' || temp[stringctrl] == ',') {
            stringctrl++;
        }
        char binregnum[7] = {0};

        if(temp[stringctrl + 1] ==  ' ' || temp[stringctrl+1] == ',' || temp[stringctrl+1] == '\0' || temp[stringctrl+1] == '\n') {
            convertbin((int)(temp[stringctrl]) - 48, binregnum);
            stringctrl++;
        } else{
            convertbin( ((int)(temp[stringctrl]) - 48) * 10 + (int)temp[stringctrl + 1] - 48, binregnum);
            stringctrl += 2;
        }
        strcat(instructionMatrix[instrCount], binregnum);
    }
    strcat(instructionMatrix[instrCount], "11000110100\n");
    puts(instructionMatrix[instrCount]);
    instrCount++;
}

"sradi"[ ]+{reg}[ ]*,[ ]*{reg}[ ]*,[ ]*{reg}[ \n]+ {
    char* temp = yytext;
   
    char* opcode = "011111";
    strcpy(instructionMatrix[instrCount], opcode);
    
    int stringctrl = 6;

    for(int count = 0; count < 2; count++) {
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
    }
    while(temp[stringctrl] == ' ' || temp[stringctrl] == ',') {
            stringctrl++;
    }
    char binregnum6[7] = {0};
    if(temp[stringctrl + 1] ==  ' ' || temp[stringctrl+1] == ',' || temp[stringctrl+1] == '\0' || temp[stringctrl+1] == '\n') {
        convertbin6bit((int)(temp[stringctrl]) - 48, binregnum6);
        stringctrl++;
    } else {
        convertbin6bit( ((int)(temp[stringctrl]) - 48) * 10 + (int)temp[stringctrl + 1] - 48, binregnum6);
        stringctrl += 2;
    }
    strncat(instructionMatrix[instrCount], binregnum6, 5);
    strcat(instructionMatrix[instrCount], "0110011101");
    instructionMatrix[instrCount][30] = binregnum6[5];
    strcat(instructionMatrix[instrCount], "0\n");
    puts(instructionMatrix[instrCount]);
    instrCount++;
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
    for(int k = 0; k < instrCount; k++) {
        fputs(instructionMatrix[k], instrFp);
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
void convertbincomp(int n, char temp[], int negativeflag) {
    int lastdig = negativeflag;
    int indx = 15;
    while(n) {
        temp[indx--] = n % 2 + 48;
        n = n / 2;
    }
    while(indx >= 0) {
        temp[indx--] = lastdig + 48;          
    }
}
void convertbin6bit(int n, char temp[]) {
    int i = 5;
    while(n) {
        temp[i--] = n % 2 + 48;
        n = n/2;

    }
    while(i >= 0) {
        temp[i] = '0';
        i--;
    }
}
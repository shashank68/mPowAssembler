%option yylineno
%{
    #include<stdio.h>
    #include<string.h>
    #include<stdlib.h>
    #include<math.h>
    char instructionMatrix[100][100];
    char funclabels[100][2][25];
    char varlabels[100][2][17];
    int funcaddress[100];
    int varlabelcount = 0;
    int funclabelcount = 0;
    int instrCount = 0;
    void convertbin(int , char*);
    void convertbin14comp(int, char*, int);
    void convertbincomp(int, char*, int);
    void convertbin6bit(int, char*);
    void convertbin24bit(int, char*);
    void convertbincomp_seven(int , char*);

    int dataline, textline;
    int pos[] = {6, 11, 16, 21, 26, 31};
%}
reg ([0-9]|[12][0-9]|3[01])
regwithout0 ([1-9]|[12][0-9]|3[01])
reg6bit ([0-9]|[1-5][0-9]|6[0-3])
sitwopow14 [+-]?([0-9]|[1-8][0-9]|9[0-9]|[1-8][0-9]{2}|9[0-8][0-9]|99[0-9]|[1-7][0-9]{3}|80[0-9]{2}|81[0-8][0-9]|819[01])|"-8192"
sitwopow16 [+-]?([0-9]|[1-8][0-9]|9[0-9]|[1-8][0-9]{2}|9[0-8][0-9]|99[0-9]|[1-8][0-9]{3}|9[0-8][0-9]{2}|99[0-8][0-9]|999[0-9]|[12][0-9]{4}|3[01][0-9]{3}|32[0-6][0-9]{2}|327[0-5][0-9]|3276[0-7])|"-32768"
uitwopow16 ([0-9]|[1-8][0-9]|9[0-9]|[1-8][0-9]{2}|9[0-8][0-9]|99[0-9]|[1-8][0-9]{3}|9[0-8][0-9]{2}|99[0-8][0-9]|999[0-9]|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5])
functname ([a-zA-Z_][a-zA-Z0-9_]*)
lev ([0-9]|[1-8][0-9]|9[0-9]|1[01][0-9]|12[0-7])

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
    instrCount++;
}

"extsw"[ ]+{reg}[ ]*,[ ]*{reg}[ ]*[ ]*[ \n]+ {
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
        strcat(instructionMatrix[instrCount], "0000011110110100\n");

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
    instrCount++;
}

"xorr"[ ]+{reg}[ ]*,[ ]*{reg}[ ]*,[ ]*{reg}[ \n]+ {
        char* temp = yytext;
        for(int n = 0; n < 3; n++) {
        }
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
        strcat(instructionMatrix[instrCount], "01001111000\n");

        instrCount++;
    }

"xorri"[ ]+{reg}[ ]*,[ ]*{reg}[ ]*,[ ]*{uitwopow16}[ \n]+ {
        char* temp = yytext;
        for(int n = 0; n < 3; n++) {
        }
        char* opcode = "011010";
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

        instrCount++;
    }

"ld"[ ]+{reg}[ ]*,[ ]*{sitwopow14}\({reg}\)[ \n]+ {
    char* temp = yytext;

    char* opcode = "111010";
    strcpy(instructionMatrix[instrCount], opcode);

    int stringctrl = 3;

    for(int count = 0; count < 1; count++) {
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
    int negativeflag = 0;
    if(temp[stringctrl] == '-') {
        negativeflag = 1;
        stringctrl++;
    }
    int count;
    for(count = 1; count <= 4; count++) {
        if( temp[stringctrl + count] ==  '(' ){
            break;
        }
    }
    int n = 0;
    for(int ctr = 0; ctr < count; ctr++) {
        n += (temp[stringctrl + ctr] - 48) * (int)(pow(10, count - ctr - 1));
    }
    char bin14num[15] = {0};

    if(negativeflag == 1) {
            convertbin14comp(16384 - n, bin14num, negativeflag);
    } else {
            convertbin14comp(n, bin14num, negativeflag);
    }

    stringctrl = stringctrl + count + 1;

    char binregnum[6] = {0};

    if(temp[stringctrl + 1] ==  ')' ) {
        convertbin((int)(temp[stringctrl]) - 48, binregnum);
        stringctrl++;
    } else{
        convertbin( ((int)(temp[stringctrl]) - 48) * 10 + (int)temp[stringctrl + 1] - 48, binregnum);
        stringctrl += 2;
    }
    strcat(instructionMatrix[instrCount], binregnum);
    strcat(instructionMatrix[instrCount], bin14num);
    strcat(instructionMatrix[instrCount], "00\n");
    instrCount++;
}

"lwz"[ ]+{reg}[ ]*,[ ]*{sitwopow16}\({reg}\)[ \n]+ {
    char* temp = yytext;

    char* opcode = "100000";
    strcpy(instructionMatrix[instrCount], opcode);

    int stringctrl = 4;

    for(int count = 0; count < 1; count++) {
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
    int negativeflag = 0;
    if(temp[stringctrl] == '-') {
        negativeflag = 1;
        stringctrl++;
    }
    int count;
    for(count = 1; count <= 4; count++) {
        if( temp[stringctrl + count] ==  '(' ){
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

    stringctrl = stringctrl + count + 1;

    char binregnum[6] = {0};

    if(temp[stringctrl + 1] ==  ')' ) {
        convertbin((int)(temp[stringctrl]) - 48, binregnum);
        stringctrl++;
    } else{
        convertbin( ((int)(temp[stringctrl]) - 48) * 10 + (int)temp[stringctrl + 1] - 48, binregnum);
        stringctrl += 2;
    }
    strcat(instructionMatrix[instrCount], binregnum);
    strcat(instructionMatrix[instrCount], bin16num);
    strcat(instructionMatrix[instrCount], "\n");
    instrCount++;
}

"std"[ ]+{reg}[ ]*,[ ]*{sitwopow14}\({reg}\)[ \n]+ {
    char* temp = yytext;

    char* opcode = "111110";
    strcpy(instructionMatrix[instrCount], opcode);

    int stringctrl = 4;

    for(int count = 0; count < 1; count++) {
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
    int negativeflag = 0;
    if(temp[stringctrl] == '-') {
        negativeflag = 1;
        stringctrl++;
    }
    int count;
    for(count = 1; count <= 4; count++) {
        if( temp[stringctrl + count] ==  '(' ){
            break;
        }
    }
    int n = 0;
    for(int ctr = 0; ctr < count; ctr++) {
        n += (temp[stringctrl + ctr] - 48) * (int)(pow(10, count - ctr - 1));
    }
    char bin14num[15] = {0};

    if(negativeflag == 1) {
            convertbin14comp(16384 - n, bin14num, negativeflag);
    } else {
            convertbin14comp(n, bin14num, negativeflag);
    }

    stringctrl = stringctrl + count + 1;

    char binregnum[6] = {0};

    if(temp[stringctrl + 1] ==  ')' ) {
        convertbin((int)(temp[stringctrl]) - 48, binregnum);
        stringctrl++;
    } else{
        convertbin( ((int)(temp[stringctrl]) - 48) * 10 + (int)temp[stringctrl + 1] - 48, binregnum);
        stringctrl += 2;
    }
    strcat(instructionMatrix[instrCount], binregnum);
    strcat(instructionMatrix[instrCount], bin14num);
    strcat(instructionMatrix[instrCount], "00\n");
    instrCount++;
}

"stw"[ ]+{reg}[ ]*,[ ]*{sitwopow16}\({reg}\)[ \n]+ {
    char* temp = yytext;

    char* opcode = "100100";
    strcpy(instructionMatrix[instrCount], opcode);

    int stringctrl = 4;

    for(int count = 0; count < 1; count++) {
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
    int negativeflag = 0;
    if(temp[stringctrl] == '-') {
        negativeflag = 1;
        stringctrl++;
    }
    int count;
    for(count = 1; count <= 4; count++) {
        if( temp[stringctrl + count] ==  '(' ){
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

    stringctrl = stringctrl + count + 1;

    char binregnum[6] = {0};

    if(temp[stringctrl + 1] ==  ')' ) {
        convertbin((int)(temp[stringctrl]) - 48, binregnum);
        stringctrl++;
    } else{
        convertbin( ((int)(temp[stringctrl]) - 48) * 10 + (int)temp[stringctrl + 1] - 48, binregnum);
        stringctrl += 2;
    }
    strcat(instructionMatrix[instrCount], binregnum);
    strcat(instructionMatrix[instrCount], bin16num);
    strcat(instructionMatrix[instrCount], "\n");
    instrCount++;
}

"stwu"[ ]+{reg}[ ]*,[ ]*{sitwopow16}\({regwithout0}\)[ \n]+ {
    char* temp = yytext;

    char* opcode = "100101";
    strcpy(instructionMatrix[instrCount], opcode);

    int stringctrl = 5;

    for(int count = 0; count < 1; count++) {
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
    int negativeflag = 0;
    if(temp[stringctrl] == '-') {
        negativeflag = 1;
        stringctrl++;
    }
    int count;
    for(count = 1; count <= 4; count++) {
        if( temp[stringctrl + count] ==  '(' ){
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

    stringctrl = stringctrl + count + 1;

    char binregnum[6] = {0};

    if(temp[stringctrl + 1] ==  ')' ) {
        convertbin((int)(temp[stringctrl]) - 48, binregnum);
        stringctrl++;
    } else{
        convertbin( ((int)(temp[stringctrl]) - 48) * 10 + (int)temp[stringctrl + 1] - 48, binregnum);
        stringctrl += 2;
    }
    strcat(instructionMatrix[instrCount], binregnum);
    strcat(instructionMatrix[instrCount], bin16num);
    strcat(instructionMatrix[instrCount], "\n");
    instrCount++;
}

"lhz"[ ]+{reg}[ ]*,[ ]*{sitwopow16}\({reg}\)[ \n]+ {
    char* temp = yytext;

    char* opcode = "101000";
    strcpy(instructionMatrix[instrCount], opcode);

    int stringctrl = 4;

    for(int count = 0; count < 1; count++) {
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
    int negativeflag = 0;
    if(temp[stringctrl] == '-') {
        negativeflag = 1;
        stringctrl++;
    }
    int count;
    for(count = 1; count <= 4; count++) {
        if( temp[stringctrl + count] ==  '(' ){
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

    stringctrl = stringctrl + count + 1;

    char binregnum[6] = {0};

    if(temp[stringctrl + 1] ==  ')' ) {
        convertbin((int)(temp[stringctrl]) - 48, binregnum);
        stringctrl++;
    } else{
        convertbin( ((int)(temp[stringctrl]) - 48) * 10 + (int)temp[stringctrl + 1] - 48, binregnum);
        stringctrl += 2;
    }
    strcat(instructionMatrix[instrCount], binregnum);
    strcat(instructionMatrix[instrCount], bin16num);
    strcat(instructionMatrix[instrCount], "\n");
    instrCount++;
}

"lha"[ ]+{reg}[ ]*,[ ]*{sitwopow16}\({reg}\)[ \n]+ {
    char* temp = yytext;

    char* opcode = "101010";
    strcpy(instructionMatrix[instrCount], opcode);

    int stringctrl = 4;

    for(int count = 0; count < 1; count++) {
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
    int negativeflag = 0;
    if(temp[stringctrl] == '-') {
        negativeflag = 1;
        stringctrl++;
    }
    int count;
    for(count = 1; count <= 4; count++) {
        if( temp[stringctrl + count] ==  '(' ){
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

    stringctrl = stringctrl + count + 1;

    char binregnum[6] = {0};

    if(temp[stringctrl + 1] ==  ')' ) {
        convertbin((int)(temp[stringctrl]) - 48, binregnum);
        stringctrl++;
    } else{
        convertbin( ((int)(temp[stringctrl]) - 48) * 10 + (int)temp[stringctrl + 1] - 48, binregnum);
        stringctrl += 2;
    }
    strcat(instructionMatrix[instrCount], binregnum);
    strcat(instructionMatrix[instrCount], bin16num);
    strcat(instructionMatrix[instrCount], "\n");
    instrCount++;
}

"sth"[ ]+{reg}[ ]*,[ ]*{sitwopow16}\({reg}\)[ \n]+ {
    char* temp = yytext;

    char* opcode = "101100";
    strcpy(instructionMatrix[instrCount], opcode);

    int stringctrl = 4;

    for(int count = 0; count < 1; count++) {
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
    int negativeflag = 0;
    if(temp[stringctrl] == '-') {
        negativeflag = 1;
        stringctrl++;
    }
    int count;
    for(count = 1; count <= 4; count++) {
        if( temp[stringctrl + count] ==  '(' ){
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

    stringctrl = stringctrl + count + 1;

    char binregnum[6] = {0};

    if(temp[stringctrl + 1] ==  ')' ) {
        convertbin((int)(temp[stringctrl]) - 48, binregnum);
        stringctrl++;
    } else{
        convertbin( ((int)(temp[stringctrl]) - 48) * 10 + (int)temp[stringctrl + 1] - 48, binregnum);
        stringctrl += 2;
    }
    strcat(instructionMatrix[instrCount], binregnum);
    strcat(instructionMatrix[instrCount], bin16num);
    strcat(instructionMatrix[instrCount], "\n");
    instrCount++;
}

"lbz"[ ]+{reg}[ ]*,[ ]*{sitwopow16}\({reg}\)[ \n]+ {
    char* temp = yytext;

    char* opcode = "100010";
    strcpy(instructionMatrix[instrCount], opcode);

    int stringctrl = 4;

    for(int count = 0; count < 1; count++) {
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
    int negativeflag = 0;
    if(temp[stringctrl] == '-') {
        negativeflag = 1;
        stringctrl++;
    }
    int count;
    for(count = 1; count <= 4; count++) {
        if( temp[stringctrl + count] ==  '(' ){
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

    stringctrl = stringctrl + count + 1;

    char binregnum[6] = {0};

    if(temp[stringctrl + 1] ==  ')' ) {
        convertbin((int)(temp[stringctrl]) - 48, binregnum);
        stringctrl++;
    } else{
        convertbin( ((int)(temp[stringctrl]) - 48) * 10 + (int)temp[stringctrl + 1] - 48, binregnum);
        stringctrl += 2;
    }
    strcat(instructionMatrix[instrCount], binregnum);
    strcat(instructionMatrix[instrCount], bin16num);
    strcat(instructionMatrix[instrCount], "\n");
    instrCount++;
}

"stb"[ ]+{reg}[ ]*,[ ]*{sitwopow16}\({reg}\)[ \n]+ {
    char* temp = yytext;

    char* opcode = "100110";
    strcpy(instructionMatrix[instrCount], opcode);

    int stringctrl = 4;

    for(int count = 0; count < 1; count++) {
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
    int negativeflag = 0;
    if(temp[stringctrl] == '-') {
        negativeflag = 1;
        stringctrl++;
    }
    int count;
    for(count = 1; count <= 4; count++) {
        if( temp[stringctrl + count] ==  '(' ){
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

    stringctrl = stringctrl + count + 1;

    char binregnum[6] = {0};

    if(temp[stringctrl + 1] ==  ')' ) {
        convertbin((int)(temp[stringctrl]) - 48, binregnum);
        stringctrl++;
    } else{
        convertbin( ((int)(temp[stringctrl]) - 48) * 10 + (int)temp[stringctrl + 1] - 48, binregnum);
        stringctrl += 2;
    }
    strcat(instructionMatrix[instrCount], binregnum);
    strcat(instructionMatrix[instrCount], bin16num);
    strcat(instructionMatrix[instrCount], "\n");
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
    instrCount++;
}

"b"[ ]+{functname}[ \n]+ {
    char* temp = yytext;

    char* opcode = "010010";
    strcpy(instructionMatrix[instrCount], opcode);

    int stringctrl = 2;

    int  instrctrl = 6;
    while(temp[stringctrl] == ' ') {
        stringctrl++;
    }

    int count;
    for(count = 1; count <= 100; count++) {
        if( temp[stringctrl + count] ==  ' ' || temp[stringctrl + count] ==  '\n'){
            break;
        }
    }
    char functionName[count+1];
    for(int cnt = 0; cnt < count; cnt++) {
        functionName[cnt] = temp[stringctrl+cnt];
    }
    functionName[count] = 0;
    int found  = 0, j;
    for(j = 0; j < funclabelcount; j++) {

        if(strncmp( funclabels[j][0], functionName, count) == 0 && functionName[count] == 0 && funclabels[j][0][count] == 0) {
            found = 1;
            break;
        }
    }

    if(found == 1) {
        strcat(instructionMatrix[instrCount], "00000000");
        strcat(instructionMatrix[instrCount], funclabels[j][1]);


        strcat(instructionMatrix[instrCount], "00\n");

        instrCount++;
    } else {
        printf("ERROR:  %s is undefined!\n", functionName);
    }
}

"ba"[ ]+{functname}[ \n]+ {
    char* temp = yytext;

    char* opcode = "010010";
    strcpy(instructionMatrix[instrCount], opcode);

    int stringctrl = 3;

    int  instrctrl = 6;
    while(temp[stringctrl] == ' ') {
        stringctrl++;
    }

    int count;
    for(count = 1; count <= 100; count++) {
        if( temp[stringctrl + count] ==  ' ' || temp[stringctrl + count] ==  '\n'){
            break;
        }
    }
    char functionName[count+1];
    for(int cnt = 0; cnt < count; cnt++) {
        functionName[cnt] = temp[stringctrl+cnt];
    }
    functionName[count] = 0;
    int found  = 0, j;
    for(j = 0; j < funclabelcount; j++) {

        if(strncmp( funclabels[j][0], functionName, count) == 0 && functionName[count] == 0 && funclabels[j][0][count] == 0) {
            found = 1;
            break;
        }
    }

    if(found == 1) {
        strcat(instructionMatrix[instrCount], "00000000");
        strcat(instructionMatrix[instrCount], funclabels[j][1]);
        strcat(instructionMatrix[instrCount], "10\n");

        instrCount++;
    } else {
        printf("ERROR:  %s is undefined!\n", functionName);
    }
}

"bl"[ ]+{functname}[ \n]+ {
    char* temp = yytext;

    char* opcode = "010010";
    strcpy(instructionMatrix[instrCount], opcode);

    int stringctrl = 3;

    int  instrctrl = 6;
    while(temp[stringctrl] == ' ') {
        stringctrl++;
    }

    int count;
    for(count = 1; count <= 100; count++) {
        if( temp[stringctrl + count] ==  ' ' || temp[stringctrl + count] ==  '\n'){
            break;
        }
    }
    char functionName[count+1];
    for(int cnt = 0; cnt < count; cnt++) {
        functionName[cnt] = temp[stringctrl+cnt];
    }
    functionName[count] = 0;
    int found  = 0, j;
    for(j = 0; j < funclabelcount; j++) {

        if(strncmp( funclabels[j][0], functionName, count) == 0 && functionName[count] == 0 && funclabels[j][0][count] == 0) {
            found = 1;
            break;
        }
    }

    if(found == 1) {
        strcat(instructionMatrix[instrCount], "00000000");
        strcat(instructionMatrix[instrCount], funclabels[j][1]);
        strcat(instructionMatrix[instrCount], "01\n");

        instrCount++;
    } else {
        printf("ERROR:  %s is undefined!\n", functionName);
    }
}

"bclr"[ \n]+ {
    char* opcode = "01001100000000000000000000100000";
    strcpy(instructionMatrix[instrCount],opcode);
    instrCount++;
}

"bc"[ ]+{reg}[ ]*,[ ]*{reg}[ ]*,[ ]*{functname}[ \n]+ {
    char* temp = yytext;

    char* opcode = "010011";
    strcpy(instructionMatrix[instrCount], opcode);

     int stringctrl = 3;

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

    int count;
    for(count = 1; count <= 100; count++) {
        if( temp[stringctrl + count] ==  ' ' || temp[stringctrl + count] ==  '\n'){
            break;
        }
    }
    char functionName[count+1];
    for(int cnt = 0; cnt < count; cnt++) {
        functionName[cnt] = temp[stringctrl+cnt];
    }
    functionName[count] = 0;
    int found  = 0, j;
    for(j = 0; j < funclabelcount; j++) {
        if(strncmp( funclabels[j][0], functionName, count) == 0 && functionName[count] == 0 && funclabels[j][0][count] == 0) {
            found = 1;
            break;
        }
    }

    if(found == 1) {
        char addr[15] = {0};
        int diff = funcaddress[funclabelcount] - (instrCount * 4 + 262144);
        if(diff >= 0) {
            convertbin14comp(diff, addr, 0);
        } else {
            convertbin14comp(-1*diff, addr, 1);
        }
        strcat(instructionMatrix[instrCount], addr);
        strcat(instructionMatrix[instrCount], "00\n");

        instrCount++;
    } else {
        printf("ERROR:  %s is undefined!\n", functionName);
    }
}

"beq"[ ]+{reg}[ ]*,[ ]*{reg}[ ]*,[ ]*{functname}[ \n]+ {
    char* temp = yytext;

    char* opcode = "010011";
    strcpy(instructionMatrix[instrCount], opcode);

     int stringctrl = 4;

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

    int count;
    for(count = 1; count <= 100; count++) {
        if( temp[stringctrl + count] ==  ' ' || temp[stringctrl + count] ==  '\n'){
            break;
        }
    }
    char functionName[count+1];
    for(int cnt = 0; cnt < count; cnt++) {
        functionName[cnt] = temp[stringctrl+cnt];
    }
    functionName[count] = 0;
    int found  = 0, j;
    for(j = 0; j < funclabelcount; j++) {
        if(strncmp( funclabels[j][0], functionName, count) == 0 && functionName[count] == 0 && funclabels[j][0][count] == 0) {
            found = 1;
            break;
        }
    }

    if(found == 1) {
        char addr[15] = {0};
        int diff = funcaddress[funclabelcount] - (instrCount * 4 + 262144);
        if(diff >= 0) {
            convertbin14comp(diff, addr, 0);
        } else {
            convertbin14comp(-1*diff, addr, 1);
        }
        strcat(instructionMatrix[instrCount], addr);
        strcat(instructionMatrix[instrCount], "00\n");

        instrCount++;
    } else {
        printf("ERROR:  %s is undefined!\n", functionName);
    }
}

"bca"[ ]+{reg}[ ]*,[ ]*{reg}[ ]*,[ ]*{functname}[ \n]+ {

    char* temp = yytext;
    char* opcode = "010011";
    strcpy(instructionMatrix[instrCount], opcode);

     int stringctrl = 4;

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

    int count;
    for(count = 1; count <= 100; count++) {
        if( temp[stringctrl + count] ==  ' ' || temp[stringctrl + count] ==  '\n'){
            break;
        }
    }
    char functionName[count+1];
    for(int cnt = 0; cnt < count; cnt++) {
        functionName[cnt] = temp[stringctrl+cnt];
    }
    functionName[count] = 0;
    int found  = 0, j;
    for(j = 0; j < funclabelcount; j++) {
        if(strncmp( funclabels[j][0], functionName, count) == 0 && functionName[count] == 0 && funclabels[j][0][count] == 0) {
            found = 1;
            break;
        }
    }

    if(found == 1) {
        char addr[15] = {0};
        int diff = funcaddress[funclabelcount] - (instrCount * 4 + 262144);
        if(diff >= 0) {
            convertbin14comp(diff, addr, 0);
        } else {
            convertbin14comp(-1*diff, addr, 1);
        }
        strcat(instructionMatrix[instrCount], addr);
        strcat(instructionMatrix[instrCount], "10\n");

        instrCount++;
    } else {
        printf("ERROR:  %s is undefined!\n", functionName);
        return -1;
    }
}

"la"[ ]+{reg}[ ]*,[ ]*{functname}[ \n]+ {
    char* temp = yytext;

    char* opcode = "001110";
    strcpy(instructionMatrix[instrCount], opcode);

    int stringctrl = 3;

    for(int count = 0; count < 1; count++) {
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
    strcat(instructionMatrix[instrCount], "00000");
    while(temp[stringctrl] == ' ' || temp[stringctrl] == ',') {
            stringctrl++;
    }

    int count;
    for(count = 1; count <= 100; count++) {
        if( temp[stringctrl + count] ==  ' ' || temp[stringctrl + count] ==  '\n'){
            break;
        }
    }
    char variableName[count+1];
    for(int cnt = 0; cnt < count; cnt++) {
        variableName[cnt] = temp[stringctrl+cnt];
    }
    variableName[count] = 0;
    int found  = 0, j;
    for(j = 0; j < varlabelcount; j++) {



        if(strncmp( varlabels[j][0], variableName, count) == 0 && variableName[count] == 0 && varlabels[j][0][count] == 0) {
            found = 1;
            break;
        }
    }

    if(found == 1) {
        strcat(instructionMatrix[instrCount], varlabels[j][1]);
        strcat(instructionMatrix[instrCount], "\n");

        instrCount++;
    } else {
        printf("ERROR:  %s is undefined!\n", variableName);
    }
}

"cmp"[ ]+"7"[ ]*,[ ]*"1"[ ]*,[ ]*{reg}[ ]*,[ ]*{reg}[ \n]+ {
        char* temp = yytext;
        char* opcode = "011111";
        strcpy(instructionMatrix[instrCount], opcode);
        strcat(instructionMatrix[instrCount],"11101");
        int stringctrl = 4;
        while(temp[stringctrl]!='1'){
        stringctrl++;
        }
        stringctrl++;


        for(int count = 1; count < 3; count++) {
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
        strcat(instructionMatrix[instrCount], "00000000000\n");

        instrCount++;
    }

"cmpi"[ ]+"7"[ ]*,[ ]*"1"[ ]*,[ ]*{reg}[ ]*,[ ]*{sitwopow16}[ \n]+ {
  char* temp = yytext;
  char* opcode = "001011";
  strcpy(instructionMatrix[instrCount], opcode);
  strcat(instructionMatrix[instrCount],"11101");
  int stringctrl = 5;
  while(temp[stringctrl]!='1')
  stringctrl++;

  stringctrl++;

  for(int count = 1; count < 2; count++) {
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
  instrCount++;
}

"sc"[ ]+{lev}[ \n]+ {
  char* temp = yytext;
  char* opcode = "010001";
  strcpy(instructionMatrix[instrCount], opcode);
  strcat(instructionMatrix[instrCount], "00000000000000");
  int stringctrl=2;
  while(temp[stringctrl] == ' ' || temp[stringctrl] == ',') {
          stringctrl++;
  }
  int count;
  for(count = 1; count <= 3; count++) {
      if(temp[stringctrl + count] ==  ' ' || temp[stringctrl+count] == ',' || temp[stringctrl+count] == '\0' || temp[stringctrl+count] == '\n'){
          break;
      }
  }
  int n = 0;
  for(int ctr = 0; ctr < count; ctr++) {
      n += (temp[stringctrl + ctr] - 48) * (int)(pow(10, count - ctr - 1));
  }
  char binnum7[8] = {0};
  convertbincomp_seven(n, binnum7);
  strcat(instructionMatrix[instrCount], binnum7);
  strcat(instructionMatrix[instrCount], "00010\n");
  instrCount++;


}

#.*\n {
    ;
}

\n {
    ;
}

{functname}[ ]*\:[ \n]+ {
    ;
}


%%

int main(int arc, char **argv) {
    FILE* linefile = fopen("linedet.txt", "r");
    int linecnt = 0;
    for(char c = getc(linefile); c != EOF; c = getc(linefile)) {
        if(c == '\n') {
            linecnt++;
        }
    }
    fclose(linefile);
    if(linecnt == 2) {
        scanf("%d %d", &dataline, &textline);
    } else {

        return 0;
    }
    FILE* inputFile = fopen(argv[1], "r");
    yyin = inputFile;

    FILE* varsymtable = fopen("varsymtab.txt", "r");
    FILE* funcsymtable = fopen("funcsymtab.txt", "r");
    for(int i = 0; fscanf(varsymtable, "%s", varlabels[i][0]) != EOF && fscanf(varsymtable, "%s", varlabels[i][1]) != EOF; i++) {
        varlabelcount = i+1;
    }
     for(int i = 0; fscanf(funcsymtable, "%s", funclabels[i][0]) != EOF && fscanf(funcsymtable, "%s", funclabels[i][1]) != EOF; i++) {
       funclabelcount = i+1;
    }
    for(int i = 0; i < 4; i++) {


    }

    yylex();
    FILE* instrFp = fopen("instrfile.txt", "w");
    for(int k = 0; k < instrCount; k++) {
        fputs(instructionMatrix[k], instrFp);
    }
    fclose(inputFile);
    fclose(instrFp);
    fclose(varsymtable);
    fclose(funcsymtable);

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

void convertbin14comp(int n, char temp[], int negativeflag) {
    int lastdig = negativeflag;
    int indx = 13;
    while(n) {
        temp[indx--] = n % 2 + 48;
        n = n / 2;
    }
    while(indx >= 0) {
        temp[indx--] = lastdig + 48;
    }
}

void convertbin24bit(int n, char temp[]) {
    int i = 23;
    while(n) {
        temp[i--] = n % 2 + 48;
        n = n/2;

    }
    while(i >= 0) {
        temp[i] = '0';
        i--;
    }
}

void convertbincomp_seven(int n, char temp[]) {
    int i = 6;
    while(n) {
        temp[i--] = n % 2 + 48;
        n = n/2;

    }
    while(i >= 0) {
        temp[i] = '0';
        i--;
    }
}

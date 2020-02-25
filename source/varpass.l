%option yylineno
%{
    #include<stdio.h>
    #include<string.h>
    #include<stdlib.h>
    #include<math.h>
    char varlabels[50][2][17];
    char vardata[50][20][33];  // name|address|type|no of data| all data....
    // type = 01 for .word type = 02 for .asciiz and 03 for .byte.
    int varlabelcount = 0;
    int datanum[20] = {0};
    void convertbin(int , char*);
    void convertbin14comp(int, char*, int);
    void convertbincomp(int, char*, int);
    void convertbincomp32(long, char*, int);
    void convertbin6bit(int, char*);
    void convertbin24bit(int, char*);
    int dataline, textline;
    int currentbyte = 0;
    int lastbyte = 0;
%}
labelname ([a-zA-Z_][a-zA-Z0-9_]*)


%%
{labelname}[ ]*\:[ ]+".word"[ ]+([+-]?[0-9]+)([ ][-+]?+[0-9]+)*[ ]*[\n] {
    int stringctrl = 0;
    char *temp = yytext;
    int explen = strlen(yytext);
    int count;
    for(count = 1; count <= 100; count++) {
        if( temp[stringctrl + count] ==  ' ' || temp[stringctrl + count] == ':' ){
            break;
        }
    }
    
    char varName[count+1];
    for(int cnt = 0; cnt < count; cnt++) {
        varName[cnt] = temp[stringctrl+cnt];
    }
    varName[count] = 0;
    strcpy(varlabels[varlabelcount][0], varName);
    strcpy(vardata[varlabelcount][0], varName); // name of label
   
    strcpy(vardata[varlabelcount][2], "01");    // type of data i.e .word here

    stringctrl += (count + 1);
    
    
    for(int i = 0; temp[stringctrl] != '\n' && stringctrl <= explen; i++) {
        while( !(temp[stringctrl] <= 57 && temp[stringctrl] >= 48) ) {
            stringctrl++;
            if(stringctrl > explen) {
                char addressInTextSec[17] = {0};
                convertbincomp(lastbyte, addressInTextSec, 0);
                lastbyte = currentbyte;
                strcpy(varlabels[varlabelcount][1], addressInTextSec);  // address
                strcpy(vardata[varlabelcount][1], addressInTextSec);
                goto lab;
            }
        }
        int negativeflag = 0;

        if(temp[stringctrl-1] == '-') {
            negativeflag = 1;
        }
        int count;
        for(count = 1; count <= 20; count++) {
            if( temp[stringctrl + count] ==  ' ' || temp[stringctrl + count] == '\n'){
                break;
            }
        }
        
        long n = 0;
        for(int ctr = 0; ctr < count; ctr++) {
            n += (temp[stringctrl + ctr] - 48) * (int)(pow(10, count - ctr - 1));
        }
        char bin32num[33] = {0};
        if(negativeflag == 1) {
            convertbincomp32(4294967296-n, bin32num, negativeflag);
        } else {
            convertbincomp32(n, bin32num, negativeflag);
        }
        strcpy(vardata[varlabelcount][4 + datanum[varlabelcount]], bin32num);

        datanum[varlabelcount] = datanum[varlabelcount] + 1;
        currentbyte += 4;
        convertbincomp32(datanum[varlabelcount], bin32num, 0);
        strcpy(vardata[varlabelcount][3], bin32num);
        stringctrl += (count+1);
    }
    
    lab: varlabelcount++;
} 


{labelname}[ ]*\:[ ]+".asciiz"[ ]+\"[a-zA-Z0-9!@#$%^&*() ]*\"[ \n] {
    int stringctrl = 0;
    char *temp = yytext;
    int explen = strlen(yytext);
    int count;
    for(count = 1; count <= 100; count++) {
        if( temp[stringctrl + count] ==  ' ' || temp[stringctrl + count] == ':' ){
            break;
        }
    }
    
    char varName[count+1];
    for(int cnt = 0; cnt < count; cnt++) {
        varName[cnt] = temp[stringctrl+cnt];
    }
    varName[count] = 0;
    strcpy(varlabels[varlabelcount][0], varName);
    strcpy(vardata[varlabelcount][0], varName); // name of label
    
    strcpy(vardata[varlabelcount][2], "10");    // type of data i.e .asciiz here

    stringctrl += (count + 1);

    while( temp[stringctrl] != '"' && stringctrl <= explen) {
            stringctrl++;
    }
    stringctrl++;
    for(count = 1; count <= 100 && stringctrl + count <= explen + 1; count++) {
        if( temp[stringctrl + count] ==  '"' ){
            break;
        }
    }
    
    char varName1[count+1];
    for(int cnt = 0; cnt < count; cnt++) {
        varName1[cnt] = temp[stringctrl+cnt];
    }
    varName1[count] = 0;
    strcpy(vardata[varlabelcount][4], varName1);
    char bin32num[33] = {0};
    convertbincomp32(count, bin32num, 0);
    strcpy(vardata[varlabelcount][3], bin32num);
    char addressInTextSec[17] = {0};
    currentbyte += count + 1;
    convertbincomp(lastbyte, addressInTextSec, 0);
    lastbyte = currentbyte;
    strcpy(varlabels[varlabelcount][1], addressInTextSec);  // address
    strcpy(vardata[varlabelcount][1], addressInTextSec);
    datanum[varlabelcount]++;
    lar: varlabelcount++;
}


{labelname}[ ]*\:[ ]+".byte"[ ]+([+-]?[0-9]+)([ ][-+]?+[0-9]+)*[ ]*[\n] {
    int stringctrl = 0;
    char *temp = yytext;
    int explen = strlen(yytext);
    int count;
    for(count = 1; count <= 100; count++) {
        if( temp[stringctrl + count] ==  ' ' || temp[stringctrl + count] == ':' ){
            break;
        }
    }
    
    char varName[count+1];
    for(int cnt = 0; cnt < count; cnt++) {
        varName[cnt] = temp[stringctrl+cnt];
    }
    varName[count] = 0;
    strcpy(varlabels[varlabelcount][0], varName);
    strcpy(vardata[varlabelcount][0], varName); // name of label
    
    strcpy(vardata[varlabelcount][2], "11");    // type of data i.e .word here

    stringctrl += (count + 1);
    
    
    for(int i = 0; temp[stringctrl] != '\n' && stringctrl <= explen; i++) {
        while( !(temp[stringctrl] <= 57 && temp[stringctrl] >= 48) ) {
            stringctrl++;
            if(stringctrl > explen) {
                char addressInTextSec[17] = {0};
                convertbincomp(lastbyte, addressInTextSec, 0);
                lastbyte = currentbyte;
                strcpy(varlabels[varlabelcount][1], addressInTextSec);  // address
                strcpy(vardata[varlabelcount][1], addressInTextSec);
                goto bal;
            }
        }
        int negativeflag = 0;

        if(temp[stringctrl-1] == '-') {
            negativeflag = 1;
        }
        int count;
        for(count = 1; count <= 20; count++) {
            if( temp[stringctrl + count] ==  ' ' || temp[stringctrl + count] == '\n'){
                break;
            }
        }
        
        long n = 0;
        for(int ctr = 0; ctr < count; ctr++) {
            n += (temp[stringctrl + ctr] - 48) * (int)(pow(10, count - ctr - 1));
        }
        char bin32num[33] = {0};
        if(negativeflag == 1) {
            convertbincomp32(4294967296-n, bin32num, negativeflag);
        } else {
            convertbincomp32(n, bin32num, negativeflag);
        }
        strcpy(vardata[varlabelcount][4 + datanum[varlabelcount]], bin32num);
        datanum[varlabelcount]++;
        currentbyte += 1;
        
        convertbincomp32(datanum[varlabelcount], bin32num, 0);
        strcpy(vardata[varlabelcount][3], bin32num);
        stringctrl += (count+1);
    }
    bal: varlabelcount++;
} 


\n {
    ;
}
.* {
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
        puts("ERROR: NO .text or .data directives found!!");
        return 0;
    }
    FILE* inputFile = fopen(argv[1], "r");
    yyin = inputFile;
    
    FILE* initData = fopen("initdata.txt", "w");
    FILE* varSymTab = fopen("varsymtab.txt", "w");
    yylex();

    for(int j = 0; j < varlabelcount; j++) {
        fprintf(varSymTab, "%s %s\n", varlabels[j][0], varlabels[j][1]);
    }
    for(int j = 0; j < varlabelcount; j++) {
        for(int k = 0; k < 4; k++) {
            fprintf(initData, "%s ", vardata[j][k]);
        }

        for(int k = 4; k < (datanum[j]+4); k++) {
           
           fprintf(initData, "%s ", vardata[j][k]);
           if(k == datanum[j] + 3) {
               fprintf(initData, "\n");
           }
        }
    }
    fclose(inputFile);
    fclose(initData);
    fclose(varSymTab);
    // open 3 files for 2 for sym table and 1 initialed vaule

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


void convertbincomp32(long n, char temp[], int negativeflag) {
    int lastdig = negativeflag;
    int indx = 31;
    while(n) {
        temp[indx--] = n % 2 + 48;
        n = n / 2;
    }
    while(indx >= 0) {
        temp[indx--] = lastdig + 48;          
    }
}
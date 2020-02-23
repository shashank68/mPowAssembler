%option yylineno
%{
    #include<stdio.h>
    #include<string.h>
    #include<stdlib.h>
    #include<math.h>
    char varlabels[50][2][17];
    char vardata[50][20][32];  // name|address|type|no of data| all data....
    // type = 01 for .word type = 02 for .asciiz and 03 for .byte.
    int varlabelcount = 0;
    int datanum[20];
    void convertbin(int , char*);
    void convertbin14comp(int, char*, int);
    void convertbincomp(int, char*, int);
    void convertbincomp32(long, char*, int);
    void convertbin6bit(int, char*);
    void convertbin24bit(int, char*);
    int dataline, textline;
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
    puts("40");
    printf("%s :label: %s\n", varlabels[varlabelcount][0], vardata[varlabelcount][0]);
    char addressInTextSec[17] = {0};
    convertbincomp(varlabelcount * 4, addressInTextSec, 0);
    puts(addressInTextSec);
    strcpy(varlabels[varlabelcount][1], addressInTextSec);  // address
    strcpy(vardata[varlabelcount][1], addressInTextSec);
    strcpy(vardata[varlabelcount][2], "01");    // type of data i.e .word here
    puts(vardata[varlabelcount][2]);

    stringctrl += (count + 1);
    
    
    for(int i = 0; temp[stringctrl] != '\n' && stringctrl <= explen; i++) {
        while( !(temp[stringctrl] <= 57 && temp[stringctrl] >= 48) ) {
            stringctrl++;
            if(stringctrl > explen) {
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
        printf("%ld is the num:\n", n);
        char bin32num[33] = {0};
        if(negativeflag == 1) {
            convertbincomp32(4294967296-n, bin32num, negativeflag);
        } else {
            convertbincomp32(n, bin32num, negativeflag);
        }
        strcpy(vardata[varlabelcount][4 + datanum[varlabelcount]], bin32num);
        puts(vardata[varlabelcount][4 + datanum[varlabelcount]]);
        datanum[varlabelcount]++;
        
        convertbincomp32(datanum[varlabelcount], bin32num, 0);
        strcpy(vardata[varlabelcount][3], bin32num);
        stringctrl += (count+1);
    }
    lab: varlabelcount++;
} 


{labelname}[ ]*\:[ ]+".asciiz"[ ]+\"[a-zA-Z0-9!@#$%^&*() ]*\"[ \n] {
    puts("found teh sritn");
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
    puts("40");
    printf("%s :label: %s\n", varlabels[varlabelcount][0], vardata[varlabelcount][0]);
    char addressInTextSec[17] = {0};
    convertbincomp(varlabelcount * 4, addressInTextSec, 0);
    puts(addressInTextSec);
    strcpy(varlabels[varlabelcount][1], addressInTextSec);  // address
    strcpy(vardata[varlabelcount][1], addressInTextSec);
    strcpy(vardata[varlabelcount][2], "00000000000000000000000000000010");    // type of data i.e .asciiz here
    puts(vardata[varlabelcount][1]);

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
    puts(vardata[varlabelcount][4]);
    char bin32num[33] = {0};
    convertbincomp32(count, bin32num, 0);
    strcpy(vardata[varlabelcount][3], bin32num);
    puts(vardata[varlabelcount][3]);
    lar: varlabelcount++;
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
    int indx = 33;
    while(n) {
        temp[indx--] = n % 2 + 48;
        n = n / 2;
    }
    while(indx >= 0) {
        temp[indx--] = lastdig + 48;          
    }
}
%option yylineno
%{
    #include<stdio.h>
    #include<string.h>
    #include<stdlib.h>
    #include<math.h>
    char functlabels[50][2][25];
    char vardata[50][20][32];
    int functlabelcount = 0;
    int datanum[20];
    void convertbin(int , char*);
    void convertbin14comp(int, char*, int);
    void convertbincomp(int, char*, int);
    void convertbincomp32(long, char*, int);
    void convertbin6bit(int, char*);
    void convertbin24bit(int, char*);
    int dataline, textline, instrCount;
%}
labelname ([a-zA-Z_][a-zA-Z0-9_]*)
reg ([0-9]|[12][0-9]|3[01])
regwithout0 ([1-9]|[12][0-9]|3[01])
reg6bit ([0-9]|[1-5][0-9]|6[0-3])
sitwopow14 [+-]?([0-9]|[1-8][0-9]|9[0-9]|[1-8][0-9]{2}|9[0-8][0-9]|99[0-9]|[1-7][0-9]{3}|80[0-9]{2}|81[0-8][0-9]|819[01])|"-8192"
sitwopow16 [+-]?([0-9]|[1-8][0-9]|9[0-9]|[1-8][0-9]{2}|9[0-8][0-9]|99[0-9]|[1-8][0-9]{3}|9[0-8][0-9]{2}|99[0-8][0-9]|999[0-9]|[12][0-9]{4}|3[01][0-9]{3}|32[0-6][0-9]{2}|327[0-5][0-9]|3276[0-7])|"-32768"
uitwopow16 ([0-9]|[1-8][0-9]|9[0-9]|[1-8][0-9]{2}|9[0-8][0-9]|99[0-9]|[1-8][0-9]{3}|9[0-8][0-9]{2}|99[0-8][0-9]|999[0-9]|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5])
functname ([a-zA-Z_][a-zA-Z0-9_]*)

%%
"add"[ ]+{reg}[ ]*,[ ]*{reg}[ ]*,[ ]*{reg}[ \n]+ {
    instrCount++;
}
"addi"[ ]+{reg}[ ]*,[ ]*{reg}[ ]*,[ ]*{sitwopow16}[ \n]+ {
    instrCount++;
} 
"addis"[ ]+{reg}[ ]*,[ ]*{reg}[ ]*,[ ]*{sitwopow16}[ \n]+ {
   instrCount++;
}
"and"[ ]+{reg}[ ]*,[ ]*{reg}[ ]*,[ ]*{reg}[ \n]+ {
    instrCount++;
}
"subf"[ ]+{reg}[ ]*,[ ]*{reg}[ ]*,[ ]*{reg}[ \n]+ {
    instrCount++;
}  
"andi"[ ]+{reg}[ ]*,[ ]*{reg}[ ]*,[ ]*{uitwopow16}[ \n]+ {
  instrCount++;
} 
"ori"[ ]+{reg}[ ]*,[ ]*{reg}[ ]*,[ ]*{uitwopow16}[ \n]+ {
   instrCount++;
}
"or"[ ]+{reg}[ ]*,[ ]*{reg}[ ]*,[ ]*{reg}[ \n]+ {
    instrCount++;
}
"nand"[ ]+{reg}[ ]*,[ ]*{reg}[ ]*,[ ]*{reg}[ \n]+ {
    instrCount++;
} 
"rlwinm"[ ]+{reg}[ ]*,[ ]*{reg}[ ]*,[ ]*{reg}[ ]*,[ ]*{reg}[ ]*,[ ]*{reg}[ \n]+ {
   instrCount++;
}
"sld"[ ]+{reg}[ ]*,[ ]*{reg}[ ]*,[ ]*{reg}[ \n]+ {
    instrCount++;
} 
"srd"[ ]+{reg}[ ]*,[ ]*{reg}[ ]*,[ ]*{reg}[ \n]+ {
   instrCount++;
}
"srad"[ ]+{reg}[ ]*,[ ]*{reg}[ ]*,[ ]*{reg}[ \n]+ {
    instrCount++;
}
"sradi"[ ]+{reg}[ ]*,[ ]*{reg}[ ]*,[ ]*{reg}[ \n]+ {
    instrCount++;
}
"ld"[ ]+{reg}[ ]*,[ ]*{sitwopow14}\({reg}\)[ \n]+ {
    instrCount++;
}
"lwz"[ ]+{reg}[ ]*,[ ]*{sitwopow16}\({reg}\)[ \n]+ {
    instrCount++;
}
"std"[ ]+{reg}[ ]*,[ ]*{sitwopow14}\({reg}\)[ \n]+ {
    instrCount++;
}
"stw"[ ]+{reg}[ ]*,[ ]*{sitwopow16}\({reg}\)[ \n]+ {
    instrCount++;
}
"stwu"[ ]+{reg}[ ]*,[ ]*{sitwopow16}\({regwithout0}\)[ \n]+ {
    instrCount++;
}
"lhz"[ ]+{reg}[ ]*,[ ]*{sitwopow16}\({reg}\)[ \n]+ {
    instrCount++;
}
"lha"[ ]+{reg}[ ]*,[ ]*{sitwopow16}\({reg}\)[ \n]+ {
    instrCount++;
}
"sth"[ ]+{reg}[ ]*,[ ]*{sitwopow16}\({reg}\)[ \n]+ {
    instrCount++;
}
"lbz"[ ]+{reg}[ ]*,[ ]*{sitwopow16}\({reg}\)[ \n]+ {
    instrCount++;
}
"stb"[ ]+{reg}[ ]*,[ ]*{sitwopow16}\({reg}\)[ \n]+ {
    instrCount++;
}
"b"[ ]+{functname}[ \n]+ {
    instrCount++;
}
"ba"[ ]+{functname}[ \n]+ {
    instrCount++;
}
"bl"[ ]+{functname}[ \n]+ {
    instrCount++;
}
"bc"[ ]+{reg}[ ]*,[ ]*{reg}[ ]*,[ ]*{functname}[ \n]+ {
    instrCount++;
}
"bclr"[ \n]+ {
    instrCount++;
}
"bca"[ ]+{functname}[ \n]+ {
    instrCount++;
}
"la"[ ]+{reg}[ ]*,[ ]*{functname}[ \n]+ {
    instrCount++;          
}
{labelname}[ ]*\:[ \n]+ {
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
    strcpy(functlabels[functlabelcount][0], varName);
    strcpy(vardata[functlabelcount][0], varName); // name of label
    char addressInTextSec[17] = {0};
    convertbincomp(functlabelcount * 4, addressInTextSec, 0);
    strcpy(functlabels[functlabelcount][1], addressInTextSec);  // address
    strcpy(vardata[functlabelcount][1], addressInTextSec);

    stringctrl += (count + 1);
    
    
    functlabelcount++;
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
    
    FILE* funcSymTab = fopen("funcsymtab.txt", "w");
    yylex();

    for(int j = 0; j < functlabelcount; j++) {
        fprintf(funcSymTab, "%s %s\n", functlabels[j][0], functlabels[j][1]);
    }
    
    fclose(inputFile);
    fclose(funcSymTab);
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
 //Implementation of Lexical Analyzer using Lex tool
%{
    #include<stdio.h>
    #include<string.h>
    int COUNT[8]={0},line = 1;
    char identifiers[100][100];
    char keywords[100][100];
    char operators[100][10]; 
    char separators[100][10]; 
%}
identifier [a-zA-Z_][a-zA-Z0-9]*
separator [{};:,.]
start \/\* 
end  \*\/ 
notid [0-9][a-zA-Z0-9]*


%%
\/\/(.*) ; 
\/\*(.*\n)*.*\*\/  {};			
#.* {
        printf("\nline %d : %s -> PREPROCESSOR DIRECTIVE",line,yytext);
    }
auto|double|int|struct|break|else|long|switch|case|enum|register|typedef|char|extern|return|union|continue|for|signed|void|do|if|static|while|default|goto|sizeof|volatile|const|float|short {
        printf("\nline %d : %s -> KEYWORD",line, yytext);
        strcpy(keywords[COUNT[1]++],yytext);
    }
{separator} {
            printf("\nline %d : %s -> SEPARATOR",line,yytext);
            strcpy(separators[COUNT[3]++],yytext);
}




{identifier}\( {
        printf("\nline %d : %s -> FUNCTION",line,yytext);
        strcpy(identifiers[COUNT[0]++],yytext);
    }

{identifier}(\[[0-9]*\])? {
        
            printf("\nline %d : %s -> IDENTIFIER",line,yytext);
            strcpy(identifiers[COUNT[0]++],yytext);
        
    }

\".*\" {
        printf("\nline %d : %s -> CHARACTER_ARRAY",line,yytext);
    }
[0-9]+ {
         printf("\nline %d : %s -> NUMBER ",line,yytext);
}
{notid} {
    printf("\nline %d : %s -> INVALID IDENTIFIER",line,yytext);
}

\)(\:)? {
        printf("\n\t");ECHO;printf("\n");
    }
\( ECHO;
= { 
        printf("\nline %d : %s -> ASSIGNMENT OPERATOR",line,yytext);
        strcpy(operators[COUNT[2]++],yytext);
}
\<= |
\>= |
\< |
== |
\> {
            printf("\nline %d : %s -> RELATIONAL OPERATOR",line,yytext);
            strcpy(operators[COUNT[2]++],yytext);
    }



\n {
    line++;
}
%%

int main(int argc, char **argv)
{
    if(argc < 2){
        printf("Enter a file!");
        return 1;
    }
    FILE *inputFile, *outputFile;
    inputFile = fopen(argv[1], "r");
    if(!inputFile){
        printf("Error opening file!");
        exit(0);
    }
    yyin = inputFile;
    yylex();
    printf("\n%d",line);
    printf("\nIDENTIFIERS : ");
    for(int i = 0;i < COUNT[0];i++)
        printf("%s, ",identifiers[i]);
        printf("\t count: %d",COUNT[0]);
    printf("\nKEYWORDS : ");
    for(int i = 0;i < COUNT[1];i++)
        printf("%s, ",keywords[i]);
        printf("\t count: %d",COUNT[1]);

    printf("\nOPERATORS : ");
    for(int i = 0;i < COUNT[2];i++)
        printf("%s, ",operators[i]);
        printf("\t count: %d",COUNT[2]);

    printf("\nSEPARATORS : ");
    for(int i = 0;i < COUNT[3];i++)
        printf("%s, ",separators[i]);
        printf("\t count: %d",COUNT[3]);

    printf("\n");
    return(0);
}
int yywrap()
{
    return(1);
}
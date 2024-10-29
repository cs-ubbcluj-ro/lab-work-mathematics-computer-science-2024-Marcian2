%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define MAX_SYMBOLS 100
#define MAX_PIF 200 

typedef struct {
    char name[50];
    int position;
} Symbol;

typedef struct {
    char lexeme[50];
    char type[20];
} PIF;

Symbol symbol_table[MAX_SYMBOLS];
int symbol_count = 0;
PIF pif[MAX_PIF];
int pif_count = 0;

int add_to_symbol_table(const char *name, int is_constant);
void print_symbol_table();
void add_to_pif(const char *lexeme, const int type);
void print_pif();

%}

%%
"include"                { add_to_pif("INCLUDE", 0); }
"iostream"              { add_to_pif("IOSTREAM", 0); }
"using"                 { add_to_pif("USING", 0); }
"namespace"             { add_to_pif("NAMESPACE", 0); }
"std"                   { add_to_pif("STD", 0); }
"int"                   { add_to_pif("INT", 0); }
"main"                  { add_to_pif("MAIN", 0); }
"cout"                  { add_to_pif("COUT", 0); }
"cin"                   { add_to_pif("CIN", 0); }
"for"                   { add_to_pif("FOR", 0); }
"if"                    { add_to_pif("IF", 0); }
"else"                  { add_to_pif("ELSE", 0); }
"break"                  { add_to_pif("BREAK", 0); }
"endl"                  { add_to_pif("ENDL", 0); }
"("                     { add_to_pif("LPAREN", 0); }
")"                     { add_to_pif("RPAREN", 0); }
"{"                     { add_to_pif("LBRACE", 0); }
"}"                     { add_to_pif("RBRACE", 0); }
";"                     { add_to_pif("SEMICOLON", 0); }
","                     { add_to_pif("COMMA", 0); }
"=="                    { add_to_pif("EQUALS", 0); }
"!="                    { add_to_pif("NOTEQUALS", 0); }
"<"                     { add_to_pif("LESS", 0); }
"<="                    { add_to_pif("LESSEQUAL", 0); }
">"                     { add_to_pif("GREATER", 0); }
">="                    { add_to_pif("GREATEREQUAL", 0); }
"="                     { add_to_pif("ASSIGN", 0); }
[0-9]+ {
                        int pos = add_to_symbol_table(yytext, 1);
                        add_to_pif(yytext, pos);
}
[a-zA-Z_][a-zA-Z0-9_]*      {
                        int pos = add_to_symbol_table(yytext, 0);
                        add_to_pif(yytext, pos);                           
}
\"([^\\\"]|\\.)*\"      { add_to_pif(yytext, 0); }
"/*"([^*]|\*+[^/*])*\*+"/" { /* Ignore multi-line comments */ }
"//".*                   { /* Ignore single-line comments */ }
[ \t]+                  { /* Ignore whitespace */ }
\n                      { /* Ignore new lines */ }
.                       {printf("Error unknown");}
%%

int yywrap() {
    return 1; 
}

int add_to_symbol_table(const char *name, int is_constant) {
    for (int i = 0; i < symbol_count; i++) {
        if (strcmp(symbol_table[i].name, name) == 0) {
            return symbol_table[i].position;
        }
    }
    strcpy(symbol_table[symbol_count].name, name);
    symbol_table[symbol_count].position = symbol_count + 1;
    symbol_count++;
    return symbol_table[symbol_count - 1].position;
}

void print_symbol_table() {
    printf("Symbol Table:\n");
    for (int i = 0; i < symbol_count; i++) {
        printf("%s - %d\n", symbol_table[i].name, symbol_table[i].position);
    }
}

void add_to_pif(const char *lexeme, int type) {
    if (pif_count < MAX_PIF) {
        strcpy(pif[pif_count].lexeme, lexeme);
        sprintf(pif[pif_count].type, "%d", type);
        pif_count++;
    } else {
        printf("PIF overflow\n");
    }
}

void print_pif() {
    printf("Program Internal Form (PIF):\n");
    for (int i = 0; i < pif_count; i++) {
        printf("%s - %s\n", pif[i].lexeme, pif[i].type);
    }
}

int main() {
    yylex();
    print_symbol_table();
    print_pif();
    return 0;
}

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define YYDEBUG 1

extern int yylineno;
extern char* yytext;

int productions_used[100];
int production_count = 0;
int yylex(void);

void yyerror(const char* s);

void add_production(int index) {
    if (production_count < 100) {
        productions_used[production_count++] = index;
    }
}

void print_productions() {
    printf("Productions used: ");
    for (int i = 0; i < production_count; i++) {
        printf("%d ", productions_used[i]);
    }
    printf("\n");
}

%}

%union {
    char* string;
}

%token <string> INCLUDE IOSTREAM USING NAMESPACE STD MAIN INT CIN COUT IF ELSE FOR WHILE DO BREAK ENDL IDENTIFIER CONSTANT
%token ASSIGN LESS LESSEQUAL GREATER GREATEREQUAL EQUAL NOTEQUAL PLUS MOD SEMICOLON COMMA LPAREN RPAREN LBRACE RBRACE
%token LSHIFT
%token DIEZ
%token <string> STRING_LITERAL
%token COLON
%type <string> factor expression term
%type <string> decl_stmt assign_stmt io_stmt 
%type stmt_list expr_stmt

%%
program:
    DIEZ INCLUDE LESS IOSTREAM GREATER USING NAMESPACE STD SEMICOLON INT MAIN LPAREN RPAREN LBRACE stmt_list RBRACE {
        printf("Parsing completed successfully.\n");
        print_productions();
    }
    { add_production(1); }
    ;

stmt_list:
    stmt stmt_list { add_production(2); }
    | /* empty */ { add_production(3); }
    ;

stmt:
    decl_stmt SEMICOLON { add_production(4); }
    | assign_stmt SEMICOLON { add_production(5); }
    | io_stmt SEMICOLON { add_production(6); }
    | if_stmt { add_production(7); }
    | for_stmt { add_production(8); }
    | expr_stmt SEMICOLON { add_production(9); }
    | BREAK SEMICOLON { add_production(10); }
    ;

decl_stmt:
    INT identifier_list { add_production(11); }
    | INT identifier_list ASSIGN expression { add_production(12); }
    ;

identifier_list:
    IDENTIFIER { add_production(13); }
    | IDENTIFIER COMMA identifier_list { add_production(14); }
    ;

assign_stmt:
    IDENTIFIER ASSIGN expression { add_production(15); }
    ;

expression:
    term { add_production(16); }
    | term PLUS expression { add_production(17); }
    ;

term:
    factor { add_production(18); }
    | factor MOD term { add_production(19); }
    ;

factor:
    CONSTANT { add_production(20); }
    | IDENTIFIER { add_production(21); }
    ;

io_stmt:
    COUT LSHIFT expression { add_production(22); }
    | io_stmt LSHIFT expression { add_production(23); }
    | COUT LSHIFT STRING_LITERAL { add_production(24); }
    | io_stmt LSHIFT STRING_LITERAL { add_production(25); }
    | COUT LSHIFT ENDL { add_production(26); }
    | io_stmt LSHIFT ENDL { add_production(27); }
    | CIN GREATER GREATER IDENTIFIER { add_production(28); }
    | io_stmt GREATER GREATER IDENTIFIER { add_production(29); }
    ;

if_stmt:
    IF LPAREN condition RPAREN LBRACE stmt_list RBRACE { add_production(30); }
    | IF LPAREN condition RPAREN LBRACE stmt_list RBRACE ELSE LBRACE stmt_list RBRACE { add_production(31); }
    ;

for_stmt:
    FOR LPAREN assign_stmt SEMICOLON condition SEMICOLON assign_stmt RPAREN LBRACE stmt_list RBRACE { add_production(32); }
    ;

expr_stmt:
    expression { add_production(33); }
    | /* empty */ { add_production(34); }
    ;

condition:
    expression rel_op expression { add_production(35); }
    ;

rel_op:
    LESS { add_production(36); }
    | LESSEQUAL { add_production(37); }
    | GREATER { add_production(38); }
    | GREATEREQUAL { add_production(39); }
    | EQUAL { add_production(40); }
    | NOTEQUAL { add_production(41); }
    ;
%%

void yyerror(const char* s) {
    fprintf(stderr, "Error at line %d: %s (token: %s)", yylineno, s, yytext);
}

int main() {
    if (yyparse() == 0) {
        printf("Parsing completed successfully.\n");
    } else {
        printf("Parsing failed.\n");
    }
    return 0;
}

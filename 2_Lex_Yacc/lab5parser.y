%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define YYDEBUG 1


/* External declarations */
extern int yylineno;
extern char* yytext;

void yyerror(const char* s);
int yylex(void);
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
    }
    ;

stmt_list:
    stmt stmt_list
    | /* empty */
    ;

stmt:
    decl_stmt SEMICOLON
    | assign_stmt SEMICOLON
    | io_stmt SEMICOLON
    | if_stmt
    | for_stmt
    | expr_stmt SEMICOLON
    | BREAK SEMICOLON 
    ;

decl_stmt:
    INT identifier_list
    | INT identifier_list ASSIGN expression
    ;


identifier_list:
    IDENTIFIER
    | IDENTIFIER COMMA identifier_list
    ;

assign_stmt:
    IDENTIFIER ASSIGN expression 
    ;

expression:
    term
    | term PLUS expression 
    ;

term:
    factor
    | factor MOD term 
    ;

factor:
    CONSTANT 
    | IDENTIFIER 
    
    ;

io_stmt:
    COUT LSHIFT expression 
    | io_stmt LSHIFT expression 
    | COUT LSHIFT STRING_LITERAL 
    | io_stmt LSHIFT STRING_LITERAL 
    | COUT LSHIFT ENDL 
    | io_stmt LSHIFT ENDL 
    | CIN GREATER GREATER IDENTIFIER 
    | io_stmt GREATER GREATER IDENTIFIER 
    ;



if_stmt:
    IF LPAREN condition RPAREN LBRACE stmt_list RBRACE 
    | IF LPAREN condition RPAREN LBRACE stmt_list RBRACE ELSE LBRACE stmt_list RBRACE
    ;

for_stmt:
    FOR LPAREN assign_stmt SEMICOLON condition SEMICOLON assign_stmt RPAREN LBRACE stmt_list RBRACE 
    ;

expr_stmt:
    expression
    | /* empty */
    ;

condition:
    expression rel_op expression 
    ;

rel_op:
    LESS 
    | LESSEQUAL 
    | GREATER 
    | GREATEREQUAL 
    | EQUAL 
    | NOTEQUAL 
    ;
%%

void yyerror(const char* s) {
    fprintf(stderr, "Error at line %d: %s (token: %s)", yylineno, s, yytext);
}

int main() {
    if (yyparse() == 0) {
        printf("Parsing completed successfully.");
    } else {
        printf("Parsing failed.");
    }
    return 0;
}

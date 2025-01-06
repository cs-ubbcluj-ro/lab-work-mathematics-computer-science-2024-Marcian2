%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"

int yyline = 1; 
extern int yylineno;  
%}

%%

"#"                 { printf("Token: DIEZ, Value: %s\n", yytext); return DIEZ; }
"include"           { printf("Token: INCLUDE, Value: %s\n", yytext); return INCLUDE; }
"iostream"          { printf("Token: IOSTREAM, Value: %s\n", yytext); return IOSTREAM; }
"using"             { printf("Token: USING, Value: %s\n", yytext); return USING; }
"namespace"         { printf("Token: NAMESPACE, Value: %s\n", yytext); return NAMESPACE; }
"std"               { printf("Token: STD, Value: %s\n", yytext); return STD; }
"int"               { printf("Token: INT, Value: %s\n", yytext); return INT; }
"main"              { printf("Token: MAIN, Value: %s\n", yytext); return MAIN; }
"cout"              { printf("Token: COUT, Value: %s\n", yytext); return COUT; }
"cin"               { printf("Token: CIN, Value: %s\n", yytext); return CIN; }
"for"               { printf("Token: FOR, Value: %s\n", yytext); return FOR; }
"if"                { printf("Token: IF, Value: %s\n", yytext); return IF; }
"else"              { printf("Token: ELSE, Value: %s\n", yytext); return ELSE; }
"break"             { printf("Token: BREAK, Value: %s\n", yytext); return BREAK; }
"endl"              { printf("Token: ENDL, Value: %s\n", yytext); return ENDL; }
"("                 { printf("Token: LPAREN, Value: %s\n", yytext); return LPAREN; }
")"                 { printf("Token: RPAREN, Value: %s\n", yytext); return RPAREN; }
"{"                 { printf("Token: LBRACE, Value: %s\n", yytext); return LBRACE; }
"}"                 { printf("Token: RBRACE, Value: %s\n", yytext); return RBRACE; }
";"                 { printf("Token: SEMICOLON, Value: %s\n", yytext); return SEMICOLON; }
","                 { printf("Token: COMMA, Value: %s\n", yytext); return COMMA; }
"=="                { printf("Token: EQUAL, Value: %s\n", yytext); return EQUAL; }
"!="                { printf("Token: NOTEQUAL, Value: %s\n", yytext); return NOTEQUAL; }
"<"                 { printf("Token: LESS, Value: %s\n", yytext); return LESS; }
"<="                { printf("Token: LESSEQUAL, Value: %s\n", yytext); return LESSEQUAL; }
">"                 { printf("Token: GREATER, Value: %s\n", yytext); return GREATER; }
">="                { printf("Token: GREATEREQUAL, Value: %s\n", yytext); return GREATEREQUAL; }
"="                 { printf("Token: ASSIGN, Value: %s\n", yytext); return ASSIGN; }
"+"                 { printf("Token: PLUS, Value: %s\n", yytext); return PLUS; }
"%"                 { printf("Token: MOD, Value: %s\n", yytext); return MOD; }
":"                 { printf("Token: COLON, Value: %s\n", yytext); return COLON; }
"<<"                { printf("Token: LSHIFT, Value: %s\n", yytext); return LSHIFT; }
[0-9]+ {
    yylval.string = strdup(yytext);
    printf("Token: CONSTANT, Value: %s\n", yytext);
    return CONSTANT;
}
\"[^\"]*\" {
    yylval.string = strdup(yytext);
    printf("Token: STRING_LITERAL, Value: %s\n", yytext);
    return STRING_LITERAL;
}
[a-zA-Z_][a-zA-Z0-9_]* {
    yylval.string = strdup(yytext);
    printf("Token: IDENTIFIER, Value: %s\n", yytext);
    return IDENTIFIER;
}
[ \t]+              ; 
\n                  { yyline++; yylineno = yyline; } 
.                   { printf("Error at line %d: Unknown character '%s'\n", yyline, yytext); }
%%

int yywrap() {
    return 1;
}

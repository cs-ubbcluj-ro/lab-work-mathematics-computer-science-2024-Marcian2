%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"

int yyline = 1; 
extern int yylineno;  
%}

%%

"#"                 { return DIEZ; }
"include"           { return INCLUDE; }
"iostream"          { return IOSTREAM; }
"using"             { return USING; }
"namespace"         { return NAMESPACE; }
"std"               { return STD; }
"int"               { return INT; }
"main"              { return MAIN; }
"cout"              { return COUT; }
"cin"               { return CIN; }
"for"               { return FOR; }
"if"                { return IF; }
"else"              { return ELSE; }
"break"             { return BREAK; }
"endl"              { return ENDL; }
"("                 { return LPAREN; }
")"                 { return RPAREN; }
"{"                 { return LBRACE; }
"}"                 { return RBRACE; }
";"                 { return SEMICOLON; }
","                 { return COMMA; }
"=="                { return EQUAL; }
"!="                { return NOTEQUAL; }
"<"                 { return LESS; }
"<="                { return LESSEQUAL; }
">"                 { return GREATER; }
">="                { return GREATEREQUAL; }
"="                 { return ASSIGN; }
"+"                 { return PLUS; }
"%"                 { return MOD; }
":"                 { return COLON; }
"<<"                { return LSHIFT; }
[0-9]+ {
    yylval.string = strdup(yytext);
    return CONSTANT;
}
\"[^\"]*\" {
    yylval.string = strdup(yytext);
    return STRING_LITERAL;
}
[a-zA-Z_][a-zA-Z0-9_]* {
    yylval.string = strdup(yytext);
    return IDENTIFIER;
}
[ \t]+              ; 
\n                  { yyline++; yylineno = yyline; } 
.                   { printf("Error at line %d: Unknown character '%s'\n", yyline, yytext); }
%%

int yywrap() {
    return 1;
}

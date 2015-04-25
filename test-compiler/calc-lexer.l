%{
#include "calc.h"
#include "./calc-parser.tab.h"   
%}

digit [0-9]
letter [a-zA-Z]

space [ ]
tab [\t]
newline [\n]
whitespace {space}+|{tab}+

int {digit}+
decimal {digit}+\.{digit}*|{digit}*\.{digit}+ 
symbol {letter}({letter}|{digit})*

number {int}|{decimal}

%%

"+" |
"-" |
"*" |
"/" |
"=" |
"|" |
"," |
";" |
"(" |
")" { return yytext[0]; }

">"     { yylval.fn = 1; return CMP; }
"<"     { yylval.fn = 2; return CMP; }
"!="    { yylval.fn = 3; return CMP; }
"=="    { yylval.fn = 4; return CMP; }
">="    { yylval.fn = 5; return CMP; }
"<="    { yylval.fn = 6; return CMP; }

"if"    { return IF; }
"then"  { return THEN; }
"else"  { return ELSE; }
"while" { return WHILE; }
"do"    { return DO; }
"let"   { return LET; }

"sqrt"  { yylval.fn = B_sqrt; return FUNC; }
"exp"   { yylval.fn = B_exp; return FUNC; }
"log"   { yylval.fn = B_log; return FUNC; }
"print" { yylval.fn = B_print; return FUNC; }

{symbol} {
    yylval.s = lookup(yytext);
    return NAME;
}

{number} {
    yylval.d = atof(yytext);
    return NUMBER;
}

\\\n { printf("c> "); }

{newline} {
    return EOL;
}

{whitespace} {
    //ignore this
}

. {
    // if nothing matched then we have a problem
    printf("error with %s\n", yytext);
}

%%

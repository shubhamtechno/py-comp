%{
#include <stdio.h>
%}

%token NEWLINE INDENT DEDENT ENDMARKER 
%token KEYWORD PUNCT ID
%token LIT

%%

fileinput               : NEWLINE
                        | fileinput statement ENDMARKER
                        ;

statement               : simple_statement
                        | compound_statement
                        ;

simple_statement        : small_statement PUNCT NEWLINE
                        ;

small_statement         : flow_statement
                        ;

flow_statement          : return_statement
                        ;

return_statement        : KEYWORD expression
                        ;

expression              : arithmetic_expression
                        ;

arithmetic_expression   : term 
                        | arithmetic_expression '+' term
                        | arithmetic_expression '-' term
                        ;

term                    : factor
                        | term '*' factor
                        | term '/' factor
                        ;

factor                  : power
                        ;

power                   : atom 
                        | atom trailer
                        ;

atom                    : LIT 
                        ;

trailer                 : '(' argument_list ')'
                        ;

argument_list           : argument
                        | argument_list ',' argument
                        ;

argument                : expression
                        ;

compound_statement      : 
                        ;


%%

int yyerror(char *s) {
	printf("%s\n", s);	
}

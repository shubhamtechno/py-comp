%{
#include <stdio.h>
#include <stdlib.h>
%}

%token NEWLINE INDENT DEDENT 
%token KEYWORD PUNCT ID
%token LIT
%token ENDMARKER 

%token FALSE IS RETURN FOR IF ELIF ELSE DEF

%%

simple_statement        : return_statement ';' NEWLINE
							{ printf("small!\n"); }
                        ;

return_statement        : RETURN arithmetic_expression 
							{ 
								printf("return!\n"); 
							}
                        ;

arithmetic_expression   : term 
                        | arithmetic_expression '+' term 
							{ 
								printf("arith!\n"); 
							}
                        | arithmetic_expression '-' term 
							{ 
								printf("arith!\n"); 
							}
                        ;

term                    : LIT 
							{
								printf("term!\n"); 
							}
						;
%%

int main() 
{
	//int tok;

	//while(tok = yylex()) {
	//	printf("%d\n", tok);
	//}

	yyparse();
}

int yyerror(char *s) 
{
	printf("%s\n", s);	
}

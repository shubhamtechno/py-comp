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

file_input				: stmt 
						| file_input stmt 
							{ printf("multiple file!\n"); }
						;

funcdef					: DEF ID parameters ':' NEWLINE
							{ printf("function\n"); }
						;

parameters				: '(' typedargslist ')'
						;

/* TODO -- make this allow more types of arguments. */
typedargslist			: ID
						| typedargslist ',' ID 
						;

stmt					: simple_stmt 
							{ printf("statement\n"); }
						| compound_stmt
						;

/* TODO -- allow multiple simple statements on same line. */
simple_stmt		        : small_stmt ';' NEWLINE
							{ printf("simple statement!\n"); }
						;

compound_stmt			: funcdef
						;

small_stmt				: flow_stmt
							{ printf("small statement!\n"); }
						;

flow_stmt				: return_stmt
							{ printf("flow statement!\n"); }
						;

return_stmt			    : RETURN testlist 
							{ printf("return!\n"); }
                        ;

testlist				: test
						;

test					: or_test
						;

or_test					: and_test
						;

and_test				: not_test
						;

not_test				: comparison
						;

comparison				: expr
						;

expr					: arith_expr
						;

arith_expr				: term 
                        | arith_expr '+' term 
							{ printf("arith!\n"); }
                        | arith_expr '-' term 
							{ printf("arith!\n"); }
                        ;

term                    : factor
						| term '*' factor 
							{ printf("term!\n"); }
						| term '/' factor
							{ printf("term!\n"); }
						| term '%' factor
							{ printf("term!\n"); }
						;

factor					: power
						;

power					: atom
						;

atom					: LIT
							{ printf("atom!\n"); }
						| ID
							{ printf("atom!\n"); }
						;

%%

int main() 
{
//	int tok;
//
//	push(0);
//	while(tok = yylex()) {
//		printf("%d\n", tok);
//	}

	yyparse();
}

int yyerror(char *s) 
{
	printf("%s\n", s);	
}

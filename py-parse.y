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

file_input		: stmt 
				| file_input stmt 
				;

funcdef			: DEF ID parameters ':' NEWLINE
				;

parameters		: '(' typedargslist ')'
				;

/* TODO -- make this allow more types of arguments. */
typedargslist	: ID
				| typedargslist ',' ID 
				;

stmt			: simple_stmt 
				| compound_stmt
				;

/* TODO -- allow multiple simple statements on same line. */
simple_stmt		: small_stmt ';' NEWLINE
				;

compound_stmt	: funcdef
				;

small_stmt		: flow_stmt
				;

flow_stmt		: return_stmt
				;

return_stmt		: RETURN testlist 
				;

testlist		: test
				;

test			: or_test
				;

or_test			: and_test
				;

and_test		: not_test
				;

not_test		: comparison
				;

comparison		: expr
				;

expr			: arith_expr
				;

arith_expr		: term 
				| arith_expr '+' term 
				| arith_expr '-' term 
				;

term			: factor
				| term '*' factor 
				| term '/' factor
				| term '%' factor
				;

factor			: power
				;

power			: atom
				;

atom			: LIT
				| ID
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

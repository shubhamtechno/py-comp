%{
#include <stdio.h>
%}

%token NEWLINE INDENT DEDENT ENDMARKER 
%token KEYWORD PUNCT ID
%token LIT

%%


fileinput	:
			;

/* grammar */

%%

int yyerror(char *s) {
	printf("%s\n", s);	
}

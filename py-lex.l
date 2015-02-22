%{
#include "py-parse.tab.h"
#define MAX_INDENTS 1000

int stack[MAX_INDENTS];
int top = 0;

int poll() {
	return stack[top - 1];
}

int pop() {
	return stack[--top];	
}

void push(int value) {
	stack[top++] = value;
}

int handle_indentation(int current_indentation) {
	int previous_indentation = poll();
	
	if (current_indentation > previous_indentation) {
		push(current_indentation);
		return INDENT;
	}

	// TODO -- This might be a terrible way of handling dedentation?
	int times_dedented = 0;
	while (current_indentation < previous_indentation) {
		pop();
		times_dedented++;
		previous_indentation = poll();
	}
	yylval = times_dedented;
	return DEDENT;
}

%}

digit		[0-9]
alpha		[A-Za-z_]
keyword		False|class|finally|is|return|None|continue|for|lambda|try|True|def|from|nonlocal|while|and|del|global|not|with|as|elif|if|or|yield|assert|else|import|pass|break|except|in|raise
operator	\+|-|\*|\*\*|\/|\/\/|%|<<|>>|&|\||\^|~|<|>|<=|>=|==|!=
delimeter	\(|\)|\[|\]|\{|\}|,|:|\.|;|@|=|->|\+=|-=|\*=|\/=|\/\/=|%=|&=|\|=|\^=|>>=|<<=|\*\*=
string		\"[^"]*\"
comment		[ ]*#.*
newline		[ ]*\n
spaces		[ ]+

int			{digit}+
float		{digit}*\.{digit}*
alnum		{alpha}|{digit}
identifier	{alpha}{alnum}*
punctuation	{operator}|{delimeter}
literal		{string}|{float}|{int}

%s MAIN NEWLINE_STATE

%%

<INITIAL>{keyword} {
	yylval = 12;
	BEGIN(MAIN);
	return KEYWORD;
}

<INITIAL>{identifier} {
	BEGIN(MAIN);
	return ID;
}

<INITIAL>{literal} {
	BEGIN(MAIN);
	return LIT;
}

<INITIAL>{punctuation} {
	BEGIN(MAIN);
	return PUNCT;
}

<INITIAL,NEWLINE_STATE>{newline} {
	// Ignore newlines at the beginning.
	// Also treat consecutive newlines as just one newline.
}

<MAIN,INITIAL,NEWLINE_STATE>{comment} {
	// ignore all comments
}

<MAIN>{newline} {
	BEGIN(NEWLINE_STATE);
	return NEWLINE;
}

<INITIAL,MAIN>{spaces} {
	// ignore spaces 
}

<MAIN>{keyword} {
	return KEYWORD;
}

<MAIN>{identifier} {
	return ID;
}

<MAIN>{literal} {
	return LIT;
}

<MAIN>{punctuation} {
	return PUNCT;
}

<NEWLINE_STATE>{spaces} {
	BEGIN(MAIN);
	// handle indentation here.
	// current indentation is length of yytext, i.e. amount of spaces matched.
	return handle_indentation(strlen(yytext));
}

<NEWLINE_STATE>{keyword}|{identifier}|{literal}|{punctuation} {
	BEGIN(MAIN);
	// put back the matched text after entering main.
	yyless(0);
	return handle_indentation(0);
}

.|\n {
	// if nothing matched then we have a problem
	printf("error with %s\n", yytext);
}

%%

int main() {
	int tok;

	while(tok = yylex()) {
		switch(tok) {
			case NEWLINE: printf("(NEWLINE)\n"); break;
			case INDENT: printf("(INDENT)\n"); break;
			case DEDENT: 
				for (int i = 0; i < yylval; i++) { 
					printf("(DEDENT)\n"); 
				}
				break;
			case KEYWORD: printf("(KEYWORD %s)\n", yytext); break;
			case PUNCT: printf("(PUNCT \"%s\")\n", yytext); break;
			case ID: printf("(ID \"%s\")\n", yytext); break;
			case LIT: printf("(LIT %s)\n", yytext); break;
		}
	}

	printf("(ENDMARKER)\n");

	return 0;
}

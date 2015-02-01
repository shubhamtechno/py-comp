%{

%}

digit		[0-9]
int			{digit}+
float		{digit}*\.{digit}*
alpha		[A-Za-z_]
alnum		{alpha}|{digit}
identifier	{alpha}{alnum}*
keyword		False|class|finally|is|return|None|continue|for|lambda|try|True|def|from|nonlocal|while|and|del|global|not|with|as|elif|if|or|yield|assert|else|import|pass|break|except|in|raise
operator	\+|-|\*|\*\*|\/|\/\/|%|<<|>>|&|\||\^|~|<|>|<=|>=|==|!=
delimeter	\(|\)|\[|\]|\{|\}|,|:|\.|;|@|=|->|\+=|-=|\*=|\/=|\/\/=|%=|&=|\|=|\^=|>>=|<<=|\*\*=
punctuation	{operator}|{delimeter}
string		\"(\\.|[^"])*\"
comment		#.*\n
literal		{string}|{float}|{int}
newline		\n(\s|\n|{comment})*
tab			\t

%%


{keyword} {
	//keyword
	printf("(KEYWORD %s)\n", yytext);
}

{identifier} {
	// identifier
	printf("(ID \"%s\")\n", yytext);
}

{punctuation} {
	printf("(PUNCT \"%s\")\n", yytext);
}

{literal} {
	printf("(LIT %s)\n", yytext);
}

{newline} {
	printf("(NEWLINE)\n");
}

{comment} {
	//printf("comment %s\n", yytext);
}

.|\n {
	//printf("error %s\n", yytext);
}

%%

int main() {
	yylex();
	printf("(ENDMARKER)\n");
	return 0;
}

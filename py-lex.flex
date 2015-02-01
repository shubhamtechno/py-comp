%{
int stack[1000];
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

void handleIndentation(int currentIndentation) {
	int previousIndentation = poll();
	
	if (currentIndentation > previousIndentation) {
		printf("(INDENT)\n");
		push(currentIndentation);
		return;
	}

	while (currentIndentation < previousIndentation) {
		pop();
		printf("(DEDENT)\n");
		previousIndentation = poll();
	}
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

%s MAIN NEWLINE

%%
<MAIN>{newline} {
	printf("(NEWLINE)\n");
	BEGIN(NEWLINE);
}

<MAIN>{spaces} {
	// ignore these spaces
}

<MAIN,INITIAL>{keyword} {
	printf("(KEYWORD %s)\n", yytext);
	BEGIN(MAIN);
}

<MAIN,INITIAL>{identifier} {
	printf("(ID \"%s\")\n", yytext);
	BEGIN(MAIN);
}

<MAIN,INITIAL>{punctuation} {
	printf("(PUNCT \"%s\")\n", yytext);
	BEGIN(MAIN);
}

<MAIN,INITIAL>{literal} {
	printf("(LIT %s)\n", yytext);
	BEGIN(MAIN);
}

<MAIN>{comment} {
	printf("(NEWLINE)\n");
	BEGIN(NEWLINE);
}

<INITIAL,NEWLINE>{newline} {
	// ignore newlines at beginning of file
	// ignore multiple newlines
}

<NEWLINE>{spaces} {
	int currentIndentation = strlen(yytext); 
	handleIndentation(currentIndentation);
	BEGIN(MAIN);
}

<NEWLINE>{keyword} {
	handleIndentation(0);

	printf("(KEYWORD %s)\n", yytext);
	BEGIN(MAIN);
}

<NEWLINE>{identifier} {
	handleIndentation(0);

	printf("(ID \"%s\")\n", yytext);
	BEGIN(MAIN);
}

<NEWLINE>{punctuation} {
	handleIndentation(0);

	printf("(PUNCT \"%s\")\n", yytext);
	BEGIN(MAIN);
}

<NEWLINE>{literal} {
	handleIndentation(0);

	printf("(LIT %s)\n", yytext);
	BEGIN(MAIN);
}

<INITIAL,NEWLINE>{comment} {
	// ignore comments at beginning of file
}

.|\n {
	// if nothing matched then we have a problem
	printf("error %s\n", yytext);
}

%%

int main() {
	push(0);
	yylex();
	printf("(ENDMARKER)\n");
	return 0;
}

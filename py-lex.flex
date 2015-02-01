%{
int beginingOfFile = 1;

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
%}

digit		[0-9]
alpha		[A-Za-z_]
keyword		False|class|finally|is|return|None|continue|for|lambda|try|True|def|from|nonlocal|while|and|del|global|not|with|as|elif|if|or|yield|assert|else|import|pass|break|except|in|raise
operator	\+|-|\*|\*\*|\/|\/\/|%|<<|>>|&|\||\^|~|<|>|<=|>=|==|!=
delimeter	\(|\)|\[|\]|\{|\}|,|:|\.|;|@|=|->|\+=|-=|\*=|\/=|\/\/=|%=|&=|\|=|\^=|>>=|<<=|\*\*=
string		\"[^"]*\"
comment		[ ]*#.*\n
newline		[ ]*\n
spaces		[ ]+

int			{digit}+
float		{digit}*\.{digit}*
alnum		{alpha}|{digit}
identifier	{alpha}{alnum}*
punctuation	{operator}|{delimeter}
literal		{string}|{float}|{int}

%s NEWLINE

%%
<INITIAL>{newline} {
	if (!beginingOfFile)
		printf("(NEWLINE)\n");
	BEGIN(NEWLINE);
}

<NEWLINE>{newline} {
	// ignore multiple newlines
}

<INITIAL>{spaces} {
	// ignore these spaces
}

<NEWLINE>{spaces} {
	// these spaces are indentation.

	int previousIndentation = poll();
	int currentIndentation = strlen(yytext) - 1; // -1 to account for new line character

	if (currentIndentation > previousIndentation) {
		push(currentIndentation);
		printf("(INDENT)\n");
	} else if (currentIndentation < previousIndentation) {
		pop();	
		printf("(DEDENT)\n");
	} else {
		// do nothing when equal
	}
	BEGIN(INITIAL);
}

{keyword} {
	printf("(KEYWORD %s)\n", yytext);

	beginingOfFile = 0;
	BEGIN(INITIAL);
}

{identifier} {
	printf("(ID \"%s\")\n", yytext);

	beginingOfFile = 0;
	BEGIN(INITIAL);
}

{punctuation} {
	printf("(PUNCT \"%s\")\n", yytext);

	beginingOfFile = 0;
	BEGIN(INITIAL);
}

{literal} {
	printf("(LIT %s)\n", yytext);

	beginingOfFile = 0;
	BEGIN(INITIAL);
}

{comment} {
	// ignore comments
}

.|\n {
	printf("error %s\n", yytext);
}

%%

int main() {
	push(0);
	yylex();
	printf("(ENDMARKER)\n");
	return 0;
}

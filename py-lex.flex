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
%}

digit		[0-9]
alpha		[A-Za-z_]
keyword		False|class|finally|is|return|None|continue|for|lambda|try|True|def|from|nonlocal|while|and|del|global|not|with|as|elif|if|or|yield|assert|else|import|pass|break|except|in|raise
operator	\+|-|\*|\*\*|\/|\/\/|%|<<|>>|&|\||\^|~|<|>|<=|>=|==|!=
delimeter	\(|\)|\[|\]|\{|\}|,|:|\.|;|@|=|->|\+=|-=|\*=|\/=|\/\/=|%=|&=|\|=|\^=|>>=|<<=|\*\*=
string		\"[^"]*\"
comment		\s*#.*\n
newline		\n*
spaces		[ ]+

int			{digit}+
float		{digit}*\.{digit}*
alnum		{alpha}|{digit}
identifier	{alpha}{alnum}*
punctuation	{operator}|{delimeter}
literal		{string}|{float}|{int}
indentation \n[ ]+

%%

{keyword} {
	printf("(KEYWORD %s)\n", yytext);
}

{identifier} {
	printf("(ID \"%s\")\n", yytext);
}

{punctuation} {
	printf("(PUNCT \"%s\")\n", yytext);
}

{literal} {
	printf("(LIT %s)\n", yytext);
}

{indentation} {
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
}

{newline} {
	printf("(NEWLINE)\n");
}

{spaces}|{comment} {
	// ignore these
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

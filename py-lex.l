%{
#include "py-parse.tab.h"
#define MAX_INDENTS 1000

int stack[MAX_INDENTS];
int top = 0;

int poll() 
{
    return stack[top - 1];
}

int pop() 
{
    return stack[--top];    
}

void push(int value) 
{
    stack[top++] = value;
}

int handle_indentation(int current_indentation) 
{
    int previous_indentation = poll();
    
    if (current_indentation > previous_indentation) 
    {
        push(current_indentation);
        return INDENT;
    }

    if (current_indentation < previous_indentation) 
    {
        pop();
        return DEDENT;
    }

    return 0;
}

int get_token_for_keyword(char *keyword) 
{
    // TODO -- add rest of keywords
    if (strcmp(keyword, "False") == 0) 
    {
        return FALSE;
    } 
    else if (strcmp(keyword, "is") == 0) 
    {
        return IS;
    } 
    else if (strcmp(keyword, "return") == 0) 
    {
        return RETURN;
    }
    else if (strcmp(keyword, "for") == 0) 
    {
        return FOR;
    }
    else if (strcmp(keyword, "if") == 0) 
    {
        return IF;
    }
    else if (strcmp(keyword, "elif") == 0) 
    {
        return ELIF;
    }
    else if (strcmp(keyword, "else") == 0) 
    {
        return ELSE;
    }
    else if (strcmp(keyword, "def") == 0) 
    {
        return DEF;
    }
    return KEYWORD;
}

int get_token_for_punctuation(char *punctuation) 
{
    // TODO -- add rest of punctuation
    if (strcmp(punctuation, "(") == 0) 
    {
        return '(';
    } 
    else if (strcmp(punctuation, ")") == 0) 
    {
        return ')';
    } 
    else if (strcmp(punctuation, "+") == 0) 
    {
        return '+';
    }
    else if (strcmp(punctuation, "-") == 0) 
    {
        return '-';
    }
    else if (strcmp(punctuation, "*") == 0) 
    {
        return '*';
    }
    else if (strcmp(punctuation, "/") == 0) 
    {
        return '/';
    }
    else if (strcmp(punctuation, "%") == 0) 
    {
        return '%';
    }
    else if (strcmp(punctuation, "=") == 0) 
    {
        return '=';
    }
    else if (strcmp(punctuation, "<") == 0) 
    {
        return '<';
    }
    else if (strcmp(punctuation, ";") == 0) 
    {
        return ';';
    }
    else if (strcmp(punctuation, ":") == 0) 
    {
        return ':';
    }
    else if (strcmp(punctuation, ",") == 0) 
    {
        return ',';
    }
    return PUNCT;
}

%}

digit       [0-9]
alpha       [A-Za-z_]
keyword     False|class|finally|is|return|None|continue|for|lambda|try|True|def|from|nonlocal|while|and|del|global|not|with|as|elif|if|or|yield|assert|else|import|pass|break|except|in|raise
operator    \+|-|\*|\*\*|\/|\/\/|%|<<|>>|&|\||\^|~|<|>|<=|>=|==|!=
delimeter   \(|\)|\[|\]|\{|\}|,|:|\.|;|@|=|->|\+=|-=|\*=|\/=|\/\/=|%=|&=|\|=|\^=|>>=|<<=|\*\*=
string      \"[^"]*\"
comment     [ ]*#.*
newline     [ ]*\n
spaces      [ ]+

int         {digit}+
float       {digit}*\.{digit}*
alnum       {alpha}|{digit}
identifier  {alpha}{alnum}*
punctuation {operator}|{delimeter}
literal     {string}|{float}|{int}

%s MAIN NEWLINE_STATE

%%

<INITIAL>{keyword} {
    BEGIN(MAIN);
    // TODO -- add rest of keywords.
    return get_token_for_keyword(yytext);
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
    return get_token_for_punctuation(yytext);
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
    return get_token_for_keyword(yytext);
}

<MAIN>{identifier} {
    return ID;
}

<MAIN>{literal} {
    return LIT;
}

<MAIN>{punctuation} {
    return get_token_for_punctuation(yytext);
}

<NEWLINE_STATE>{spaces} {
    int current_indentation = strlen(yytext);
    int token = handle_indentation(current_indentation);

    if (current_indentation >= poll()) BEGIN(MAIN);
    else yyless(0);

    return token;
}

<NEWLINE_STATE>{keyword}|{identifier}|{literal}|{punctuation} {
    yyless(0);

    int token = handle_indentation(0);
    if (0 >= poll()) BEGIN(MAIN);

    return token;
}

.|\n {
    // if nothing matched then we have a problem
    printf("error with %s\n", yytext);
}

%%


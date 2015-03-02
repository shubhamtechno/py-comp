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

extern int yylineno;
void yyerror(char *s);

struct ast {
    int nodetype;
	struct ast *l;
	struct ast *r;
};

struct ast *newast(int nodetype, struct ast *l, struct ast *r);

void treefree(struct ast*);

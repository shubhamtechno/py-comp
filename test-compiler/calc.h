struct symbol {
    char *name;
    double value;
    struct ast *func;
    struct symlist *syms;
};

#define NHASH 9997
struct symbol symtab[NHASH];
struct symbol *lookup(char*);

/*
 * + - * /
 * 0-7 comp ops
 * M unary minus
 * L expression or statement list
 * I IF
 * W WHILE
 * N symboli
 * = assignemnt
 * S list of symbols
 * F built int function call
 * C user function call
 */

enum bifs { /* built in functions */
    B_sqrt = 1,
    B_exp,
    B_log,
    B_print
};

struct ast {
    int nodetype; 
    struct ast *l;
    struct ast *r;
};

struct fncall {
    int nodetype; /* type F */
    struct ast *l;
    enum bifs functype;
};

struct ufncall {
    int nodetype; /* type C */
    struct ast *l;
    struct symbol *s;
};

struct flow {
    int nodetype; /* type I */
    struct ast *cond;
    struct ast *tl;
    struct ast *el;
};

struct numval {
    int nodetype; /* type K */
    double number;
};

struct symref {
    int nodetype; /* type N */
    struct symbol *s;
};

struct symasgn {
    int nodetype; /* type V */
    struct symbol *s;
    struct ast *v;
};

struct symlist {
    struct symbol *sym;
    struct symlist *next;
};

struct ast *newast(int nodetype, struct ast *l, struct ast *r);
struct ast *newcmp(int cmptype, struct ast *l, struct ast *r);
struct ast *newfunc(int functype, struct ast *l);
struct ast *newcall(struct symbol *s, struct ast *l);
struct ast *newref(struct symbol *s);
struct ast *newasgn(struct symbol *s, struct ast *v);
struct ast *newnum(double number);
struct ast *newflow(int nodetype, struct ast *cond, struct ast *tl, struct ast *tr);

struct symlist *newsymlist(struct symbol *sym, struct symlist *next);

void dodef(struct symbol *name, struct symlist *syms, struct ast *stmts);
double eval(struct ast *);
void treefree(struct ast *);

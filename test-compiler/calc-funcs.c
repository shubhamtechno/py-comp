#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include "./calc.h"

static unsigned int symhash(char *sym) {
    unsigned int hash = 0;
    unsigned c;

    while(c = *sym++) hash = hash * 9 ^ c;

    return hash % NHASH;
}

struct symbol *lookup(char *sym) {
    struct symbol *sp = &symtab[symhash(sym)];
    int scound = NHASH;
     while(--scound >= 0) {
        if (sp->name && !strcmp(sp->name, sym)) { 
            return sp; 
        }

        if (!sp->name) {
            sp->name = strdup(sym);
            sp->value = 0;
            sp->func = NULL;
            sp->syms = NULL;
            return sp;
        }
     }
}

struct ast *newast(int nodetype, struct ast *l, struct ast *r) {
    struct ast *a = malloc(sizeof(struct ast));
    a->nodetype = nodetype;
    a->l = l;
    a->r = r;
    return a;
}

struct ast *newcmp(int cmptype, struct ast *l, struct ast *r) {
    struct ast *a = malloc(sizeof(struct ast));    
    a->nodetype = cmptype;
    a->l = l;
    a->r = r;
    return a;
}

struct ast *newfunc(int functype, struct ast *l) {
    struct fncall *f = malloc(sizeof(struct fncall));    
    f->nodetype = 'F';
    f->l = l;
    f->functype = functype;
    return (struct ast *)f;
}

struct ast *newcall(struct symbol *s, struct ast *l) {
    struct ufncall *u = malloc(sizeof(struct ufncall));    
    u->nodetype = 'C';
    u->l = l;
    u->s = s;
    return (struct ast *)u;
}

struct ast *newref(struct symbol *s) {
    struct symref *r = malloc(sizeof(struct symref));
    r->nodetype = 'N';
    r->s = s;
    return (struct ast *)r;
}

struct ast *newasgn(struct symbol *s, struct ast *v) {
    struct symasgn *a = malloc(sizeof(struct symasgn));
    a->nodetype = 'V';
    a->s = s;
    a->v = v;
    return (struct ast *)a;
}

struct ast *newnum(double number) {
    struct numval *num = malloc(sizeof(struct numval));
    num->nodetype = 'K';
    num->number = number;
    return (struct ast *)num;
}

struct ast *newflow(int nodetype, struct ast *cond, struct ast *tl, struct ast *el) {
    struct flow *f = malloc(sizeof(struct flow));    
    f->nodetype = nodetype;
    f->cond = cond;
    f->tl = tl;
    f->el = el;
    return (struct ast *)f;
}

struct symlist *newsymlist(struct symbol *sym, struct symlist *next) {
    struct symlist *s = malloc(sizeof(struct symlist));    
    s->sym = sym;
    s->next = next;
    return s;
}

double eval(struct ast* a) {
    double v;
    switch (a->nodetype) {
        case '+': 
            v = eval(a->l) + eval(a->r);
            break;
        case '-': 
            v = eval(a->l) - eval(a->r);
            break;
        case '*': 
            v = eval(a->l) * eval(a->r);
            break;
        case '/': 
            v = eval(a->l) / eval(a->r);
            break;
        case 'K':
            v = ((struct numval *)a)->number;
            break;
        case 'N':
            v = ((struct symref *)a)->s->value;
            break;
        case 'V':
            v = ((struct symasgn *)a)->s->value = eval(((struct symasgn *)a)->v);
            break;
    }
    return v;
}

void treefree(struct ast* a) {
}

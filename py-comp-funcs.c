#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "py-comp.h"

struct ast *newast(int nodetype, struct ast *l, struct ast *r) {
	struct ast *a = (struct ast*) malloc(sizeof(struct ast));

	a->nodetype = nodetype;
	a->l = l;
	a->r = r;

	return a;
}

void treefree(struct ast*);

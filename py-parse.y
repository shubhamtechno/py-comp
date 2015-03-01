/* Lots taken from https://docs.python.org/3/reference/grammar.html */
%{
#include <stdio.h>
#include <stdlib.h>
%}

%token NEWLINE INDENT DEDENT 
%token KEYWORD PUNCT ID
%token LIT
%token ENDMARKER 

%token FALSE IS RETURN FOR IF ELIF ELSE DEF DOUBLE_EQ

%%

file_input
    : stmt  
        { printf("file input\n"); }
    | file_input stmt  
        { printf("file input\n"); }
    ;

funcdef
    : DEF ID parameters ':' suite 
        { printf("func def\n"); }
    ;

parameters
    : '(' typedargslist ')' 
        { printf("parameters\n"); }
    ;

/* TODO -- make this allow more types of arguments. */
typedargslist
    : ID 
        { printf("type d args list\n"); }
    | typedargslist ',' ID  
        { printf("type d args list\n"); }
    ;

suite
    : stmt
        { printf("suite\n"); }
    | NEWLINE INDENT stmt DEDENT
        { printf("suite 1\n"); }
    | NEWLINE INDENT suite stmt DEDENT
        { printf("suite 2\n"); }
    ;

stmt            
    : simple_stmt  
        { printf("stmt\n"); }
    | compound_stmt 
        { printf("stmt\n"); }
    ;

/* TODO -- allow multiple simple statements on same line. */
simple_stmt 
    : small_stmt ';' NEWLINE 
        { printf("simple stmt\n"); }
    | small_stmt NEWLINE 
        { printf("simple stmt\n"); }
    ;

compound_stmt
    : if_stmt 
        { printf("compund stmt\n"); }
    | funcdef 
        { printf("compund stmt\n"); }
    ;

/* TODO -- fix ambiguities here */
if_stmt
    : IF test ':' suite elif_stmt else_stmt
        { printf("if stmnt\n"); }
    ;

elif_stmt
    :
    | elif_stmt ELIF test ':' suite
        { printf("elif stmnt\n"); }
    ;

else_stmt
    : 
    | ELSE ':' suite
        { printf("else stmnt\n"); }
    ;

small_stmt
    : expr_stmt 
        { printf("small stmt\n"); }
    | flow_stmt
        { printf("small stmt\n"); }
    ;   

expr_stmt
    : testlist_star_expr
    ;

testlist_star_expr
    : test
    ;

flow_stmt
    : return_stmt 
        { printf("flow stmt\n"); }
    ;

return_stmt
    : RETURN testlist 
        { printf("return stmt\n"); } 
    ;

testlist
    : test 
        { printf("test list\n"); }
    ;

test            
    : or_test 
        { printf("test\n"); }
    ;

or_test
    : and_test 
        { printf("or test\n"); }
    ;

and_test
    : not_test 
        { printf("and test\n"); }
    ;

not_test
    : comparison 
        { printf("not test\n"); }
    ;

comparison
    : expr 
        { printf("comparison\n"); }
    | expr comp_op comparison 
    ;

comp_op
    : '<'
    | '>'
    | DOUBLE_EQ
    ;

expr            
    : arith_expr 
        { printf("expr\n"); }
    ;

arith_expr
    : term  
        { printf("arith expr\n"); }
    | arith_expr '+' term 
        { printf("arith expr\n"); } 
    | arith_expr '-' term  
        { printf("arith expr\n"); }
    ;

term
    : factor 
        { printf("term\n"); }
    | term '*' factor 
        { printf("term\n"); } 
    | term '/' factor 
        { printf("term\n"); }
    | term '%' factor 
        { printf("term\n"); }
    ;

factor
    : power 
        { printf("factor\n"); }
    ;

power
    : atom trailer
        { printf("power\n"); }
    ;

trailer
    :
    | '(' arglist ')'
    ;

arglist
    : argument
    | arglist ',' argument
    ;

argument
    : test
    ;

atom            
    : LIT 
        { printf("atom\n"); }
    | ID 
        { printf("atom\n"); }
    ;

%%

int main() 
{
//    int tok;
//
//    push(0);
//    while(tok = yylex()) {
//        printf("%d\n", tok);
//    }
//    printf("0\n");

    yyparse();

    return 0;
}

int yyerror(char *s) 
{
    printf("%s\n", s);  
}

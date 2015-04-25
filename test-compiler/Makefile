all:
	bison -d ./calc-parser.y
	flex ./calc-lexer.l
	gcc ./calc-parser.tab.c ./lex.yy.c ./calc-funcs.c -lfl

clean:
	rm ./lex.yy.c ./calc-parser.tab.c ./calc-parser.tab.h ./a.out

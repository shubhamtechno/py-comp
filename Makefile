all:
	flex ./py-lex.flex
	cc ./lex.yy.c -lfl

run:
	make
	./a.out < sample.py	

clean:
	rm ./lex.yy.c ./a.out

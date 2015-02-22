all: 
	bison -d py-parse.y
	flex py-lex.l
	gcc py-parse.tab.c lex.yy.c -lfl -std=c99

run:
	make
	./a.out < sample.py	

test: 
	make
	./a.out < ./tests/test1.py > ./tests/actual-test1.txt
	diff -y ./tests/expected-test1.txt ./tests/actual-test1.txt

clean:
	rm ./lex.yy.c ./py-parse.tab.c ./py-parse.tab.h ./a.out ./tests/actual*.txt 

all:
	flex ./py-lex.flex
	cc ./lex.yy.c -lfl

run:
	make
	./a.out < sample.py	

test: 
	make
	./a.out < ./tests/test1.py > ./tests/actual-test1.txt
	diff ./tests/expected-test1.txt ./tests/actual-test1.txt

clean:
	rm ./lex.yy.c ./a.out ./tests/actual*.txt

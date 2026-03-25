all: s21_grep

s21_grep: s21_grep.o
	gcc s21_grep.o -o s21_grep

s21_grep.o: s21_grep.c s21_grep.h
	gcc -Wall -Werror -Wextra -std=c11 -c s21_grep.c -o s21_grep.o

clean:
	rm -f s21_grep s21_grep.o

rebuild:
	make clean && make

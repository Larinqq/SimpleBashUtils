all: s21_cat

s21_cat: s21_cat.o
	gcc s21_cat.o -o s21_cat

s21_cat.o: s21_cat.c s21_cat.h
	gcc -Wall -Werror -Wextra -c s21_cat.c -o s21_cat.o

clean:
	rm -f s21_cat s21_cat.o

rebuild:
	make clean && make

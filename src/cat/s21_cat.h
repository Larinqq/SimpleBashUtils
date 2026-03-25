#ifndef s21_cat_h
#define s21_cat_h

#include <getopt.h>
#include <stdio.h>
#include <stdlib.h>

typedef struct {
  int b;
  int e;
  int n;
  int s;
  int t;
  int v;
} options;

void parse_opts(int argc, char *argv[], options *opts, int *is_error);
void parse_files(int argc, char *argv[], char **files, int *counter);
int check_file_is_exist(char *file_path);
void print_cat_func(char *file_path, options opts, int *line_number);

#endif

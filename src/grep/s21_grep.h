#ifndef s21_grep_h
#define s21_grep_h

#define _POSIX_C_SOURCE 200809L
#include <getopt.h>
#include <regex.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
  int pattern_count;
  int file_index;
  int file_count;
  int i;
  int v;
  int c;
  int l;
  int n;
  int h;
  int s;
} options;

void parse_opts(int argc, char *argv[], options *opts, int *is_error,
                char *patterns[]);
int check_file_is_exist(char *file_path);
void compile_patterns(options *opts, int *is_error, regex_t compt_patterns[],
                      char *patterns[]);
void free_compiled_patterns(options *opts, regex_t compt_patterns[]);
void print_grep_func(char *file_path, options *opts, regex_t compt_patterns[]);

#endif

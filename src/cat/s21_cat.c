#include "s21_cat.h"

int main(int argc, char *argv[]) {
  int is_error = 0;
  options opts = {0};
  char *files[argc];
  int file_count = 0;
  int line_number = 1;
  parse_opts(argc, argv, &opts, &is_error);
  if (!is_error) parse_files(argc, argv, files, &file_count);
  if (!is_error) {
    for (int i = 0; i < file_count; i++) {
      if (check_file_is_exist(files[i]))
        print_cat_func(files[i], opts, &line_number);
      else
        fprintf(stderr, "cat: %s: No such file or directory\n", files[i]);
    }
  }
  return 0;
}

void parse_opts(int argc, char *argv[], options *opts, int *is_error) {
  static struct option long_options[] = {{"number-nonblank", 0, 0, 'b'},
                                         {"number", 0, 0, 'n'},
                                         {"squeeze-blank", 0, 0, 's'},
                                         {0, 0, 0, 0}};
  int option_index;
  int rez;
  while (((rez = getopt_long(argc, argv, "+bevnEstT", long_options,
                             &option_index)) != -1) &&
         !(*is_error)) {
    switch (rez) {
      case 'b':
        opts->b = 1;
        break;
      case 'n':
        opts->n = 1;
        break;
      case 's':
        opts->s = 1;
        break;
      case 'E':
        opts->e = 1;
        break;
      case 'e':
        opts->e = 1;
        opts->v = 1;
        break;
      case 't':
        opts->t = 1;
        opts->v = 1;
        break;
      case 'T':
        opts->t = 1;
        break;
      case 'v':
        opts->v = 1;
        break;
      default:
        fprintf(stderr, "example: s21_cat [OPTION] [FILE]...\n");
        *is_error = 1;
    }
  }
}

void parse_files(int argc, char *argv[], char **files, int *counter) {
  for (int i = 1; i < argc; i++) {
    if (argv[i][0] != '-') {
      files[*counter] = argv[i];
      *counter += 1;
    }
  }
}

int check_file_is_exist(char *file_path) {
  int is_exist = 1;
  FILE *given_file = fopen(file_path, "r");
  if (given_file == NULL)
    is_exist = 0;
  else
    fclose(given_file);
  return is_exist;
}

void print_cat_func(char *file_path, options opts, int *line_number) {
  FILE *given_file = fopen(file_path, "r");
  int current_ch, prev_ch = '\n';
  int squeeze_blank = 0;
  int line_start = 1;
  while ((current_ch = fgetc(given_file)) != EOF) {
    int skip_char = 0;
    int print_char = 1;
    int special_print = 0;
    if (opts.s) {
      if (current_ch == '\n') {
        if (prev_ch == '\n') {
          squeeze_blank++;
          if (squeeze_blank > 1) {
            skip_char = 1;
          }
        }
      } else {
        squeeze_blank = 0;
      }
    }
    if (line_start && current_ch != '\n' && opts.b && !skip_char) {
      printf("%6d\t", (*line_number)++);
      line_start = 0;
    } else if (line_start && opts.n && !opts.b && !skip_char) {
      printf("%6d\t", (*line_number)++);
      line_start = 0;
    }
    if (opts.v && !skip_char) {
      if (current_ch < 32 && current_ch != '\t' && current_ch != '\n' &&
          !skip_char) {
        printf("^%c", current_ch + 64);
        print_char = 0;
        special_print = 1;
      } else if (current_ch == 127 && !skip_char) {
        printf("^?");
        print_char = 0;
        special_print = 1;
      }
    }
    if (print_char && opts.t && current_ch == '\t' && !skip_char) {
      printf("^I");
      print_char = 0;
      special_print = 1;
    }
    if (print_char && opts.e && current_ch == '\n' && !skip_char) {
      printf("$");
    }
    if (print_char && !special_print && !skip_char) {
      printf("%c", current_ch);
    }
    if (current_ch == '\n' && !skip_char) {
      line_start = 1;
    }
    if (!skip_char) prev_ch = current_ch;
  }
  fclose(given_file);
}

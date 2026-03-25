#include "s21_grep.h"

int main(int argc, char *argv[]) {
  char *patterns[argc];
  regex_t compt_patterns[argc];
  int is_error = 0;
  options opts = {0};
  parse_opts(argc, argv, &opts, &is_error, patterns);

  if (!is_error) compile_patterns(&opts, &is_error, compt_patterns, patterns);
  opts.file_count = argc - opts.file_index;

  if (!is_error) {
    for (int i = opts.file_index; (i < argc); i++) {
      if (check_file_is_exist(argv[i]))

        print_grep_func(argv[i], &opts, compt_patterns);
      else if (!opts.s)
        fprintf(stderr, "grep: %s: No such file or directory\n", argv[i]);
    }
    free_compiled_patterns(&opts, compt_patterns);
  }

  return 0;
}
void parse_opts(int argc, char *argv[], options *opts, int *is_error,
                char *patterns[]) {
  int rez;
  while (((rez = getopt(argc, argv, "e:ivclnhs")) != -1) && !(*is_error)) {
    switch (rez) {
      case 'e':
        patterns[opts->pattern_count++] = optarg;
        break;
      case 'i':
        opts->i = 1;
        break;
      case 'v':
        opts->v = 1;
        break;
      case 'c':
        opts->c = 1;
        break;
      case 'l':
        opts->l = 1;
        break;
      case 'n':
        opts->n = 1;
        break;
      case 'h':
        opts->h = 1;
        break;
      case 's':
        opts->s = 1;
        break;
      default:
        printf("example s21_grep [options] template [file_name]");
        *is_error = 1;
    }
  }

  if (opts->pattern_count == 0 && optind < argc) {
    patterns[opts->pattern_count++] = argv[optind++];
  }

  opts->file_index = optind;
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

void compile_patterns(options *opts, int *is_error, regex_t compt_patterns[],
                      char *patterns[]) {
  int success_counter = 0;
  int flags = 0;
  if (opts->i) flags |= REG_ICASE;

  for (int i = 0; (i < opts->pattern_count) && !(*is_error); i++) {
    if (regcomp(&compt_patterns[success_counter], patterns[i], flags) != 0) {
      *is_error = 1;
      fprintf(stderr, "grep: invalid regular expression\n");
    }
    if (!(*is_error)) success_counter++;
  }
  if (!(*is_error)) opts->pattern_count = success_counter;
}

void free_compiled_patterns(options *opts, regex_t compt_patterns[]) {
  for (int i = 0; i < opts->pattern_count; i++) {
    regfree(&compt_patterns[i]);
  }
}
void print_grep_func(char *file_path, options *opts, regex_t compt_patterns[]) {
  FILE *given_file = fopen(file_path, "r");

  char *line = NULL;
  size_t len_buf = 0;
  int line_number = 0;
  ssize_t line_len;
  int skip_file = 0;
  int match_counter = 0;

  while ((line_len = getline(&line, &len_buf, given_file)) != -1 &&
         !skip_file) {
    int match = 0;
    int skip_line = 0;
    line_number++;

    for (int i = 0; i < opts->pattern_count; i++) {
      if (regexec(&compt_patterns[i], line, 0, NULL, 0) == 0) {
        match = 1;
        break;
      }
    }

    if (opts->v) match = !match;

    if (opts->l && match) {
      printf("%s\n", file_path);
      skip_file = 1;
      skip_line = 1;
    }

    if (match && !skip_line) match_counter++;

    if (opts->c && !skip_line) skip_line = 1;

    if (match && !skip_line) {
      if (opts->file_count > 1) {
        if (!opts->h) printf("%s:", file_path);
      }
      if (opts->n) printf("%d:", line_number);

      char *check_enter_char = strchr(line, '\n');
      if (check_enter_char != NULL)
        printf("%s", line);
      else
        printf("%s\n", line);
    }
  }

  free(line);
  fclose(given_file);

  if (opts->c && !opts->l) {
    if (opts->file_count > 1) {
      if (!opts->h)
        printf("%s:%d\n", file_path, match_counter);
      else
        printf("%d\n", match_counter);
    } else
      printf("%d\n", match_counter);
  }
}

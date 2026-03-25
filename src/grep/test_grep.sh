#!/bin/bash

compare_output() {
    local test_num=$1
    local flags=$2
    local pattern=$3
    shift 3
    local files=("$@")
    local red='\033[0;31m'
    local green='\033[0;32m'
    local reset='\033[0m'
    
    grep $flags "$pattern" "${files[@]}" > grep_output.txt 2>/dev/null
    ./s21_grep $flags "$pattern" "${files[@]}" > s21_grep_output.txt 2>/dev/null
    if diff -q grep_output.txt s21_grep_output.txt > /dev/null; then
        echo -e "Test $test_num with flags: $flags pattern: $pattern in file: ${files[*]} ${green}PASS ${reset}"
        return 0
    else
        echo -e "Test $test_num with flags: $flags pattern: $pattern in file: ${files[*]} ${red}FAIL ${reset}"
        return 1
    fi
}

run_tests() {
    local red='\033[0;31m'
    local green='\033[0;32m'
    local reset='\033[0m'
    local test_singe_files=("1.txt" "2.txt" "3.txt")
    local test_multi_files=("1.txt 2.txt" "2.txt 3.txt" "1.txt 2.txt 3.txt" "1.txt 2.txt 3.txt nofile.txt")
    local patterns=("[0-9]+" "a.c" "Nik" "rik" "Rik" "[" "++"  "-e nik -e rik" "world!  " "Multiple    spaces" " " "^Line")
    local flags=("-v" "-i" "-c" "-l" "-s" "-h" "-n" "-e" "-v" "-n -e" "-l -e" "-v -e" "-i -e" "-nl -e" "-vlsh -e" "-c -l -e" "-i -v -e" "-i -c -h -e" "-n -e" "-ncl -s -e")
    local test_num=0
    local pass_counter=0
    local fails_counter=0
    
    echo -e "\n TESTING SINGLE FILE\n"
    for file in "${test_singe_files[@]}"; do
        for pattern in "${patterns[@]}"; do
            for flag in "${flags[@]}"; do
                ((test_num++))
                compare_output $test_num "$flag" "$pattern" "$file"
                if [ $? -eq 0 ]; then
                    ((pass_counter++))
                else
                    ((fails_counter++))
                fi
            done
        done
    done

    echo -e "\nTESTING MULTIPLE FILES\n"
        for files in "${test_multi_files[@]}"; do
            for pattern in "${patterns[@]}"; do
                for flag in "${flags[@]}"; do
                    ((test_num++))
                    compare_output $test_num "$flag" "$pattern" $files
                    if [ $? -eq 0 ]; then
                    ((pass_counter++))
                else
                    ((fails_counter++))
                fi
                done
            done
        done
    echo -e "\nTotal tests: $test_num \n${green}PASS: $pass_counter ${reset}\n${red}FAIL: $fails_counter ${reset}"
    rm -f grep_output.txt s21_grep_output.txt
}

run_tests

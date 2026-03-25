#!/bin/bash

compare_output() {
    local test_num=$1
    local flags=$2
    local file=$3
    local red='\033[0;31m'
    local green='\033[0;32m'
    local reset='\033[0m'

    cat -$flags "$file" > cat_output.txt 2>/dev/null
    ./s21_cat -$flags "$file" > s21_cat_output.txt 2>/dev/null
    if diff -q cat_output.txt s21_cat_output.txt > /dev/null; then
        echo -e "Test $test_num: flags: -$flags, file: $file ${green}PASS${reset}"
        return 0
    else
        echo -e "Test $test_num: flags: -$flags, file: $file ${red}FAIL${reset}"
        return 1
    fi
}

run_tests() {
    local red='\033[0;31m'
    local green='\033[0;32m'
    local reset='\033[0m'
    local test_files=("1.txt" "2.txt" "3.txt" "ascii.txt")
    local flags=(
        "b" "e" "n" "s" "t" "E" "T" "v"
        "be" "bn" "bs" "bt" "bE" "bT"
        "en" "es" "et" "eE" "eT"
        "ns" "nt" "nE" "nTv"
        "st" "sE" "sT"
        "tE" "tT"
        "ET"
    )
    

    local long_flags=("--number" "--number-nonblank" "--squeeze-blank")
    local test_num=0
    local pass_counter=0
    local fails_counter=0
    
    echo -e "\nTESTING SINGLE AND COMBINED FLAGS\n"
    
    for file in "${test_files[@]}"; do
      
        for flag in "${flags[@]}"; do
            ((test_num++))
            compare_output $test_num "$flag" "$file"
            if [ $? -eq 0 ]; then
                ((pass_counter++))
            else
                ((fails_counter++))
            fi
        done
    done

    echo -e "\nTESTING LONG FLAGS (GNU-style)\n"

    for file in "${test_files[@]}"; do
        for flag in "${long_flags[@]}"; do
            ((test_num++))
            cat $flag "$file" > cat_output.txt 2>/dev/null
            ./s21_cat $flag "$file" > s21_cat_output.txt 2>/dev/null
            
            if diff -q cat_output.txt s21_cat_output.txt > /dev/null; then
                echo -e "Test $test_num: flag: $flag, file: $file ${green}PASS${reset}"
                ((pass_counter++))
            else
                echo -e "Test $test_num: flag: $flag, file: $file ${red}FAIL${reset}"
                ((fails_counter++))
            fi
        done
    done
    
    echo -e "\nTESTING COMPLETED"
    echo -e "Total tests: $test_num"
    echo -e "${green}PASSED: $pass_counter${reset}"
    echo -e "${red}FAILED: $fails_counter${reset}"
    rm -f cat_output.txt s21_cat_output.txt
}

run_tests

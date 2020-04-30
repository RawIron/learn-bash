#!/usr/bin/env bash


function success_per_interval() {
    # roughly every 100 requests a log record should be written
    # throw a dice to decide if a request is logged
    # count how many log entries expected to be written after 100 requests
    # simulate the distribution
    success=0
    for sim in {0..100000}; do
        if [[ $((1 + RANDOM % 100)) -eq 1 ]]; then
            success=$((success+1))
        fi
        if [[ $((sim % 100)) -eq 0 ]]; then
            echo $success
            success=0
        fi
    done
}


success_per_interval \
    | awk '{size[int($1)]++} END {for (i in size) printf("%14d %4d\n", i, size[i])}' \
    | sort -n

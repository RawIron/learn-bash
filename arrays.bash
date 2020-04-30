#!/bin/bash

mapfile -t numbers< <(tail -n +2 | tr ' ' '\n')
declare -A number_count

for number in ${numbers[@]}; do
    if [[ ${number_count[$number]+_} ]]; then
        number_count[$number]=1
    else
        number_count[$number]=0
    fi
done

echo ${number_count[@]}

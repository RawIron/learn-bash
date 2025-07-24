source bunit.bash
#set -x


# DICTIONARY
#   associative array
declare -A wordcount

wordcount["bash"]=45
wordcount["zsh"]=21
[[ ${wordcount["zsh"]} -eq 21 ]] ; should_pass

# compound assignment
wordcount=("bash" 13 "zsh" 12)
[[ ${wordcount["zsh"]} -eq 12 ]] ; should_pass

wordcount=(["bash"]=3 \
           ["zsh"]=2)
[[ ${wordcount["zsh"]} -eq 2 ]] ; should_pass


# count words in a text
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


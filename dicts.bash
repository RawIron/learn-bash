source bunit.bash
#set -x


# DICTIONARY
declare -A wordcount

wordcount["bash"]=45
wordcount["zsh"]=21
[[ ${wordcount["zsh"]} -eq 21 ]] ; should_pass


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


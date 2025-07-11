source bunit.bash
#set -x

# ARRAY, LIST

#
words=("arrays" "in" "bash" "like this")
[[ ${words[2]} == "bash" ]] ; should_pass
[[ ${words[3]} == "like this" ]] ; should_pass

# literals are strings
#   quotes are optional
bag=(apples 4 "oranges" 10)
[[ ${bag[0]} == "apples" ]] ; should_pass
[[ ${bag[0]} == apples ]] ; should_pass
[[ ${bag[2]} == "oranges" ]] ; should_pass
[[ ${bag[2]} == oranges ]] ; should_pass

# implicit conversion from string to number
[[ ${bag[1]} -eq 4 ]] ; should_pass
[[ ${bag[1]} -lt 8 ]] ; should_pass

# strangely this works
[[ bag[1] -eq 4 ]] ; should_pass

# zip
# fold
# sum
# filter


# DICTIONARY
declare -A wordcount

wordcount["bash"]=45
wordcount["zsh"]=21

[[ ${wordcount["zsh"]} -eq 21 ]] ; should_pass


# PAIR
# use array of size 2
#   no support for user-defined types

pair=(1 "result")

# pass array by name
fst() {
    local name=$1[@]
    local pair=("${!name}")
    echo ${pair[0]}
}
snd() {
    local name=$1[@]
    local pair=("${!name}")
    echo ${pair[1]}
}
[[ $(fst pair) -eq 1 ]] ; should_pass
[[ $(snd pair) == "result" ]] ; should_pass

# err value = (1 "result")


# TUPLE
# use array
#   array is mutable


# STRUCT
# use dictionary
#   size in memory is not fixed
#   keys can be missing
#   extra keys can be present
#
#   car.color
# becomes
#   car["color"]

show_summary

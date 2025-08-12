source bunit.bash
#set -x


# return the last argument
last() {
    local args=("$@")
    echo "${args[@]:(-1)}"
}

# sum the arguments
sum() {
    local total=0
    for num in "$@"; do
        (( total += num ))
    done
    echo $total
}


# ARRAY, LIST

#
words=("arrays" "in" "bash" "like this")
[[ ${words[2]} == "bash" ]] ; should_pass
[[ ${words[3]} == "like this" ]] ; should_pass

# expand the array
#   outputs identical string for words[@] and words[*]
[[ ${words[@]} == "arrays in bash like this" ]] ; should_pass
[[ "${words[@]}" == "arrays in bash like this" ]] ; should_pass
[[ ${words[*]} == "arrays in bash like this" ]] ; should_pass
[[ "${words[*]}" == "arrays in bash like this" ]] ; should_pass
#   creates different parameters for a function call
#   when quoted
[[ $(last "${words[@]}") == "like this" ]] ; should_pass
[[ $(last "${words[*]}") == "arrays in bash like this" ]] ; should_pass
#   identical parameters
#   without quotes
[[ $(last ${words[@]}) == "this" ]] ; should_pass
[[ $(last ${words[*]}) == "this" ]] ; should_pass

# literals are strings
#   quotes are optional
bag=(apples 4 "oranges" 10)
[[ ${bag[0]} == "apples" ]] ; should_pass
[[ ${bag[0]} == apples ]] ; should_pass
[[ ${bag[2]} == "oranges" ]] ; should_pass
[[ ${bag[2]} == oranges ]] ; should_pass
[[ ${bag[@]} == "apples 4 oranges 10" ]] ; should_pass
[[ ${bag[*]} == "apples 4 oranges 10" ]] ; should_pass

# implicit conversion from string to number
[[ ${bag[1]} -eq 4 ]] ; should_pass
[[ ${bag[1]} == 4 ]] ; should_pass
[[ ${bag[1]} -lt 8 ]] ; should_pass
[[ ${bag[1]} < 8 ]] ; should_pass

# strangely this works
[[ bag[1] -eq 4 ]] ; should_pass
[[ bag[1] == 4 ]] ; should_fail
(( bag[1] == 4 )) ; should_pass
(( bag[1] < 8 )) ; should_pass
(( bag[3] == 10 )) ; should_pass

# out of bounds
bag=(apples 4 "oranges" 10)
#   is unset
[[ ${bag[4]-"out-of-bounds"} == "out-of-bounds" ]] ; should_pass
#   is also null
[[ ${bag[4]} == "" ]] ; should_pass
[[ -z ${bag[4]} ]] ; should_pass


# slice
#   returns string
words=("arrays" "in" "bash" "like this")
sliced_words=(${words[@]:1:2})
[[ ${#sliced_words[@]} == 2 ]] ; should_pass
[[ ${sliced_words[1]} == "bash" ]] ; should_pass
#   what about quotes?
#   take a slice of 2 words
#   no quotes around the parameter expansion
sliced_words=(${words[*]:2:2})
#   and get 3 back !!
[[ ${#sliced_words[@]} == 3 ]] ; should_pass
[[ ${sliced_words[2]} == "this" ]] ; should_pass
#   add quotes
#   and get 2 back
sliced_words=("${words[@]:2:2}")
[[ ${#sliced_words[@]} == 2 ]] ; should_pass
[[ ${sliced_words[1]} == "like this" ]] ; should_pass
#   or get 1 back
#   with words[*] instead of words[@]
sliced_words=("${words[*]:2:2}")
[[ ${#sliced_words[@]} == 1 ]] ; should_pass
[[ ${sliced_words[0]} == "bash like this" ]] ; should_pass

# slice from the right
sliced_words=("${words[@]:(-1):1}")
[[ ${sliced_words[0]} == "like this" ]] ; should_pass
sliced_words=("${words[@]:(-2)}")
[[ ${sliced_words[0]} == "bash" ]] ; should_pass
[[ ${sliced_words[1]} == "like this" ]] ; should_pass
sliced_words=("${words[*]:(-2)}")
[[ ${sliced_words[0]} == "bash like this" ]] ; should_pass


# length
words=("arrays" "in" "bash" "like this")
[[ ${#words[@]} == 4 ]] ; should_pass
[[ "${#words[@]}" == 4 ]] ; should_pass
[[ ${#words[*]} == 4 ]] ; should_pass
[[ "${#words[*]}" == 4 ]] ; should_pass

# find
# zip
# fold
# sum := fold +
numbers=(3 4 8 11 1)
(( $(sum "${numbers[@]}") == 27 )) ; should_pass
# prod := fold *
# filter := fold `predicate`

# convert indexed array to dict
#   -> error
declare -A bag=(apples 4 "oranges" 10)


# convert dict to indexed array
#   -> error
declare -A box=(apples 4 "oranges" 10)
declare -a box=(apples 4 "oranges" 10)
# box is still a dict
[[ ${box[@]} == "apples 4 oranges 10" ]] ; should_fail
[[ ${box[@]} == "10 4" ]] ; should_pass
[[ ${box[*]} == "10 4" ]] ; should_pass


show_summary

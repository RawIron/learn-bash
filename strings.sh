# string operations

source bunit.bash


trim() {
    # echo $1 | xargs
    local var="$1"
    # remove leading whitespace characters
    var="${var#"${var%%[![:space:]]*}"}"
    # remove trailing whitespace characters
    var="${var%"${var##*[![:space:]]}"}"
}

in_python() {
    local assignments="${1%;*}"
    local have="${1##*;}"
    python -c "$assignments; exit(0) if ($have) else exit(1)"
}

in_lua() {
    local assignments="${1%;*}"
    local have="${1##*;}"

    if [[ $1 =~ ";" ]]; then
        lua -e "$assignments; if ($have) then os.exit(0) else os.exit(1) end"
    else
        lua -e "if ($have) then os.exit(0) else os.exit(1) end"
    fi
}


# raw strings
# formatted strings

# string interpolation
player="topscorer"
points=101
message="the player ${player} achieved ${points} points"
[[ "$message" == "the player topscorer achieved 101 points" ]] ; should_pass

# length
title="learn bash"
(( ${#title} == 10 )) ; should_pass

in_python 'len("learn bash") == 10' ; should_pass
in_lua 'string.len("learn bash") == 10' ; should_pass

# uppercase

# camel case

# lowercase

# find substring
the_cat="a cat lives in a cathouse with other cats."

# find and replace
the_cat="a cat lives in a cathouse with other cats."
[[ ${the_cat//cat/dog} == "a dog lives in a doghouse with other dogs." ]] ; should_pass
[[ ${the_cat/cat/dog} == "a dog lives in a cathouse with other cats." ]] ; should_pass

# split at delimiter
my_tuple="head-tail"
# remove tail
first=${my_tuple%-*}
[[ $first == "head" ]] ; should_pass
# remove head
second=${my_tuple#*-}
[[ $second == "tail" ]] ; should_pass

# {variable%-*} finds first from the right
my_host="transformer12-themachine-cell-dc.domain.com"
[[ ${my_host%-*} == "transformer12-themachine-cell" ]] ; should_pass
# {variable%%-*} is greedy from the right
[[ ${my_host%%-*} == "transformer12" ]] ; should_pass

[[ ${my_host#*-} == "themachine-cell-dc.domain.com" ]] ; should_pass

# split at first delimiter
# with {variable%%-*}
my_host="transformer12-themachine-cell-dc.domain.com"
service=${my_host%%-*}
[[ $service == "transformer12" ]] ; should_pass

# concatenate
first="head"
second="tail"
[[ "${first}${second}" == "headtail" ]] ; should_pass

# prepend
threads=4
[[ "${threads},bench" == "4,bench" ]] ; should_pass

with_sed=$( echo "bench" | sed "s/^/${threads},/" )
[[ $with_sed == "4,bench" ]] ; should_pass

in_python 'threads=4; str(threads) + "," + "bench" == "4,bench"' ; should_pass
in_lua 'threads=4; threads .. "," .. "bench" == "4,bench"' ; should_pass

# append


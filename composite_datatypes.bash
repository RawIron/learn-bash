source bunit.bash
#set -x


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

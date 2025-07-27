#set -x

source bunit.bash


# name reference
#   dereference null or unset does not error
#   scoped name resolution is used

# function with a _pointer_ parameter
#   $1 string
#   $2 name reference
greeter() {
    local mesg="$1"
    local name="me"
    echo $mesg ${!2}
}

# evil access to function local variable
[[ $(greeter hallo name) == "hallo me" ]] ; should_pass

# pitfall
# local variable shadows global
name="them"
[[ $(greeter hallo name) == "hallo them" ]] ; should_fail

global_name="them"
[[ $(greeter hallo global_name) == "hallo them" ]] ; should_pass
[[ $(greeter hallo wrong_name) == "hallo" ]] ; should_pass
[[ $(greeter hallo) == "hallo" ]] ; should_pass


# function with an optional parameter
#   default value for null and unset is "no"
#   $1 string
#   $2 optional {yes no}
greeter_optional() {
    local mesg="$1"
    local add_name=${2:-"no"}
    local name="me"

    if [[ $add_name == "yes" ]]; then
        mesg="$mesg $name"
    fi
    echo $mesg
}

# only yes will print name
[[ $(greeter_optional "hallo" yes) == "hallo me" ]] ; should_pass
# otherwise just hallo
[[ $(greeter_optional "hallo" no) == "hallo" ]] ; should_pass
[[ $(greeter_optional "hallo" "") == "hallo" ]] ; should_pass
[[ $(greeter_optional "hallo") == "hallo" ]] ; should_pass
[[ $(greeter_optional "hallo" false) == "hallo" ]] ; should_pass
[[ $(greeter_optional "hallo" "anything") == "hallo" ]] ; should_pass

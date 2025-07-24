source bunit.bash

# indirection
# assign the name of a variable key1_log
# to a new variable log
# use log to access the value of key1_log
key1_log="/test/key1/log"
key2_log="/test/key2/log"

key="key1"
log="${key}_log"
[[ ${!log} == "/test/key1/log" ]] ; should_pass

# access the value _behind_ a name
# why not a dict instead?
declare -A log=("key1" "/test/key1/log" \
                "key2" "/test/key2/log")
[[ ${log[$key]} == "/test/key1/log" ]] ; should_pass


# indirection does not work on functions
callback() {
    echo "callback"
}

on_complete=callback
[[ ${!on_complete} == "callback" ]] ; should_fail

# simply call what is in the variable instead
[[ $($on_complete) == "callback" ]] ; should_pass

declare -A callbacks=("on_complete" "callback")
[[ $(${callbacks["on_complete"]}) == "callback" ]] ; should_pass


# nested indirection is not supported
#   error "bad substitution"
string="a string"
fst_indirect=string
snd_indirect=fst_indirect
[[ ${!${!snd_indirect}} == "a string" ]] ; should_pass


# function with a _pointer_ parameter
#   pass-by-name
greeter() {
    local mesg="$1"
    local name="me"
    echo $mesg ${!2}
}

# pitfall
# local variable shadows global
name="them"
[[ $(greeter hallo name) == "hallo them" ]] ; should_fail

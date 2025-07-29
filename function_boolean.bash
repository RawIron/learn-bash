source bunit.bash

# string is the only possible _return_ type of a function
# or more accurate a function outputs a string(s) to stdout,stderr
# a function returns a status code

# so the following function does not return a boolean value
# it exits with a status code of either 0 or 1
is_working() {
    local state="r"

    if [[ $state == "r" ]]; then
        true
    else
        false
    fi
}

# consequently the above function is identical to
is_working_ret() {
    local state=${1-"r"}

    if [[ $state == "r" ]]; then
        return 0;
    else
        return 1;
    fi
}


# [[ .. ]] is a command
# that returns either 0 (true) or 1 (false)
# [[ <command> ]] checks the status code of <command>
# for success or failure
[[ is_working ]] ; should_pass
is_working ; should_pass
[[ is_working_ret ]] ; should_pass
is_working_ret  ; should_pass
is_working_ret "w"  ; should_fail

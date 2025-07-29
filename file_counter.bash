source bunit.bash

# function _returns_ a number
# writes a string to stdout which can be converted to a number
count_files() {
    echo one two three four | wc -w
}

[[ $(count_files) -gt "0" ]] ; should_pass
[[ $(count_files) -gt 0 ]] ; should_pass
[[ $(count_files) -eq 4 ]] ; should_pass
(( $(count_files) == 4 )) ; should_pass

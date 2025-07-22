#!/bin/bash

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

summary

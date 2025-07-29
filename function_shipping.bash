source bunit.bash

# remote function call
# with function shipping

# the environment the commands
# are shipped from
MY_ENV="needed"

# pass dependencies into the function
another_func() {
	local param="$1"
	echo -n ":$param"
}

# dependency on environment is
# inside the function
# dependency will be resolved from
# the environment the function is shipped to
list_files() {
	local directory="$1"
	echo -n ":$directory $MY_ENV"
}


cmd="$(typeset -f list_files another_func) && list_files /tmp && another_func $MY_ENV"
[[ $(echo "$cmd" | bash) == ":/tmp :needed" ]] ; should_pass

cmd="$(typeset -f list_files) && list_files /tmp"
[[ $(echo "$cmd" | bash) == ":/tmp " ]] ; should_pass

cmd="$(typeset -f list_files) && list_files /tmp"
[[ $(echo "$cmd" | bash) == ":/tmp needed" ]] ; should_fail

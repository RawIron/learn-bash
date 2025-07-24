source ./bunit.bash
#set -x


# CONST VARIABLES
#   readonly
#   declare -r

# a readonly variable
readonly a=20

# cannot be unset
#   -> error
unset a
# cannot be changed
#   -> error
a=10

# $a is unchanged
[[ $a -eq 20 ]] ; should_pass

# symbol _a_ can be used
# to define a function
a() {
    echo "function a"
}
[[ $(a) == "function a" ]] ; should_pass


# NUMERIC VARIABLES
#   declare -i

# define symbol dinner
# as integer variable
declare -i dinner=12
[[ $dinner -eq 12 ]] ; should_pass
[[ dinner -eq 12 ]] ; should_pass

# define symbol dinner
# as function
dinner() {
    echo "is a function"
}
[[ $(dinner) == "is a function" ]] ; should_pass
[[ $dinner -eq 12 ]] ; should_pass

# there are separate namespaces
# for variables and functions
[[ $(compgen -A variable | grep --line-regexp dinner) == "dinner" ]] ; should_pass
[[ $(compgen -A function | grep --line-regexp dinner) == "dinner" ]] ; should_pass

# but what does the below line do?
# left-hand side has to be a variable
# is the right-hand side the variable or function?
dinner=dinner
[[ $dinner -eq 12 ]] ; should_pass

# assign dinner to a new variable _lunch_
# the value of _lunch_ is a string
lunch=dinner
[[ $lunch == "dinner" ]] ; should_pass

# recall from above that
# with integer operators no _$_ prefix is required
[[ dinner -eq 12 ]] ; should_pass
# and so surprisingly
[[ $lunch -eq 12 ]] ; should_pass
# and at the same time
[[ $lunch == "dinner" ]] ; should_pass

# with integer operators
# dinner and $lunch are the same
dinner=14
[[ dinner -eq 14 ]] ; should_pass
[[ $lunch -eq 14 ]] ; should_pass
(( dinner + $lunch == 28 )) ; should_pass
[[ ${lunch} -eq 14 ]] ; should_pass
[[ "$lunch" -eq 14 ]] ; should_pass
[[ "${lunch}" -eq 14 ]] ; should_pass

# and still lunch contains the string "dinner"
[[ $lunch == "dinner" ]] ; should_pass


# if converting to an integer fails
# the result is 0
dinner="something"
[[ $dinner -eq 0 ]] ; should_pass

# make it an array of integers
declare -a dinner=(4 7 11)
[[ ${dinner[1]} -eq 7 ]] ; should_pass
[[ ${dinner[@]} == "4 7 11" ]] ; should_pass

# anything in the array that is not an integer
# converts to 0
dinner=(too 2 dinners)
[[ ${dinner[@]} == "0 2 0" ]] ; should_pass


# FUNCTIONS

# define a function name
f() {
	echo "first f"
}
[[ $(f) == "first f" ]] ; should_pass

# redefine symbol f()
f() {
	echo "second f"
}
[[ $(f) == "second f" ]] ; should_pass


show_summary

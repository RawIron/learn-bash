source ./bunit.bash


# CONST VARIABLES

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


# VARIABLES

# define symbol dinner
# as integer variable
declare -i dinner=12
[[ $dinner -eq 12 ]] ; should_pass

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

# assign dinner to a new variable
lunch=dinner
[[ $lunch -eq 12 ]] ; should_pass

# dinner points to both locations
#
# dinner ---> 14
#        `--> lunch ---> 14
dinner=14
[[ $dinner -eq 14 ]] ; should_pass
[[ $lunch  -eq 14 ]] ; should_pass

# lunch points only to one location
# lunch ---> 16
lunch=16
[[ $lunch  -eq 16 ]] ; should_pass
[[ $dinner -eq 14 ]] ; should_pass


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

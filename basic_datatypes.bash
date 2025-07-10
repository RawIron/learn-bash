#set -x
source ./bunit.bash


# VARIABLES

# define a variable name
# and assign a value to it
dinner="toast"
[[ $dinner == "toast" ]] ; should_pass 

# values are strings
# strings do not need to be quoted
dinner=pasta
[[ $dinner == "pasta" ]] ; should_pass 

# a numeric literal does _not_ define an integer variable
# it is still a string
dinner=12
dinner+=2
[[ $dinner -eq 14 ]] ; should_fail 
[[ $dinner == 122 ]] ; should_pass 

# though the string is converted
# when used in a numeric expression
dinner=12
[[ $dinner -eq 12 ]] ; should_pass 
[[ $((dinner + 2)) -eq 14 ]] ; should_pass 

# using quotes makes it clear
dinner="12"
[[ $dinner == "12" ]] ; should_pass 
# but can be fragile
dinner="12 "
[[ $dinner == "12" ]] ; should_fail 
[[ $dinner -eq 12 ]] ; should_pass 
[[ $((dinner + 2)) -eq 14 ]] ; should_pass 

show_summary

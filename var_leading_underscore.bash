_name="zombie"

echo ${_name}
echo $_name


declare -A _dict
_dict=(
	["name"]="array_of_zombies"
)

echo ${_dict["name"]}

source bunit.bash

# a leading underscore is a valid name
# it works for variables and functions

_name="zombie"
[[ ${_name} == "zombie" ]] ; should_pass
[[ $_name == "zombie" ]] ; should_pass

declare -n ref=_name
[[ ${ref} == "zombie" ]] ; should_pass


declare -A _dict
_dict=(
	["name"]="array of zombies"
)
[[ ${_dict["name"]} == "array of zombies" ]] ; should_pass


_call_zombie() {
  echo "hey zombie"
}
[[ $(_call_zombie) == "hey zombie" ]] ; should_pass

callback=_call_zombie
[[ $($callback) == "hey zombie" ]] ; should_pass


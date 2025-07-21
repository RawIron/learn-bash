source bunit.bash


# ternary operator

# implement with && and ||
#   this is not robust --> see pitfall
ternary() {
  local input="$1"
  [[ "$input" == "doit" ]] && echo "doing it" || echo "staying out of it"
}

[[ $(ternary "doit") == "doing it" ]] ; should_pass
[[ $(ternary "dont") == "staying out of it" ]] ; should_pass


# the && A || B pitfall
#   will execute B in case A failed
ternary() {
  local input="$1"
  [[ "$input" == "doit" ]] && false || echo "staying out of it"
}

[[ $(ternary "doit") == "doing it" ]] ; should_fail
[[ $(ternary "doit") == "staying out of it" ]] ; should_pass

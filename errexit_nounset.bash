source bunit.bash

#set -o xtrace

# returns heads or tails
flip_coin() {
  if (( 1 + SRANDOM % 10 <= 5 )); then
        echo "heads"
    else
        echo "tails"
    fi
}

# run randomized tests
# just calling each script once
# would be fine
for _ in {0..10}; do
    if [[ $(flip_coin) == "heads" ]]; then
        [[ $(bash nounset.bash 2>/dev/null) == "unbound variable accessed" ]] ; should_pass
    else
        [[ $(bash errexit.bash 2>/dev/null) == "command failed" ]] ; should_pass
    fi
done

set -o nounset


catch_err() {
    echo "unbound variable accessed"
}

trap catch_err EXIT


# access an unset variable
unbound_func() {
    echo $not_bound
}

unbound_func

set -o errexit
set -o nounset


unbound_func() {
    echo $not_bound
    echo "should never reach this line"
}

err_func() {
    tar -xvf ./not_exists
    echo "should never reach this line"
}

err_func
unbound_func

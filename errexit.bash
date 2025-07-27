set -o errexit


catch_err() {
    echo "command failed"
}

trap catch_err EXIT


# run a command which exits with a code >0
err_func() {
    tar -xvf ./not_exists
}

err_func

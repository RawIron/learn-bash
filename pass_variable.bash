set -x

greeter_option() {
    local mesg="$1"
    local add_name=${2-false}
    local name="me"

    if [[ add_name ]]; then
        mesg="$mesg $name"
    fi
    echo $mesg
}

greeter() {
    local mesg="$1"
    local name="me"
    # should print "hallo me"
    echo ???
}

message="hallo \$name"
greeter "$message"

message="hallo"
greeter_option $message true

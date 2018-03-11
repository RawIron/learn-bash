is_working() {
    local state="r"

    if [[ $state = "r" ]]; then
        true
    else
        false
    fi
}


if [[ is_working ]]; then
    echo "ok"
fi

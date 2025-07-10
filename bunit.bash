
_tests_total=0
_tests_failed=0

should_pass() {
    if [[ $? -eq 0 ]]; then
        echo -n "." 
    else
      echo -n "F"
      (( ++_tests_failed ))
    fi
    (( ++_tests_total ))
}

should_fail() {
    if [[ $? -eq 1 ]]; then
        echo -n "." 
    else
      echo -n "F"
      (( ++_tests_failed ))
    fi
    (( ++_tests_total ))
}

show_summary() {
    echo
    echo "total:  $_tests_total"
    echo "failed: $_tests_failed"
}

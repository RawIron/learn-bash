
count_files() {
    ls -1 | wc -l
}


if [[ $(count_files) -le "0" ]]; then
    echo "no files"
else
    echo "many files"
fi

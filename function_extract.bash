MY_ENV="needed"

another_func() {
	local param="$1"
	echo $param
}

list_files() {
	local directory="$1"
	ls -1 $directory $MY_ENV
}

cmd="$(typeset -f); list_files /tmp; another_func $MY_ENV"
echo $cmd

cmd="$(typeset -f list_files); list_files /tmp"
echo $cmd

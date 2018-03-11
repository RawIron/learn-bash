on_prod() {
	echo "prod"
}

on_test() {
	echo "test"
}


if [[ $1 == "p" ]]; then
	func=on_prod
else
	func=on_test
fi

eval ${func}

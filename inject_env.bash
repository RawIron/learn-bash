on_prod() {
	echo "prod"
}

on_test() {
	echo "test"
}

FUNC=""

if [[ $1 == "p" ]]; then
	FUNC=on_prod
else
	FUNC=on_test
fi

$FUNC

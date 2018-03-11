readonly a=20

unset a
a=10

echo $a


f() {
	echo "first f"
}

f

f() {
	echo "second f"
}

f

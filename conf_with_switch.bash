environment="$1"

if [[ $environment == "p" ]]; then
	GCC=/usr/bin/gcc
elif [[ $environment == "t" ]]; then
	GCC=/var/lib/gcc
else
	kill -SIGTERM $$
fi

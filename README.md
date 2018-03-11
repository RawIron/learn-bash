# bash Code-Guide

Not everyone is a Bash coding wizard.
Readable code is more important than consise Bash-idiomatic code.
Although it is good to struggle for balance.

It should be really easy to understand what a script does.
Comments are great.
Although only the code holds the truth.

Using functions helps to avoid code duplication.
Create libs and use _source_ to import them into scripts.

* http://www.kfirlavi.com/blog/2012/11/14/defensive-bash-programming/
* https://github.com/progrium/bashstyle

A few bash specials:

* the scope of anything is global.
* definition and passing of data structures is awkward.
* nothing is protected or enforced by default.
    * anything can be re-defined, changed.
    * any error is ignored.
* 'sudo rm -rf ${my_path}/' would wipe the whole file system when *$my_path* is empty.


## Common Idioms

```
# script is run from command line => run main
# script is sourced by another script => skip main
#
# for testing _shunit_ sources the script and main should not run

[[ "$0" == "$BASH_SOURCE" ]] && main || true
```

### inject or mock a function
```
on_prod() {
	echo "prod"
}

on_test() {
	echo "test"
}

FUNC=""

if [[ $environment == "p" ]]; then
	FUNC=on_prod
else
	FUNC=on_test
fi

$FUNC
```

### ship a function to a remote server via ssh(1)
* inject all dependencies into the function
```
ship_this() {
    local dir="$1"
    ls -1 $dir
}

cmd="$(typeset -f ship_this); ship_this /tmp"
ssh -i $ssh_key $ssh_user@$node "$cmd"
```

### Strings
* append to string
```
sentence="the"
sentence="$sentence house"
```

* match string with regex
```
[[ "this is the text" =~ "this * text" ]] && matched
```

### optional parameter with default value
* the 3rd parameter is optional, default value is false
```
log_search() {
    local pattern="$1"
    local logfile="$2"
    local compressed=${3:-false}
    ...
}
```

### tuples as a delimited string
```
my_tuple="first:second"

first=${tuple%:*}
second=${tuple#*:}
```

### counters
```
# define
counter=0

# increment
((counter++))

# use in expression
if [[ $counter -gt 1 ]]; then
    ...
fi
}
```

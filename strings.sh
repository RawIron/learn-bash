# string manipulations

# split at delimiter
my_tuple="head-tail"

first=${my_tuple%-*}
second=${my_tuple#*-}

echo $first $second

# split at first delimiter
my_host="transformer12-themachine-cell-dc.domain.com"
service=${my_host%%-*}
echo $service


# prepend
threads=4
echo "bench" | sed "s/^/${threads},/"

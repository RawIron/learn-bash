source ./conf_with_switch.bash p
echo "on production $GCC"

source ./conf_with_switch.bash t
echo "on test $GCC"

trap "echo broken; exit 1" TERM
source ./conf_with_switch.bash x
echo "on nowhere $GCC"
trap - TERM

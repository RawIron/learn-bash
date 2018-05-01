POSITIONAL=()
while [[ $# -gt 0 ]]
do
    key="$1"

    case $key in
        --default)
        DEFAULT=YES
        shift
        ;;
        *)    # unknown option
        POSITIONAL+=("$1") # save it in an array for later
        shift
        ;;
    esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters
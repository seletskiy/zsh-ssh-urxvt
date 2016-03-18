alias ssh='ssh-urxvt'

function ssh-urxvt() {
    local opts_noarg="1246AaCfGgKkMNnqsTtVvXxYy"
    local opts_arg="bcDEeFIiLlmOopQRSWw"

    local flags=()
    local positionals=()

    # parse ssh options and split flags from positional arguments
    while [ $# -gt 0 ]; do
        case "$1" in
            -[$opts_noarg])
                flags=($flags $1)
                ;;
            -[$opts_arg])
                flags=($flags $1$2)
                shift
                ;;
            -[$opts_arg]*)
                flags=($flags $1)
                ;;
            -*)
                echo unknown ssh flag: "$1"
                return 1
                ;;
            *)
                positionals=($positionals "$1")
                ;;
        esac

        shift

        if [ ${#positionals[@]} -ge 2 ]; then
            break
        fi
    done

    if [ $# -gt 0 ]; then
        positionals=($positionals $@)
    fi

    # in case of stdin, stdout or stderr is not a terminal, fallback to ssh
    if [[ ! ( -t 0 && -t 1 && -t 2 ) ]]; then
        \ssh "$@"
        return
    fi

    # if command sspeciified, fallback to ssh
    if [ ${#positionals} -ge 2 ]; then
        \ssh "${flags[@]}" "${positionals[@]}"
        return
    fi

    # check terminal is known, if not, fallback to xterm
    \ssh -t "${flags[@]}" "$positionals" \
        "infocmp >/dev/null 2>&1 || export TERM=xterm; LANG=$LANG \$SHELL"
}

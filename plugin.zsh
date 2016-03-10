alias ssh='ssh-urxvt'

function ssh-urxvt() {
    local opts_noargs="1246AaCfGgKkMNnqsTtVvXxYy"
    local opts_args="b:c:D:E:e:F:I:i:L:l:m:O:o:p:Q:R:S:W:w:"
    local flags=()
    local positionals=()

    # parse ssh options and split flags from positional arguments
    while [ $# -gt 0 ]; do
        OPTIND=0
        while getopts "$opts_noargs$opts_args" opt "$@"; do
            flags=($flags -$opt$OPTARG)
        done

        shift $(( $OPTIND - 1 ))

        if [ $# -gt 0 ]; then
            positionals=($positionals "$1")
            shift
        fi
    done

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

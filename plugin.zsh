alias ssh=ssh-urxvt

function ssh-urxvt() {
    # in case of stdin, stdout or stderr is not a terminal, fallback to ssh
    if [[ ! ( -t 0 && -t 1 && -t 2 ) ]]; then
        command ssh "$@"
        return
    fi

    # for ## pattern in case
    setopt local_options extended_glob

    local interactive
    local opts

    # parse ssh options and split flags from positional arguments
    zparseopts -a opts -D \
        'b:' 'c:' 'D:' 'E:' 'e:' 'F:' 'I:' 'i:' 'L:' 'l:' 'm:' 'O:' 'o:' \
            'p:' 'Q:' 'R:' 'S:' 'W:' 'w:' \
        '1' '2' '4' '6' 'A' 'a' 'C' 'f' 'G' 'g' 'K' 'k' 'M' 'N' 'n' 'q' 's' \
            'T' 'V' 'v' 'X' 'x' 'Y' 'y' \
            't=interactive'

    local shell='$SHELL'
    if [ $# -ge 2 ]; then
        if [ "$interactive" ]; then
            shell+=" -ic ${(q)${(qqq@)@:2}}"
        else
            command ssh "${opts[@]}" "$@"
            return $?
        fi
    fi

    # check terminal is known, if not, fallback to xterm
    command ssh -t "${opts[@]}" "$1" \
        "infocmp >/dev/null 2>&1 || export TERM=xterm; LANG=$LANG exec $shell"
}

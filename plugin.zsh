alias ssh='ssh-urxvt'

function ssh-urxvt() {
    # in case of stdin, stdout or stderr is not a terminal, fallback to ssh
    if [[ ! ( -t 0 && -t 1 && -t 2 ) ]]; then
        \ssh "$@"
        return
    fi

    # if there more than one arg (hostname) without dash "-", fallback to ssh
    local hostname=''
    for arg in "$@"; do
        if [ ${arg:0:1} != - ]; then
            if [[ -n $hostname ]]; then
                \ssh "$@"
                return
            fi
            hostname=$arg
        fi
    done

    # check terminal is known, if not, fallback to xterm
    \ssh -t "$@" "infocmp >/dev/null 2>&1 || export TERM=xterm; LANG=$LANG \$SHELL"
}

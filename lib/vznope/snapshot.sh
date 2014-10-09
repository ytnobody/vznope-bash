function vznope-snapshot () {
    subcmd=$1 ; shift
    ctid=$(vzutil-get-ctid $1) ; shift
    if [ -z $ctid ]; then
        vznope-snapshot-help
    fi
    if [ "$subcmd" = "add" ]; then
        subcmd=""
    else
        subcmd="-"$subcmd
    fi
    vzctl snapshot$subcmd $ctid $*
}

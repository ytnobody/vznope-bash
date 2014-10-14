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

function vznope-current-snapshot () {
    ctid=$(vzutil-get-ctid $1) ; shift
    vznope-snapshot list $ctid | awk '$2=="*"{sub("{","",$3);sub("}","",$3);print($3);last;}$1=="*"{sub("{","",$2);sub("}","",$2);print($2);last;}'
}

function vznope-parent-snapshot () {
    ctid=$(vzutil-get-ctid $1) ; shift
    vznope-snapshot list $ctid | awk '$2=="*"{sub("{","",$1);sub("}","",$1);print($1);last;}'
}

function vznope-revert-snapshot () {
    ctid=$(vzutil-get-ctid $1) ; shift
    snapshot_id=$(vznope-current-snapshot $ctid)
    parent_id=$(vznope-parent-snapshot $ctid)
    if [ ! -z "$snapshot_id" ] ; then
        vznope-snapshot switch $ctid --id $parent_id &&
        vznope-snapshot delete $ctid --id $snapshot_id
    else 
        echo "no snapshot used." > /dev/stderr
        exit 1
    fi       
}

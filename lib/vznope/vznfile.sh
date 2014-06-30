function vznfile-append () {
    ctid=$1 ; shift
    vznfile=$(vznfile $ctid);
    echo $* >> $vznfile
}

function vznfile-init () {
    ctid=$1 ; shift
    metadir=$(metadir $ctid)
    if [ ! -d $metadir ] ; then
        mkdir -p $metadir
    fi
    cd $metadir
    git init .
}

function vznfile-commit () {
    ctid=$1 ; shift
    message=$1 ; shift
    metadir=$(metadir $ctid)
    cd $metadir
    git add vznfile
    git commit -m $message
}

function vznfile () {
    ctid=$1 ; shift
    metadir=$(metadir $ctid)
    touch $metadir/vznfile
    echo $metadir/vznfile
}

function metadir () {
    ctid=$1 ; shift
    if [ -d $VZN_CT_METADIR/$ctid ] ; then
        echo $VZN_CT_METADIR/$ctid
    else 
        ctname=$ctid;
        ctid=$(get-ctid $ctname)
        if [ -z "$ctid" ] ; then
            echo "not such container (input=$ctid)" > /dev/stderr
            exit 1
        fi
        if [ ! -d $VZN_CT_METADIR/$ctid ] ; then
            echo "not such container (input=$ctid)" > /dev/stderr
            exit 1
        fi
        echo $VZN_CT_METADIR/$ctid
    fi
}

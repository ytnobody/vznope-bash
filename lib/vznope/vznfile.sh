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
    echo '[user]' >> .git/config
    echo "  name = $VZN_GIT_USER" >> .git/config
    echo "  email = $VZN_GIT_EMAIL" >> .git/config
}

function vznfile-commit () {
    ctid=$1 ; shift
    metadir=$(metadir $ctid)
    cd $metadir
    git add vznfile
    git commit --author "$VZN_GIT_USER <$VZN_GIT_EMAIL>" -m "$*"
}

function vznfile-put {
    vznfile-append $* &&
    vznfile-commit $*
}

function vznfile () {
    ctid=$1 ; shift
    metadir=$(metadir $ctid)
    touch $metadir/vznfile
    echo $metadir/vznfile
}

function vznope-vznfile () {
    ctid=$1 ; shift
    if [ -z "$ctid" ] ; then
        vznope-vznfile-help
    fi
    cat $(vznfile $ctid)
}

function vznfile-revert () {
    ctid=$1 ; shift
    metadir=$(metadir $ctid)
    cd $metadir
    git revert HEAD
}

function metadir () {
    ctid=$1 ; shift
    if [ -d $VZN_CT_METADIR/$ctid ] ; then
        echo $VZN_CT_METADIR/$ctid
    else 
        ctname=$ctid;
        ctid=$(vzutil-get-ctid $ctname)
        if [ -z "$ctid" ] ; then
            echo "not such container (INPUT=$ctid)" > /dev/stderr
            exit 1
        fi
        echo $VZN_CT_METADIR/$ctid
    fi
}

function vznope-commit-history () {
    ctid=$1 ; shift
    step=$1 ; shift
    metadir=$(metadir $ctid)
    if [ ! -d $metadir ] ; then
        echo '0000000|<none>|<none>'
    else 
        cd $metadir &&
            git log --format="%h|%an|%s" --date-order --reverse | 
            sed -n $step'p'
    fi
}

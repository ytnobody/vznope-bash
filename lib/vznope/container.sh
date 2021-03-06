function vznope-create () {
    ctid=$1
    if [ -z "$ctid" ] ; then
        vznope-create-help
    fi
    shift

    image=$(vznope-image $*)

    getopt $*

    distver=$OPT_0
    ip=$OPT_ip
    name=$OPT_name
    arch=$OPT_arch

    if [ -z "$distver" ] ; then
        vznope-create-help
    fi

    if [ -z "$ip" ] ; then
        ip=$(vzutil-default-ip $ctid)
    fi
    if [ -z "$name" ] ; then
        name=$(vzutil-dummy-name)
    fi
    if [ -z "$arch" ] ; then
        arch=$(uname -i)
    fi

    vzctl create $ctid --ostemplate $image --name $name --hostname $name --ipadd $ip --layout ploop &&
        vznope-snapshot add $ctid &&
        vznfile-init $ctid &&
        vznfile-append $ctid create $distver --arch $arch &&
        vznfile-commit $ctid 'create'
}

function vznope-destroy () {
    ctid=$1 ; shift

    if [ -z "$ctid" ] ; then
        vznope-destroy-help
    fi

    metadir=$(metadir $ctid)
    vznope-napt-delete $ctid &&
    vznope-stop $ctid &&
    vzctl destroy $ctid &&
      rm -fr $metadir
}

function vznope-list () {
    conf_list=$(ls $VZN_CT_CONFDIR/*.conf | sed '/\/0.conf$/d')

    cat <<EOF;
  CTID                  NAME    STAT         IP-Addr.    CPUut.         RAM        SWAP        DISK
-----------------------------------------------------------------------------------------------------
EOF

    for conf in $conf_list ; do
        CTID=$(echo $conf | awk '{
            sub("'$VZN_CT_CONFDIR'/", ""); 
            sub(".conf", ""); 
            print($0);
        }');
        vz_stat=$(vznope-status $CTID);
        cat $conf | awk '
            BEGIN { FS = "="; }
            $0 !~ /^#/ && $0 !~ /^$/ { gsub("\"", ""); ct[$1] = $2;}
            END {
                format = "% 6s  % 20s  % 6s  % 15s  % 8s  % 10s  % 10s  % 10s\n"; 
                printf(format, "'$CTID'", ct["NAME"], "'$vz_stat'", ct["IP_ADDRESS"], ct["CPUUNITS"], ct["PHYSPAGES"], ct["SWAPPAGES"], ct["DISKSPACE"]);
            }
        '
    done
}

function vznope-getinfo () {
    ctid=$(vzutil-get-ctid $1) ; shift
    key=$1
    if [ -z "$key" ] ; then 
        cat $VZN_CT_CONFDIR/$ctid.conf | sed '/^#/d; /^$/d;'
    else 
        cat $VZN_CT_CONFDIR/$ctid.conf | sed '/^#/d; /^$/d;' | grep -e "^$key" | awk 'BEGIN{FS="=";}{gsub(/"/, "", $2);print($2);}'
    fi
}

function vznope-status () {
    ctid=$(vzutil-get-ctid $1) ; shift
    vzroot=$(vznope-getinfo $ctid VE_ROOT | sed "s/\$VEID/$ctid/g")
    if [ $(ls $vzroot | wc -l) -gt 0 ] ; then
        echo 'ON'
    else
        echo 'off'
    fi
}

function vznope-start () {
    ctid=$1
    if [ -z "$ctid" ] ; then
        vznope-start-help
    fi
    ipaddr=$(vznope-getinfo $ctid IP_ADDRESS)
    vzctl start $ctid && 
        echo "ping check to $ipaddr" &&
        ping -w 60 -c 1 $ipaddr > /dev/null 2>&1 &&
        echo "network ok" &&
        vznfile-put $ctid start
}

function vznope-stop () {
    ctid=$1
    if [ -z "$ctid" ] ; then
        vznope-stop-help
    fi
    vzctl stop $ctid &&
        vznfile-put $ctid stop
}

function vznope-enter () {
    ctid=$1
    if [ -z "$ctid" ] ; then
        vznope-enter-help
    fi
    vzctl enter $ctid
}

function vznope-exec () {
    ctid=$(vzutil-get-ctid $1) ; shift
    getopt $*
    user=$OPT_user
    dir=$OPT_dir
    cmd=$OPT_CMD
    if [ -z "$ctid" ] || [ -z "$*" ] ; then
        vznope-exec-help
    fi
    if [ ! -z "$dir" ] ; then
        cmd="cd $dir && $cmd"
    fi
    if [ ! -z "$user" ] ; then
        cmd="su - $user -c '$cmd'"
    fi
    if [ -z "$cmd" ] ; then
        cmd=$*
    fi
    echo "[EXEC]--> $cmd"

    vzctl exec $ctid "($cmd)" && 
        vznope-snapshot add $ctid &&
        vznfile-put $ctid "exec $*"
}

function vznope-set () {
    ctid=$(vzutil-get-ctid $1) ; shift
    if [ -z "$ctid" ] ; then
        vznope-set-help
    fi
    vzctl set $ctid $* --save &&
        vznfile-put $ctid "set $*"
}

function vznope-put () {
    ctid=$(vzutil-get-ctid $1) ; shift
    src=$1 ; shift
    dst=$1
    if [ -z "$ctid" ] || [ -z "$src" ] || [ -z "$dst" ] ; then
        vznope-put-help
    fi
    cp $src $VZN_CT_ROOTDIR/$ctid$dst &&
        vznfile-put $ctid "put $src $dst"
}

function vznope-revert () {
    ctid=$(vzutil-get-ctid $1) ; shift
    if [ -z "$ctid" ] ; then
        vznope-revert-help
    fi
    vznope-revert-snapshot $ctid &&
        vznfile-revert $ctid
}

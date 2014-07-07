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

    vzctl create $ctid --ostemplate $image --name $name --hostname $name --ipadd $ip &&
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
    vznope-stop $ctid &&
    vzctl destroy $ctid &&
      rm -fr $metadir
}

function vznope-list () {
    conf_list=$(ls $VZN_CT_CONFDIR/*.conf | sed '/\/0.conf$/d')

    for conf in $conf_list ; do
        CTID=$(echo $conf | awk '{
            sub("'$VZN_CT_CONFDIR'/", ""); 
            sub(".conf", ""); 
            print($0);
        }');
        cat <<EOF;
  CTID                  NAME       IP_ADDRESS    CPUUNITS         RAM        SWAP        DISK
---------------------------------------------------------------------------------------------
EOF
        cat $conf | awk '
            BEGIN { FS = "="; }
            $0 !~ /^#/ && $0 !~ /^$/ { gsub("\"", ""); ct[$1] = $2;}
            END {
                format = "% 6s  % 20s  % 15s  % 10s  % 10s  % 10s  % 10s\n"; 
                printf(format, "'$CTID'", ct["NAME"], ct["IP_ADDRESS"], ct["CPUUNITS"], ct["PHYSPAGES"], ct["SWAPPAGES"], ct["DISKSPACE"]);
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
        vznfile-append $ctid start &&
        vznfile-commit $ctid 'start'
}

function vznope-stop () {
    ctid=$1
    if [ -z "$ctid" ] ; then
        vznope-stop-help
    fi
    vzctl stop $ctid &&
        vznfile-append $ctid stop &&
        vznfile-commit $ctid 'stop'
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
    if [ -z "$ctid" ] || [ -z "$*" ] ; then
        vznope-exec-help
    fi
    vzctl exec $ctid $* && 
        vznfile-append $ctid $* &&
        vznfile-commit $ctid "$*" 
}


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
    vzctl destroy $ctid &&
      rm -fr $metadir
}


function vznope-pack () {
    if [ ! -z "$1" ] ; then 
        ctid=$(vzutil-get-ctid $1) ; shift
        ctname=$(vznope-getinfo $ctid HOSTNAME);
    fi
    if [ $ctid ]; then
        echo "packaging CTID $ctid ..."
        mkdir -p $VZN_PACK_DIR/$ctname/conf
        mkdir -p $VZN_PACK_DIR/$ctname/image
        mkdir -p $VZN_PACK_DIR/$ctname/meta
        cp $VZN_CT_CONFDIR/$ctid.conf $VZN_PACK_DIR/$ctname/conf/CT.conf
        cwd=$(pwd)
        rsync -az $VZN_CT_PRIVDIR/$ctid/* $VZN_PACK_DIR/$ctname/image/
        rsync -az $VZN_CT_METADIR/$ctid/* $VZN_PACK_DIR/$ctname/meta/
        cd $VZN_PACK_DIR/$ctname
        tar czf ../$ctname.tar.gz ./
        cd $cwd
        rm -fr $VZN_PACK_DIR/$ctname
        mv $VZN_PACK_DIR/$ctname.tar.gz ./
        chown $VZN_ORIG_USER.$VZN_ORIG_GROUP ./$ctname.tar.gz
        echo "done."
    else
        vznope-pack-help
    fi
}

function vznope-unpack () {
    if [ -z "$1" ] || [ -z "$2" ] ; then
        vznope-unpack-help
    else
        ct_package=$1
        ctid=$2
        echo "unpacking CT-Package into CTID $ctid ..."
        mkdir -p $VZN_PACK_DIR/$ctid
        mv $ct_package $VZN_PACK_DIR/$ctid
        cwd=$(pwd)
        cd $VZN_PACK_DIR/$ctid
        tar zxf $(ls *.tar.gz)
        mv $(ls *.tar.gz) $cwd/
        cd $cwd
        mv $VZN_PACK_DIR/$ctid/conf/CT.conf $VZN_CT_CONFDIR/$ctid.conf
        mkdir -p $VZN_CT_PRIVDIR/$ctid
        rsync -az $VZN_PACK_DIR/$ctid/image/* $VZN_CT_PRIVDIR/$ctid/
        rsync -az $VZN_PACK_DIR/$ctid/meta/* $VZN_CT_METADIR/$ctid/
        mkdir -p $VZN_CT_ROOTDIR/$ctid
        vznfile-init $ctid
        vznfile-commit $ctid "unpacked from $ct_package"
        newip=$(vzutil-default-ip $ctid)
        vznope-set $ctid --ipdel all --ipadd $newip
        rm -fr $VZN_PACK_DIR/$ctid
        echo "done."
    fi
}

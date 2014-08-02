function vznope-pack () {
    ctid=$(vzutil-get-ctid $1) ; shift
    ctname=$(vznope-getinfo $ctid HOSTNAME);
    if [ $ctid ]; then
        mkdir -p $VZN_PACK_DIR/$ctname/conf
        mkdir -p $VZN_PACK_DIR/$ctname/image
        cp $VZN_CT_CONFDIR/$ctid.conf $VZN_PACK_DIR/$ctname/conf/
        rsync -az $VZN_CT_PRIVDIR/$ctid/* $VZN_PACK_DIR/$ctname/image/
        tar czf $VZN_PACK_DIR/$ctname.tar.gz $VZN_PACK_DIR/$ctname
        rm -fr $VZN_PACK_DIR/$ctname
    else
        vznope-pack-help
    fi
}

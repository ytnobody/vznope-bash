if [ -z "$VZN_VZDIR" ] ; then
    export VZN_VZDIR=/var/lib/vz
fi

if [ -z "$VZN_IMAGES_URL" ] ; then
    export VZN_IMAGES_URL=http://download.openvz.org/template/precreated/
fi

if [ -z "$VZN_IMAGE_CACHEDIR" ] ; then
    export VZN_IMAGES_CACHEDIR=$VZN_VZDIR/template/cache
fi

if [ -z "$VZN_WORKDIR" ] ; then
    export VZN_WORKDIR=/var/share/vzn
fi

if [ -z "$VZN_CT_PRIVDIR" ] ; then
    export VZN_CT_PRIVDIR=$VZN_VZDIR/private
fi

if [ -z "$VZN_CT_ROOTDIR" ] ; then
    export VZN_CT_ROOTDIR=$VZN_VZDIR/root
fi

if [ -z "$VZN_CT_CONFDIR" ] ; then
    export VZN_CT_CONFDIR=/etc/vz/conf
fi

if [ -z "$VZN_CT_METADIR" ] ; then
    export VZN_CT_METADIR=$VZN_WORKDIR/meta
fi

if [ -z "$VZN_CT_NETMASK" ] ; then
    export VZN_CT_NETMASK=16
fi

if [ -z "$VZN_CT_NETWORK" ] ; then
    export VZN_CT_NETWORK=169.254.0.0/$VZN_CT_NETMASK
fi

if [ -z "$VZN_CT_GATEWAY" ] ; then
    export VZN_CT_GATEWAY=169.254.0.1
fi

if [ -z "$VZN_CT_NAMESERVER" ] ; then
    export VZN_CT_NAMESERVER=8.8.8.8
fi

if [ -z "$VZN_NETIF" ] ; then
    export VZN_NETIF=eth0
fi

if [ -z "$VZN_WORDS_DICT" ] ; then
    export VZN_WORDS_DICT=/usr/share/dict/words
fi

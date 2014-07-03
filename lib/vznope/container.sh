function vznope-create () {
    ctid=$1
    if [ -z "$ctid" ] ; then
        vznope-help
        exit
    fi
    shift

    image=$(vznope-image $*)

    getopt $*

    distver=$OPT_0
    ip=$OPT_ip
    name=$OPT_name
    arch=$OPT_arch

    if [ -z "$distver" ] ; then
        vznope-help
        exit
    fi


    if [ -z "$ip" ] ; then
        ip=$(vznope-default-ip $ctid)
    fi
    if [ -z "$name" ] ; then
        name=$(vznope-dummy-name)
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

    metadir=$(metadir $ctid)
    vzctl destroy $ctid &&
      rm -fr $metadir
}

function vznope-dummy-name () {
    name=""
    for i in $(seq 1 2); do
        words=$(wc -l $VZN_WORDS_DICT | awk '{print($1)}')
        pick=$(( (RANDOM % $words) + 1));
        word=$(sed -n "$pick"p $VZN_WORDS_DICT | tr '[:upper:]' '[:lower:]' | sed "s/'s//g; s/'//g;")
        if [ -z "$name" ] ; then
            name=$word
        else 
            name=$name'_'$word
        fi
    done
    echo $name
}

function vznope-default-ip () {
    number=$1 ; shift
    if [ -z "$number" ] ; then
        number=0;
    fi
    ipaddr_create $VZN_CT_NETWORK $number
}

function ipaddr_create () {
    network=$1 ; shift
    number=$1 ; shift
    offset=$(echo $network | sed 's/\/.*$//')
    mask=$(echo $network | sed 's/^.*\///')
    mask_pwr=$(( 32 - $mask ))
    mask_range=$(( 2 ** $mask_pwr ))

    if [ $number -gt $mask_range ] ; then
        echo 'too large number' > /dev/stderr
        exit 1
    else 
        echo $number | awk '
            BEGIN {
                split("'$offset'", ipseg, ".");
            }
            {
                number = $1;
                seg1 = int(number / 16581375);

                number = number - seg1 * 16581375;
                seg2 = int(number / 65025);

                number = number - seg2 * 65025;
                seg3 = int(number / 255);

                number = number - seg3 * 255;
                seg4 = number;

                seg1 += ipseg[1];
                seg2 += ipseg[2];
                seg3 += ipseg[3];
                seg4 += ipseg[4];
                print seg1"."seg2"."seg3"."seg4;
            }
        '
    fi
}

function get-ctid () {
    ctname=$1 ; shift
    grep -e '^NAME="'$ctname'"$' $VZN_CT_CONFDIR/*.conf | 
    awk '
        BEGIN{FS=":";}
        {
            id=$1;
            sub("'$VZN_CT_CONFDIR'/","",id);
            sub(".conf","",id);
            print(id);
        }
    '
}

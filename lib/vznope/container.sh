function vznope-create () {
    ctid=$1 ; shift
    image=$(vznope-image $*)
    getopt $*
    distver=$OPT_0
    ip=$OPT_ip
    name=$OPT_name
    arch=$OPT_arch

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
    offset_deg=$(echo $offset | awk '
        BEGIN {FS = ".";}
        {
            seg1 = $1 * 16581375;
            seg2 = $2 * 65025;
            seg3 = $3 * 255;
            seg4 = $4;
            offset_deg = seg1 + seg2 + seg3 + seg4;
            print offset_deg;
        }
    ')
    mask_range=$(echo $mask | awk '
        {
            range_bit = 32 - $1;
            range_num = 2 ** range_bit;
            print range_num;
        }
    ')
    if [ $number -gt $mask_range ] ; then
        echo 'too large number' > /dev/stderr
        exit 1
    else 
        answer_deg=$(expr $offset_deg + $number)
        echo $answer_deg | awk '
            {
                answer_deg1 = $1;
                seg1 = int(answer_deg1 / 16581375);

                answer_deg2 = answer_deg1 - seg1 * 16581375;
                seg2 = int(answer_deg2 / 65025);

                answer_deg3 = answer_deg2 - seg2 * 65025;
                seg3 = int(answer_deg3 / 255);

                answer_deg4 = answer_deg3 - seg3 * 255;
                seg4 = answer_deg4;

                print seg1"."seg2"."seg3"."seg4;
            }
        '
    fi
}

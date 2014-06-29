function getopt () {
    optname=""
    opt_i=0;

    while [ ! -z "$*" ] ; do
        thing=$1 ; shift
        if [[ "$thing" =~ ^\- ]] ; then
            optname=$(echo $thing | sed 's/^\-/OPT_/; s/\-//')
        else 
            if [ -z "$optname" ] ; then
                optname="OPT_$opt_i"
                opt_i=$(expr $opt_i + 1)
            fi
            eval "$optname=$thing"
            optname=""
        fi
    done
}

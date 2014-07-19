function getopt () {
    optname=""
    opt_i=0;

    while [ ! -z "$*" ] ; do
        thing=$1 ; shift

        if [[ "$thing" =~ ^\-\-$ ]] ; then
            optname="OPT_CMD"
            continue
        fi

        if [ "$optname" == "OPT_CMD" ] ; then
            if [ ! -z "$OPT_CMD" ] ; then
                OPT_CMD="$OPT_CMD $thing"
            else 
                OPT_CMD=$thing
            fi

        else
            if [[ "$thing" =~ ^\- ]] ; then
                optname=$(echo $thing | sed 's/^\-/OPT_/; s/\-//')
            else 
                if [ -z "$optname" ] ; then
                    optname="OPT_$opt_i"
                    opt_i=$(expr $opt_i + 1)
                    if [ -z "$OPT_N" ] ; then
                        OPT_N=$thing
                    else
                        OPT_N="$OPT_N $thing"
                    fi
                fi
    
                eval "$optname=$thing"
    
                optname=""
            fi

        fi

    done

}

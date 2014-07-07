function vznope-build () {
    ctid=$1 ; shift
    i=0
    echo '---'
    cat - | 
        sed '/^#/d; /^$/d;' | 
        while read line ; do
            i=$(($i + 1))
            commit=$(vznfile-commit-history $ctid $i)
            commit_hash=$(echo $commit | awk 'BEGIN{FS="|";}{print($1);}')
            committer=$(echo $commit | awk 'BEGIN{FS="|";}{print($2);}')
            commit_message=$(echo $commit | awk 'BEGIN{FS="|";}{print($3);}')
            if [ "$line" == "$commit_message" ] ; then
                echo "SKIP: $commit_message"
                echo "      already committed [$commit_hash by $committer]"
            elif [ "$commit_message" == "create" ] && [[ $line =~ ^create ]] ; then 
                echo "SKIP: $commit_message"
                echo "      already committed [$commit_hash by $committer]"
            else 
                vzn-run $ctid $line || break
            fi
            echo '---'
        done
}

function vzn-run () {
    ctid=$1 ; shift
    subcmd=$1 ; shift
    echo "RUN: $subcmd $*"
    eval "vznope-$subcmd" $ctid $*
}

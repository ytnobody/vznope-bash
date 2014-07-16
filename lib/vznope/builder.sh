function vznope-build () {
    ctid=$1 ; shift
    i=0
    cat - | 
        sed '/^#/d; /^$/d;' | 
        awk '{
            getcommit = "'$VZN' commit-history '$ctid' "NR;
            getcommit | getline commit
            split(commit, part, "|");
            hash = part[1];
            author = part[2];
            message = part[3];
            if ($0 == message || (message == "create" && $0 ~ /^create/)) {
                printf "\033[33mSKIP: %s\033[0m\n  already committed (%s by %s)\n", $0, hash, author;
            }
            else {
                printf "\033[36mRUN: %s\033[0m\n", $0;
                exitval = system("'$VZN' run '$ctid' "$0);
                if (exitval) {
                    exit exitval;
                }
            }
            print "";
        }
        END {
            printf "\033[94mBuild finish.\033[0m\n";
        }'
}

function vznope-run () {
    ctid=$1 ; shift
    subcmd=$1 ; shift
    echo -e "\033[35m  ==> vznope-$subcmd $ctid $*\033[0m"
    eval "vznope-$subcmd" $ctid $*
}

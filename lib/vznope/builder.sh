function vznope-build () {
    ctid=$1 ; shift
    i=0
    cat - | 
        sed '/^#/d; /^$/d; s/^ *//' | 
        awk '
        BEGIN {
            is_exec_mode = 0;
            exec_opts = "";
        }
        $0 ~ /^(begin|end)/ {
            if ($0 ~ /^begin/) {
                is_exec_mode = 1;
                exec_opts = $0;
                sub("begin", "", exec_opts);
                sub(" ", "", exec_opts);
            }
            else {
                is_exec_mode = 0;
                exec_opts = "";
            }
            next;
        }  
        {
            getcommit = "'$VZN' commit-history '$ctid' "NR;
            getcommit | getline commit
            split(commit, part, "|");
            hash = part[1];
            author = part[2];
            message = part[3];

            run_cmd = $0;
            if (is_exec_mode) {
                run_cmd = exec_opts ? "exec " exec_opts " -- " $0 : "exec -- " $0;
            }

            if (run_cmd == message || (message == "create" && run_cmd ~ /^create/)) {
                printf "\033[33mSKIP: %s\033[0m\n  already committed (%s by %s)\n", $0, hash, author;
            }
            else {
                printf "\033[36mRUN: %s\033[0m\n", run_cmd;
                exitval = system("'$VZN' run '$ctid' "run_cmd);
                if (exitval) {
                    exit exitval;
                }
            }
            print "";
        }
        END {
            printf "\033[94mBuild finish.\033[0m\n";
        }
    '
}

function vznope-run () {
    ctid=$1 ; shift
    subcmd=$1 ; shift
    echo -e "\033[35m  ==> vznope-$subcmd $ctid $*\033[0m"
    eval "vznope-$subcmd" $ctid $*
}

. $VZNLIB/getopt_smart.sh
. $VZNLIB/vznope/constants.sh
. $VZNLIB/vznope/image.sh

function vznope-help () {
cat <<EOF

  usage: 
    vzn [subcommand] [options]

  subcommands:
    build
    commit
    commit-log
    create
    destroy
    enter
    exec
    get-image
    help
    images
    images-available
    list
    set
    start
    stop
    vznfile

EOF
}


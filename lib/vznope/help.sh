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
    exec-as
    help
    images-available
    list
    set
    start
    stop
    vznfile

EOF
exit
}


function vznope-create-help () {
cat <<EOF

  # vzn create

  Create a new container from specified image to target CTID

  usage:
    vzn create [CTID] [distname](@[version]) [options]
    
    options:
      --name [hostname]
      --ip [ip-address]
      --arch [os-architecture]

EOF
exit
}

function vznope-destroy-help () {
cat <<EOF

  # vzn destroy

  Stop and remove a specified container

  usage:
    vzn destroy [CTID or NAME]

EOF
exit
}

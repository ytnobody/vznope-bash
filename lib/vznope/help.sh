function vznope-help () {
cat <<EOF

  usage: 
    vzn [subcommand] [options]

  subcommands:
    build
    create
    destroy
    enter
    exec
    help
    images-available
    list
    put
    set
    start
    stop
    vznfile
    napt-add
    napt-delete
    napt-list
    pack
    unpack
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

function vznope-start-help () {
cat <<EOF

  # vzn start

  Start a specified container 

  usage:
    vzn start [CTID or NAME]
EOF
exit
}

function vznope-stop-help () {
cat <<EOF

  # vzn stop

  Stop a specified container 

  usage:
    vzn stop [CTID or NAME]
EOF
exit
}

function vznope-enter-help () {
cat <<EOF

  # vzn enter

  Enter to specified container

  usage:
    vzn enter [CTID or NAME]
EOF
exit
}

function vznope-exec-help () {
cat <<EOF

  # vzn exec

  Exec command in specified container. Then append as history into vznfile.

  usage:
    vzn exec [CTID or NAME] [OPTIONS] -- [COMMANDS]

  options:
    --dir  : Exec COMMANDS in specified directory.
    --user : Exec COMMANDS as specified user.

EOF
exit
}

function vznope-put-help () {
cat <<EOF

  # vzn put

  Copy source file to destination host's path

  usage:
    vzn put [CTID or NAME] [SOURCE FILE] [DESTINATION PATH]

  !!! NOTICE !!!
    DESTINATION PATH must be ABSOLUTE PATH
EOF
exit
}

function vznope-set-help () {
cat <<EOF

  # vzn set

  Set specified beancounter parameters and save these

  usage:
    vzn set [CTID or NAME] ([options])

    options:
    [--force] [--setmode restart|ignore]
       [--ram <bytes>[KMG]] [--swap <bytes>[KMG]]
       [--ipadd <addr>] [--ipdel <addr>|all] [--hostname <name>]
       [--nameserver <addr>] [--searchdomain <name>]
       [--onboot yes|no] [--bootorder <N>]
       [--userpasswd <user>:<passwd>]
       [--cpuunits <N>] [--cpulimit <N>] [--cpus <N>] [--cpumask <cpus>]
       [--diskspace <soft>[:<hard>]] [--diskinodes <soft>[:<hard>]]
       [--quotatime <N>] [--quotaugidlimit <N>] [--mount_opts <opt>[,<opt>...]]
       [--capability <name>:on|off ...]
       [--devices b|c:major:minor|all:r|w|rw]
       [--devnodes device:r|w|rw|none]
       [--netif_add <ifname[,mac,host_ifname,host_mac,bridge]]>]
       [--netif_del <ifname>]
       [--applyconfig <name>] [--applyconfig_map <name>]
       [--features <name:on|off>] [--name <vename>]
       [--ioprio <N>] [--iolimit <N>] --iopslimit <N>
       [--pci_add [<domain>:]<bus>:<slot>.<func>] [--pci_del <d:b:s.f>]
       [--iptables <name>] [--disabled <yes|no>]
       [--stop-timeout <seconds>
       [UBC parameters]
    
    UBC parameters (N - items, P - pages, B - bytes):
    Two numbers divided by colon means barrier:limit.
    In case the limit is not given it is set to the same value as the barrier.
       --numproc N[:N]	--numtcpsock N[:N]	--numothersock N[:N]
       --vmguarpages P[:P]	--kmemsize B[:B]	--tcpsndbuf B[:B]
       --tcprcvbuf B[:B]	--othersockbuf B[:B]	--dgramrcvbuf B[:B]
       --oomguarpages P[:P]	--lockedpages P[:P]	--privvmpages P[:P]
       --shmpages P[:P]	--numfile N[:N]		--numflock N[:N]
       --numpty N[:N]	--numsiginfo N[:N]	--dcachesize N[:N]
       --numiptent N[:N]	--physpages P[:P]	--avnumproc N[:N]
       --swappages P[:P]
    


EOF
exit
}

function vznope-napt-add-help () {
cat <<EOF
  # vzn napt-add
  
  Add a rule for transporting packets to container

  usage:
    vzn napt-add [CTID or NAME] [Source Port] ([Destination Port])


EOF
exit
}

function vznope-napt-delete-help () {
cat <<EOF
  # vzn napt-delete
  
  Delete a rule for transporting packets to container

  usage:
    vzn napt-delete [CTID or NAME] [Source Port]


EOF
exit
}


function vznope-vznfile-help () {
cat <<EOF

  # vzn vznfile

  Dump content of vznfile for specified container

  usage:
    vzn vznfile [CTID or NAME]


EOF
exit
}

function vznope-pack-help () {
cat <<EOF

  # vzn pack

  Pack specified container

  usage:
    vzn pack [CTID or NAME]


EOF
exit
}

function vznope-unpack-help () {
cat <<EOF

  # vzn unpack

  Unpack a CT-Package and import as a container

  usage:
    vzn unpack [CT-Package.tar.gz path] [Destination CTID]
EOF
exit
}


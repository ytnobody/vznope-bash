function vznet-init () {
    ip addr show $VZN_NETIF | grep "$VZN_CT_GATEWAY/$VZN_CT_NETMASK" > /dev/null 2>&1 ||
    ip addr add $VZN_CT_GATEWAY/$VZN_CT_NETMASK dev $VZN_NETIF

    vznet-create-chain vzn
    vznet-create-chain vzn-nat -t nat
    vznet-create-chain vzn-napt -t nat

    iptables -S vzn-nat -t nat | grep $VZN_CT_NETWORK > /dev/null 2>&1 ||
        vznet-chain-rule vzn-nat -t nat -s $VZN_CT_NETWORK -j MASQUERADE

    iptables -S PREROUTING -t nat | grep vzn-napt > /dev/null 2>&1 ||
        vznet-chain-rule PREROUTING -t nat -j vzn-napt

    iptables -S POSTROUTING -t nat | grep vzn-nat > /dev/null 2>&1 ||
        vznet-chain-rule POSTROUTING -t nat -s $VZN_CT_NETWORK -j vzn-nat
}

function vznet-create-chain () {
    chain=$1 ; shift
    iptables -nL $chain $* > /dev/null 2>&1 || iptables -N $chain $*
}

function vznet-chain-rule () {
    chain=$1 ; shift
    iptables -A $chain $*
}

function vznope-napt-add () {
    ctid=$(vzutil-get-ctid $1) ; shift
    src=$1; shift
    if [ -z "$ctid" ] || [ -z "$src" ] ; then
        vznope-napt-add-help
    fi
    dst=$1
    if [ -z "$dst" ] ; then
        dst=$src
    fi
    ctip=$(vznope-getinfo $ctid IP_ADDRESS)
    iptables -S vzn-napt -t nat | grep $ctip | grep "dport $src" > /dev/null 2>&1 ||
        vznet-chain-rule vzn-napt -t nat -p tcp --dport $src -j DNAT --to $ctip:$dst
}

function vznope-napt-delete () {
    ctid=$(vzutil-get-ctid $1) ; shift
    src=$1; shift
    if [ -z "$ctid" ] || [ -z "$src" ] ; then
        vznope-napt-delete-help
    fi
    dst=$1
    if [ -z "$dst" ] ; then
        dst=$src
    fi
    ctip=$(vznope-getinfo $ctid IP_ADDRESS)
    iptables -t nat -D vzn-napt -p tcp --dport $src -j DNAT --to $ctip:$dst
}

function vznope-napt-list () {
    iptables -nL vzn-napt -t nat 2>&1 | grep DNAT | awk '
        {
            dport = $7;
            sub("dpt:","",dport);
            to = $8;
            split(to,part,":");
            comm = "'$VZN' ctid-from-ip "part[2];
            comm | getline ctid
            printf("%s => [CT%s] %s\n", dport, ctid, part[3]);
        }
    '
}

function vznope-ctid-from-ip () {
    ctip=$1 ; shift
    vznope-list | sed '1,2d' | awk '$4=="'$ctip'"{print($1)}'
}

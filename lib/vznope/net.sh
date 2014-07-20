function vznet-init () {
    ip addr show $VZN_NETIF | grep "$VZN_CT_GATEWAY/$VZN_CT_NETMASK" > /dev/null 2>&1 ||
    ip addr add $VZN_CT_GATEWAY/$VZN_CT_NETMASK dev $VZN_NETIF
    vznet-create-chain vzn
    iptables -S vzn-nat -t nat | grep $VZN_CT_NETWORK ||
        vznet-chain-rule vzn-nat -t nat -s $VZN_CT_NETWORK -j MASQUERADE
}

function vznet-create-chain () {
    chain=$1 ; shift
    iptables -nL $chain $* > /dev/null 2>&1 || iptables -N $chain $*
}

function vznet-chain-rule () {
    chain=$1 ; shift
    iptables -A $chain $*
}


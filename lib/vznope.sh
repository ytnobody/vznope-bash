. $VZNLIB/getopt_smart.sh
. $VZNLIB/vznope/util.sh
. $VZNLIB/vznope/help.sh
. $VZNLIB/vznope/vznfile.sh
. $VZNLIB/vznope/constants.sh
. $VZNLIB/vznope/image.sh
. $VZNLIB/vznope/container.sh

function vznope-init () {
    ifconfig $VZN_NETIF $VZN_CT_GATEWAY/$VZN_CT_NETMASK
    
}

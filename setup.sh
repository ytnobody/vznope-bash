#!/bin/bash

APPROOT=$(cd $(dirname $0) ; pwd)
BINDIR=$PERLROOT/bin

if [ -z "$VZN_ROOT" ]; then
    echo . $APPROOT/vznope.bashrc >> $HOME/.bash_profile
    echo 'Please add a following line by visudo.'
    echo $USER'        ALL=(root)      NOPASSWD: '$APPROOT'/bin/vzn'
    exec /bin/bash
fi


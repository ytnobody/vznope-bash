#!/bin/bash

APPROOT=$(cd $(dirname $0) ; pwd)
BINDIR=$PERLROOT/bin

if [ -z "$VZN_ROOT" ]; then
    echo . $APPROOT/vznope.bashrc >> $HOME/.bash_profile
    exec /bin/bash
fi


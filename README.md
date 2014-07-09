# NAME

vzn - OpenVZ wrapper toolkit that aims to realize "Immutable Container"

# DESCRIPTION

vzn is a wrapper command that is provided by vznope-bash.

# DEPENDENCIES

* openvz
* git
* bash
* wget

# INSTALL

## SETUP

    $ git clone https://github.com/ytnobody/vznope-bash
    $ cd vznope-bash
    $ ./setup.sh

## BEFORE USING - Get super user authority

vznope-bash provides 'vzn' command. But, vzn requires super user authority.

    $ pwd vzn # check path to vzn
    $ sudo visudo # add 'you ALL=(root) NOPASSWD: /path/to/vzn' into sudoers.

# GET STARTED

## 1st. LOOK IMAGES LIST AND CHOOSE ONE FROM THESE

First, try 'vzn images-available'. You can look images list of container.

      DISTRO@VERSION        ARCH         TAG    SIZE
            centos@5         x86       devel    197M
            centos@5         x86     default    174M
            centos@5      x86_64       devel    208M
        :
      (snip)
        :
        ubuntu@14.04         x86     minimal     73M
        ubuntu@14.04         x86     default    145M
        ubuntu@14.04      x86_64     minimal     75M
        ubuntu@14.04      x86_64     default    147M


## 2nd. CREATING AND SETTING

Try 'vzn create' command as following.

    $ vzn create 101 centos --name 'my_ct'

'101' is container-id. And, 'centos' is distribution image name that you seen in 'images-available' list.

Then, you can see as following messages.

    Creating container private area (centos-6-x86_64)
    Performing postcreate actions
    CT configuration saved to /etc/vz/conf/101.conf
    Container private area was created
    Initialized empty Git repository in /var/share/vzn/meta/101/.git/
    [master (root-commit) b530c49] create
     1 file changed, 1 insertion(+)
     create mode 100644 vznfile

If you seen, Creating a container finished completely.

For overviewing a created container, try 'vzn list' command.

    $ vzn list
      CTID                  NAME    STAT         IP-Addr.    CPUut.         RAM        SWAP        DISK
    -----------------------------------------------------------------------------------------------------
       101                 my_ct     off   169.254.32.101      1000      0:256M      0:512M     2G:2.2G

Then, let us set nameserver for resolving any domains. Try 'vzn set' command as followings.

    $ vzn set 101 --nameserver 8.8.8.8


## 3rd. BOOT UP

Next, boot your container with 'vzn start' command.

    $ vzn start my_ct 
    ### or 'vzn start 101'

Following message appears.

    Starting container...
    Container is mounted
    Adding IP address(es): 169.254.32.101
    Setting CPU units: 1000
    Container start in progress...
    ping check to 169.254.32.101
    network ok
    [master af4981b] start
     1 file changed, 1 insertion(+)

Container is completely boot up. Then, try 'vzn list' again.

    $ vzn list

      CTID                  NAME    STAT         IP-Addr.    CPUut.         RAM        SWAP        DISK
    -----------------------------------------------------------------------------------------------------
       101                 my_ct      ON   169.254.32.101      1000      0:256M      0:512M     2G:2.2G


## 4th. MAKE CHANGE

Try to install mysql-server with 'vzn exec' command.

First, we want to run 'yum -y update'.

    $ vzn exec my_ct yum -y update

Then, wait a few time.

Next, try 'yum -y install nginx' through 'vzn exec' command.

    $ vzn exec my_ct yum -y install mysql-server

And, we want to boot-up mysqld.

    $ vzn exec my_ct service mysqld start

On boot up time, too.

    $ vzn exec my_ct chkconfig mysqld on

Okay! We make some changes for installing mysq-server.

vznope logged these actions through 'vzn exec' command. 

Check with 'vzn vznfile' command.

    $ vzn vznfile my_ct

Then, it shows following.

    create centos --name my_ct
    set --nameserver 8.8.8.8
    start
    exec yum -y update
    exec yum -y install mysql-server
    exec service mysqld start
    exec chkconfig mysqld on

This text that named 'vznfile' is useful for creating an another container with duplicated setting.

## 5th. ENTERING

Simply. try 'vzn enter' command.

    $ vzn enter my_ct

Then, you can enter into container with root authority.

## 6th. BUILD WITH vznfile

You can create another container with duplicated setting with vznfile and 'vzn build' command.

    $ vzn vznfile my_ct > my_ct.vznfile
    $ vzn build 102 --name my_ct_2 < my_ct.vznfile

# LICENSE

Copyright (C) ytnobody.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

ytnobody <ytnobody@gmail.com>


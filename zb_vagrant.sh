#!/bin/bash

check_program() {
    i=0
    for program_name in $1; do
        type -P $program_name > /dev/null
        if [ $? -gt 0 ]; then
            echo $program_name " is needed."       
            i=`expr $i + 1`
        fi
    done

    return $i
}

exit_if_failed() {
    if [ $? -gt 0 ]; then
        echo "$1 failed, exit now."
    fi
}

generate_vagrant_file() {
    cd $ZANBAI_VAGRANT_PATH
    echo -n "Please input your local zanbai repository path: "
    read ZANBAI_REPO_PATH
    echo "local_zanbai_repo_file=\"$ZANBAI_REPO_PATH\"" > Vagrantfile
    echo "" >> Vagrantfile
    cat Vagrantfile.tpl >> Vagrantfile
}

print_usage() {
    echo "========= Welcome ====================================================="
    echo "this scripts is actually an wrapper for vagrant, "
    echo "which means you can use all commands from vagrant."
    echo "user age: zb_vagrant up / halt"
    echo "======================================================================="
}

NEEDED_PROGRAMS="git vagrant VirtualBox"
check_program "$NEEDED_PROGRAMS"
BOX_NAME="zanbai"
ZANBAI_DEV_PATH="$HOME/.zanbai"
CONFIG_GIT_REPO="https://github.com/demien/zanbai_vagrant.git"
ZANBAI_VAGRANT_PATH=$ZANBAI_DEV_PATH/vagrant

print_usage

if [ ! -d "$ZANBAI_DEV_PATH" ]; then

    # get box path
    echo -n "Please input box file location: "
    read BOX_FILE_PATH

    # add box
    vagrant box add $BOX_NAME $BOX_FILE_PATH
    exit_if_failed "add vagrant box"

    # create dir
    mkdir $ZANBAI_DEV_PATH
    mkdir $ZANBAI_VAGRANT_PATH

    # get git file
    git clone $CONFIG_GIT_REPO $ZANBAI_DEV_PATH
    exit_if_failed "clone config repo from git"

    # make a link
    echo "This scripts is trying to create an link under /usr/local/bin. Type your password to allow this."
    sudo ln -s $ZANBAI_VAGRANT_PATH/zb_vagrant.sh /usr/local/bin/zb_vagrant

    # create vagrant file
    generate_vagrant_file

    # vagrant up
    cd $ZANBAI_VAGRANT_PATH
    vagrant up
else
    cd $ZANBAI_VAGRANT_PATH
    vagrant up --no-provision
fi
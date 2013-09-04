#!/bin/bash

set -e

# \brief Hard way to install goagent
# \author gongqijian@gmail.com
# \date 2012/06/01

# ==============================================================================

dir_base=$(cd `dirname ${0}`; pwd)
dir_export=$dir_base/goagent_export
dir_repos=$dir_base/goagent_repos
cfg_file=$dir_base/.hard-way-install-goagent
branch="2.0"
setup_client="yes"
setup_server="yes"

# ==============================================================================

function usage() {
    echo "Usage: $0 -[h|s|c|a]"
    echo "Options:"
    echo "      -h      print help"
    echo "      -s      install server only"
    echo "      -c      install client only"
    echo "      -a      install both server and client. default"
}

function first_time() {
    cat << EOF
Hard way to install goagent
==========================================
This is the first time you run this script

1. make sure these directory are not exists:
    '$dir_repos'
    '$dir_export'

2. create file '$cfg_file', 
and set fields 'appids' 'gmail' 'asp' like this:
    profile=hk 
    # or profile=cn
    appids="appid“
    # or appids="appid1\|appid2\|appid3"
    gmail="account@gmail.com"
    asp="app-specific-password"
EOF
}

function setup() {
    if [[ "$setup_client" == "yes" ]]; then
        cd "$dir_export"/local
        $sedi "s/appid = goagent/appid = $appids/g" ./proxy.ini
        $sedi "s/profile = google_.*/profile = google_$profile/g" ./proxy.ini
    fi

    if [[ "$setup_server" == "yes" ]]; then
        cd "$dir_export"/server
        unzip -q uploader.zip -d uploader
        cd uploader
        $sedi "s/getpass.getpass = getpass_getpass/getpass.getpass = lambda x='Pswd', y=None: '$asp'/g" ./appcfg.py
        $sedi "s/appids = raw_input('APPID:')/appids = '$appids'/g" ./appcfg.py
        $sedi "s/email = self.raw_input_fn('Email: ')/email = '$gmail'/g" ./google/appengine/tools/appcfg.py
        zip -r ../uploader.mod.zip ./*
        cd ../
        python uploader.mod.zip
    fi
}

function check() {
    if [ ! -e "$cfg_file" ]; then
        first_time
        exit 1
    else
        source $cfg_file
    fi

    if [ ! -e "$dir_repos" ]; then
        git clone https://github.com/goagent/goagent.git "$dir_repos"
    fi

    cd "$dir_repos"
    git checkout $branch && git pull
    rm -rf $dir_export  && mkdir $dir_export
    git archive $branch | tar -x -C "$dir_export"
    cd "$dir_base"

    case `uname` in
        "Linux" | "CYGWIN"* | "MSYS"*)
            sedi='sed -i'
            ;;
        *) # Darwin & other Unix
            sedi='sed -i ""'
            ;;
    esac
}

# ==============================================================================

while getopts "hcsa" OPTION; do
    case $OPTION in
        h)
            usage; exit 0;;
        c)
            echo "setup client..." 
            setup_server="no"; break;;
        s)
            echo "setup server..."
            setup_client="no"; break;;
        a)
            echo "setup all..."
            break;;
        *)
            usage; exit 1;;
    esac
done

# ==============================================================================

check
setup
exit 0

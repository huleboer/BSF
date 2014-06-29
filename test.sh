#! /bin/bash

 LOCKFILE="/tmp/test2.lock"
 exec 200>$LOCKFILE
 flock -n 200 || exit 1
 pid=$$
 echo $pid 1>&200

 set -e
 
err_report() {
    echo "Error on line $1. Fix it"
}

trap 'err_report $LINENO' ERR

echo hello | grep foo

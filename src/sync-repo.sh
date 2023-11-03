#!/bin/bash

export PROG=`basename $0`;
export BIN="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

MANDATORY_ARGS=1

# print date for logfile
date

# get optional args
ARGS=`getopt -o u: --long umask: -n "$0" -- "$@"`
if [ $? != 0 ] ; then 
    echo "no argument given"
    exit
fi
eval set -- "$ARGS"

old_umask=$(umask)
new_umask=$umask

while :; do
  case "$1" in
    -u|umask) new_umask="$2"; shift;;
    -- ) shift; break ;;
    * ) break ;;
  esac
  shift
done

if [ $# -lt $MANDATORY_ARGS ] ; then 
  echo "Mandatory argument is missing."
  exit 1
fi

# mandatory args
DIR=$1

if ! [[ -d "$DIR" && -w "$DIR" ]]; then
  echo "$DIR is not a writeable directory, exiting."
  exit 1
fi

# set umask
umask $new_umask

# go to repository
cd $DIR

# print status for logfile
git status

# git workflow
git pull && \
git add . && \
git commit -m "update $(date)" && \
git push origin main

# reset umask
umask $old_umask

exit 0

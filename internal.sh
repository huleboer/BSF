#!/usr/bin/env bash
#
# Author: Torstein Hansen
# License: BSD
#
######################
# Internal functions #
######################

# Variables

# Locking
AppLock()
{
 LOCKFILE="$LOCKDIR/$(basename $0).lock"
 exec 200>$LOCKFILE
 flock -n 200 || exit 1
 pid=$$
 echo $pid 1>&200
}

SetOptions()
{
 # Descriptions from http://www.tldp.org/LDP/abs/html/options.html
 # Similar to -v, but expands commands (Print each command to stdout before executing it)
 set -x
 # Prevent overwriting of files by redirection (may be overridden by >|)
 set -C 
 # Abort script at first error, when a command exits with non-zero status (except in until or while loops, if-tests, list constructs)
 set -e
 # Have to declear variables first
 # set -u
 # Causes a pipeline to return the exit status of the last command in the pipe that returned a non-zero return value.
 set -o pipefail
}

# Redirect all output to log file and to screen if it it's executed manually by a user
IoRedirect()
{
 LOGFILE=$LOGDIR/$(basename $0).log
 if [ ${INTAND}=="non" ]
 then
  exec > >(tee $LOGFILE)
 else
  exec >> $LOGFILE 2>&1 
 fi
  exec 2>&1
}

# Check if it's executed by a user or by system
IntAndNonInt()
{
 if [ -z "$PS1" ]; then
  INTAND="non"
 else
  INTAND="int"
 fi
}

TrapError()
{
 MYSELF="$0"               # equals to my script name
 LASTLINE="$1"            # argument 1: last line of error occurence
 LASTERR="$2"             # argument 2: error code of last command
 echo "script error encountered at `date` in ${MYSELF}: line ${LASTLINE}: exit status of last command: ${LASTERR}"
}

TimeCheck()
{
 if [ $MAXTIME -eq "0" ]
 then
  # Default to 1 minutte
  readonly MAXTIME=60
 fi
 DIFFTIME=$(( $ENDTIME - $STARTTIME ))
 if [ ! $DIFFTIME -lt $MAXTIME ]
 then
  # Log that we have stopped
  echo "$(date) - $APPNAME - script stopped"
  echo "Error: script took to long"
  exit 1
 fi
}

LoadAddon()
{
 true
}

CollectVars()
{
 __DIR__="$(cd "$(dirname "${0}")"; echo $(pwd))"
 __BASE__="$(basename "${0}")"
 __FILE__="${__DIR__}/${__BASE__}"
}

ReadConfig()
{
 true
}

#!/usr/bin/env bash
#
# Author: Torstein Hansen
# License: BSD
#
# Features:
# * MUTEX so you don't end up with race conditions
# * Always redirect io (output and error) to log file and if it's execution by a user output to screen
# * Catch errors and exit if something wrong happends
# * Log everything
# * Log how long the script takes to execute and log an error message if it exceeds a time limit 

. ./internal.sh

####################
# Public functions #
####################
# StartScript - sets everything up
# StopScript - cleans up everything. The script detects this automatically

# Set everything up
StartScript()
{
 # Set time we started
 readonly STARTTIME=$(date +%s)


 # Set some default options
 SetOptions

 # Script locking
 AppLock

 # Trap errors and exits
 trap 'TrapError ${LINENO} $?' ERR
 trap 'StopScript' INT TERM EXIT QUIT

 # Figures out if it's executed by user or cron jobb
 IntAndNonInt

 # Sends output to log file and to screen if it's a regular user
 IoRedirect
 
 # Load extra user addons
 LoadAddon

 # Default secure umask. If you want something else, change the file afterward
 umask 077

 # Add log message
 echo "$(date) - $APPNAME - script started" 
}

# Clean everything up
StopScript()
{
 # Stop date
 readonly ENDTIME=$(date +%s)


 # Check how long we've been executing
 TimeCheck

 # Log that we have stopped
 echo "$(date) - $APPNAME - script stopped"
 
 # Remove lockfile
 rm ${LOCKFILE}
}

SafeCp()
{
 local SOURCE="$1"
 local TARGET="$2"
 cp ${SOURCE} ${TARGET}
 diff ${SOURCE} ${TARGET}
}

SafeMv()
{
 local SOURCE="$1"
 local TARGET="$2"
 local MD5S=${md5sum "$SOURCE"}
 mv ${SOURCE} ${TARGET}
 local MD5T=${md5sum "$TARGET"}
 if [ ! "$MD5S" -eq "$MD5T" ]
 then
  exit 1
 fi
}

SafeRm()
{
 local FILE="$1"
 LockFile ${FILE}
 BackupFile ${FILE}
 rm $(FILE)
}

BackupFile()
{
 FILE="$1"
 if [! isset "$BACKUPDIR"]
 then
  # Default to 1 minutte
  readonly BACKUPDIR="/var/spool/backup"
 fi
 tar zxvf ${BACKUPDIR}/${FILE}-$(date +%s) ${FILE} 
}

GetTempFile()
{
 true
}

GetTempDir()
{
 true
}

LockFile()
{
 true
 # use flock on the file
}

NotRoot()
{
 if [ "$(whoami)" = root ]
 then
  exit 1
 fi
}

# Check that a script is executed as a user
AsUser()
{
 true
}

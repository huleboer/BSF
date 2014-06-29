BSF
===
Bash Script Framework (bsf) is some basic scripts to include in your script to provide some basic functionality. Basically I got tired of making it for different companies and in different scripts... It's an early edition.. Consider it alfa software

Features
========
* Mutex - Locking. You don't have to be afreid multiple copies of the script execute at the same time
* Logging - Logs everything to log files and output to console if executed from console
* Debug - Debug mode on all the time

Roadmap features
================
* Config file - Turn debugging on and off etc
* Lot's of functions

Usage
=====
<pre>
#!/bin/bash
. /dir/public.sh
#################
# SCRIPT HEADER #
#################
# Required variables
# Name of application
readonly APPNAME="MyAPP"
# Optional variables (have default values)
# Where to store lockfiles
readonly LOCKDIR="/tmp"
# Where to log
readonly LOGDIR="/tmp"
# Backup location
readonly BACKUPDIR="/var/backup"

# Optional variables
# Give an error if the script takes longer then this to execute successfull. In seconds
readonly MAXTIME="60"

# Start all the magic 
StartScript

# Your code here
</pre>

License
=======
BSD. Do whatever you want with it :)

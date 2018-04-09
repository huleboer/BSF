#!/usr/bin/env bash
# Author: Torstein Hansen
#
. ./public.sh

#################
# SCRIPT HEADER #
#################
# Required variables
# Name of application
readonly APPNAME="test"

# Optional variables (have default values)
# Where to store lockfiles
readonly LOCKDIR="/tmp"
# Where to log
readonly LOGDIR="/tmp"
# Give an error if the script takes longer then this to execute successfull
readonly MAXTIME="60"
# Backup location
readonly BACKUPDIR="/var/backup"

# Script
StartScript
sleep 1
echo "dette er en test"
StopScript

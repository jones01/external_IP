#!/bin/bash

# monitor.sh - Monitors external IP and emails update
# By:Jones 09/2016
#
##################################################

# Global Declarations
declare -r SCRIPT="${0##*/}"
cmd_list='mail dig curl diff mv grep' # Reference Commands
path="<Path of this file>"
email="<Yourmail Address>"

cmd_exists() {  # Function to check if referenced command exists
  if [ $# -eq 0 ]; then
    echo 'No command argument was passed to verify exists'
    exit 190
  fi
  cmd=${1}
  cmd_fullpath=$(which "${cmd}")
  if [ ! -x "${cmd_fullpath}" ]; then
    printf "${SCRIPT}: the command ${cmd} not found - aborting\n"
    exit 191
  fi
}

for cmd in ${cmd_list}; do   # Verify that referenced commands exist on the system
  cmd_exists "$cmd"
done

  old="old_IP.txt"
  new="new_IP.txt"
  mv "$path/$new" "$path/$old" 2> /dev/null
# Note: If error, create both .txt files and leave blank
 
## Find IP Address
  IP='dig +short myip.opendns.com @resolver1.opendns.com'
  $IP > $path/$new
 
# Diff addresses
  DIFF_OUTPUT="$(diff $path/$new $path/$old)"
  
  if [ "0" != "${#DIFF_OUTPUT}" ]; then
 ### Create Email function  
  echo "${SCRIPT}: You have a NEW IP it is `dig +short myip.opendns.com @resolver1.opendns.com`" | mail -s "Your Home IP Has Changed" $email
  fi

#!/bin/bash

# SpeedTest.sh -
# By:Jones 09/2016
#
# Require the install of speedtest_cli
# http://www.tecmint.com/check-internet-speed-from-command-line-in-linux/
##################################################

# Global Declarations
declare -r SCRIPT="${0##*/}"
cmd_list='mail' # Reference Commands
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

#run speedtest python SCRIPT
SP='speedtest.py --simple --share'
$SP

 ### Create Email function
#  echo "${SCRIPT}: You're speed results are /r $SP`" | mail -s "Your Home Network Speed Test" $email

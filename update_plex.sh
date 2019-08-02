#!/bin/bash

# Downloads version of Plex you provided to current Dir
# installs,restarts then removes file
#
#################################


# Global Declarations
declare -r SCRIPT="${0##*/}"
cmd_list='rpm curl systemctl rm' # Reference Commands
prefix="plexmediaserver-"
suffix=".x86_64.rpm"

#get input from user and strip front&rear
read -p "Name the file for download: " string
string=${string#$prefix}
version=${string%$suffix}

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
##################


#download plex version listed above
 curl -o plexmediaserver-"$version" 'https://plex.tv/downloads/latest/5?channel=8&build=linux-x86_64&distro=redhat'

#install new Plex version
 sudo rpm -Uvh plexmediaserver-"$version"

#restart the PLEX service
 sudo systemctl start plexmediaserver.service

#cleanup/remove installer
 rm plexmediaserver-"$version"

echo " === Complete ==== "

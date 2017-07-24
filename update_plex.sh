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
read -p "Which version do you wish to install? "string
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
 curl -o plexmediaserver-"$version".x86_64.rpm 'https://downloads.plex.tv/plex-media-server/'$version'/plexmediaserver-'$version'.x86_64.rpm'

#install new Plex version
 sudo rpm -Uvh plexmediaserver-"$version".x86_64.rpm

#restart the PLEX service
 systemctl start plexmediaserver.service

#cleanup/remove installer
 rm plexmediaserver-"$version".x86_64.rpm

echo " === Complete ==== "

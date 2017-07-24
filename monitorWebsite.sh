#!/bin/bash

# monitor.sh - Monitors a web page for changes
# sends an Mac notification if the file change
# By:Octavis Jones 4/4/16
# v2 - 11/8/2016
#    - output veriable name to notification
#
##################################################

# Global Declarations
declare -r SCRIPT="${0##*/}"
cmd_list='osascript curl diff mv grep touch' # Reference Commands
path="<Path of this file>/site_test/"
title="Website Update"


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

check_site(){
  oldsite="$2_old.txt"
  newsite="$2_new.txt"
  touch "$path/$newsite" "$path/$oldsite"
  mv "$path/$newsite" "$path/$oldsite" 2> /dev/null
  echo "Downloading: $2"
  if [[ $1 == *"jamf.com"* ]]; then
      curl $1 -L -s --compressed | grep "Last Updated:" -A 1 > $path/$newsite
    else
      curl $1 -L --compressed -s > "$path/$newsite"
  fi
  echo "Compairing: $2"
  message="There has been a change to $2. Go Check!"
  DIFF_OUTPUT="$(diff site_test/$newsite site_test/$oldsite)"
  if [ "0" != "${#DIFF_OUTPUT}" ]; then
    osascript -e "display notification \"$message\" with title \"$title\" "
  fi
 }


### Function calls - Check sites
check_site 'http://macadmins.software/' MSOffice2016
check_site 'https://app-updates.agilebits.com/product_history/OPM4' 1Password
check_site 'https://cyberduck.io/changelog/' Cyberduck
check_site 'https://www.jamf.com/jamf-nation/third-party-products/41/flash-player?view=info' JAMF_AdobeFlash
check_site 'https://www.jamf.com/jamf-nation/third-party-products/492/slack?view=info' JAMF_Slack

#!/bin/bash

# monitor.sh - Monitors a web page for changes
# sends an Mac notification if the file change
# By:Octavis Jones 4/4/16
#
##################################################

# Global Declarations
declare -r SCRIPT="${0##*/}"
cmd_list='osascript curl diff mv grep' # Reference Commands
path="/Users/octavis/scripts"

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
  mv "$path/$newsite" "$path/$oldsite" 2> /dev/null
  echo "Downloading: $2"
  if [[ $1 == *"jamfnation"* ]]
    then
      curl $1 -L -s --compressed | grep "Last Updated:" -A 1 > $path/$newsite
    else
      curl $1 -L --compressed -s > "$path/$newsite"
  fi
  echo "Compairing: $2"
  DIFF_OUTPUT="$(diff $newsite $oldsite)"
  if [ "0" != "${#DIFF_OUTPUT}" ]; then
  osascript -e 'display notification "There has been a change to one or more websites. Go Check! "'
  fi
 }


### Function calls - Check sites
check_site 'http://macadmins.software/' MSOffice2016
check_site 'https://jamfnation.jamfsoftware.com/viewProduct.html?id=41' JAMF_AdobeFlash
check_site 'https://jamfnation.jamfsoftware.com/viewProduct.html?id=492' JAMF_Slack

#!/usr/bin/env bash

##############################
# Description
# Keep OS X laptops from bridging the wireless and wired networks.
# Turn off the wired interface when the wireless is being used,
# on the wired network.
#
# Calls from /Library/LaunchAgents/com.DisableWirelessWiredBridging.plist 
#
# By:Jones modified 8-15-16

  # Global Declarations
  declare -r SCRIPT="${0##*/}"
  declare -r subnet2="XX.XX.XX." #Group1 network DHCP Network v4 
  declare -r subnet1="XX.XX.XX"  #Group2 network DHCP Network v4
  declare -r statusOn=On
  declare -r statusOff=Off
  wifi_port=`Networksetup -listallhardwareports | grep -iA2 wi-fi | grep -i Device | cut -d : -f2` # Returns wifi port
  cmd_list='grep ifconfig Networksetup osascript' # Reference Commands

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

wifi_check() { # Function to check actual wifi status On/Off
  if [ "`ifconfig $wifi_port | grep \"status: active\"`" != "" ]; then
      wifistatus="On"
    else
      printf "${SCRIPT}: the WiFi is Off - Nothing to do\n"
      exit 192
  fi
}
wifi_off() { # Function to turns off wifi
  Networksetup -setairportpower $wifi_port off
  osascript -e 'display notification "Turning Wi-Fi off. An Ethernet port is curently plugged into the wired network." with title "Wireless Bridging"'
  printf "${SCRIPT}: Turning WiFi off. Ethernet port is on wired network\n"
  wifi_check
}

# MAIN
wifi_check
eth_list="Ethernet" # Reference ports
for eth in ${eth_list}; do # Check Ethernet Ports
  ePort=`Networksetup -listallhardwareports | grep -iA2 $eth | grep -i Device | cut -d : -f2`
  if [ "$ePort" != "" ]; then
      eStatus=`ipconfig getifaddr $ePort`
      if [[ $eStatus == *"$subnet2"* ]] || [[ $eStatus == *"$subnet1"* ]];then #if on Wired Ethernet subnets then check wifi
        if [ $wifistatus == $statusOn ]; then # if on disables wireless
        wifi_off
      	fi
      fi
  fi
done

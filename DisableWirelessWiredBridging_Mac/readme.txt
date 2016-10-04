These files work together in order to disable the wireless network when plugged into a spacific network subnet. This is done so that if an user moves to a home newtwork they are not restricted & allowed to bridge.

com.DisableWirelessWiredBridging.plist
-Calls /Library/Scripts/DisableWirelessWiredBridging.sh
-Run every 5 mins
-To be named & placed in /Library/LaunchAgents/com.DisableWirelessWiredBridging.plist 

DisableWirelessWiredBridging.sh
-Setup to call two subnets, simply replace the XX.XX.XX with you subnet.
-Is called from /Library/LaunchAgents/com.DisableWirelessWiredBridging.plist 
-osascript notification for user works on OSX 10.10 and up 

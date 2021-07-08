# Welcome to the macOS Hardening project

This project was inspired by
- [macOS_Hardening from beerisgood](https://github.com/beerisgood/macOS_Hardening)
- [MacOS-Hardening-Script from ayethatsright](https://github.com/ayethatsright/MacOS-Hardening-Script)
- [awesome-macos-command-line](https://github.com/herrbischoff/awesome-macos-command-line)
- [Note from MoeClub](https://github.com/MoeClub/Note/blob/81a3651d81c871f2327c3312e090bdca3cabf915/MacInitial.sh)
- [stronghold from alichtman](https://github.com/alichtman/stronghold/blob/master/stronghold.py)

(Thanks for your good work !)

Also, I use this Apple documentation : https://developer.apple.com/documentation/devicemanagement/profile-specific_payload_keys.


Before, you have to login to your iCloud account

This Hardening depends on a list :

- Updates
  - Software Update
    - [1000] Automatically check new software updates
    - [1001] Automatically download new software updates
    - [1002] Automatically install new critical updates
    - [1003] Automatically install macOS updates
    - [1004] Restrict SoftwareUpdate require Admin to install
  - AppStore
    - [1100] Automatically keep apps up to date from app store
- Login
  - Console
    - [2000] Disable console logon from the logon screen
  - Screen saver
    - [2100] Enable prompt for a password on screen saver
    - [2101] Set password delay
  - Policy Banner
    - [2200] Enable Policy Banner
  - Logout
    - [2300] Set Logout delay
  - Windows text
    - [2400] Set Login Window Text
- User Preferences
  - iCloud
    - [3000] Disable the iCloud password for local accounts
    - [3001] Enable Find my mac
    - Dia
  - Bluetooth
    - [3100] Disable Bluetooth
  - Finder
    - [3200] Show hidden files in Finder
    - [3201] Display all file extensions
- Protections
  - Systeme intergrity protection
    - [4000] Enable Systeme intergrity protection
  - Gatekeeper
    - [4100] Enable Gatekeeper
- Encryption
  - FileVault
    - [5000] Enable FileVault
- Network
  - Firewall
    - [6000] Enable Firewall
    - [6001] Enable logging
    - [6003] Enable Stealth Mode
    - [6004] Disable captive portal
  - Remote Management
    - [6100] Disable remote management



## Updates

### Software Update
infos : https://developer.apple.com/documentation/devicemanagement/softwareupdate

- Automatically check new software updates
  - ID : 1000
  - checking command : `defaults read /Library/Preferences/com.apple.SoftwareUpdate.plist AutomaticCheckEnabled`
  - setting command : `defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist AutomaticCheckEnabled -bool true`
  - DefaultValue :
  - RecommendedValue : `true`
  - TypeValue : `bool`
  - source :

- Automatically download new software updates
  - ID : 1001
  - checking command : `defaults read /Library/Preferences/com.apple.SoftwareUpdate.plist AutomaticDownload`
  - setting command : `defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist AutomaticDownload -bool true`
  - DefaultValue :
  - RecommendedValue : `true`
  - TypeValue : `bool`
  - source :

- Automatically install new critical updates
  - ID : 1002
  - checking command : `defaults read /Library/Preferences/com.apple.SoftwareUpdate.plist CriticalUpdateInstall
  - setting command : defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist CriticalUpdateInstall -bool true`
  - DefaultValue :
  - RecommendedValue : `true`
  - TypeValue : `bool`
  - source :

- Automatically install macOS updates
  - ID : 1003
  - checking command : `defaults read /Library/Preferences/com.apple.SoftwareUpdate AutomaticallyInstallMacOSUpdates`
  - setting command : `defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticallyInstallMacOSUpdates -bool true`
  - DefaultValue :
  - RecommendedValue : `true`
  - TypeValue : `bool`
  - source :

- Restrict SoftwareUpdate require Admin to install
  - ID : 1004
  - checking command : `defaults read /Library/Preferences/com.apple.SoftwareUpdate restrict-software-update-require-admin-to-install`
  - setting command : `defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist restrict-software-update-require-admin-to-install 1`
  - DefaultValue : `false`
  - RecommendedValue : `true`
  - TypeValue : `bool`
  - source :


### AppStore

- Automatically keep apps up to date from app store
  - ID : 1100
  - checking command : `defaults read /Library/Preferences/com.apple.commerce AutoUpdate`
  - setting command : `defaults write /Library/Preferences/com.apple.commerce AutoUpdate -bool true`
  - DefaultValue : `false`
  - RecommendedValue : `true`
  - Type : `bool`
  - source :

- Automatically update when restart is required
  - ID : 1101
  - checking command : `defaults read /Library/Preferences/com.apple.commerce AutoUpdateRestartRequired`
  - setting command : `defaults write /Library/Preferences/com.apple.commerce AutoUpdateRestartRequired -bool true`
  - DefaultValue :
  - RecommendedValue : `true`
  - Type : `bool`
  - source :

## Login

source : https://developer.apple.com/documentation/devicemanagement/loginwindow

### Console
- Disable console logon from the logon screen
  - ID : 2000
  - checking command : `defaults read /Library/Preferences/com.apple.loginwindow.plist DisableConsoleAccess`
  - setting command : `defaults write /Library/Preferences/com.apple.loginwindow.plist DisableConsoleAccess -bool true`
  - DefaultValue : `false`
  - RecommendedValue : `true`
  - source :

### Screen saver
https://developer.apple.com/documentation/devicemanagement/screensaver

- Enable prompt for a password on screen saver
  - ID : 2100
  - checking command : `defaults read /Library/Preferences/com.apple.screensaver askForPassword`
  - setting command : `defaults write /Library/Preferences/com.apple.screensaver askForPassword -bool 1`
  - type : `bool`
  - DefaultValue :
  - RecommendedValue : `true`
  - source : https://developer.apple.com/documentation/devicemanagement/screensaver

- Set password delay
  - ID : 2101
  - checking command : `defaults read /Library/Preferences/com.apple.screensaver askForPasswordDelay`
  - setting command : `defaults write /Library/Preferences/com.apple.screensaver askForPasswordDelay -int 0`
  - type : int
  - DefaultValue :
  - RecommendedValue : 0
  - source : https://developer.apple.com/documentation/devicemanagement/screensaver

### Policy banner

- Enable Policy Banner
  - ID : 2200
  - checking command : PolicyBanner.txt it exist ?
  - setting command : `printf '%s\n' '{ADD COMPANY NAME HERE}' 'Unauthorised use of this system is an offence under the Computer Misuse Act 1990.' 'Unless authorised by {ADD COMPANY NAME HERE} do not proceed. You must not abuse your' 'own system access or use the system under another User ID.' > /Library/Security/PolicyBanner.txt`
  - DefaultValue :
  - RecommendedValue : true
  - source :

### Logout

- Set Logout delay
  - ID : 2300
  - checking command : `defaults read /Library/Preferences/.GlobalPreferences com.apple.autologout.AutoLogOutDelay`
  - setting command : `sudo defaults write /Library/Preferences/.GlobalPreferences com.apple.autologout.AutoLogOutDelay -int 3600`
  - DefaultValue :
  - RecommendedValue : 3600
  - source : https://developer.apple.com/documentation/devicemanagement/globalpreferences

### Windows text

- Set Login Window Text
  - ID : 2400
  - checking command : `defaults read /Library/Preferences/com.apple.loginwindow LoginwindowText`
  - setting command : `defaults write /Library/Preferences/com.apple.loginwindow LoginwindowText "Your text"`
  - DefaultValue :
  - TypeValue : string
  - RecommendedValue : 3600
  - source : https://developer.apple.com/documentation/devicemanagement/globalpreferences


## User Preferences

### iCloud
- Disable the iCloud password for local accounts - Hight
  - ID : 3000
  - checking command : `defaults read com.apple.preference.users DisableUsingiCloudPassword`
  - setting command : `defaults write com.apple.preference.users DisableUsingiCloudPassword true`
  - DefaultValue : false
  - RecommendedValue : false
  - source : https://developer.apple.com/documentation/devicemanagement/userpreferences

- Enable Find my mac
  - ID : 3001
  - checking command : `nvram -p | grep -c 'fmm-mobileme-token-FMM'`
  - setting command : ``
  - source :

### Bluetooth

- Disable Bluetooth
  - ID : 3100
  - checking command : `defaults read /Library/Preferences/com.apple.Bluetooth ControllerPowerState`
  - setting command : `defaults write /Library/Preferences/com.apple.Bluetooth AutoUpdate true`
  - DefaultValue : false
  - RecommendedValue : true
  - source :

### Finder

- Show hidden files in Finder
  - ID : 3200
  - checking command : `defaults read com.apple.finder AppleShowAllFiles`
  - setting command : `defaults write com.apple.finder AppleShowAllFiles -bool true`
  - DefaultValue : `false`
  - RecommendedValue : `true`
  - source :

- Display all files extentions
  - ID : 3201
  - checking command : `defaults read NSGlobalDomain AppleShowAllExtensions`
  - setting command : `defaults write NSGlobalDomain AppleShowAllExtensions -bool true`
  - DefaultValue : false  
  - RecommendedValue : true
  - source :

- Show status bar
  - ID : 3202
  - checking command : `defaults read com.apple.finder ShowStatusBar`
  - setting command : `defaults write com.apple.finder ShowStatusBar -bool true`
  - DefaultValue :   
  - RecommendedValue : `true`
  - source :

### Safari

- Disable the automatic run of safe files in Safari
  - ID : 3300
  - checking command : `defaults read /Users/<username>/Library/Containers/com.apple.Safari/Data/Library/Preferences/com.apple.Safari AutoOpenSafeDownloads`
  - setting command : `sudo defaults read /Users/<username>/Library/Containers/com.apple.Safari/Data/Library/Preferences/com.apple.Safari AutoOpenSafeDownloads -bool false`
  - DefaultValue : `true`
  - TypeValue : `bool`
  - RecommendedValue : `false`

- Don't send search queries to Apple
  - ID : 3301
  - checking command : `defaults read com.apple.Safari UniversalSearchEnabled`
  - setting command : `defaults write com.apple.Safari UniversalSearchEnabled -bool false`
  - DefaultValue : `true`
  - TypeValue : `bool`
  - RecommendedValue : `false`

- Enable suppress search suggestions
  - ID : 3301
  - checking command : `defaults read com.apple.Safari SuppressSearchSuggestions`
  - setting command : `defaults write com.apple.Safari SuppressSearchSuggestions -bool true`
  - DefaultValue :
  - TypeValue : `bool`
  - RecommendedValue : `true`


## Protections

### Systeme intergrity protection

- Enable Systeme intergrity protection
  - ID : 4000
  - checking command : `csrutil status`
  - setting command : `csrutil enable`
  - DefaultValue : enable
  - RecommendedValue : enable
  - source :

### Gatekeeper

- Enable Gatekeeper
  - ID : 4100
  - checking command : `spctl --status`
  - setting command : `sudo spctl --master-enable`
  - DefaultValue : --master-enable
  - RecommendedValue : --master-enable
  - source :

## Encryption

### FileVault

- Enable FileVault
  - ID : 5000
  - checking command : `fdesetup status`
  - setting command : `sudo fdesetup enable`
  - DefaultValue : disable
  - RecommendedValue : enable
  - source :

## Network

### Firewall

- Enable Firewall
  - ID : 6000
  - checking command : `defaults read /Library/Preferences/com.apple.alf globalstate`
  - setting command : `defaults write /Library/Preferences/com.apple.alf globalstate -int 1`
  - type = `int`
  - DefaultValue : `0`
  - RecommendedValue : `1`
  - PossibleValues : `0,1,2`
  - source : https://raymii.org/s/snippets/OS_X_-_Turn_firewall_on_or_off_from_the_command_line.html

- Enable logging
  - ID : 6001
  - checking command : `defaults read /Library/Preferences/com.apple.alf loggingenabled`
  - setting command : `defaults write /Library/Preferences/com.apple.alf loggingenabled -bool true`
  - type = `bool`
  - DefaultValue : `false`
  - RecommendedValue : `true`
  - source :

- Enable Stealth Mode
  - ID : 6002
  - checking command : `defaults read /Library/Preferences/com.apple.alf stealthenabled`
  - setting command : `defaults write /Library/Preferences/com.apple.alf loggingenabled -bool true`
  - type = `bool`
  - DefaultValue : `false`
  - RecommendedValue : `true`
  - source :

- Disable automatic software whitelisting
  - ID : 6003
  - checking command : `defaults read /Library/Preferences/com.apple.alf allowsignedenabled`
  - setting command : `defaults write /Library/Preferences/com.apple.alf allowsignedenabled -bool false`
  - type = `bool`
  - DefaultValue : `true`
  - RecommendedValue : `false`
  - source :

- Disable automatic signed software whitelisting
  - ID : 6004
  - checking command : `defaults read /Library/Preferences/com.apple.alf allowdownloadsignedenabled`
  - setting command : `defaults write /Library/Preferences/com.apple.alf allowdownloadsignedenabled -bool false`
  - type = `bool`
  - DefaultValue : `true`
  - RecommendedValue : `false`
  - source :

- Disable captive portal
  - ID : 6005
  - checking command : `defaults read /Library/Preferences/SystemConfiguration/com.apple.captive.control Active`
  - setting command : `defaults write /Library/Preferences/SystemConfiguration/com.apple.captive.control Active -bool false`
  - type = `bool`
  - DefaultValue : `true`
  - RecommendedValue : `false`
  - source :

### Remote Management

- Disable Remote Management
  - ID : 6100
  - checking command :
  - setting command : `/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -desactivate`
  - DefaultValue : 0
  - RecommendedValue : `-desactive`
  - source : https://support.apple.com/fr-fr/guide/remote-desktop/apd8b1c65bd/mac

- Disable "Wake for network access"
  - ID : 6101
  - checking command : `/usr/libexec/PlistBuddy -c "Print 'AC Power':'Wake On LAN'" /Library/Preferences/com.apple.PowerManagement.plist`
  - setting command : `sudo /usr/libexec/PlistBuddy -c "Set 'AC Power':'Wake On LAN' 0" /Library/Preferences/com.apple.PowerManagement.plist`
  - DefaultValue : `1`
  - RecommendedValue : `0`
  - Consquence : Problemes with FindMyMac


## Cache

- Configurer les réglages avancés de la mise en cache de contenu sur Mac
  - checking command :
  - setting command :
  - DefaultValue :
  - RecommendedValue :
  - source : https://support.apple.com/fr-fr/guide/mac-help/mchl91e7141a/mac



  - checking command :
  - setting command :
  - DefaultValue :
  - RecommendedValue :
  - source :

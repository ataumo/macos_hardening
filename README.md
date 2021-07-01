Apple documentation : https://developer.apple.com/documentation/devicemanagement/profile-specific_payload_keys


Before, you have to login to your iCloud account

## Updates

### Software Update
infos : https://developer.apple.com/documentation/devicemanagement/softwareupdate

- Automatically check new software updates
  - ID : 1000
  - checking command : defaults read /Library/Preferences/com.apple.SoftwareUpdate.plist AutomaticCheckEnabled
  - setting command : defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist AutomaticCheckEnabled -bool true
  - DefaultValue :
  - RecommendedValue : 1
  - source :

- Automatically download new software updates
  - ID : 1001
  - checking command : defaults read /Library/Preferences/com.apple.SoftwareUpdate.plist AutomaticDownload
  - setting command : defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist AutomaticDownload -bool true
  - DefaultValue :
  - RecommendedValue : 1
  - source :

- Automatically install new critical updates
  - ID : 1002
  - checking command : defaults read /Library/Preferences/com.apple.SoftwareUpdate.plist CriticalUpdateInstall
  - setting command : defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist CriticalUpdateInstall -bool true
  - DefaultValue :
  - RecommendedValue : 1
  - source :

- Automatically install macOS updates
  - ID : 1003
  - checking command : defaults read /Library/Preferences/com.apple.SoftwareUpdate.plist AutomaticallyInstallMacOSUpdates
  - setting command : defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist AutomaticallyInstallMacOSUpdates -bool true
  - DefaultValue :
  - RecommendedValue : 1
  - source :

- Restrict SoftwareUpdate require Admin to install
  - ID : 1004
  - checking command : defaults read /Library/Preferences/com.apple.SoftwareUpdate restrict-software-update-require-admin-to-install
  - setting command : defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist restrict-software-update-require-admin-to-install 1
  - DefaultValue : 0
  - RecommendedValue : 1
  - source :


### AppStore

- Automatically keep apps up to date from app store
  - ID : 1100
  - checking command : defaults read /Library/Preferences/com.apple.commerce AutoUpdate
  - setting command : defaults write /Library/Preferences/com.apple.commerce AutoUpdate -bool 1
  - DefaultValue : 1
  - RecommendedValue : 1
  - source :

## Login

source : https://developer.apple.com/documentation/devicemanagement/loginwindow

### Console
- Diable console logon from the logon screen
  - ID : 2000
  - checking command : defaults read /Library/Preferences/com.apple.loginwindow.plist DisableConsoleAccess
  - setting command : defaults write /Library/Preferences/com.apple.loginwindow.plist DisableConsoleAccess -bool TRUE
  - DefaultValue : false
  - RecommendedValue : true
  - source :

### Screen saver
https://developer.apple.com/documentation/devicemanagement/screensaver

- Enable prompt for a password on screen saver
  - ID : 2100
  - checking command : defaults read com.apple.screensaver askForPassword
  - setting command : defaults write com.apple.screensaver askForPassword 1
  - DefaultValue : false
  - RecommendedValue : true
  - source : https://developer.apple.com/documentation/devicemanagement/screensaver

- Enable prompt for a password on screen saver
  - ID : 2101
  - checking command : defaults read com.apple.screensaver askForPassword
  - setting command : defaults write com.apple.screensaver askForPassword 1
  - DefaultValue : false
  - RecommendedValue : true
  - source : https://developer.apple.com/documentation/devicemanagement/screensaver

### Policy banner

- Enable Policy Banner
  - ID : 2200
  - checking command : PolicyBanner.txt it exist ?
  - setting command : printf '%s\n' '{ADD COMPANY NAME HERE}' 'Unauthorised use of this system is an offence under the Computer Misuse Act 1990.' 'Unless authorised by {ADD COMPANY NAME HERE} do not proceed. You must not abuse your' 'own system access or use the system under another User ID.' > /Library/Security/PolicyBanner.txt
  - DefaultValue :
  - RecommendedValue : true
  - source :

### Logout

- Set Logout delay
  - ID : 2300
  - checking command : defaults read /Library/Preferences/.GlobalPreferences com.apple.autologout.AutoLogOutDelay
  - setting command : sudo defaults write /Library/Preferences/.GlobalPreferences com.apple.autologout.AutoLogOutDelay -int 3600
  - DefaultValue :
  - RecommendedValue : 3600
  - source : https://developer.apple.com/documentation/devicemanagement/globalpreferences

## User Preferences

### iCloud
- Disable the iCloud password for local accounts - Hight
  - ID : 3000
  - checking command : defaults read com.apple.preference.users DisableUsingiCloudPassword
  - setting command : defaults write com.apple.preference.users DisableUsingiCloudPassword true
  - DefaultValue : false
  - RecommendedValue : false
  - source : https://developer.apple.com/documentation/devicemanagement/userpreferences

- Enable Find my mac
  - ID : 3000
  - checking command : defaults read com.apple.FindMyMac FMMEnabled
  - setting command : defaults write com.apple.FindMyMac FMMEnabled 1
  - DefaultValue : 0
  - RecommendedValue : 1
  - source :

## Bluetooth

- Disable Bluetooth
  - ID : 4000
  - checking command : defaults read /Library/Preferences/com.apple.Bluetooth ControllerPowerState
  - setting command : defaults write /Library/Preferences/com.apple.Bluetooth AutoUpdate true
  - DefaultValue : false
  - RecommendedValue : true
  - source :


## Protections

### Systeme intergrity protection

- Enable Systeme intergrity protection
  - ID : 5000
  - checking command : csrutil status
  - setting command : csrutil enable
  - DefaultValue : enable
  - RecommendedValue : enable
  - source :

### Gatekeeper

- Enable Gatekeeper
  - ID : 5100
  - checking command : spctl --status
  - setting command : sudo spctl --master-enable
  - DefaultValue : --master-enable
  - RecommendedValue : --master-enable
  - source :

## Encryption

- Enable FileVault
  - ID : 6000
  - checking command : fdesetup status
  - setting command : sudo fdesetup enable
  - DefaultValue : disable
  - RecommendedValue : enable
  - source :

## AppStore

source : https://developer.apple.com/documentation/devicemanagement/appstore

- Enable FileVault
  - ID : 6000
  - checking command : fdesetup status
  - setting command : sudo fdesetup enable
  - DefaultValue : disable
  - RecommendedValue : enable
  - source :



## Firewall

- Enable Firewall
  - ID : 7000
  - checking command : defaults read /Library/Preferences/com.apple.alf.plist globalstate
  - setting command : defaults write /Library/Preferences/com.apple.alf.plist globalstate -int 1
  - DefaultValue : 0
  - RecommendedValue : 1
  - source : https://raymii.org/s/snippets/OS_X_-_Turn_firewall_on_or_off_from_the_command_line.html




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

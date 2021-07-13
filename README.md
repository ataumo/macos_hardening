# Welcome to the macOS Hardening project

**[Work in progess]**

This project was inspired by
- [macOS_Hardening from beerisgood](https://github.com/beerisgood/macOS_Hardening)
- [MacOS-Hardening-Script from ayethatsright](https://github.com/ayethatsright/MacOS-Hardening-Script)
- [awesome-macos-command-line](https://github.com/herrbischoff/awesome-macos-command-line)
- [Note from MoeClub](https://github.com/MoeClub/Note/blob/81a3651d81c871f2327c3312e090bdca3cabf915/MacInitial.sh)
- [stronghold from alichtman](https://github.com/alichtman/stronghold/blob/master/stronghold.py)
- [cis_apple_macOS_10.13.yml from wazuh](https://github.com/wazuh/wazuh-ruleset/blob/13925fbe0d0e27f012d3d3f3c492e4d420a104b4/sca/darwin/17/cis_apple_macOS_10.13.yml)

(Thanks for your good work !)

Also, I use this Apple documentation : https://developer.apple.com/documentation/devicemanagement/profile-specific_payload_keys.


And based on CIS Apple macOS 11.0 Benchmark v1.2.0 (https://downloads.cisecurity.org/#/)

## CIS Apple macOS Benchmark

### Profile Definitions

1. Level 1 : Items in this profile intend to:
  - be practical and prudent;
  - provide a clear security benefit; and
  - not inhibit the utility of the technology beyond acceptable means.

2. Level 2 : This profile extends the "Level 1" profile. Items in this profile exhibit one or more of
the following characteristics:
  - are intended for environments or use cases where security is paramount
  - acts as defense in depth measure
  - may negatively inhibit the utility or performance of the technology.


## List of policies

Before, you have to login to your iCloud account

This Hardening depends on a list :

- Updates

  - [1000] Verify all Apple provided software is current
  - Software Update
    - [1001] Automatically check new software updates
    - [1002] Automatically download new software updates
    - [1003] Enable system data files update install
    - [1004] Enable security updates install
    - [1005] Automatically install macOS updates
  - AppStore
    - [1100] Automatically keep apps up to date from app store
- Login

  - Sleep
    - [2000] AC display sleep timer
    - [2001] Battery display sleep timer
  - Screen saver
    - [2100] Enable prompt for a password on screen saver
    - [2101] Set password delay
    - [2102] Set inactivity interval for the screen saver
    - Secure screen saver corners
      - [2103:1] Secure screen saver corners (top-left)
      - [2103:2] Secure screen saver corners (bottom-left)
      - [2103:3] Secure screen saver corners (top-right)
      - [2103:4] Secure screen saver corners (bottom-right)
  - Policy Banner
    - [2200] Enable Policy Banner
  - Logout
    - [2300] Set Logout delay
  - Windows text
    - [2400] Set Login Window Text
  - Automatic login
    - [2500] Disable automatic login
  - Console
    - [2600] Disable console logon from the logon screen
  - Remote Login
    - [2700] Disable Remote Login
- User Preferences

  - iCloud
    - [3000] Disable the iCloud password for local accounts
    - [3001] Enable Find my mac
  - Bluetooth
    - [3100] Disable Bluetooth
    - [3101] Show Bluetooth status in menu bar
  - Finder
    - [3200] Show hidden files in Finder
    - [3201] Display all file extensions
    - [3202] Show status bar
  - Safari
    - [3300] Disable the automatic run of safe files in Safari
    - [3301] Don't send search queries to Apple
    - [3302] Enable suppress search suggestions
  - Date and Time
    - [3400] Set time and date automatically
  - Sharing
    - [3500] Remote Apple Events
    - [3501] Internet Sharing
    - [3502] Screen Sharing
    - [3503] File Sharing
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
    - [6002] Enable Stealth Mode
    - [6003] Disable automatic software whitelisting
    - [6004] Disable automatic signed software whitelisting
    - [6005] Disable captive portal
  - Remote Management
    - [6100] Disable remote management
    - [6101] Disable "Wake for network access"



### Updates

- Verify all Apple provided software is current
  - ID : 1000
  - Level : 1
  - Method : softwareupdate
  - Assessment Status : Automatically
  - Checking command : `softwareupdate -l`
  - ExpectedOutput : `No new software available`
  - Setting command : `sudo softwareupdate -ia`
  - Graphical Method :
    1. Open System Preferences
    2. Select Software Update
    3. Select Automatically check for updates to allow Software Update to check with
    Apple's servers for any outstanding updates
    4. Select Show Updates to verify that there are no software updates available

#### Software Update
infos : https://developer.apple.com/documentation/devicemanagement/softwareupdate

- Automatically check new software updates
  - ID : 1001
  - Level : 1
  - Method : Registry
  - Assessment Status : Automatically
  - Checking command : `defaults read /Library/Preferences/com.apple.SoftwareUpdate AutomaticCheckEnabled`
  - Setting command : `defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true`
  - RecommendedValue : `true`
  - TypeValue : `bool`
  - Graphical Method :
    1. Open System Preferences
    2. Select Software Update
    3. Select Advanced
    4. Verify that Check for updates is selected

- Automatically download new software updates
  - ID : 1002
  - Level : 1
  - Method : Registry
  - Assessment Status : Automatically
  - Checking command : `defaults read /Library/Preferences/com.apple.SoftwareUpdate.plist AutomaticDownload`
  - Setting command : `defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist AutomaticDownload -bool true`
  - DefaultValue :
  - RecommendedValue : `true`
  - TypeValue : `bool`
  - Graphical Method :
    1. Open System Preferences
    2. Select Software Update
    3. Select Advanced
    4. Verify that Download new updates when available is selected

- Enable system data files updates install
  - ID : 1003
  - Level : 1
  - Method : Registry
  - Assessment Status : Automatically
  - Checking command : `defaults read /Library/Preferences/com.apple.commerce ConfigDataInstall`
  - Setting command : `defaults write /Library/Preferences/com.apple.commerce ConfigDataInstall -bool true`
  - DefaultValue : `false`
  - RecommendedValue : `true`
  - Type : `bool`
  - Graphical method :
    1. Open System Preferences
    2. Select Software Updates
    3. Select Advanced
    4. Verify that Install system data files and security updates is selected

- Enable security updates install
  - ID : 1004
  - Level : 1
  - Method : Registry
  - Assessment Status : Automatically
  - Checking command : `defaults read /Library/Preferences/com.apple.commerce CriticalUpdateInstall`
  - Setting command : `defaults write /Library/Preferences/com.apple.commerce CriticalUpdateInstall -bool true`
  - DefaultValue : `false`
  - RecommendedValue : `true`
  - Type : `bool`
  - Graphical method :
    1. Open System Preferences
    2. Select Software Updates
    3. Select Advanced
    4. Verify that Install system data files and security updates is selected

- Automatically install macOS updates
  - ID : 1005
  - Level : 1
  - Method : Registry
  - Assessment Status : Automatically
  - Checking command : `defaults read /Library/Preferences/com.apple.SoftwareUpdate AutomaticallyInstallMacOSUpdates`
  - Setting command : `defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticallyInstallMacOSUpdates -bool true`
  - RecommendedValue : `true`
  - TypeValue : `bool`
  - Graphical method :
    1. Open System Preferences
    2. Select Software Updates
    3. Select Advanced
    4. Verify that Install macOS updates is selected


#### AppStore

- Automatically keep apps up to date from app store
  - ID : 1100
  - Level : 1
  - Method : Registry
  - Assessment Status : Automatically
  - checking command : `defaults read /Library/Preferences/com.apple.commerce AutoUpdate`
  - setting command : `defaults write /Library/Preferences/com.apple.commerce AutoUpdate -bool true`
  - DefaultValue : `false`
  - RecommendedValue : `true`
  - Type : `bool`
  - Graphical method :
    1. Open System Preferences
    2. Select Software Updates
    3. Select Advanced
    4. Verify that Install app updates from the App Store is checked

### Login/Logout

source : https://developer.apple.com/documentation/devicemanagement/loginwindow

#### Sleep

- AC display sleep timer
  - ID : 2000
  - Checking command : `/usr/libexec/PlistBuddy -c "Print 'AC Power':'Display Sleep Timer'" /Library/Preferences/com.apple.PowerManagement.plist`
  - Setting command : `sudo /usr/libexec/PlistBuddy -c "Set 'AC Power':'Display Sleep Timer' 20" /Library/Preferences/com.apple.PowerManagement.plist`
  - RecommendedValue : `20`

- Battery display sleep timer
  - ID : 2001
  - Checking command : `/usr/libexec/PlistBuddy -c "Print 'Battery Power':'Display Sleep Timer'" /Library/Preferences/com.apple.PowerManagement.plist`
  - Setting command : `sudo /usr/libexec/PlistBuddy -c "Set 'Battery Power':'Display Sleep Timer' 10" /Library/Preferences/com.apple.PowerManagement.plist`
  - RecommendedValue : `10`

#### Screen saver
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

- Set an inactivity interval for the screen saver
  - ID : 2102
  - Level : 1
  - Method : Registry
  - Assessment Status : Automatically
  - checking command : `defaults -currentHost read com.apple.screensaver idleTime`
  - setting command : `sudo -u <username> defaults -currentHost write com.apple.screensaver idleTime -int <value ≤1200>`
  - RecommendedValue : `1200`
  - Type : `int`
  - Graphical method :
    1. Open System Preferences
    2. Select Desktop & Screen Saver
    3. Select Screen Saver
    4. Verify that Start after is set for 20 minutes of less (≤1200)

##### Secure screen saver corners

- Secure screen saver corners (top-left)
  - ID : 2103:1
  - Level : 2
  - Method : Registry
  - Assessment Status : Automatically
  - checking command : `defaults read com.apple.dock wvous-tl-corner`
  - setting command : `sudo -u <username> defaults write com.apple.dock wvous-tl-corner -int 0`
  - RecommendedValue : `0`
  - Type : `int`
  - Graphical method :
    1. Open System Preferences
    2. Select Desktop & Screen Saver
    3. Select Screen Saver
    4. Select Hot Corners... and verify that Disable Screen Saver is not set

- Secure screen saver corners (bottom-left)
  - ID : 2103:2
  - Level : 2
  - Method : Registry
  - Assessment Status : Automatically
  - checking command : `defaults read com.apple.dock wvous-bl-corner`
  - setting command : `sudo -u <username> defaults write com.apple.dock wvous-bl-corner -int 0`
  - RecommendedValue : `0`
  - Type : `int`
  - Graphical method :
    1. Open System Preferences
    2. Select Desktop & Screen Saver
    3. Select Screen Saver
    4. Select Hot Corners... and verify that Disable Screen Saver is not set

- Secure screen saver corners (top-right)
  - ID : 2103:3
  - Level : 2
  - Method : Registry
  - Assessment Status : Automatically
  - checking command : `defaults read com.apple.dock wvous-tr-corner`
  - setting command : `sudo -u <username> defaults write com.apple.dock wvous-tr-corner -int 0`
  - RecommendedValue : `0`
  - Type : `int`
  - Graphical method :
    1. Open System Preferences
    2. Select Desktop & Screen Saver
    3. Select Screen Saver
    4. Select Hot Corners... and verify that Disable Screen Saver is not set

- Secure screen saver corners (bottom-right)
  - ID : 2103:4
  - Level : 2
  - Method : Registry
  - Assessment Status : Automatically
  - checking command : `defaults read com.apple.dock wvous-br-corner`
  - setting command : `sudo -u <username> defaults write com.apple.dock wvous-br-corner -int 0`
  - RecommendedValue : `0`
  - Type : `int`
  - Graphical method :
    1. Open System Preferences
    2. Select Desktop & Screen Saver
    3. Select Screen Saver
    4. Select Hot Corners... and verify that Disable Screen Saver is not set

#### Policy banner

- Enable Policy Banner
  - ID : 2200
  - checking command : PolicyBanner.txt it exist ?
  - setting command : `printf '%s\n' '{ADD COMPANY NAME HERE}' 'Unauthorised use of this system is an offence under the Computer Misuse Act 1990.' 'Unless authorised by {ADD COMPANY NAME HERE} do not proceed. You must not abuse your' 'own system access or use the system under another User ID.' > /Library/Security/PolicyBanner.txt`
  - DefaultValue :
  - RecommendedValue : true
  - source :

#### Logout

- Set Logout delay
  - ID : 2300
  - checking command : `defaults read /Library/Preferences/.GlobalPreferences com.apple.autologout.AutoLogOutDelay`
  - setting command : `sudo defaults write /Library/Preferences/.GlobalPreferences com.apple.autologout.AutoLogOutDelay -int 3600`
  - DefaultValue :
  - RecommendedValue : 3600
  - source : https://developer.apple.com/documentation/devicemanagement/globalpreferences

#### Windows text

- Set Login Window Text
  - ID : 2400
  - checking command : `defaults read /Library/Preferences/com.apple.loginwindow LoginwindowText`
  - setting command : `defaults write /Library/Preferences/com.apple.loginwindow LoginwindowText "Your text"`
  - TypeValue : string
  - source : https://developer.apple.com/documentation/devicemanagement/globalpreferences

#### Automatic login

- Disable automatic login
  - ID : 2500
  - checking command : `defaults read /Library/Preferences/com.apple.loginwindow autoLoginUser`
  - setting command : `defaults write /Library/Preferences/com.apple.loginwindow autoLoginUser -bool false`
  - DefaultValue :
  - TypeValue : `bool`
  - RecommendedValue : `false`
  - source : https://developer.apple.com/documentation/devicemanagement/globalpreferences

#### Console

- Disable console logon from the logon screen
  - ID : 2600
  - checking command : `defaults read /Library/Preferences/com.apple.loginwindow.plist DisableConsoleAccess`
  - setting command : `defaults write /Library/Preferences/com.apple.loginwindow.plist DisableConsoleAccess -bool true`
  - DefaultValue : `false`
  - RecommendedValue : `true`
  - source :

#### Remote Login

- Disable Remote Login
  - ID : 2700
  - Level : 1
  - Method : Registry
  - Assessment Status : Automatically
  - Checking command : `sudo systemsetup -getremotelogin`
  - Setting command : `sudo systemsetup -setremotelogin`
  - RecommendedValue : `off`
  - Graphical method :
    1. Open System Preferences
    2. Select Sharing
    3. Uncheck Remote Login


### User Preferences

#### iCloud
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

#### Bluetooth

- Disable Bluetooth
  - ID : 3100
  - Level : 1
  - Method : Registry
  - Assessment Status : Automatically
  - checking command : `defaults read /Library/Preferences/com.apple.Bluetooth ControllerPowerState`
  - setting command : `defaults write /Library/Preferences/com.apple.Bluetooth ControllerPowerState -bool false`
  - DefaultValue : `true`
  - RecommendedValue : `false`
  - Type : `bool`
  - Graphical method :
    1. Open System Preferences
    2. Select Bluetooth
    3. Select Turn Bluetooth Off

- Show Bluetooth status in menu bar
  - ID : 3101
  - Level : 1
  - Method : Registry
  - Assessment Status : Automatically
  - Checking command : `sudo -u <username> defaults -currentHost read com.apple.controlcenter.plist Bluetooth`
  - Setting command : `sudo -u <username> defaults -currentHost write com.apple.controlcenter.plist Bluetooth -int 18`
  - RecommendedValue : `18`
  - Type : `int`
  - Graphical method :
    1. Open System Preferences
    2. Select Bluetooth
    3. Verify the Show Bluetooth in menu bar is selected

#### Finder

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

#### Safari

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
  - ID : 3302
  - checking command : `defaults read com.apple.Safari SuppressSearchSuggestions`
  - setting command : `defaults write com.apple.Safari SuppressSearchSuggestions -bool true`
  - DefaultValue :
  - TypeValue : `bool`
  - RecommendedValue : `true`

#### Date and Time

- Enable "Set time and date automatically"
  - ID : 3400
  - Level : 1
  - Method : systemsetup
  - Assessment Status : Automatically
  - Checking command : `sudo systemsetup -getnetworktimeserver`
  - Setting command : `sudo systemsetup -setnetworktimeserver time.euro.apple.com`
  - RecommendedValue : `time.euro.apple.com`
  - Graphical method :
    1. Open System Preferences
    2. Select Date & Time
    3. Verify that Set date and time automatically is selected

#### Sharing

- Remote Apple Events
  - ID : 3500
  - Level : 1
  - Method : systemsetup
  - Assessment Status : Automatically
  - Checking command : `sudo systemsetup -getremoteappleevents`
  - Setting command : `sudo systemsetup -setremoteappleevents off`
  - RecommendedValue : `off`
  - Graphical method :
    1. Open System Preferences
    2. Select Sharing
    3. Verify that Remote Apple Events is not set

- Internet Sharing
  - ID : 3501
  - Level : 1
  - Method : PlistBuddy
  - Assessment Status : Automatically
  - Checking command : `/usr/libexec/PlistBuddy -c "Print NAT:Enabled" /Library/Preferences/SystemConfiguration/com.apple.nat.plist`
  - Setting command : `/usr/libexec/PlistBuddy -c "Set NAT:Enabled 0" /Library/Preferences/SystemConfiguration/com.apple.nat.plist`
  - RecommendedValue : `0`
  - Graphical method :
    1. Open System Preferences
    2. Select Sharing
    3. Verify that Internet Sharing is not set

- Disable Screen Sharing
  - ID : 3502
  - Level : 1
  - Method : launchctl
  - Assessment Status : Automatically
  - Checking command : `launchctl print-disabled system | grep -c '"com.apple.screensharing" => true'`
  - Setting command : `sudo launchctl disable system/com.apple.screensharing`
  - RecommendedValue : `disable`
  - PossibleValues : `enable/disable`
  - Graphical method :
    1. Open System Preferences
    2. Select Sharing
    3. Verify that Screen Sharing is not set

- Disable File Sharing
  - ID : 3503
  - Level : 1
  - Method : launchctl
  - Assessment Status : Automatically
  - Checking command : `launchctl print-disabled system | grep -c '"com.apple.smbd" => true'`
  - Setting command : `sudo launchctl disable system/com.apple.smbd`
  - RecommendedValue : `disable`
  - PossibleValues : `enable/disable`
  - Graphical method :
    1. Open System Preferences
    2. Select Sharing
    3. Verify that File Sharing is not set


### Protections

#### Systeme intergrity protection

- Enable Systeme intergrity protection
  - ID : 4000
  - checking command : `csrutil status`
  - setting command : `csrutil enable`
  - DefaultValue : enable
  - RecommendedValue : enable
  - source :

#### Gatekeeper

- Enable Gatekeeper
  - ID : 4100
  - checking command : `spctl --status`
  - setting command : `sudo spctl --master-enable`
  - DefaultValue : --master-enable
  - RecommendedValue : --master-enable
  - source :

### Encryption

#### FileVault

- Enable FileVault
  - ID : 5000
  - checking command : `fdesetup status`
  - setting command : `sudo fdesetup enable`
  - DefaultValue : disable
  - RecommendedValue : enable
  - source :

### Network

#### Firewall

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

#### Remote Management

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


### Cache

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

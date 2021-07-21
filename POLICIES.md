# Details of policies

## Updates

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

### Software Update
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


### AppStore

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

## Login/Logout

source : https://developer.apple.com/documentation/devicemanagement/loginwindow

### Sleep

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

#### Secure screen saver corners

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
  - TypeValue : string
  - source : https://developer.apple.com/documentation/devicemanagement/globalpreferences

### Automatic login

- Disable automatic login
  - ID : 2500
  - checking command : `defaults read /Library/Preferences/com.apple.loginwindow autoLoginUser`
  - setting command : `defaults write /Library/Preferences/com.apple.loginwindow autoLoginUser -bool false`
  - DefaultValue :
  - TypeValue : `bool`
  - RecommendedValue : `false`
  - source : https://developer.apple.com/documentation/devicemanagement/globalpreferences

### Console

- Disable console logon from the logon screen
  - ID : 2600
  - checking command : `defaults read /Library/Preferences/com.apple.loginwindow.plist DisableConsoleAccess`
  - setting command : `defaults write /Library/Preferences/com.apple.loginwindow.plist DisableConsoleAccess -bool true`
  - DefaultValue : `false`
  - RecommendedValue : `true`
  - source :

### Remote Login

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


## User Preferences

### iCloud

- iCloud configuration
  - ID : 3000
  - Level : 2
  - Method : PlistBuddy
  - Assessment Status : Manually
  - Checking command : `/usr/libexec/PlistBuddy -c "Print Accounts:0:LoggedIn" ~/Library/Preferences/MobileMeAccounts.plist`
  - DefaultValue : false
  - RecommendedValue : true
  - source : https://developer.apple.com/documentation/devicemanagement/userpreferences
  - Graphical method :
    1. Open System Preferences
    2. Select Apple ID
    3. Select iCloud

- Enable Find my mac
  - ID : 3001
  - Method : nvram
  - AssessmentStatus : Manually
  - Checking command : `nvram -p | grep -c 'fmm-mobileme-token-FMM'`
  - DefaultValue : 0
  - RecommendedValue : 2
  - Graphical method :
    1. Open System Preferences
    2. Select Apple ID
    3. Select iCloud
    4. Enable "Find my mac"

### Bluetooth

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

- Disable Bluetooth Sharing
  - ID : 3102
  - Level : 1
  - Method : Registry
  - Assessment Status : Automatically
  - Checking command : `sudo -u <username> defaults -currentHost read com.apple.Bluetooth PrefKeyServicesEnabled`
  - Setting command : `sudo -u <username> defaults -currentHost write com.apple.Bluetooth PrefKeyServicesEnabled -int false`
  - RecommendedValue : `false`
  - Type : `bool`
  - Graphical method :
    1. Open System Preferences
    2. Select Sharing
    3. Verify that Bluetooth Sharing is not set

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
  - ID : 3302
  - checking command : `defaults read com.apple.Safari SuppressSearchSuggestions`
  - setting command : `defaults write com.apple.Safari SuppressSearchSuggestions -bool true`
  - DefaultValue :
  - TypeValue : `bool`
  - RecommendedValue : `true`

### Date and Time

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

### Sharing

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

- Disable DVD or CD Sharing
  - ID : 3504
  - Level : 1
  - Method : launchctl
  - Assessment Status : Automatically
  - Checking command : `launchctl print-disabled system | grep -c '"com.apple.ODSAgent" => true'`
  - Setting command : `sudo launchctl disable system/com.apple.ODSAgent`
  - RecommendedValue : `disable`
  - PossibleValues : `enable/disable`
  - Graphical method :
    1. Open System Preferences
    2. Select Sharing
    3. Verify that DVD or CD sharing is not set

- Disable Media Sharing
  - ID : 3505
  - Level : 1
  - Method : Registry
  - Assessment Status : Automatically
  - Checking command : `sudo -u <username> defaults read com.apple.amp.mediasharingd home-sharing-enabled`
  - Setting command : `sudo -u <username> defaults write com.apple.amp.mediasharingd home-sharing-enabled -int 0`
  - RecommendedValue : `0`
  - TypeValue : `int`
  - Graphical method :
    1. Open System Preferences
    2. Select Sharing
    3. Verify that DVD or CD sharing is not set

### Location

- Enable Location Services
  - ID : 3600
  - Level : 2
  - Method : launchctl
  - Assessment Status : Automatically
  - Checking command : `sudo launchctl list | grep -c com.apple.locationd`
  - Setting command : `sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.locationd.plist`
  - RecommendedValue : `disable`
  - PossibleValues : `enable/disable`
  - Graphical method :
    1. Open System Preferences
    2. Select Security & Privacy
    3. Select Privacy
    4. Verify Location Services is enabled

### Diagnostic

- Disable sending diagnostic and usage data to Apple
  - ID : 3700
  - Level : 2
  - Method : Registry
  - Assessment Status : Automatically
  - Checking command : `defaults read /Library/Application\ Support/CrashReporter/DiagnosticMessagesHistory.plist AutoSubmit`
  - Setting command : `sudo defaults write /Library/Application\ Support/CrashReporter/DiagnosticMessagesHistory.plist AutoSubmit -bool false`
  - RecommendedValue : `false`
  - Type : `bool`
  - Graphical method :
    1. Open System Preferences
    2. Select Security & Privacy
    3. Select Privacy
    4. Select Analytics & Improvements
    5. Verify that "Share Mac Analytics" is not selected
    6. Verify that "Share with App Developers" is not selected

- Disable "Share with App Developers"
  - ID : 3701
  - Method : Registry
  - Assessment Status : Automatically
  - Checking command : `defaults read /Library/Application\ Support/CrashReporter/DiagnosticMessagesHistory.plist ThirdPartyDataSubmit`
  - Setting command : `sudo defaults write /Library/Application\ Support/CrashReporter/DiagnosticMessagesHistory.plist ThirdPartyDataSubmit -bool false`
  - RecommendedValue : `false`
  - Type : `bool`
  - Graphical method :
    1. Open System Preferences
    2. Select Security & Privacy
    3. Select Privacy
    4. Select Analytics & Improvements
    5. Verify that "Share with App Developers" is not selected

### Advertisements

- Limit Ad tracking and personalized Ads
  - ID : 3800
  - Level : 1
  - Method : Registry
  - Assessment Status : Automatically
  - Checking command : `sudo -u <username> defaults -currentHost read /Users/<username>/Library/Preferences/com.apple.AdLib.plist allowApplePersonalizedAdvertising`
  - Setting command : `sudo -u <username> defaults -currentHost write /Users/<username>/Library/Preferences/com.apple.Adlib.plist allowApplePersonalizedAdvertising -bool false`
  - RecommendedValue : `false`
  - Type : `bool`
  - Graphical method :
    1. Open System Preferences
    2. Select Security & Privacy
    3. Select Privacy
    4. Select Advertising
    5. Verify that Limit Ad Tracking is set

### Backups

- Time Machine Auto-Backup
  - ID : 3900
  - Level : 2
  - Method : Registry
  - Assessment Status : Manually
  - Checking command : `sudo defaults read /Library/Preferences/com.apple.TimeMachine.plist AutoBackup`
  - Setting command : `sudo sudo tmutil setdestination -a /Volumes/<volumename>`
  - RecommendedValue : `true`
  - Type : `bool`
  - Graphical method :
    1. Open System Preferences
    2. Select Time Machine
    3. Verify that Back Up Automatically is set
    >To set this policy, we have to configure a volume

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
  - Level : 1
  - Method : `spctl`
  - Checking command : `spctl --status`
  - Setting command : `sudo spctl --master-enable`
  - DefaultValue : --master-enable
  - RecommendedValue : --master-enable
  - Graphical Method :
    1. Open System Preferences
    2. Select Security & Privacy
    3. Select General
    4. Verify that Allow apps downloaded from is set to App Store and identified
    developers

### Secure Keyboard Entry

- Enable Secure Keyboard Entry in terminal.app
  - ID : 4200
  - Level : 1
  - Method : Registry
  - Assessment Status : Automatically
  - Checking command : `sudo -u <username> defaults read -app Terminal SecureKeyboardEntry`
  - Setting command : `sudo -u <username> defaults write -app Terminal SecureKeyboardEntry -bool true`
  - DefaultValue : `false`
  - RecommendedValue : `true`
  - Type : `bool`
  - Graphical method :
    1. Open Terminal
    2. Select Terminal
    3. Select Secure Keyboard Entry

## Encryption

### FileVault

- Enable FileVault
  - ID : 5000
  - Level : 1
  - Method : fdsetup
  - Assessment Status : Automatically
  - Checking command : `fdesetup status`
  - Setting command : `sudo fdesetup enable`
  - DefaultValue : disable
  - RecommendedValue : enable
  - Graphical Method :
    1. Open System Preferences
    2. Select Security & Privacy
    3. Select FileVault
    4. Verify that FileVault is on

## Network

### Firewall

- Enable Firewall
  - ID : 6000
  - Level : 1
  - Method : Registry
  - Assessment Status : Automatically
  - checking command : `defaults read /Library/Preferences/com.apple.alf globalstate`
  - setting command : `defaults write /Library/Preferences/com.apple.alf globalstate -int 1`
  - type = `int`
  - DefaultValue : `0`
  - RecommendedValue : `1`
  - PossibleValues : `0,1,2`
  - Graphical Method :
    1. Open System Preferences
    2. Select Security & Privacy
    3. Select Firewall
    4. Verify that the firewall is turned on
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
  - Level : 1
  - Method : Registry
  - Assessment Status : Automatically
  - Checking command : `defaults read /Library/Preferences/com.apple.alf stealthenabled`
  - Setting command : `defaults write /Library/Preferences/com.apple.alf loggingenabled -bool true`
  - Type = `bool`
  - DefaultValue : `false`
  - RecommendedValue : `true`
  - Graphical Method :
    1. Open System Preferences
    2. Select Security & Privacy
    3. Select Firewall Options
    4. Verify that Enable stealth mode is set
  - Alternative : `sudo /usr/libexec/ApplicationFirewall/socketfilterfw --getstealthmode`

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
  - Level : 1
  - Assessment Status : Automatically
  - Method 1 :
    - Method : Registry
    - Checking command : `/usr/libexec/PlistBuddy -c "Print 'AC Power':'Wake On LAN'" /Library/Preferences/com.apple.PowerManagement.plist`
    - Setting command : `sudo /usr/libexec/PlistBuddy -c "Set 'AC Power':'Wake On LAN' 0" /Library/Preferences/com.apple.PowerManagement.plist`
  - Method 2 :
    - Method : pmset
    - Checking command : `pmset -g | grep womp`
    - Setting command : `sudo pmset -a womp 0`
  - DefaultValue : `1`
  - RecommendedValue : `0`
  - Consquence : Problemes with FindMyMac
  - Graphical method :
    1. Open System Preferences
    2. Select Energy Saver
    3. Verify that Wake for network access is not set

### PowerNap

- Disable Power Nap
  - ID : 6200
  - Level : 1
  - Method : `pmset`
  - Assessment Status : Automatically
  - Checking command : `pmset -g | grep powernap`
  - Setting command : `sudo pmset -a powernap 0`
  - DefaultValue : `0`
  - RecommendedValue : `0`
  - Graphical method :
    1. Open System Preferences
    2. Select Energy Saver
    3. Verify that Power Nap is not set


## Cache

- Disable Content Caching
  - ID : 7000
  - Level : 2
  - Method : Registry
  - Assessment Status : Automatically
  - Checking command : `sudo AssetCacheManagerUtil isActivated`
  - Setting command : `sudo AssetCacheManagerUtil deactivated`
  - PossibleValues : `deactivated/activated`
  - Graphical method :
    1. Open System Preferences
    2. Select Sharing
    3. Uncheck Content Caching  
  - Comment : when this command return 1 it's not an error, it's just because cache saervice is deactivated

## Siri

- Disable Siri
  - ID : 8000
  - Method : Registry
  - Assessment Status : Automatically
  - Checking command : `sudo -u <username> defaults read com.apple.assistant.support.plist 'Assistant Enabled'`
  - Setting command : `sudo -u <username> defaults read com.apple.assistant.support.plist 'Assistant Enabled' -bool false`
  - RecommendedValue : `false`
  - Graphical method :
    1. Open System Preferences
    2. Select Sharing
    3. Uncheck Content Caching  
  - Comment : when this command return 1 it's not an error, it's just because cache saervice is deactivated

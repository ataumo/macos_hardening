# Welcome to the macOS Hardening project

![Work in progress label](https://img.shields.io/badge/-Work%20in%20progress-yellow)

This project was inspired by
- [beerisgood/macOS_Hardening](https://github.com/beerisgood/macOS_Hardening)
- [ayethatsright/MacOS-Hardening-Script](https://github.com/ayethatsright/MacOS-Hardening-Script)
- [herrbischoff/awesome-macos-command-line](https://github.com/herrbischoff/awesome-macos-command-line)
- [MoeClub/Note](https://github.com/MoeClub/Note/blob/81a3651d81c871f2327c3312e090bdca3cabf915/MacInitial.sh)
- [alichtman/stronghold](https://github.com/alichtman/stronghold/blob/master/stronghold.py)
- [wazuh/cis_apple_macOS_10.13.yml](https://github.com/wazuh/wazuh-ruleset/blob/13925fbe0d0e27f012d3d3f3c492e4d420a104b4/sca/darwin/17/cis_apple_macOS_10.13.yml)

Also, structure is based on [0x6d69636b/windows_hardening](https://github.com/0x6d69636b/windows_hardening) project.

(Thanks for your good work !)

## Documentation

### Apple Documentation

For setting preferences throught `plist` files (Registry method with `defaults` command), I use this [Apple documentation](https://developer.apple.com/documentation/devicemanagement/profile-specific_payload_keys).

### CIS Apple macOS Benchmark

This project is mainly based on [CIS Apple macOS 11.0 Benchmark v1.2.0](https://downloads.cisecurity.org/#/)

#### Profile Definitions

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


## Details of policies

For more details about policies : 

# Welcome to the macOS Hardening project

![Work in progress label](https://img.shields.io/badge/-Work%20in%20progress-yellow)
[![CI](https://github.com/ataumo/macos_hardening/actions/workflows/lint.yml/badge.svg)](https://github.com/ataumo/macos_hardening/actions/workflows/lint.yml)

This project was inspired by
- [beerisgood/macOS_Hardening](https://github.com/beerisgood/macOS_Hardening)
- [ayethatsright/MacOS-Hardening-Script](https://github.com/ayethatsright/MacOS-Hardening-Script)
- [herrbischoff/awesome-macos-command-line](https://github.com/herrbischoff/awesome-macos-command-line)
- [MoeClub/Note](https://github.com/MoeClub/Note/blob/81a3651d81c871f2327c3312e090bdca3cabf915/MacInitial.sh)
- [alichtman/stronghold](https://github.com/alichtman/stronghold/blob/master/stronghold.py)
- [wazuh/cis_apple_macOS_10.13.yml](https://github.com/wazuh/wazuh-ruleset/blob/13925fbe0d0e27f012d3d3f3c492e4d420a104b4/sca/darwin/17/cis_apple_macOS_10.13.yml)
- [mathiasbynens/dotfiles](https://github.com/mathiasbynens/dotfiles/blob/master/.macos)
- [pathikrit/mac-setup-script](https://github.com/pathikrit/mac-setup-script/blob/master/defaults.sh)

**(Thanks for your good work !)**

Also, project structure is based on [HardeningKitty](https://github.com/0x6d69636b/windows_hardening) work and, because Windows and macOS are like cats and dogs, this project is called _HardeningPuppy_.

## HardeningPuppy

_HardeningPuppy_ supports hardening of a macOS system. The configuration of the system is retrieved and assessed using a finding list. In addition, the system can be hardened according to predefined values. _HardeningPuppy_ reads settings from the registry (`defaults` command) and uses other modules to read configurations outside the registry.

### How to run

1. Clone or download this repository
2. Go to `macos_hardening`
```bash
cd macos_hardening
```
2. Run this command :
```bash
./puppy.sh
```

```
username@hostname ~/macos_hardening % ./puppy.sh


                             ^. .^                                   
                             (=°=)                                   
                             (n  n )/  HardeningPuppy                


################################################################################
User name               : username
Mode to apply           : AUDIT
Hostname                : hostname
CSV File configuration  : list.csv
################################################################################

################################################################################
Verify all Apple provided software is current...
Your software is up to date !
################################################################################

    ID      Name                                                  Actual Recommended
--------------------------------------------------------------------------------
[*] 07/26/21 16:14:07 Starting Category Updates
------------Software Update
[-] 1001    Automatically check new software updates               1           1
[-] 1002    Automatically download new software updates            1           1
.
.
.

--------------------------------------------------------------------------------
[*] 07/26/21 16:14:07 Starting Category Login/Logout
------------Sleep
[/] 2000    AC display sleep timer                                 0           5
[/] 2001    Battery display sleep timer                            0           2
------------Screen Saver
[X] 2100    Enable prompt for a password on screen saver           0           1
[X] 2101    Set password delay                                     0          
.
.
.

--------------------------------------------------------------------------------
[*] 07/26/21 16:14:08 Starting Category Cache
------------Disable Content Caching
[-] 7000    Disable Content Caching                                deactivate  deactivate

#################################### SCORE #####################################

total points : 216
points archived : 140
Score : 4.24 / 6
```

### Usages

1. Status Mode : To just read a configuration.
```bash
./puppy.sh -s
```

2. Audit Mode : It will read and audit a configuration with colors.
  - Color code :
    - `Purple` : Appears when a policy with `High` severity is not set to the recommended value.
    - `Red`    : Appears when a policy with `Medium` severity is not set to the recommended value.
    - `Yellow` : It's when a policy with `Low` severity is not set to the recommended value. It can be ignored.
```bash
./puppy.sh -a
```
> You can skip Software Update verification with `-skipu`.

3. Hardening Mode : This function will apply all policies with `Automatically` assessment status.
```bash
./puppy.sh -H
```
> Hardening Mode will ask your confirmation.

4. Backup option : You can save your configuration in csv file before the Hardening Mode.
```bash
./puppy.sh -b
```

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

For more details about policies read [POLICIES.md](https://github.com/ataumo/macos_hardening/blob/main/POLICIES.md)

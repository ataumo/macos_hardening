#!/bin/bash
CYAN='\033[0;36m'
RED='\033[0;31m'
REDBOLD='\033[1;31m'
YELLOWBOLD='\033[1;33m'
YELLOW='\033[0;33m'
#PURPLE='\033[0;35m'
PURPLEBOLD='\033[1;35m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color
MAXIMUMPOINTS=0
POINTSARCHIVED=0

################################################################################
#                                                                              #
#                                 FUNCTIONS                                    #
#                                                                              #
################################################################################


#
# Usage function
#
function Usage() {
  echo "Usages: "
  echo "  ./tethys.sh -h"
  echo "  ./tethys.sh [mode]"
  echo "  ./tethys.sh [mode [options]]"
  echo "  ./tethys.sh [mode] [file <file.csv>]"
  echo "  ./tethys.sh [mode [options]] [global options] [file <file.csv>]"
  echo ""
  echo "  -h | --help                   : help method"
  echo "  mode :"
  echo "    -s | --status               : read configuration"
  echo "    -a | --audit                : audit configuration"
  echo "    options :"
  echo "        -skipu | --skip-update     : to skip software update verification in audit mode"
  echo "    -H | --harden            : to harden a configuration"
  echo "  file :"
  echo "    -f | --file                 : csv file containing list of policies"
  echo "  global options :"
  echo "    -v | --verbose              : print executed commands"

}

#
# Convertor functions
#

# Convert numerical boolean to string boolean
function NumToStingBoolean() {
  if [[ "$1" == 1 ]]; then
    echo "true"
  else
    echo "false"
  fi
}

# Convert string boolean to numerical boolean
function StringToNumBoolean() {
  if [[ "$1" == "true" ]]; then
    echo "1"
  else
    echo "0"
  fi
}

#
# Messages functions
#

# Simple message
function SimpleMessage() {
  echo "[ ] $1"
}

# Warning message
function WarningMessage() {
  echo -e "${YELLOW}[!] $1${NC}"
}

# Alert messages
function AlertMessage() {
  echo -e "${RED}[x] $1${NC}"
}
function AlertHightMessage() {
  echo -e "${PURPLEBOLD}[X] $1${NC}"
}
function AlertMediumMessage() {
  echo -e "${REDBOLD}[/] $1${NC}"
}
function AlertLowMessage() {
  echo -e "${YELLOWBOLD}[~] $1${NC}"
}

# Success message
function SuccessMessage() {
  echo -e "${GREEN}[-] $1${NC}"
}

#
# Backup function
#
function Save() {
  echo "$1" >> "$BACKUPFILE"
}

#
# First print
#
function FirstPrint() {
  echo "User name               : $USER"
  echo "Mode to apply           : $MODE"
  echo "Hostname                : $(hostname)"
  echo "CSV File configuration  : $INPUT"
}

#
# Print result (STATUS mode)
# INPUT : ID, Name, ReturnedExit, ReturnedValue
#
function PrintResult() {
  local ID=$1
  local Name=$2
  local ReturnedExit=$3
  local ReturnedValue=$4

  case $ReturnedExit in
    0 | 26 )#No Error or proplem with existance
      # if RecommendedValue is empty (not defined)
      if [[ -z "$RecommendedValue" ]]; then
        WarningMessage "$ID : $Name ; Warning : policy does not exist yet"
      # if RecommendedValue is defined
      else
        #MESSAGE="$ID : $Name ; ActualValue = $ReturnedValue ; RecommendedValue = $RecommendedValue"
        MESSAGE=$(printf "%-6s %-55s %-11s %s \n" "$ID" "$Name" "$ReturnedValue" "$RecommendedValue")
        SimpleMessage "$MESSAGE"
      fi
      ;;

    1 )#Error Exec
    AlertMessage "$ID : $Name ; Error : The execution caused an error"
      ;;
  esac
}

#
# Print result with colors depending on the status (AUDIT mode)
# INPUT : ID, Name, ReturnedExit, ReturnedValue, RecommendedValue, Severity
#
function PrintAudit() {
  local ID=$1
  local Name=$2
  local ReturnedExit=$3
  local ReturnedValue=$4
  local RecommendedValue=$5
  local Severity=$6
  MAXIMUMPOINTS=$((MAXIMUMPOINTS+4))

  case $ReturnedExit in
    0 | 26 )#No Error or proplem with existance
      # if RecommendedValue is empty (not defined)
      if [[ -z "$RecommendedValue" ]]; then
        WarningMessage "$ID : $Name ; Warning : policy does not exist yet"
      # if RecommendedValue is defined
      else
        #MESSAGE="$ID : $Name ; ActualValue = $ReturnedValue ; RecommendedValue = $RecommendedValue"
        MESSAGE=$(printf "%-6s %-55s %-11s %s \n" "$ID" "$Name" "$ReturnedValue" "$RecommendedValue")
        if [[ "$RecommendedValue" == "$ReturnedValue" ]]; then
          POINTSARCHIVED=$((POINTSARCHIVED+4))
          SuccessMessage "$MESSAGE"
        else
          case $Severity in
            "Hight" )
            POINTSARCHIVED=$((POINTSARCHIVED+0))
            AlertHightMessage "$MESSAGE"
              ;;
            "Medium" )
            POINTSARCHIVED=$((POINTSARCHIVED+1))
            AlertMediumMessage "$MESSAGE"
              ;;
            "Low" )
            POINTSARCHIVED=$((POINTSARCHIVED+2))
            AlertLowMessage "$MESSAGE"
              ;;
          esac
        fi
      fi
      ;;

    1 )#Error Exec
    AlertMessage "$ID : $Name ; Error : The execution caused an error"
      ;;
  esac
}

#
# Audit all returned values to know what policies need to be apply in HARDEN (HARDEN mode)
# INPUT : ID, Name, ReturnedExit, ReturnedValue, RecommendedValue, Severity
#
function AuditBeforeReinforce() {
  case $ReturnedExit in
    0|26 )#No Error
    if [[ "$RecommendedValue" == "$ReturnedValue" ]]; then
      APPLYHARDEN=0
    else
      case $Severity in
        "Hight" )
        APPLYHARDEN=1
          ;;
        "Medium" )
        APPLYHARDEN=2
          ;;
        "Low" )
        APPLYHARDEN=3
          ;;
      esac
    fi
      ;;

    1 )#Error Exec
    APPLYHARDEN=0
      ;;

  esac
}

#
# State result of hardening (HARDEN mode)
# INPUT : ID, Name, ReturnedExit
#
function PrintReinforce() {
  local ID=$1
  local Name=$2
  local ReturnedExit=$3

  case $ReturnedExit in
    0 )#No Error
    SuccessMessage "[-] $ID : $Name ; Successfully modified"
      ;;
    1 )#Error Exec
    AlertMessage "[x] $ID, $Name, Error : The execution caused an error."
      ;;
    13 )#Error Gatekeeper needs Recovery OS
    WarningMessage "[!] $ID, $Name, This tool needs to be executed from Recovery OS."
      ;;
  esac
}

function PrintVerbose() {
  echo -e "${CYAN}[v] $ID :"
  echo -e "    Command          : $COMMAND"
  echo -e "    Level            : $Level"
  echo -e "    Operator         : $Operator"
  echo -e "    AssessmentStatus : $AssessmentStatus"
  echo -e "    ReturnedValue    : $ReturnedValue"
  echo -e "    ReturnedExit     : $ReturnedExit${NC}"
}

#
# Test if type is correct
# INPUT : TYPE
#
function GoodType() {
  local TYPE=$1
  if [[ "$TYPE" =~ ^(string|data|int|float|bool|date|array|array-add|dict|dict-add)$ ]]; then
    # Good type
    return 1
  else
    # Type is not correct
    return 0
  fi
}

#
# Transform generic sudo option with correct option
# Example : -u <usename> -> -u steavejobs
#
function SudoUserFilter() {
  case $SudoUser in
    "username" )
      SudoUser="$(logname)"
      ;;
    *)
      SudoUser="root"
      ;;
  esac
}

################################################################################
#                                                                              #
#                                  OPTIONS                                     #
#                                                                              #
################################################################################


POSITIONAL=()
SKIP_UPDATE=false
VERBOSE=false
while [[ $# -gt 0 ]]; do
  key="$1"

  case $key in
    -h|--help)
      Usage
      exit 1
      ;;
    -a|--audit)
      MODE="AUDIT"
      shift # past argument
      ;;
    -s|--status)
      MODE="STATUS"
      shift # past argument
      ;;
    -H|--harden)
      MODE="HARDEN"
      shift # past argument
      ;;
    -b|--backup)
      MODE="BACKUP"
      shift # past argument
      ;;
    -f|--file)
      INPUT="$2"
      shift # past argument
      shift # past value
      ;;
    -skipu|--skip-update)
      SKIP_UPDATE=true
      shift # past argument
      ;;
    -v|--verbose)
      VERBOSE=true
      shift # past argument
      ;;
    *)    # unknown option
      POSITIONAL+=("$1") # save it in an array for later
      shift # past argument
      ;;
  esac
done


## Define default CSV File configuration ##
if [[ -z $INPUT ]]; then #if INPUT is empty
  INPUT='finding_list.csv'
fi

set -- "${POSITIONAL[@]}" # restore positional parameters

## backup init file
if [[ "$MODE" == "BACKUP" ]]; then
  #BACKUPFILE=$(date +"backup-$USER-%y%m%d-%H%M.csv")
  BACKUPFILE="backup.csv"
  # remove file if it already exit
  if [[ -f "$BACKUPFILE" ]]; then
    rm "$BACKUPFILE"
  fi

  Save "ID,Category,Name,AssessmentStatus,Method,MethodOption,GetCommand,SetCommand,User,RegistryPath,RegistryItem,DefaultValue,RecommendedValue,TypeValue,Operator,Severity,Level"
fi

################################################################################
#                                                                              #
#                                 MAIN CODE                                    #
#                                                                              #
################################################################################

#
# First print with some caracteritics environnement
#
echo "################################################################################"
FirstPrint
echo "################################################################################"
echo ""

#
# Confirm part
#
if [[ "$MODE" == "HARDEN" ]]; then
  read -p "Are you sure to run HARDEN mode ? [y/N] " -n 1 -r
  echo    # (optional) move to a new line
  if [[ ! $REPLY =~ ^[Yy]$ ]]
  then
      exit 1
  fi
fi


#
# Verify all Apple provided software is current
#
ID='1000'
if [[ "$SKIP_UPDATE" == false ]]; then
  echo "################################################################################"
  EXPECTED_OUTPUT_SOFTWARE_UPDATE="SoftwareUpdateToolFindingavailablesoftware"
  if [[ $MODE == "AUDIT" ]]; then
    echo "Verify all Apple provided software is current..."

    # command
    COMMAND="softwareupdate -l"

    # print command in verbose mode
    if [[ "$VERBOSE" == true ]]; then
      ReturnedValue=$(eval "$COMMAND")
    else
      ReturnedValue=$(eval "$COMMAND" 2>/dev/null) # throw away stderr
    fi
    ReturnedExit=$?

    # verbose mode
    if [[ "$VERBOSE" == true ]]; then
      PrintVerbose
    fi

    ReturnedValue=${ReturnedValue//[[:space:]]/} # we remove all white space

    if [[ "$ReturnedValue" == "$EXPECTED_OUTPUT_SOFTWARE_UPDATE" ]]; then
      SuccessMessage "Your software is up to date !"
    else
      AlertHightMessage "You have to update your software."
      SimpleMessage "Remediation 1 : with hadening mode (-H|--harden)"
      SimpleMessage "Remediation 2 : with command 'sudo softwareupdate -ia'"
    fi
  fi
  echo "################################################################################"
fi


### Global varibles
PRECEDENT_CATEGORY=''
PRECEDENT_SUBCATEGORY=''

## Save old separator
OLDIFS=$IFS
## Define new separator
IFS=','

## If CSV file does not exist
if [ ! -f $INPUT ]; then
  echo "$INPUT file not found";
  exit 99;
fi
while read -r ID Category Name AssessmentStatus Method MethodOption GetCommand SetCommand SudoUser RegistryPath RegistryItem DefaultValue RecommendedValue TypeValue Operator Severity Level
do
  ## Print first raw with categories
  if [[ $ID == "ID" ]]; then
    ActualValue="Actual"
    RecommendedValue="Recommended"
    FIRSTROW=$(printf "%6s %9s %55s %s \n" "$ID" "$Name" "$ActualValue" "$RecommendedValue")
    echo -ne "$FIRSTROW"
  ## We will not take the first row
  else

    #
    ############################################################################
    #                           STATUS AND AUDIT MODE                          #
    ############################################################################
    #
    if [[ "$MODE" == "STATUS" || "$MODE" == "AUDIT" || "$MODE" == "HARDEN" || "$MODE" == "BACKUP" ]]; then

      #
      # RecommendedValue and DefaultValue boolean filter
      #
      if [[ "$TypeValue" == "bool" ]]; then
        RecommendedValue=$(StringToNumBoolean "$RecommendedValue")
        DefaultValue=$(StringToNumBoolean "$DefaultValue")
      fi

      #
      # Print category
      #
      if [[ "$PRECEDENT_CATEGORY" != "$Category" ]]; then
        echo #new line
        echo "--------------------------------------------------------------------------------"
        DateValue=$(date +"%D %X")
        echo "[*] $DateValue Starting Category $Category"
        PRECEDENT_CATEGORY=$Category
      fi

      #
      # Print subcategory
      #
      SubCategory=${Name%:*} # retain the part before the colon
      Name=${Name##*:} # retain the part after the colon
      if [[ "$PRECEDENT_SUBCATEGORY" != "$SubCategory" ]]; then
        echo "------------$SubCategory"
        PRECEDENT_SUBCATEGORY=$SubCategory
      fi

      ###################################
      #        CASE METHODS             #
      ###################################


      # STATUS/AUDIT
      # Registry
      #
      if [[ "$Method" == "Registry" ]]; then

        # command
        COMMAND="defaults $MethodOption read $RegistryPath $RegistryItem"

        # print command in verbose mode
        if [[ "$VERBOSE" == true ]]; then
          ReturnedValue=$(eval "$COMMAND")
        else
          ReturnedValue=$(eval "$COMMAND" 2>/dev/null) # throw away stderr
        fi
        ReturnedExit=$?

        # if an error occurs, it's caused by non-existance of the couple (file,item)
        # we will not consider this as an error, but as an warning
        if [[ "$ReturnedExit" == 1 ]]; then
          ReturnedExit=26
          ReturnedValue="$DefaultValue"
        fi


      # STATUS/AUDIT
      # PlistBuddy (like Registry with more options)
      #
      elif [[ $Method == "PlistBuddy" ]]; then

        # command
        COMMAND="/usr/libexec/PlistBuddy $MethodOption \"Print $RegistryItem\" $RegistryPath"

        # print command in verbose mode
        if [[ "$VERBOSE" == true ]]; then
          ReturnedValue=$(eval "$COMMAND")
        else
          ReturnedValue=$(eval "$COMMAND" 2>/dev/null) # throw away stderr
        fi
        ReturnedExit=$?

        # if an error occurs, it's caused by non-existance of the couple (file,item)
        # we will not consider this as an error, but as an warning
        if [[ $ReturnedExit == 1 ]]; then
          ReturnedExit=26
          ReturnedValue="$DefaultValue"
        fi

        #
        # ReturnedExit filter
        #
        ReturnedValue=$(StringToNumBoolean "$ReturnedValue")


      # STATUS/AUDIT
      # launchctl
      # intro : Interfaces with launchd to load, unload daemons/agents and generally control launchd.
      # requirements : $RegistryItem
      #
      elif [[ "$Method" == "launchctl" ]]; then

        # command
        COMMAND="launchctl print system/$RegistryItem"

        # print command in verbose mode
        if [[ "$VERBOSE" == true ]]; then
          ReturnedValue=$(eval "$COMMAND")
        else
          ReturnedValue=$(eval "$COMMAND" 2>/dev/null) # throw away stderr
        fi
        ReturnedExit=$?

        # if an error occurs (113 code), it's caused by non-existance of the RegistryItem in system
        # so, it's not enabled
        if [[ $ReturnedExit == 1 ]]; then
          ReturnedExit=26
          ReturnedValue="$DefaultValue"
        elif [[ $ReturnedExit == 113 ]]; then
          ReturnedExit=0
          ReturnedValue="disable"
        else
          ReturnedValue="enable"
        fi


      # STATUS/AUDIT
      # csrutil (Intergrity Protection)
      #
      elif [[ $Method == "csrutil" ]]; then

        # command
        COMMAND="csrutil $GetCommand"

        # print command in verbose mode
        if [[ "$VERBOSE" == true ]]; then
          ReturnedValue=$(eval "$COMMAND")
        else
          ReturnedValue=$(eval "$COMMAND" 2>/dev/null)
        fi
        ReturnedExit=$?

        # clean retuned value
        if [[ $ReturnedValue == "System Integrity Protection status: enabled." ]]; then
          ReturnedValue="enable"
        else
          ReturnedValue="disable"
        fi


      # STATUS/AUDIT
      # spctl (Gatekeeper)
      #
      elif [[ $Method == "spctl" ]]; then

        # command
        COMMAND="spctl $GetCommand"

        # print command in verbose mode
        if [[ "$VERBOSE" == true ]]; then
          ReturnedValue=$(eval "$COMMAND")
        else
          ReturnedValue=$(eval "$COMMAND" 2>/dev/null)
        fi
        ReturnedExit=$?

        # clean retuned value
        if [[ $ReturnedValue == "assessments enabled" ]]; then
          ReturnedValue="enable"
        else
          ReturnedValue="disable"
        fi


      # STATUS/AUDIT
      # systemsetup
      #
      elif [[ $Method == "systemsetup" ]]; then

        # command
        COMMAND="sudo systemsetup $GetCommand"

        # keep alert error in verbose mode
        if [[ "$VERBOSE" == true ]]; then
          ReturnedValue=$(eval "$COMMAND")
        else
          ReturnedValue=$(eval "$COMMAND" 2>/dev/null)
        fi
        ReturnedExit=$?

        # clean retuned value
        ReturnedValue="${ReturnedValue##*:}" # get content after ":"
        ReturnedValue=$(echo "$ReturnedValue" | tr '[:upper:]' '[:lower:]') # convert to lowercase
        ReturnedValue="${ReturnedValue:1}" # remove first char (space)


      # STATUS/AUDIT
      # pmset
      #
      elif [[ $Method == "pmset" ]]; then

          # command
          COMMAND="pmset -g | grep $RegistryItem"

          # keep alert error in verbose mode
          if [[ "$VERBOSE" == true ]]; then
            ReturnedValue=$(eval "$COMMAND")
          else
            ReturnedValue=$(eval "$COMMAND" 2>/dev/null)
          fi
          ReturnedExit=$?

          # clean returned value
          ReturnedValue="${ReturnedValue//[[:space:]]/}" # we remove all white space
          ReturnedValue="${ReturnedValue#"$RegistryItem"}" # get content after RegistryItem


      # STATUS/AUDIT
      # fdesetup (FileVault)
      #
      elif [[ "$Method" == "fdesetup" ]]; then

        # command
        COMMAND="fdesetup $GetCommand"

        # keep alert error in verbose mode
        if [[ "$VERBOSE" == true ]]; then
          ReturnedValue=$(eval "$COMMAND")
        else
          ReturnedValue=$(eval "$COMMAND" 2>/dev/null)
        fi
        ReturnedExit=$?

        # clean retuned value
        if [[ "$ReturnedValue" == "FileVault is Off." ]]; then
          ReturnedValue="disable"
        else
          ReturnedValue="enable"
        fi

      # STATUS/AUDIT
      # nvram
      #
      elif [[ "$Method" == "nvram" ]]; then

        # command
        # we add '|| true' because grep return 1 when it does not find RegistryItem
        COMMAND="nvram -p | grep -c '$RegistryItem' || true"

        # keep alert error in verbose mode
        if [[ "$VERBOSE" == true ]]; then
          ReturnedValue=$(eval "$COMMAND")
        else
          ReturnedValue=$(eval "$COMMAND" 2>/dev/null)
        fi
        ReturnedExit=$?

      # STATUS/AUDIT
      # AssetCacheManagerUtil
      #
      elif [[ "$Method" == "AssetCacheManagerUtil" ]]; then

        # command
        COMMAND="sudo AssetCacheManagerUtil $GetCommand"

        # keep alert error in verbose mode
        if [[ "$VERBOSE" == true ]]; then
          ReturnedValue=$(eval "$COMMAND")
        else
          ReturnedValue=$(eval "$COMMAND" 2>/dev/null)
        fi
        ReturnedExit=$?

        # when this command return 1 it's not an error, it's just beacause cache saervice is deactivated
        if [[ "$ReturnedExit" == '1' ]]; then
          ReturnedExit=0
          ReturnedValue='deactivate'
        else
          ReturnedValue='activate'
        fi


      fi
    fi



    #
    ############################################################################
    #                             HARDEN METHOD                             #
    ############################################################################
    #

    if [[ "$MODE" == "HARDEN" ]]; then

      #
      # Get audit before hardening
      # APPLYHARDEN=0 : policy is already configured to recommended value
      # APPLYHARDEN=1 : Hight policy have to be configured
      # APPLYHARDEN=2 : Medium policy have to be configured
      # APPLYHARDEN=3 : Low policy have to be configured
      #
      APPLYHARDEN=0
      AuditBeforeReinforce "$ID" "$Name" "$ReturnedExit" "$ReturnedValue" "$RecommendedValue" "$Severity"
      # echo "$ID, APPLYHARDEN ===> $APPLYHARDEN"

      if [[ "$APPLYHARDEN" != 0 && "$AssessmentStatus" != "Manually" ]]; then

        #
        # Sudo option filter
        #
        SudoUserFilter

        #
        # Print category
        #
        if [[ "$PRECEDENT_CATEGORY" != "$Category" ]]; then
          echo #new line
          DateValue=$(date +"%D %X")
          echo "[*] $DateValue Starting Category $Category"
          PRECEDENT_CATEGORY=$Category
        fi

        ###################################
        #        CASE METHODS             #
        ###################################

        #
        # Registry
        # requirements  : $MethodOption, $RegistryPath, $RegistryItem, $TypeValue, $RecommendedValue
        # optional      : $SudoUser
        #
        if [[ "$Method" == "Registry" ]]; then

          # Type filter
          if GoodType "$TypeValue"; then
            AlertMessage "this type is not correct"
            exit 1
          fi

          # Add '' around RecommendedValue when type is string
          if [[ "$TypeValue" == 'string' ]]; then
            RecommendedValue="'$RecommendedValue'"
          fi

          # Convert numerical boolean to string boolean
          if [[ "$TypeValue" == 'bool' ]]; then
            RecommendedValue=$(NumToStingBoolean "$RecommendedValue")
          fi

          # command
          COMMAND="sudo -u $SudoUser defaults $MethodOption write $RegistryPath $RegistryItem -$TypeValue $RecommendedValue"

          # keep alert error in verbose mode
          if [[ "$VERBOSE" == true ]]; then
            ReturnedValue=$(eval "$COMMAND")
          else
            ReturnedValue=$(eval "$COMMAND" 2>/dev/null) # throw away stderr
          fi
          ReturnedExit=$?

        #
        # PlistBuddy (like Registry with more options)
        # requirements : $MethodOption, $RegistryItem, $RecommendedValue, $RegistryPath
        #
        elif [[ $Method == "PlistBuddy" ]]; then

          # command
          COMMAND="sudo /usr/libexec/PlistBuddy $MethodOption \"Set $RegistryItem $RecommendedValue\" $RegistryPath"

          # print command in verbose mode
          if [[ "$VERBOSE" == true ]]; then
            ReturnedValue=$(eval "$COMMAND")
          else
            ReturnedValue=$(eval "$COMMAND" 2>/dev/null) # throw away stderr
          fi
          ReturnedExit=$?


        #
        # launchctl
        # intro : Interfaces with launchd to load, unload daemons/agents and generally control launchd.
        # requirements : $RegistryItem
        #
        elif [[ $Method == "launchctl" ]]; then

          # command
          COMMAND="sudo launchctl $RecommendedValue system/$RegistryItem"

          # print command in verbose mode
          if [[ "$VERBOSE" == true ]]; then
            ReturnedValue=$(eval "$COMMAND")
          else
            ReturnedValue=$(eval "$COMMAND" 2>/dev/null) # throw away stderr
          fi
          ReturnedExit=$?


        #
        # csrutil (Integrity Protection)
        #
        elif [[ $Method == "csrutil" ]]; then
          # "This tool needs to be executed from Recovery OS."
          ReturnedExit=13


        #
        # spctl (Gatekeeper)
        # requirements  : $RecommendedValue
        #
        elif [[ $Method == "spctl" ]]; then

          # command
          COMMAND="sudo spctl --$RecommendedValue"

          # keep alert error in verbose mode
          if [[ "$VERBOSE" == true ]]; then
            ReturnedValue=$(eval "$COMMAND")
          else
            ReturnedValue=$(eval "$COMMAND" 2>/dev/null)
          fi
          ReturnedExit=$?


        #
        # systemsetup
        #
        elif [[ $Method == "systemsetup" ]]; then

          # command
          COMMAND="sudo systemsetup $SetCommand"

          # keep alert error in verbose mode
          if [[ "$VERBOSE" == true ]]; then
            ReturnedValue=$(eval "$COMMAND")
          else
            ReturnedValue=$(eval "$COMMAND" 2>/dev/null)
          fi
          ReturnedExit=$?


        #
        # fdesetup (FileVault)
        #
        elif [[ $Method == "fdesetup" ]]; then

          # command
          COMMAND="sudo fdesetup $RecommendedValue"

          # in HARDEN mode and with this fdesetup moethod, we have to keep stdout
          ReturnedValue=$(eval "$COMMAND")
          ReturnedExit=$?


        #
        # AssetCacheManagerUtil
        #
        elif [[ $Method == "AssetCacheManagerUtil" ]]; then

          # command
          COMMAND="sudo AssetCacheManagerUtil $RecommendedValue"

          # keep alert error in verbose mode
          if [[ "$VERBOSE" == true ]]; then
            ReturnedValue=$(eval "$COMMAND")
          else
            ReturnedValue=$(eval "$COMMAND" 2>/dev/null)
          fi
          ReturnedExit=$?


        fi

      fi
      # end of APPLYHARDEN condition
    fi
    # end of HARDEN METHOD

    ## Result printing
    case "$MODE" in
      "STATUS" )
        PrintResult "$ID" "$Name" "$ReturnedExit" "$ReturnedValue"
        ;;
      "AUDIT" )
        PrintAudit "$ID" "$Name" "$ReturnedExit" "$ReturnedValue" "$RecommendedValue" "$Severity"
        ;;
      "HARDEN" )
        PrintReinforce "$ID" "$Name" "$ReturnedExit"
        ;;
      "BACKUP" )
        #echo "$ID, $ReturnedValue"
        Save "$ID,$Category,$Name,$AssessmentStatus,$Method,$MethodOption,$GetCommand,$SetCommand,$SudoUser,$RegistryPath,$RegistryItem,$DefaultValue,$ReturnedValue,$TypeValue,$Operator,$Severity,$Level"
        ;;
    esac

    # print verbose mode
    if [[ "$VERBOSE" == true ]]; then
      PrintVerbose
    fi


  fi

  # Out of main condition to take first line of csv file
  # reset some values
  ReturnedExit=""
  ReturnedValue=""
done < $INPUT

## Redefine separator with its precedent value
IFS=$OLDIFS

################################################################################
#                                END OF PROCESS                                #
################################################################################

if [[ $MODE == "AUDIT" ]]; then
  echo ""
  echo "#################################### SCORE #####################################"
  echo ""
  echo "total points : $MAXIMUMPOINTS"
  echo "points archived : $POINTSARCHIVED"
  VALUE=$(bc -l <<< "($POINTSARCHIVED/$MAXIMUMPOINTS)*5+1")
  echo "Score : ${VALUE:0:4} / 6"
fi

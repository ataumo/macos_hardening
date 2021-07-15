#!/bin/bash
CYAN='\033[0;36m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
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
  echo "    -r | --reinforce            : reinforce a configuration"
  echo "  file :"
  echo "    -f | --file                 : csv file containing list of policies"
  echo "  global options :"
  echo "    -v | --verbose              : print executed commands"

}

#
# Messages functions
#

# Simple message
function SimpleMessage() {
  local STRING=$1
  echo "$STRING"
}

# Warning message
function WarningMessage() {
  local STRING=$1
  echo -e "${YELLOW}$STRING${NC}"
}

# Alert message
function AlertMessage() {
  local STRING=$1
  echo -e "${RED}$STRING${NC}"
}

# Success message
function SuccessMessage() {
  local STRING=$1
  echo -e "${GREEN}$STRING${NC}"
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
    0 )#No Error
    SimpleMessage "[-] $ID : $Name ; ActualValue = $ReturnedValue"
      ;;
    1 )#Error Exec
    AlertMessage "[x] $ID : $Name ; Error : The execution caused an error"
      ;;
    26 )#Error exist policy
    # if this policy does not exist, its value is DefaultValue
    SimpleMessage "[-] $ID : $Name ; ActualValue = $DefaultValue"
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
    0 )#No Error
    if [[ "$RecommendedValue" == "$ReturnedValue" ]]; then
      POINTSARCHIVED=$((POINTSARCHIVED+4))
      SuccessMessage "[-] $ID : $Name ; AssessmentStatus= $AssessmentStatus ; ActualValue = $ReturnedValue ; RecommendedValue = $RecommendedValue"
    else
      case $Severity in
        "Hight" )
        POINTSARCHIVED=$((POINTSARCHIVED+0))
          ;;
        "Medium" )
        POINTSARCHIVED=$((POINTSARCHIVED+1))
          ;;
        "Low" )
        POINTSARCHIVED=$((POINTSARCHIVED+2))
          ;;
      esac
      AlertMessage "[x] $ID : $Name ; AssessmentStatus = $AssessmentStatus ; Level = $Level ; ActualValue = $ReturnedValue ; RecommendedValue = $RecommendedValue"
    fi

      ;;
    1 )#Error Exec
    AlertMessage "[x] $ID : $Name ; AssessmentStatus = $AssessmentStatus ; Level = $Level ; Error : The execution caused an error"
      ;;
    26 )#Error exist policy
    WarningMessage "[!] $ID : $Name ; AssessmentStatus = $AssessmentStatus ; Level = $Level ; Warning : policy does not exist yet"
      ;;
  esac
}

#
# State result of reinforcement (REINFORCE mode)
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
  echo -e "    Command       : $COMMAND"
  echo -e "    Level         : $Level"
  echo -e "    Operator      : $Operator"
  echo -e "    ReturnedValue : $ReturnedValue"
  echo -e "    ReturnedExit  : $ReturnedExit${NC}"
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
    -r|--reinforce)
      MODE="REINFORCE"
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
  INPUT='list.csv'
fi

set -- "${POSITIONAL[@]}" # restore positional parameters


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
      AlertMessage "You have to update your software."
      SimpleMessage "Remediation 1 : with reinforce mode (-r)"
      SimpleMessage "Remediation 2 : with command 'sudo softwareupdate -ia'"
    fi
  fi
  echo "################################################################################"
fi


### Global varibles
PRECEDENT_CATEGORY=''

## Save old separator
OLDIFS=$IFS
## Define new separator
IFS=','

## If CSV file does not exist
if [ ! -f $INPUT ]; then
  echo "$INPUT file not found";
  exit 99;
fi
while read -r ID Category Name AssessmentStatus Method MethodOption GetCommand	SetCommand SudoUser RegistryPath RegistryItem DefaultValue RecommendedValue TypeValue Operator Severity Level
do
  ## We will not take the first row
  if [[ $ID != "ID" ]]; then

    #
    ############################################################################
    #                           STATUS AND AUDIT MODE                          #
    ############################################################################
    #
    if [[ "$MODE" == "STATUS" || "$MODE" == "AUDIT" ]]; then

      #
      # RecommendedValue filter
      #
      if [[ $RecommendedValue == "true" ]]; then
        RecommendedValue=1
      elif [[ $RecommendedValue == "false" ]]; then
        RecommendedValue=0
      fi

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
        fi


      #
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
        fi


      #
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
        elif [[ $ReturnedExit == 113 ]]; then
          ReturnedExit=0
          ReturnedValue="disable"
        else
          ReturnedValue="enable"
        fi


      #
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


      #
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


      #
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


      #
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


      #
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
    #                             REINFORCE METHOD                             #
    ############################################################################
    #
    if [[ "$MODE" == "REINFORCE" ]]; then

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

        # keep alert error in verbose mode
        if [[ "$VERBOSE" == true ]]; then
          ReturnedValue=$(eval "$COMMAND")
        else
          ReturnedValue=$(eval "$COMMAND" 2>/dev/null)
        fi
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

    ## Result printing
    if [[ $MODE == "STATUS" ]]; then
      PrintResult "$ID" "$Name" "$ReturnedExit" "$ReturnedValue"
    elif [[ $MODE == "AUDIT" ]]; then
      PrintAudit "$ID" "$Name" "$ReturnedExit" "$ReturnedValue" "$RecommendedValue" "$Severity"
    elif [[ $MODE == "REINFORCE" ]]; then
      PrintReinforce "$ID" "$Name" "$ReturnedExit"
    fi

    # print verbose mode
    if [[ "$VERBOSE" == true ]]; then
      PrintVerbose
    fi


  fi
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

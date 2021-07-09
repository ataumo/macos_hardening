#!/bin/bash

RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
LIGHTGRAY='\033[0;37m'
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
  echo "  ./tethys.sh [mode <options>]"
  echo "  ./tethys.sh [mode] [file <file.csv>]"
  echo "  ./tethys.sh [mode <options>] [global options] [file <file.csv>]"
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
    echo -e "${LIGHTGRAY}[!] $ID, $Name${NC}"
    WarningMessage "-> Warning : $ID policy does not exist yet"
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
      SuccessMessage "[-] $ID : $Name ; ActualValue = $ReturnedValue ; RecommendedValue = $RecommendedValue"
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
      AlertMessage "[-] $ID : $Name ; ActualValue = $ReturnedValue ; RecommendedValue = $RecommendedValue"
    fi

      ;;
    1 )#Error Exec
    AlertMessage "[x] $ID : $Name ; Error : The execution caused an error"
      ;;
    26 )#Error exist policy
    echo -e "${LIGHTGRAY}[!] $ID, $Name${NC}"
    WarningMessage "-> Warning : $ID policy does not exist yet"
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
      INPUT="$2"
      SKIP_UPDATE=true
      shift # past argument
      ;;
    -v|--verbose)
      VERBOSE=true
      shift # past argument
      ;;
    --default)
      DEFAULT=YES
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
if [[ "$SKIP_UPDATE" == false ]]; then
  echo "################################################################################"
  EXPECTED_OUTPUT_SOFTWARE_UPDATE="SoftwareUpdateToolFindingavailablesoftware"
  if [[ $MODE == "AUDIT" ]]; then
    echo "Verify all Apple provided software is current..."
    ReturnedValue=$(softwareupdate -l)
    ReturnedValue=${ReturnedValue//[[:space:]]/} # we remove all white space
    if [[ $ReturnedValue == $EXPECTED_OUTPUT_SOFTWARE_UPDATE ]]; then
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
while read ID Category Name AssessmentStatus Method MethodOption GetCommand	SetCommand SudoUser RegistryPath RegistryItem DefaultValue RecommendedValue TypeValue Operator Severity Level
do
  ## We will not take the first row
  if [[ $ID != "ID" ]]; then

    PARAMETER=$1

    #
    ############################################################################
    #                           STATUS AND AUDIT MODE                          #
    ############################################################################
    #
    if [[ $MODE == "STATUS" || $MODE == "AUDIT" ]]; then

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
      if [[ $PRECEDENT_CATEGORY != $Category ]]; then
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
      if [[ $Method == "Registry" ]]; then

        # throw away stderr
        ReturnedValue=$(defaults $MethodOption read $RegistryPath $RegistryItem 2>/dev/null)
        ReturnedExit=$?
        # if an error occurs, it's caused by non-existance of the couple (file,item)
        # we will not consider this as an error, but as an warning
        if [[ $ReturnedExit == 1 ]]; then
          ReturnedExit=26
        fi
      #
      # csrutil (Intergrity Protection)
      #
      elif [[ $Method == "csrutil" ]]; then
        ReturnedValue=$(csrutil status 2>/dev/null)
        if [[ $ReturnedValue == "System Integrity Protection status: enabled." ]]; then
          ReturnedValue="enable"
        else
          ReturnedValue="disable"
        fi
      #
      # spctl (Gatekeeper)
      #
      elif [[ $Method == "spctl" ]]; then
        ReturnedValue=$(spctl --status 2>/dev/null)
        if [[ $ReturnedValue == "assessments enabled" ]]; then
          ReturnedValue="enable"
        else
          ReturnedValue="disable"
        fi
      #
      # systemsetup
      #
      elif [[ $Method == "systemsetup" ]]; then

        if [[ "$VERBOSE" == true ]]; then
          echo "systemsetup -$GetCommand"
        fi
        ReturnedValue=$(systemsetup -$GetCommand 2>/dev/null)
        ReturnedValue=${ReturnedValue##*( )} # get last string
        echo $ReturnedValue
      #
      # fdesetup (FileVault)
      #
      elif [[ $Method == "fdesetup" ]]; then
        ReturnedValue=$(fdesetup status 2>/dev/null)
        if [[ $ReturnedValue == "FileVault is Off." ]]; then
          ReturnedValue="disable"
        else
          ReturnedValue="enable"
        fi
      fi
    fi



    #
    ############################################################################
    #                             REINFORCE METHOD                             #
    ############################################################################
    #
    if [[ $MODE == "REINFORCE" ]]; then

      #
      # Sudo option filter
      #
      SudoUserFilter

      #
      # Print category
      #
      if [[ $PRECEDENT_CATEGORY != $Category ]]; then
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
      if [[ $Method == "Registry" ]]; then

        # Type filter
        if GoodType $TypeValue; then
          AlertMessage "this type is not correct"
          exit 1
        fi

        # command
        if [[ "$VERBOSE" == true ]]; then
          echo "sudo -u $SudoUser defaults $MethodOption write $RegistryPath $RegistryItem -$TypeValue $RecommendedValue"
        fi
        ReturnedValue=$(sudo -u $SudoUser defaults $MethodOption write $RegistryPath $RegistryItem -$TypeValue $RecommendedValue)
        ReturnedExit=$?

      #
      # csrutil (Integrity Protection)
      #
      elif [[ $Method == "csrutil" ]]; then
        # "This tool needs to be executed from Recovery OS."
        ReturnedExit=13


      #
      # spctl (Gatekeeper)
      #
      elif [[ $Method == "spctl" ]]; then
        ReturnedValue=$(sudo spctl --$RecommendedValue 2>/dev/null)
        ReturnedExit=$?


      #
      # fdesetup (FileVault)
      #
      elif [[ $Method == "fdesetup" ]]; then
        ReturnedValue=$(sudo fdesetup $RecommendedValue 2>/dev/null)
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


  fi
done < $INPUT

## Redefine separator with its precedent value
IFS=$OLDIFS

################################################################################
#                                END OF PROCESS                                #
################################################################################

if [[ $MODE == "AUDIT" ]]; then
  echo ""
  echo "#############################"
  echo "########### SCORE ###########"
  echo "#############################"
  echo ""
  echo "total points : $MAXIMUMPOINTS"
  echo "points archived : $POINTSARCHIVED"
  VALUE=$(bc -l <<< "($POINTSARCHIVED/$MAXIMUMPOINTS)*5+1")
  echo "Score : $VALUE"
fi

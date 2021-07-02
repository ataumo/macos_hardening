#!/bin/bash

RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
LIGHTGRAY='\033[0;37m'
NC='\033[0m' # No Color

################################################################################
#                                                                              #
#                                 FUNCTIONS                                    #
#                                                                              #
################################################################################

function Usage() {
  echo "Usage: ./tethys.sh [options]"
  echo "  -s (--status)   : read method to read configuration"
  echo "  -a (-audit)     : audit method to audit configuration"
  echo "  -r (-reinforce) : apply a configuration)"
  echo "  -h : help method"
}

function WarningMessage() {
  STRING=$1
  echo -e "${YELLOW} $STRING ${NC}"
}

function AlertMessage() {
  STRING=$1
  echo -e "${RED} $STRING ${NC}"
}

function FirstPrint() {
  echo "User name : $USER"
  echo "Mode to apply : $MODE"
  echo "CSV File configuration : $INPUT"
}

function PrintResult() {
  ID=$1
  Name=$2
  ReturnedExit=$3
  ReturnedValue=$4

  case $ReturnedExit in
    0 )#No Error
    echo "[-] $ID : $Name ; ActualValue = $ReturnedValue"
      ;;
    1 )#Error Exec
    echo -e "${RED}[x] $ID : $Name ; Error : The execution caused an error${NC}"
      ;;
    26 )#Error exist policy
    echo -e "${LIGHTGRAY}[!] $ID, $Name${NC}"
    echo -e "${YELLOW}-> Warning : $ID policy does not exist yet${NC}"
      ;;
  esac
}

function PrintAudit() {
  ID=$1
  Name=$2
  ReturnedExit=$3
  ReturnedValue=$4
  RecommendedValue=$5

  case $ReturnedExit in
    0 )#No Error
    if [[ "$RecommendedValue" == "$ReturnedValue" ]]; then
      COLOR=$GREEN
    else
      COLOR=$RED
    fi
    echo -e "${COLOR}[-] $ID : $Name ; ActualValue = $ReturnedValue ; RecommendedValue = $RecommendedValue${NC}"

      ;;
    1 )#Error Exec
    echo -e "${RED}[x] $ID : $Name ; Error : The execution caused an error${NC}"
      ;;
    26 )#Error exist policy
    echo -e "${LIGHTGRAY}[!] $ID, $Name${NC}"
    echo -e "${YELLOW}-> Warning : $ID policy does not exist yet${NC}"
      ;;
  esac
}

function PrintReinforce() {
  ID=$1
  Name=$2
  ReturnedExit=$3

  case $ReturnedExit in
    0 )#No Error
    if [[ "$RecommendedValue" == "$ReturnedValue" ]]; then
      COLOR=$GREEN
    else
      COLOR=$RED
    fi
    echo -e "${COLOR}[-] $ID : $Name ; ActualValue = $ReturnedValue ; RecommendedValue = $RecommendedValue${NC}"
      ;;
    1 )#Error Exec
    AlertMessage "[x] $ID, $Name, Error : The execution caused an error."
      ;;
    13 )#Error Gatekeeper needs Recovery OS
    WarningMessage "[!] $ID, $Name, This tool needs to be executed from Recovery OS."
      ;;
  esac
}

################################################################################
#                                                                              #
#                                  OPTIONS                                     #
#                                                                              #
################################################################################

POSITIONAL=()
while [[ $# -gt 0 ]]; do
  key="$1"

  case $key in
    -h|--help)
      Usage
      exit 1
      ;;
    -a|--audit)
      INPUT="$2"
      MODE="AUDIT"
      shift # past argument
      shift # past value
      ;;
    -s|--status)
      INPUT="$2"
      MODE="STATUS"
      shift # past argument
      shift # past value
      ;;
    -r|--reinforce)
      INPUT="$2"
      MODE="REINFORCE"
      shift # past argument
      shift # past value
      ;;
    -b|--backup)
      INPUT="$2"
      MODE="BACKUP"
      shift # past argument
      shift # past value
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

FirstPrint

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
while read ID Category Name Method MethodArgument RegistryPath RegistryItem ClassName Namespace Property DefaultValue RecommendedValue Operator Severity
do
  ## We will not take the first row
  if [[ $ID != "ID" ]]; then

    PARAMETER=$1

    #
    #
    # STATUS AND AUDIT MODE
    #
    #
    if [[ $MODE == "STATUS" || $MODE == "AUDIT" ]]; then
      #
      # Print category
      #
      if [[ $PRECEDENT_CATEGORY != $Category ]]; then
        echo #new line
        DateValue=$(date +"%D %X")
        echo "[*] $DateValue Starting Category $Category"
        PRECEDENT_CATEGORY=$Category
      fi

      #
      # Registry
      #
      if [[ $Method == "Registry" ]]; then
        ## Test if file exist
        if [[ ! -f "$RegistryPath.plist" ]]; then
          ReturnedExit=26
        else
          # throw away stderr
          ReturnedValue=$(defaults read $RegistryPath $RegistryItem 2>/dev/null)
          ReturnedExit=$?
          # if an error occurs, it's caused by non-existance of the couple (file,item)
          # we will not consider this as an error, but as an warning
          if [[ $ReturnedExit == 1 ]]; then
            ReturnedExit=26
          fi
          if [[ $ReturnedValue == "true" ]]; then
            ReturnedValue=1
          fi
          if [[ $ReturnedValue == "false" ]]; then
            ReturnedValue=0
          fi
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
    #
    # REINFORCE MODE
    #
    #
    if [[ $MODE == "REINFORCE" ]]; then
      #
      # Sudo checking
      #
      if [[ $UID -ne 0 ]]; then
      	AlertMessage "You have to run this script as root (with sudo)"
      	exit 1
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

      #
      # Registry
      #
      if [[ $Method == "Registry" ]]; then
        ## Test if file exist
        if [[ ! -f "$RegistryPath.plist" ]]; then
          ReturnedExit=26
        else
          # throw away stderr
          ReturnedValue=$(defaults write $RegistryPath $RegistryItem 2>/dev/null)
          ReturnedExit=$?
          # if an error occurs, it's caused by non-existance of the couple (file,item)
          # we will not consider this as an error, but as an warning
          if [[ $ReturnedExit == 1 ]]; then
            ReturnedExit=26
          fi
          if [[ $ReturnedValue == "true" ]]; then
            ReturnedValue=1
          fi
          if [[ $ReturnedValue == "false" ]]; then
            ReturnedValue=0
          fi
        fi
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
        ReturnedValue=$(spctl --$RecommendedValue 2>/dev/null)
        ReturnedExit=$?
      #
      # fdesetup (FileVault)
      #
      elif [[ $Method == "fdesetup" ]]; then
        ReturnedValue=$(fdesetup $RecommendedValue 2>/dev/null)
        ReturnedExit=$?
      fi
    fi

    ## Result printing
    if [[ $MODE == "STATUS" ]]; then
      PrintResult "$ID" "$Name" "$ReturnedExit" "$ReturnedValue"
    elif [[ $MODE == "AUDIT" ]]; then
      PrintAudit "$ID" "$Name" "$ReturnedExit" "$ReturnedValue" "$RecommendedValue"
    elif [[ $MODE == "REINFORCE" ]]; then
      PrintReinforce "$ID" "$Name" "$ReturnedExit"
    fi


  fi
done < $INPUT

## Redefine separator with its precedent value
IFS=$OLDIFS

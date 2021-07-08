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
  echo "Usage: ./tethys.sh [options]"
  echo ""
  echo "  -s                          : read configuration from default csv file list.csv"
  echo "  -s <file_finding_list.csv>  : read configuration from file_finding_list.csv"
  echo ""
  echo "  -a                          : audit configuration from default csv file list.csv"
  echo "  -a <file_finding_list.csv>  : audit configuration from file_finding_list.csv"
  echo ""
  echo "  -r                          : reinforce a configuration from default csv file list.csv"
  echo "  -r <file_finding_list.csv>  : reinforce configuration from file_finding_list.csv"
  echo ""
  echo "  -h (--help)      : help method"
}

#
# Messages functions
#

# Simple message
function SimpleMessage() {
  STRING=$1
  echo "$STRING"
}

# Warning message
function WarningMessage() {
  STRING=$1
  echo -e "${YELLOW}$STRING${NC}"
}

# Alert message
function AlertMessage() {
  STRING=$1
  echo -e "${RED}$STRING${NC}"
}

# Success message
function SuccessMessage() {
  STRING=$1
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
  ID=$1
  Name=$2
  ReturnedExit=$3
  ReturnedValue=$4

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
  ID=$1
  Name=$2
  ReturnedExit=$3
  ReturnedValue=$4
  RecommendedValue=$5
  Severity=$6
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
  ID=$1
  Name=$2
  ReturnedExit=$3

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
  TYPE=$1
  if [[ "$TYPE" =~ ^(string|data|int|float|bool|date|array|array-add|dict|dict-add)$ ]]; then
    # Good type
    return 1
  else
    # Type is not correct
    return 0
  fi
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
while read ID Category Name Method MethodArgument RegistryPath RegistryItem ClassName Namespace Property DefaultValue RecommendedValue TypeValue Operator Severity
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
        ReturnedValue=$(defaults read $RegistryPath $RegistryItem 2>/dev/null)
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
        ReturnedValue=$(defaults write $RegistryPath $RegistryItem -$TypeValue $RecommendedValue 2>/dev/null)
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

#!/bin/bash

RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

####################### functions
function Usage() {
  echo "Script usage :"
  echo "  -r : read method to read configuration"
  echo "  -a : audit method to audit configuration"
  echo "  -h : help method"
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
    echo -e "${YELLOW}[x] $ID : $Name ; Error : The execution caused an error${NC}"
      ;;
    26 )#Error exist policy
    echo -e "${YELLOW}[!] $ID : $Name ; Warning : This policy does not exist yet${NC}"
      ;;
  esac
}

#####################

## Getting option ##
case $1 in
  '-h' )
  Usage
  exit 1
    ;;
esac


### Global varibles
PRECEDENT_CATEGORY=''

## Getting CSV File configuration ##
INPUT=list.csv

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

    ## Print category
    if [[ $PRECEDENT_CATEGORY != $Category ]]; then
      echo #new line
      echo "-----------------------------"
      DateValue=$(date +"%D %X")
      echo "[*] $DateValue Strating Category $Category"
      PRECEDENT_CATEGORY=$Category
    fi

    ## Read Mode Command
    if [[ $PARAMETER == '-r' ]]; then
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
      fi

    fi

    ## Result printing
    PrintResult "$ID" "$Name" "$ReturnedExit" "$ReturnedValue"

  fi
done < $INPUT

## Redefine separator with its precedent value
IFS=$OLDIFS

#!/bin/bash

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
  # If an error happens
  if [[ $ReturnedExit == 1 ]]; then
    #Error
    echo '[-]' $ID ':' $Name '; Error to read this policy'
  else
    #No error
    echo '[-]' $ID ':' $Name '; ActualValue =' $ReturnedValue
  fi
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



    if [[ $PARAMETER == '-r' ]]; then
      ReturnedValue=$(defaults read $RegistryPath $RegistryItem)
    fi

    ## Result printing
    PrintResult "$ID" "$Name" "$?" "$ReturnedValue"

  fi
done < $INPUT

## Redefine separator with its precedent value
IFS=$OLDIFS

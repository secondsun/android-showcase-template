#!/usr/bin/env bash

# Defaults
version="0.1"
projectName="showcase"
createNewProject=1
androidProjectNumber=""
androidServerKey=""
#Parse flags
while [[ "$1" =~ ^- && ! "$1" == "--" ]]; do case $1 in
  -V | --version )
    echo $version
    exit
    ;;
  -p | --projectName )
    shift; projectName=$1
    ;;
  --androidServerKey )
    shift; androidServerKey=$1
    ;;
  --androidProjectNumber )
    shift; androidProjectNumber=$1
    ;;    
esac; shift; done
if [[ "$1" == '--' ]]; then shift; fi

echo "$androidProjectNumber"

#Check Prerequisites
command -v oc >/dev/null 2>&1 || { echo >&2 "I require oc tools but it's not installed.  Aborting."; exit 1; }
command -v mobile >/dev/null 2>&1 || { echo >&2 "I require mobile-cli but it's not installed.  Aborting."; exit 1; }

if oc project $projectName; then
    echo "using existing project $projectName"
else
    echo "$projectName does not exist, creating"
    oc new-project $projectName
fi

keycloakexists=`mobile get serviceinstances keycloak -o json --namespace $projectName`

if [ keycloakexists ] && [ "$keycloakexists" != "null" ]; then
    echo "keycloak already provisioned in $projectName"
else
    echo "keycloak in $projectName does not exist, provisioning"
    mobile create serviceinstance keycloak --namespace $projectName
fi

upsexists=`mobile get serviceinstances ups -o json --namespace $projectName`

if [ upsexists ] && [ "$upsexists" != "null" ]; then
    echo "ups already provisioned in $projectName"
else
    if [ -z "$androidProjectNumber" ]; then
        echo "I require androidProjectNumber; provide with --androidProjectNumber.  Aborting."; exit 1; 
    fi
    if [ -z "$androidServerKey" ]; then
        echo  "I require androidServerKey; provide with --androidServerKey.  Aborting."; exit 1; 
    fi
    echo "ups in $projectName does not exist, provisioning"
    mobile create serviceinstance ups -p projectNumber=$androidProjectNumber -p googlekey=$androidServerKey --namespace $projectName
fi


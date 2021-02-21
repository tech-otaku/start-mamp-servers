#!/usr/bin/env bash

# AUTHOR:   Steve Ward [steve at tech-otaku dot com]
# URL:      https://github.com/tech-otaku/start-mamp-servers.git
# README:   https://github.com/tech-otaku/start-mamp-servers/blob/main/README.md

# USAGE:    ./create-keychain-item.sh KEYCHAINITEM
# EXAMPLE:  ./create-keychain-item.sh "MAMP"



# Exit with error if KEYCHAINITEM not passed to script
    if [ -z $1 ]; then
        printf  "ERROR: Please provide a name for the Keychain item.\n"
        exit 1
    fi


# Exit with error if KEYCHAINITEM already exists
    if security find-generic-password -l "$1" > /dev/null 2>&1; then
        printf "ERROR: A Keychain item already exists for '%s'.\n" "$1"
        exit 1
    fi

# Create new Keychain item 
#   -a = account [Account]
#   -j = comment string [Comments]
#   -l = label [Name]
#   -s = service [Where]
    security add-generic-password -a $USER -j "For use by 'start-mamp-servers.sh'" -l "$1" -s "$1" -T /usr/bin/security -w



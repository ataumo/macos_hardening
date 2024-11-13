#!/bin/zsh
#set -x
############################################################################################
##
## Script to require Administrator password to access System-Wide Preferences
##
############################################################################################

## Copyright (c) 2023 Microsoft Corp. All rights reserved.
## Scripts are not supported under any Microsoft standard support program or service. The scripts are provided AS IS without warranty of any kind.
## Microsoft disclaims all implied warranties including, without limitation, any implied warranties of merchantability or of fitness for a
## particular purpose. The entire risk arising out of the use or performance of the scripts and documentation remains with you. In no event shall
## Microsoft, its authors, or anyone else involved in the creation, production, or delivery of the scripts be liable for any damages whatsoever
## (including, without limitation, damages for loss of business profits, business interruption, loss of business information, or other pecuniary
## loss) arising out of the use of or inability to use the sample scripts or documentation, even if Microsoft has been advised of the possibility
## of such damages.
## Feedback: neiljohn@microsoft.com

# Define variables
appname="AdministratorPasswordToSystemWidePreferences"

# Check if administrator password is required to access the specified system-wide setting
AdministratorPasswordToSystemWidePreferences() {
    if [[ -z "$1" ]]; then
        echo "Error: No domain specified. Please provide a domain to check (e.g., system.preferences.network)."
        return 1
    fi

    section="$1"
    
    # Read the authorization configuration for the specified domain
    /usr/bin/security -q authorizationdb read "$section" > "/tmp/$section.plist" 2>/dev/null
    if [[ $? -ne 0 ]]; then
        echo "Error: Domain '$section' not found or cannot be accessed."
        return 1
    fi

    # Check the 'shared' key
    key_value=$(/usr/libexec/PlistBuddy -c "Print :shared" "/tmp/$section.plist" 2>&1)
    if [[ "$key_value" == *"Does Not Exist"* ]]; then
        echo "false"
    else
        echo "$key_value"
    fi

    # Clean up the temporary file
    rm "/tmp/$section.plist"
}

# Run the function with a domain argument
AdministratorPasswordToSystemWidePreferences "$1"

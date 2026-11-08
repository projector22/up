#!/bin/bash

set -euo pipefail

CONFIG_DIR="$HOME/.config/up"
CONFIG_FILE="$CONFIG_DIR/up.dat"

function prepare_config() {
    if [ -f "$CONFIG_FILE" ]; then
        DECODED_FILE="$CONFIG_DIR/up.tmp"
        base64 -d -i "$CONFIG_FILE" > "$DECODED_FILE"
        source "$DECODED_FILE"
        rm $DECODED_FILE
    else
        mkdir -p "$CONFIG_DIR" && touch $CONFIG_FILE
    fi
    return 0
}

function save_config() {
  local URL="$1"
  BASE64_RESPONSE=$(echo -n "NTFY_URL=$URL" | base64)
  printf $BASE64_RESPONSE > "$CONFIG_FILE"  
  return 0
}

function send_ntfy() {
  local URL="$1"
  local MSG="$2"

  USER_NAME=$(whoami)
  HOST_NAME=$(uname -n)

  cURL \
    -H "Title: Up Linux Updater" \
    -H "Tags: package,$HOST_NAME,up-updater" \
    -d "$MSG 
    
Sent from $USER_NAME@$HOST_NAME 🧔💻" $URL >/dev/null 2>&1
}

function set_ntfy_URL() {
    NTFY_URL=$1
    NEW_URL=$2

    if [ -n "$NTFY_URL" ]; then
        printf "%s\n" "Current NTFY URL: $NTFY_URL"
    fi

    if [ -n "$NEW_URL" ] && [ "$NEW_URL" != "" ]
    then
        URL="$NEW_URL"
    else
        read -p "Set the full NTFY server url including the http/s: " url
    fi
    validate_url "$URL"
    send_ntfy $URL "Test Notification 🧪💪"
    while true; do
        read -p "Did you receive a notification? (y/n): " response

        if [ "$response" = "y" ]; then
                printf "Saving... "
                save_config $URL
                printf "Done\n"
                exit 0
        elif [ "$response" = "n" ]; then
            printf "Cancelling, please check your NTFY URL.\n";
            exit 1
        else
            echo "Invalid response. Please enter 'y' for yes or 'n' for no."
        fi
    done
    return 0
}
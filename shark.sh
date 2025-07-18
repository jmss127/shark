#!/bin/bash
# File: shark.sh
# Author: jms
# Date: 18 Jul 2025
# ------------------------------------------------------------------------------
# Comments:
# ------------------------------------------------------------------------------
# TODO: Fix alignment issue with ctrl +c to exit
# TODO: fix error message with decrypt.
# Setup & Config

# Resolve script's directory
# SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Color Variables tput
r=$(tput setaf 1) # Warnings/errors Red
g=$(tput setaf 2) # Menus/info/success Green
c=$(tput setaf 6) # Input prompts Cyan
m=$(tput setaf 5) # Highlights Magenta
reset=$(tput sgr0) # Reset
#
trap 'echo -e "$reset"; exit 0' INT TERM EXIT
# ------------------------------------------------------------------------------
# Functions:
# Function to encrypt text
encrypt_text() {
    local input="$1"
    local key="$2"
    # Use OpenSSL to encrypt with AES-256-CBC and output in base64
    echo -n "$input" | openssl enc -aes-256-cbc -pbkdf2 -base64 -pass pass:"$key" 2>/dev/null
}

# Function to validate key (simple check for non-empty key)
validate_key() {
    local key="$1"
    if [ -z "$key" ]; then
        echo -e "${r}Error: Key cannot be empty${reset}"
        exit 1
    fi
}

# ------------------------------------------------------------------------------
# Main

clear
tput cup 0 0
echo -e "${c}Enter encryption key (will not be echoed):${reset}"
read -r -s KEY
validate_key "$KEY"
clear

tput cup 0 0
echo -e "${c}Enter ${m}d ${c}to decrypt a message or anything else to create an encrypted message."
read -r -p "> " choose
echo -ne "$reset"
clear
if [ "$choose" = d ]; then
    echo -e "${c}Paste the message into the prompt below."
    read -r -p "> " eMessage
    echo -n "$eMessage" | base64 -d 2>/dev/null | openssl enc -aes-256-cbc -pbkdf2 -d -pass pass:"$KEY" 2>/dev/null
    exit 0
fi

echo -e "${g}Type your text (Ctrl+C to exit):${reset}"
TEXT=""
while IFS= read -r -s -n1 CHAR; do
    # Handle backspace (ASCII 127)
    if [[ $CHAR == $'\x7f' ]]; then
        if [ ${#TEXT} -gt 0 ]; then
            TEXT="${TEXT%?}"
        fi
    else
        TEXT="$TEXT$CHAR"
    fi
    tput cup 3 0
    echo -e "${c}Input: ${m}$TEXT${reset}"
    tput cup 4 0
    # Encrypt if TEXT is not empty
    if [ -n "$TEXT" ]; then
        CYPHER=$(encrypt_text "$TEXT" "$KEY")
        wl-copy "$CYPHER"
        echo -e "${g}Cypher: ${m}$CYPHER${reset}"
    else
        echo -e "${g}Cypher: ${reset}"
    fi
done
exit 0

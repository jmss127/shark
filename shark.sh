#!/bin/bash
# File: shark.sh
# Author: jms
# Date: 18 Jul 2025
# ------------------------------------------------------------------------------
# Comments: An Enigma style encryption and decryption tool for the terminal.
# ------------------------------------------------------------------------------
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
    # Use OpenSSL to encrypt with AES-256-CBC and output in base64
    echo -n "$input" | openssl enc -aes-256-cbc -pbkdf2 -base64 -pass pass:"$KEY" 2>/dev/null
}

# Function to decrypt text
decrypt_text() {
    echo -ne "$m"
    # Use OpenSSL to decrypt with AES-256-CBC and output in base64
    echo -n "$eMessage" | openssl enc -aes-256-cbc -d -pbkdf2 -base64 -pass pass:"$KEY" 2>/dev/null
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
echo -e "${c}Enter encryption key:${reset}"
read -r KEY
validate_key "$KEY"
clear

tput cup 0 0
echo -e "${c}Enter ${m}d ${c}to decrypt a message or anything else to create an encrypted message."
read -r -p "> " OPT
echo -ne "$reset"
clear
# ------------------------------------------------------------------------------
# Decrypting messages
# TODO: This is not decrypting text, get no output.
if [ "$OPT" = d ]; then
    echo -e "${c}Paste the message into the prompt below."
    read -r -p "> " eMessage
    decrypt_text        # decrypt function
    exit 0
fi
# ------------------------------------------------------------------------------
# Encrypting messages
# TODO: Fix, input text is not being printed only last character.
echo -e "${g}Type your text (Ctrl+C to exit):${reset}"
while IFS= read -r -n1 input; do
    tput cup 2 0
    echo -e "${c}Input: ${m}$input${reset}"
    tput cup 4 0
    CYPHER=$(encrypt_text)
    echo -e "${g}Cypher: ${m}$CYPHER${reset}"
    
done
exit 0

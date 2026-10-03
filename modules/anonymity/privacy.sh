#!/bin/bash

# Autobot v2 Anonymity Module - Proxychains & MAC Spoofer
# This script is called by the Python Core Engine

YELLOW='\033[1;33m'
RED='\033[1;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

function banner() {
    clear
    echo -e "${YELLOW}==================================================${NC}"
    echo -e "${YELLOW}       AUTOBOT v2 - ANONYMITY & PRIVACY         ${NC}"
    echo -e "${YELLOW}==================================================${NC}"
}

function change_mac() {
    echo -e "\n${YELLOW}[*] MAC Address Spoofing${NC}"
    read -p "Enter interface (e.g., wlan0): " IFACE
    if [[ -z "$IFACE" ]]; then
        echo -e "${RED}[!] Interface cannot be empty${NC}"
        return
    fi

    echo -e "${YELLOW}[*] Bringing $IFACE down...${NC}"
    ip link set $IFACE down

    # Generate random MAC
    RANDOM_MAC=$(printf '00:%02x:%02x:%02x:%02x:%02x:%02x' $((RANDOM%256)) $((RANDOM%256)) $((RANDOM%256)) $((RANDOM%256)) $((RANDOM%256)) $((RANDOM%256)))

    echo -e "${YELLOW}[*] Setting MAC to $RANDOM_MAC...${NC}"
    macchanger -r $IFACE 2>/dev/null || macchanger -m $RANDOM_MAC $IFACE

    echo -e "${YELLOW}[*] Bringing $IFACE up...${NC}"
    ip link set $IFACE up
    echo -e "${GREEN}[+] MAC address successfully spoofed!${NC}"
}

function proxy_status() {
    echo -e "\n${YELLOW}[*] Proxychains Status${NC}"
    if command -v proxychains4 &> /dev/null; then
        echo -e "${GREEN}[+] Proxychains4 is installed.${NC}"
        echo -e "${YELLOW}[*] Current config: /etc/proxychains4.conf${NC}"
    else
        echo -e "${RED}[!] Proxychains4 not found. Install it using 'apt install proxychains4'${NC}"
    fi
}

banner
echo -e "1) Change MAC Address"
echo -e "2) Check Proxy Status"
echo -e "0) Return to Main Menu"
echo -e "\nChoose an option:"
read OPT

case $OPT in
    1) change_mac ;;
    2) proxy_status ;;
    *) echo -e "Returning..." ;;
esac

#!/bin/bash

# Autobot v2 Wireless Module - WPA/WPS Automation
# This script is called by the Python Core Engine

YELLOW='\033[1;33m'
RED='\033[1;31m'
GREEN='\033[0;32m'
NC='\033[0m'

function banner() {
    clear
    echo -e "${YELLOW}==================================================${NC}"
    echo -e "${YELLOW}         AUTOBOT v2 - WIRELESS SECURITY          ${NC}"
    echo -e "${YELLOW}==================================================${NC}"
}

function monitor_mode() {
    echo -e "\n${YELLOW}[*] Monitor Mode Management${NC}"
    read -p "Enter interface (e.g., wlan0): " IFACE
    if [[ -z "$IFACE" ]]; then return; fi

    echo -e "1) Enable Monitor Mode"
    echo -e "2) Disable Monitor Mode"
    read -p "Choice: " MODE

    if [[ "$MODE" == "1" ]]; then
        airmon-ng check kill
        airmon-ng start $IFACE
        echo -e "${GREEN}[+] Monitor mode enabled!${NC}"
    elif [[ "$MODE" == "2" ]]; then
        airmon-ng stop ${IFACE}mon
        echo -e "${GREEN}[+] Monitor mode disabled!${NC}"
    fi
}

function launch_wifite() {
    echo -e "\n${YELLOW}[*] Launching WiFite...${NC}"
    if command -v wifite &> /dev/null; then
        wifite
    else
        echo -e "${RED}[!] WiFite not installed!${NC}"
    fi
}

banner
echo -e "1) Monitor Mode Control"
echo -e "2) Launch WiFite"
echo -e "0) Return to Main Menu"
echo -e "\nChoose an option:"
read OPT

case $OPT in
    1) monitor_mode ;;
    2) launch_wifite ;;
    *) echo -e "Returning..." ;;
esac

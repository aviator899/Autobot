#!/bin/bash

# Autobot v2 Network & MITM Module
# This script is called by the Python Core Engine

YELLOW='\033[1;33m'
RED='\033[1;31m'
GREEN='\033[0;32m'
NC='\033[0m'

function banner() {
    clear
    echo -e "${YELLOW}==================================================${NC}"
    echo -e "${YELLOW}       AUTOBOT v2 - NETWORK & MITM               ${NC}"
    echo -e "${YELLOW}==================================================${NC}"
}

function network_scan() {
    echo -e "\n${YELLOW}[*] Network Scanning${NC}"
    read -p "Enter Target IP/Range (e.g., 192.168.1.0/24): " TARGET
    if [[ -z "$TARGET" ]]; then return; fi

    echo -e "${YELLOW}[*] Scanning $TARGET with Nmap...${NC}"
    nmap -sP $TARGET
}

function mitm_setup() {
    echo -e "\n${YELLOW}[*] MITM Infrastructure Setup${NC}"
    echo "1) Enable IP Forwarding"
    echo "2) Disable IP Forwarding"
    read -p "Choice: " MODE

    if [[ "$MODE" == "1" ]]; then
        echo 1 > /proc/sys/net/ipv4/ip_forward
        echo -e "${GREEN}[+] IP Forwarding Enabled${NC}"
    elif [[ "$MODE" == "2" ]]; then
        echo 0 > /proc/sys/net/ipv4/ip_forward
        echo -e "${GREEN}[+] IP Forwarding Disabled${NC}"
    fi
}

function arp_spoof() {
    echo -e "\n${YELLOW}[*] ARP Spoofing (Bettercap)${NC}"
    if command -v bettercap &> /dev/null; then
        echo -e "${YELLOW}[*] Launching Bettercap...${NC}"
        bettercap
    else
        echo -e "${RED}[!] Bettercap not found. Install with 'apt install bettercap'${NC}"
    fi
}

banner
echo -e "1) Fast Network Scan"
echo -e "2) MITM IP Forwarding"
echo -e "3) Launch Bettercap (MITM)"
echo -e "0) Return to Main Menu"
echo -e "\nChoose an option:"
read OPT

case $OPT in
    1) network_scan ;;
    2) mitm_setup ;;
    3) arp_spoof ;;
    *) echo -e "Returning..." ;;
esac

#!/bin/bash
#-----------
# Variables
#-----------
WLAN=wlan0
LAN=eth0
WLANRANGE=192.168.253.0/24
LANRANGE=192.168.69.0/24
PORTAL=192.168.253.1

#--------------
# Wireless LAN
#--------------
# Enable basic network services (DHCP, DNS, NTP, etc.) 
# for wireless access point connections
# DCHP
iptables -t filter -I INPUT 4 \
	-i $WLAN \
	-p udp --sport 68 --dport 67 \
	-j ACCEPT

iptables -t filter -I OUTPUT 7 \
	-o $WLAN \
	-p udp --sport 67 --dport 68 \
	-j ACCEPT

# DNS-UDP
iptables -t filter -I INPUT 4 \
	-i $WLAN -s $WLANRANGE \
	-p tcp --dport 53 \
	-j ACCEPT

# DNS-TCP
iptables -t filter -I INPUT 5 \
	-i $WLAN -s $WLANRANGE \
	-p udp --dport 53 \
	-j ACCEPT

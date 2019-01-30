#!/bin/bash
#-----------
# VARIABLES
#-----------
WLAN=wlan0
LAN=eth0
WLANRANGE=192.168.253.0/24
LANRANGE=192.168.69.0/24
PORTAL=192.168.253.1

#------------------
# Internet Sharing
#------------------
# 1) Forward existing connections
iptables -t filter -A FORWARD \
	-i $LAN -o $WLAN -d $WLANRANGE \
	-m conntrack --ctstate ESTABLISHED,RELATED \
	-j ACCEPT

# 2) Forward new wireless access point connections to the Internet
iptables -t filter -A FORWARD \
	-i $WLAN -o $LAN -s $WLANRANGE \
	-j ACCEPT

# 3) Drop everything else
iptables -t filter -A FORWARD \
	-j DROP

# 4) Enable NAT for wireless access point connections to the Internet
iptables -t nat -A POSTROUTING \
	-o $LAN -s $WLANRANGE \
	-j MASQUERADE

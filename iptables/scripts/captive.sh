#!/bin/bash
#-----------
# VARIABLES
#-----------
WLAN=wlan0
LAN=eth0
WLANRANGE=192.168.253.0/24
LANRANGE=192.168.69.0/24
PORTAL_ADDR=192.168.253.1

#----------------
# CAPTIVE PORTAL
#----------------
# 1) Mark packets to be redirected to captive portal
iptables -t mangle -A PREROUTING \
	-i $WLAN \
	-j MARK --set-mark 99

# 2) Redirect web traffic to captive portal
iptables -t nat -A PREROUTING \
        -i $WLAN -s $WLANRANGE \
        -m mark --mark 99 \
        -p tcp -m multiport --dport 80,443,8000,4443 \
        -j DNAT --to $PORTAL_ADDR

# 3) Enable wireless access point connections to access portal
iptables -t filter -I INPUT 3 \
	-i $WLAN -s $WLANRANGE \
	-m mark --mark 99 \
	-p tcp -m multiport --dport 80,443,8000,4443 \
	-j ACCEPT

# 4) Forward DNS packets
iptables -t filter -I FORWARD 1 \
	-i $WLAN -s $WLANRANGE \
	-m mark --mark 99 \
	-p tcp --dport 53 \
	-j ACCEPT

iptables -t filter -I FORWARD 2 \
	-i $WLAN -s $WLANRANGE \
	-m mark --mark 99 \
	-p udp --dport 53 \
	-j ACCEPT

# 6) Drop marked packets
iptables -t filter -I FORWARD 3 \
	-m mark --mark 99 \
	-j DROP

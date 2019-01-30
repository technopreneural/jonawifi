#!/bin/bash
#-----------
# VARIABLES
#-----------
WLAN=wlan0
LAN=eth0
WLANRANGE=192.168.253.0/24
LANRANGE=192.168.69.0/24
PORTAL_ADDR=192.168.253.1
PORTAL_PORT=8000

#----------------
# CAPTIVE PORTAL
#----------------
# 1) Redirect unregistered devices to captive portal
# NOTE: These rules hould appear early in the list
# (i.e. before packets are marked)
#iptables -t mangle -I PREROUTING \
#	-i $WLAN -s $WLANRANGE \
#	-m mac --mac-source $MAC \
#	-j RETURN
# 1) Enable wireless access point connections to access portal
iptables -t filter -I INPUT 3 \
	-i $WLAN -s $WLANRANGE \
	-p tcp -m multiport --dport $PORTAL_PORT \
	-j ACCEPT

# 2) Mark packets to be redirected to captive portal
iptables -t mangle -A PREROUTING \
	-i $WLAN\
	-j MARK --set-mark 99

# 3) Redirect marked packets to captive portal
iptables -t nat -A PREROUTING \
        -i $WLAN -s $WLANRANGE \
        -m mark --mark 99 \
        -p tcp -m multiport --dport 80,443 \
        -j DNAT --to ${PORTAL_ADDR}:${PORTAL_PORT}

# 4) Intercept DNS/TCP requests 
iptables -t nat -A PREROUTING \
        -i $WLAN -s $WLANRANGE \
        -m mark --mark 99 \
        -p tcp --dport 53 \
        -j DNAT --to $PORTAL_ADDR 

# 5) Intercept DNS/UDP requests
iptables -t nat -A PREROUTING \
        -i $WLAN -s $WLANRANGE \
        -m mark --mark 99 \
        -p tcp --dport 53 \
        -j DNAT --to $PORTAL_ADDR

# 6) Drop marked packets
iptables -t filter -I FORWARD 1 \
	-m mark --mark 99 \
	-j DROP
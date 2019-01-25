#!/bin/bash
#-----------
# VARIABLES
#-----------
WLAN=wlan0
LAN=eth0
WLANRANGE=192.168.253.0/24
LANRANGE=192.168.69.0/24
PORTAL=192.168.253.1

#-------
# START
#-------
# Start from scratch (i.e. delete all existing rules)
iptables -F -t mangle
iptables -F -t nat
iptables -F -t filter

#--------------------
# HOST FORTIFICATION
#--------------------
# 1) Allow local processes
iptables -t filter -A INPUT \
	-i lo \
	-j ACCEPT

iptables -t filter -A OUTPUT \
	-o lo \
	-j ACCEPT

# 2) Allow existing connections
iptables -t filter -A INPUT \
	-m conntrack --ctstate ESTABLISHED,RELATED \
	-j ACCEPT

iptables -t filter -A OUTPUT \
	-m conntrack --ctstate ESTABLISHED,RELATED \
	-j ACCEPT

# 3) Allow access to essential network services (mDNS, ping, ssh)
# on secure network only
# HTTP for apt
iptables -t filter -A OUTPUT \
	-o $LAN \
	-p tcp -m multiport --dport 80,443 \
	-j ACCEPT

# SSH
iptables -t filter -A INPUT \
	-m conntrack --ctstate NEW \
	-i $LAN -s $LANRANGE \
	-p tcp --dport 22 \
	-j ACCEPT

iptables -t filter -A OUTPUT \
	-m conntrack --ctstate NEW \
	-o $LAN -d $LANRANGE \
	-p tcp --sport 22 \
	-j ACCEPT

# DNS
iptables -t filter -A OUTPUT \
	-o $LAN \
	-p tcp --dport 53 \
	-j ACCEPT

iptables -t filter -A OUTPUT \
	-o $LAN \
	-p udp --dport 53 \
	-j ACCEPT

# mDNS
iptables -t filter -A INPUT \
	-i $LAN -s $LANRANGE \
	-p udp --dport 5353 \
	-j ACCEPT

iptables -t filter -A OUTPUT \
	-o $LAN -d $LANRANGE \
	-p udp --sport 5353 \
	-j ACCEPT

# Ping
iptables -t filter -A INPUT \
	-i $LAN -s $LANRANGE \
	-p icmp --icmp-type 8 \
	-j ACCEPT

iptables -t filter -A OUTPUT \
	-p icmp --icmp-type 8 \
	-j ACCEPT

# 5) Set default policies to DROP and enable access as necessary
iptables -t filter -A INPUT \
	-j DROP

iptables -t filter -A OUTPUT \
	-j DROP


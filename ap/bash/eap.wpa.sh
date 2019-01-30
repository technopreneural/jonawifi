#!/bin/bash
#
# Variables
#
IFACE="wlan0"
CFGDIR="/home/pi/jonawifi/ap/"
CONFIG="${CFGDIR}hostapd.conf"
WPAPSK="${CFGDIR}hostapd.wpapsk"

#
# Configure wireless access point using hostapd
#
cat <<EOF > $CONFIG
#
# Wireless interface
#
interface=$IFACE
channel=1

#
# SSID
#
ssid=eap-wpa
# 1: open system, 2: pre-shared key
auth_algs=1
# Enable 802.1x authentication (WPA-Enterprise)
ieee8021x=1

# 1: wpa, 2: wpa2/wpa3, 3: both
wpa=1
# [WPA-PSK, WPA-EAP, WPA-PSK-SHA256, WPA-EAP-SHA256
wpa_key_mgmt=WPA-EAP
# CCMP CCMP-256
wpa_pairwise=CCMP
# Time interval fo rekeying (=5min)
wpa_group_rekey=300
# Force rekey when station with key leaves
wpa_strict_rekey=1
# Time interval for rekeying GMK (=1day)
wpa_gmk_rekey=86400

# Radius Server
auth_server_addr=127.0.0.1
auth_server_port=1812
auth_server_shared_secret=testing123

# Certificates
#ca_cert=/etc/freeradius/3.0/certs/ca.pem
#server_cert=/etc/freeradius/3.0/certs/server.pem
#private_key=/etc/freeradius/3.0/certs/server.key
#private_key_passwd=whatever

#
# Control interface
#
ctrl_interface=/var/run/hostapd
ctrl_interface_group=pi

#
# Logging
#
logger_syslog=-1
logger_syslog_level=0
logger_stdout=-1
logger_stdout_level=0
EOF

#
# Reset wireless interface
#
ip link set $IFACE down
ip addr flush dev $IFACE
#sleep 1

#
# Configure wireless interface
#

ip link set $IFACE up
ip addr add 192.168.253.1/24 dev $IFACE
#sleep 3

#
# Enable IP forwarding
#
sysctl -w net.ipv4.ip_forward=1

#
# Configure DHCP using dnsmasq
#
cat <<EOT > /etc/dnsmasq.conf
interface=$IFACE
dhcp-range=192.168.253.201,192.168.253.220,1h
EOT

#
# Apply DHCP configuration
#
sudo service dnsmasq restart

#
# Activate wireless access point
#
hostapd $CONFIG

#
# Reset and flush DHCP
#
#sudo service dnsmasq restart

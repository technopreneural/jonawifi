#!/bin/bash
#
# Variables
#
IFACE="wlan0"
CFGDIR="/home/pi/jonawifi/ap/"
CONFIG="${CFGDIR}hostapd.conf"

#
# Configure wireless access point using hostapd
#
cat <<EOF > $CONFIG
#
# Wireless interface
#
interface=${IFACE}
channel=1

#
# SSID
#
bss=wlan0_0
ssid=test1

bss=wlan0_1
ssid=test2
bssid=00:13:10:95:fe:0b

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
ip link set ${IFACE} down
ip addr flush dev ${IFACE}
#sleep 1

#
# Configure wireless interface
#

ip link set ${IFACE} up
ip addr add 192.168.253.1/24 dev ${IFACE}
#sleep 3

#
# Enable IP forwarding
#
sysctl -w net.ipv4.ip_forward=1

#
# Configure DHCP using dnsmasq
#
cat <<EOT > /etc/dnsmasq.conf
interface=${IFACE}
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

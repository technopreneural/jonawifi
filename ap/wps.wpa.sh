#!/bin/bash
#
# Variables
#
CONFDIR="/home/pi/jonawifi/ap"
CONFIG="${CONFDIR}/hostapd.conf"
EVENT="${CONFDIR}/event.sh"

USERDIR=$CONFDIR
USERS="${USERDIR}/users.wps"

IFACE="wlan0"

#
# Wifi userlist (MAC, PSK)
#
touch $USERS

#
# Configure wireless access point using hostapd
#
cat <<EOF > $CONFIG
#
# Wireless interfacee
#
interface=${IFACE}
channel=1
#
# SSID
#
ssid=wpa-psk
# 1: open system, 2: pre-shared key
auth_algs=2

wpa=2
wpa_key_mgmt=WPA-PSK
rsn_pairwise=CCMP
wpa_psk_file=$USERS

#
# WPS
#
eap_server=1
wps_state=2
ap_setup_locked=1
wps_pin_requests=/var/run/hostapd/pin_requests
config_methods=label virtual_display virtual_push_button keypad
pbc_in_m1=1

# Device identifier
device_name="Mobilis"
manufacturer="Jona Wifi"
model_name="Fourze MKAR"
model_number="0.1"
serial_number="14344.5254"

# Device type (6-0050F204-1: Access Point)
device_type=6-0050F204-1

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
# Configure DHCP using dnsmasq
#
cat <<EOT > /etc/dnsmasq.conf
interface=${IFACE}
dhcp-range=192.168.253.201,192.168.253.220,1h
EOT

#
# Apply DHCP configuration
#
service dnsmasq restart

#
# Reset wireless interface
#
ip link set ${IFACE} down
ip addr flush dev ${IFACE}

#
# Configure wireless interface
#

ip link set ${IFACE} up
ip addr add 192.168.253.1/24 dev ${IFACE}

#
# Enable IP forwarding
#
sysctl -w net.ipv4.ip_forward=1

#
# Activate wireless access point
#
hostapd $CONFIG -B

#
# Process hostapd events
#
hostapd_cli -a $EVENT

#!/bin/bash
#
# Variables
#
IFACE="wlan0"
DRIVER="nl80211"

SUPPLICANT="/home/pi/jonawifi/vendor/hostap/wpa_supplicant/wpa_supplicant"
SUPPLICANT="wpa_supplicant"
CONF_FILE="/home/pi/jonawifi/go/p2p-go.conf"
CTRL_IFACE="/var/run/wpa_supplicant"

cat <<EOF > $CONF_FILE
update_config=1

#p2p_listen_reg_class=81
#p2p_listen_channel=1
#p2p_oper_reg_class=81
#p2p_oper_channel=1
p2p_go_intent=15
p2p_no_group_iface=1
driver_param=use_p2p_group_interface=1
driver_param=p2p_device=1

device_type=6-0050F204-1
device_name="device_name"
manufacturer="manufacturer"
model_name="model_name"
serial_number="serial_number"

# Control interface
ctrl_interface=$CTRL_IFACE
ctrl_interface_group=pi
EOF

$SUPPLICANT -dd -i$IFACE -c $CONF_FILE -D$DRIVER

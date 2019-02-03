#!/usr/bin/python3

#
# Libraries
#
import subprocess
import time
import os

#
# Constants
#
AP_PATH = os.path.dirname(os.path.abspath(__file__))
AP_CONFIG = AP_PATH + "/open.conf"
AP_EVENTS = AP_PATH + "/open.events"

IFACE = "wlan0"
IPADDR = "192.168.253.1/24"

def dhcp_service_reset():
	print("Resetting DHCP service...")
	f=open("/etc/dnsmasq.conf","w+")
	f.write("interface=%s\r\n" % IFACE)
	f.write("dhcp-authoritative\r\n")
	f.write("dhcp-range=192.168.253.2,192.168.253.254,1h\r\n")
	subprocess.call('service dnsmasq restart'.split())
	print("DHCP Service reset.")

def interface_wireless_reset():
	print("Resetting wireless interface...")
	subprocess.call(('ip link set %s down' % IFACE).split())
	subprocess.call(('ip addr flush dev %s' % IFACE).split())
	subprocess.call(('ip link set %s up' % IFACE).split())
	subprocess.call(('ip addr add %s dev %s' %(IPADDR,IFACE)).split())
	print("Wireless interface reset.")

def ap_activate():
	print("Activating access point...")
	dhcp_service_reset()
	interface_wireless_reset()
	subprocess.call(['hostapd','-B',AP_CONFIG])
	time.sleep(1)
	subprocess.call(['hostapd_cli','-B','-a',AP_EVENTS])
	print("Access point activated.")

def ap_deactivate():
	print("Dectivating access point...")
	subprocess.call('sudo killall hostapd')
	subprocess.call('sudo killall hostapd')
	print("Access point deactivated.")

ap_activate()

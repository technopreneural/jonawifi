#!/usr/bin/python3

#
# Libraries
#
from subprocess import Popen
import time
import os

#
# Constants
#
AP_PATH = os.path.dirname(os.path.abspath(__file__))
AP_CONFIG = AP_PATH + "/open.conf"
AP_ACTIONS = AP_PATH + "/actions"

IFACE = "wlan0"
IPADDR = "192.168.253.1/24"

def dhcp_service_reset():
	print("Resetting DHCP service...")
	f=open("/etc/dnsmasq.d/hostapd","w+")
	f.write("interface=%s\r\n" % IFACE)
	f.write("dhcp-authoritative\r\n")
	f.write("dhcp-range=192.168.253.2,192.168.253.254,1h\r\n")
	f.close();
	Popen('service dnsmasq restart'.split(),shell=False)
	print("DHCP Service reset.")

def interface_wireless_reset():
	print("Resetting wireless interface...")
	Popen(('ip link set %s down' % IFACE).split(),shell=False)
	Popen(('ip addr flush dev %s' % IFACE).split(),shell=False)
	Popen(('ip link set %s up' % IFACE).split(),shell=False)
	Popen(('ip addr add %s dev %s' %(IPADDR,IFACE)).split(),shell=False)
	print("Wireless interface reset.")

def ap_activate():
	print("Activating access point...")
	dhcp_service_reset()
	interface_wireless_reset()
	Popen(['hostapd','-B',AP_CONFIG],shell=False)
	time.sleep(1)
	hostapd_cli = Popen(['hostapd_cli','-a',AP_EVENTS],shell=False)
	print("Access point activated.")

def ap_deactivate():
	print("Dectivating access point...")
	Popen('sudo killall hostapd')
	Popen('sudo killall hostapd')
	print("Access point deactivated.")

ap_activate()

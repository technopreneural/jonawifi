#!/usr/bin/python3

import sys
import json

IFACE = sys.argv[1]
EVENT = sys.argv[2]


def on_wps_pbc_active():
	print("WPS-PBC activated")

def on_wps_pbc_disable():
	print("WPS-PBC cancelled")

def on_wps_timeout():
	print("WPS timed out")

def on_wps_reg_success():
	MACADDR = sys.argv[3]
	print("New station %s registered successfully" % MACADDR)

def on_ap_sta_connected():
	MACADDR = sys.argv[3]
	print("Station %s connected" % MACADDR)

def on_ap_sta_disconnected():
	MACADDR = sys.argv[3]
	print("Station %s disconnected" % MACADDR)

def indirect(i):
	switcher={
		'WPS-PBC-ACTIVE':on_wps_pbc_active,
		'WPS-PBC-DISABLE':on_wps_pbc_disable,
		'WPS-TIMEOUT':on_wps_timeout,
		'WPS-REG-SUCCESS':on_wps_reg_success,
		'AP-STA-CONNECTED':on_ap_sta_connected,
		'AP-STA-DISCONNECTED':on_ap_sta_disconnected,
		}
	func=switcher.get(i,lambda :'invalid')
	return func()

indirect(EVENT)


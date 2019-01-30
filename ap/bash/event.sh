#!/bin/bash
echo ================================
echo $@
echo ================================

case $2 in
	WPS-REG-SUCCESS)
		echo "New account created"
		;;
	AP-STA-CONNECTED)
		echo "Station $3 connected"
		;;
	AP-STA-DISCONNECTED)
		echo "Station $3 disconnected"
		;;
	WPS-PBC-ACTIVE)
		echo "WPS activated"
		;;
	WPS-PBC-DISABLE)
		echo "WPS deactivated"
		;;
	WPS-TIMEOUT)
		echo "WPS timed out"
		;;
	AP-DISABLED)
		echo "Access point disabled"
		;;
	*)
		;;
esac

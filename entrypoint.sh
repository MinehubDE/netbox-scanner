#!/bin/bash

if [[ -z $1 ]]; then
	echo "----------------------------"
	echo "Please provide a module when running the container."
	echo "Example: docker run -d netbox-scanner nmap"
	echo "----------------------------"
fi

MODULE=$1

if [[ ! -f /data/netbox-scanner.conf ]]; then
	cp /app/netbox-scanner.conf /data/netbox-scanner.conf
fi

if [[ $MODULE == "nmap" ]]; then
	/app/nmap-scan.sh
else
	/venv/bin/python netbox-scanner.py $MODULE
fi

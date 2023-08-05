#!/usr/bin/env bash
#
# This is just an example.
#
# Since scanning many networks can produce huge XML files,
# the idea is to create one XML file per network, then
# use all of them as input to nbs.nmap.Nmap().
#
# If you scan few networks with few hosts or if you just
# want to experiment, feel free to use the `-iL` option of
# Nmap, passing a list of all networks and hosts to be
# scanned.
#
# If you have a large number of networks, use the mapfile option.
# In order to use mapfile, populate your networks, one per line,
# in a file called networks.txt.
#
# If you have a small number of networks, comment out the mapfile
# lines, and uncomment the "small array" line.
#
# For the purpose of this example, assume that netbox-scanner
# is configured to use the same directory of this script
# to look for XML files.
##

# if not defined via env vars, NETWORKS will be taken from the networks.txt file located in the data directory
if [[ -z $NETWORKS ]]; then
	# mapfile
	declare -a NETWORKS
	mapfile -t NETWORKS < /data/networks.txt
fi

# make sure scan and logs directories exist
mkdir -p /data/scans /app/logs

TODAY=$(date +%Y-%m-%d_%H-%M-%Z)

for net in "${NETWORKS[@]}"; do
    NETNAME=$(echo $net | tr -s '/' '-')
    # requires sudo
    #nmap "$net" -T4 -O -F --host-timeout 10s -oX /tmp/nmap-"$NETNAME".xml
    # does not require sudo
    nmap "$net" -T4 -sn --host-timeout 10s -oX /tmp/nmap-"$NETNAME".xml
done

/venv/bin/python3 /app/netbox-scanner.py nmap
cd /tmp
tar -czvf /data/scans/nmap-"$TODAY".tar.gz nmap-*.xml

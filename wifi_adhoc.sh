
#!/bin/bash


read -p "Interface reseau : " a
read -p "SSID name : " ssid
read -p "IP : " ip

echo "Canal utilise $1"

sudo killall wpa_supplicant

sudo ifconfig $a down

sudo iwconfig $a mode ad-hoc

sudo iwconfig $a channel $1

sudo iwconfig $a essid $ssid

sudo iwconfig $a key off

sudo ifconfig $a $ip netmask 255.255.255.0

sudo ifconfig $a up

echo "Mode ad-hoc activé sur $ip"

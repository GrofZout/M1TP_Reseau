#!/bin/bash
 

channel=1


channel_nb= $(sudo iwlist wlan0 scan | grep -o -c "Channel 1)")

echo $channel_nb

for i in {2..13}; do
	if [ $(sudo iwlist wlan0 scan | grep -o -c "Channel $i)")g -eq $channel_nb ]
	then
		echo 'test1'
		channel= $i
		channel_nb= $liste_channel | grep -o -c "Channel $i"
	fi
done

echo "Channel choisi $channel"

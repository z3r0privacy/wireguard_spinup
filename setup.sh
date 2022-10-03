#!/bin/bash

# as root

apt-get update
apt-get upgrade -y
peer_keys=$(pwd)/clients_pubkeys
apt-get install wireguard -y
cd /etc/wireguard/
umask 077
wg genkey | tee privatekey | wg pubkey > publickey
ip link add dev wg0 type wireguard
ip address add dev wg0 192.168.210.1/24
wg set wg0 private-key /etc/wireguard/privatekey listen-port 51820
for i in $(ls $peer_keys/*.pubkey); do echo add peer $i; wg set wg0 peer $(cat $i); done
ip link set up dev wg0

echo Public IP: $(dig +short myip.opendns.com @resolver1.opendns.com):51820
echo WG conf: $(wg status)

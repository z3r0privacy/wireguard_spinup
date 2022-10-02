#!/bin/bash

# as root

apt update
apt upgrade -y
peer_keys=$(pwd)/clients_pubkeys
apt install wireguard -y
cd /etc/wireguard/
umask 077
wg genkey | tee privatekey | wg pubkey > publickey
wg set wg0 private-key /etc/wireguard/privatekey listen-port 51820
for i in $(ls $peer_keys/*.pubkey); do echo add peer $i; wg set wg0 peer $(cat $i); done
ip link set up dev wg0

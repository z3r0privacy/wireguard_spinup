#!/bin/bash

# system update & installation
apt-get update
apt-get upgrade -y
peer_keys=$(pwd)/clients_pubkeys
apt-get install wireguard -y

# wireguard configuration
cd /etc/wireguard/
umask 077
wg genkey | tee privatekey | wg pubkey > publickey
ip link add dev wg0 type wireguard
ip address add dev wg0 192.168.210.1/24
wg set wg0 private-key /etc/wireguard/privatekey listen-port 51820
for i in $(ls $peer_keys/*.pubkey); do echo add peer $i; wg set wg0 peer $(cat $i | cut -d' ' -f1) allowed-ips $(cat $i | cut -d' ' -f2); done
ip link set up dev wg0

# routing & firewall configuration
sysctl -w net.ipv4.ip_forward=1
ufw route allow in on wg0 out on th0
iptables -t nat -I POSTROUTING -o eth0 -j MASQUERADE

# show required config for clients

echo Public IP: $(dig +short myip.opendns.com @resolver1.opendns.com):51820
echo WG conf: $(wg show)

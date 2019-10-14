#!/bin/bash
#--------------------------------------------------------------
# run configure eduroam

net.ipv4.ip_forward=1
sudo iptables -t nat -A  POSTROUTING -o wlan0 -j MASQUERADE
sudo sh -c "iptables-save > /etc/iptables.ipv4.nat"
iptables-restore < /etc/iptables.ipv4.nat

#--------------------------------------------------------------
sudo apt-get update
sudo apt-get install bridge-utils
#--------------------------------------------------------------
sudo sh -c "printf '
denyinterfaces wlan0
denyinterfaces eth0
' >> /etc/dhcpcd.conf"
#--------------------------------------------------------------
sudo brctl addbr br0
sudo brctl addif br0 wlan0

## in reverse
# brctl delif br0 eth0
# ifconfig br0 down
# brctl delbr br0
#--------------------------------------------------------------
sudo sh -c "printf '# Bridge setup
[NetDev]
Name=br0
Kind=bridge' > /etc/systemd/network/bridge-br0.netdev"
#--------------------------------------------------------------
sudo sh -c "printf '# Bridge setup
[Match]
Name=wlan0

[Network]
Bridge=br0' > /etc/systemd/network/bridge-br0-slave.network"
#--------------------------------------------------------------
sudo systemctl restart systemd-networkd
#--------------------------------------------------------------
#EOF

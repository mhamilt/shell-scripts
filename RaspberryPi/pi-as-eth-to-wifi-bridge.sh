#!/bin/bash
#--------------------------------------------------------------
# Assuming WiFi is set up, this short script will forward ethernet traffic over wifi
#--------------------------------------------------------------
sudo apt-get update
sudo apt-get -y install sed
#--------------------------------------------------------------
sudo sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
sudo iptables -t nat -A  POSTROUTING -o wlan0 -j MASQUERADE
sudo sh -c "iptables-save > /etc/iptables.ipv4.nat"
sudo sh -c "printf 'iptables-restore < /etc/iptables.ipv4.nat' > /lib/dhcpcd/dhcpcd-hooks/70-ipv4-nat"

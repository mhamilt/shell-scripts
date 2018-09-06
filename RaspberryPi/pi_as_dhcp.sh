#!/bin/bash
#--------------------------------------------------------------
# Setup pi as a DHCP Server
#
#
#   Be careful of network interface names on NOOBS
#   Run ifconfig to confirm ethernet is listed as eth0 and not enx<YOUR_MAC>
#
#--------------------------------------------------------------
ADDRESS='192.168.0.1'
NETMASK='255.255.255.0'
DHCPRANGE='192.168.0.2,192.168.0.254'
#--------------------------------------------------------------
sudo apt-get update
sudo apt-get -y install dnsmasq
#--------------------------------------------------------------
sudo sed -i 's/iface eth0/#iface eth0/g' /etc/network/interfaces
sudo sh -c "printf '
interface eth0
static ip_address=%s/24
' $ADDRESS >> /etc/dhcpcd.conf"
#--------------------------------------------------------------
sudo mv /etc/dnsmasq.conf /etc/dnsmasq.conf.orig
sudo sh -c "printf 'interface=eth0      # Use interface eth0
listen-address=%s      # Explicitly specify the address to listen on
server=8.8.8.8           # Forward DNS requests to Google DNS
domain-needed            # Do not forward short names
bogus-priv               # Never forward addresses in the non-routed address spaces.
dhcp-range=%s,%s,12h # Assign IP addresses in range with a 12 hour lease time
' $ADDRESS $DHCPRANGE $NETMASK > /etc/dnsmasq.conf"
#--------------------------------------------------------------
sudo sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
sudo iptables -t nat -A POSTROUTING -o wlan0 -j MASQUERADE
sudo sh -c "iptables-save > /etc/iptables.ipv4.nat"
sudo sh -c "printf 'iptables-restore < /etc/iptables.ipv4.nat' > /lib/dhcpcd/dhcpcd-hooks/70-ipv4-nat"
#--------------------------------------------------------------
sudo service networking restart
sudo service dnsmasq restart
#--------------------------------------------------------------
#EOF

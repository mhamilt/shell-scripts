#!/bin/bash
#--------------------------------------------------------------
# Setup pi as a DHCP Server
#
#
#   Be careful of network interface names on NOOBS
#   Run ifconfig to confirm ethernet is listed as eth0 and not enx<YOUR_MAC>
#
#   Create a file:
#   /etc/udev/rules.d/70-persistent-net.rules
#
#   and add to it
#   SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="YOUR_ETHERNET_MAC", ATTR{dev_id}=="0x0", ATTR{type}=="1", KERNEL=="eth*", NAME="eth0"
#
#   which will change the interface name to eth0
#
#   from https://www.raspberrypi.org/forums/viewtopic.php?t=132674
#--------------------------------------------------------------
ADDRESS='192.168.0.1'
NETMASK='255.255.255.0'
DHCPRANGE='192.168.0.2,192.168.0.254'
#--------------------------------------------------------------
sudo apt-get update
sudo apt-get -y install dnsmasq
#--------------------------------------------------------------
sudo sh -c "printf '
interface eth0
    static ip_address=%s/24
' $ADDRESS >> /etc/dhcpcd.conf"
#--------------------------------------------------------------
sudo service dhcpcd restart
#--------------------------------------------------------------
sudo mv /etc/dnsmasq.conf /etc/dnsmasq.conf.orig
sudo sh -c "printf 'interface=eth0      # Use interface eth0
dhcp-range=%s,%s,24h                    # Assign IP addresses in range with a 12 hour lease
' $DHCPRANGE $NETMASK  > /etc/dnsmasq.conf"
#--------------------------------------------------------------
sudo systemctl reload dnsmasq
#--------------------------------------------------------------
#EOF

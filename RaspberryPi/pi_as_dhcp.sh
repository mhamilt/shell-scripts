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
listen-address=%s      # Explicitly specify the address to listen on
dhcp-range=%s,%s,24h                    # Assign IP addresses in range with a 12 hour lease
' $ADDRESS $DHCPRANGE $NETMASK  > /etc/dnsmasq.conf"
#--------------------------------------------------------------
sudo systemctl reload dnsmasq
#--------------------------------------------------------------
#EOF

# For configuring DHCP static addresses append this

# # Static IPs
# dhcp-host=00:00:5e:00:53:42,MyMac,192.168.0.10
# dhcp-host=00:00:5e:00:53:01,00:00:5e:00:53:02,MyBridges,192.168.0.22
# dhcp-host=00:00:5e:00:53:08,PC,192.168.0.23
# dhcp-host=00:00:5e:00:53:10,KeTTLe,192.168.0.32

# List
# sudo iptables -t nat -v -L POSTROUTING -n --line-number
# sudo iptables -t nat -v -L PREROUTING -n --line-number
# sudo iptables -v -L FORWARD -n --line-number
#
# # Delete
# sudo iptables -t nat -D POSTROUTING 1
# sudo iptables -t nat -D PREROUTING 1
# sudo iptables -D FORWARD 1
# sudo sh -c "iptables-save > /etc/iptables.ipv4.nat"
# sudo iptables-restore < /etc/iptables.ipv4.nat
# sudo iptables -t nat -A POSTROUTING -o wlan0 -j MASQUERADE
#
# # Add
# sudo iptables -t nat -A PREROUTING -i wlan0 -p tcp --dport 80 -j DNAT --to-destination 192.168.0.3
# sudo iptables -A FORWARD -i wlan0 -o eth0 -p tcp --syn --dport 80 -m conntrack --ctstate NEW -j ACCEPT
# sudo iptables -t nat -A PREROUTING -i wlan0 -p tcp --dport 1234 -j DNAT --to-destination 192.168.0.3:80
# sudo iptables -A FORWARD -i wlan0 -o eth0 -p tcp --syn --dport 1234 -m conntrack --ctstate NEW -j ACCEPT
# sudo iptables -A FORWARD -i wlan0 -o eth0 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
# sudo iptables -A FORWARD -i eth0 -o wlan0 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
# sudo iptables -t nat -A POSTROUTING -o wlan0 -j MASQUERADE
# sudo sh -c "iptables-save > /etc/iptables.ipv4.nat"
# cat /etc/iptables.ipv4.nat
# sudo iptables-restore < /etc/iptables.ipv4.nat

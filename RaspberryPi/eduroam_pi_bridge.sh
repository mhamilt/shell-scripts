#!/bin/bash
# Connect to Eduroam and set Raspberry Pi as Wifi Bridge
#----------------------------------------------------------
read -p 'Username: (.e.g. username@university_domain)' USERNAME
read -sp 'Password: ' PASSWORD

ADDRESS='192.168.0.1'
NETMASK='255.255.255.0'
DHCPRANGE='192.168.0.2,192.168.0.254'

#----------------------------------------------------------
sudo sh -c "printf '
allow-hotplug wlan0
iface wlan0 inet manual
wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf
' >> /etc/network/interfaces"

sudo sh -c "printf 'ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
ap_scan=1
update_config=1
country=GB

network={
   ssid=\"eduroam\"
   proto=RSN
   key_mgmt=WPA-EAP
   eap=PEAP
   identity=\"%s\"
   password=\"%s\"
   phase1=\"peaplabel=0\"
   phase2=\"auth=MSCHAPV2\"
}
' $USERNAME $PASSWORD > /etc/wpa_supplicant/wpa_supplicant.conf"
#----------------------------------------------------------

sudo systemctl daemon-reload
sudo systemctl restart dhcpcd
#--------------------------------------------------------------
# Setup pi as a WiFi Bridge
#--------------------------------------------------------------
sudo apt-get update
sudo apt-get install dnsmasq
sudo apt-get upgrade -y
sudo apt-get install rpi-update dnsmasq -y
sudo rpi-update
#--------------------------------------------------------------
sudo sed -i 's/iface eth0/#iface eth0/g' /etc/network/interfaces
sudo sh -c "printf '
interface eth0
static ip_address="%s"/24
' $ADDRESS >> /etc/dhcpcd.conf"
#--------------------------------------------------------------
sudo mv /etc/dnsmasq.conf /etc/dnsmasq.conf.orig
sudo sh -c "printf 'interface=eth0      # Use interface eth0
listen-address="%s" # Explicitly specify the address to listen on
bind-interfaces      # Bind to the interface to make sure we are not sending things elsewhere
server=8.8.8.8       # Forward DNS requests to Google DNS
domain-needed        # Do not forward short names
bogus-priv           # Never forward addresses in the non-routed address spaces.
dhcp-range="%s","%s",12h # Assign IP addresses in range with a 12 hour lease time
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

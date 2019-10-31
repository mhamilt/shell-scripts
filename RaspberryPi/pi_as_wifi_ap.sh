#!/bin/bash
#--------------------------------------------------------------
# Forward wifi traffic to ethernet
#--------------------------------------------------------------
sudo apt-get update

sudo apt-get -y install \
                dnsmasq \
                hostapd \
                    sed
#--------------------------------------------------------------
sudo sh -c "printf 'interface wlan0
    static ip_address=192.168.4.1/24
    nohook wpa_supplicant
' >> /etc/dhcpcd.conf"
#--------------------------------------------------------------
sudo service dhcpcd restart
#--------------------------------------------------------------
sudo sh -c "printf 'interface=wlan0
driver=nl80211
ssid=NameOfNetwork
hw_mode=g
channel=7
wmm_enabled=0
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wpa=2
wpa_passphrase=AardvarkBadgerHedgehog
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP
' >> /etc/dhcpcd.conf"
#--------------------------------------------------------------
sudo sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
sudo iptables -t nat -A  POSTROUTING -o eth0 -j MASQUERADE
sudo sh -c "iptables-save > /etc/iptables.ipv4.nat"
sudo iptables-restore < /etc/iptables.ipv4.nat

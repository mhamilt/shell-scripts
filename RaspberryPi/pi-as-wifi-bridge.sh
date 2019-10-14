#!/bin/bash
#--------------------------------------------------------------
# Setup pi as WiFi Access Point and bridge the ethernet connection
# from https://www.raspberrypi.org/documentation/configuration/wireless/access-point.md
#--------------------------------------------------------------
ssid='YourWiFiNAME'
wpa_passphrase='abcIoT'
#--------------------------------------------------------------
sudo apt-get update
sudo apt-get install hostapd \
                bridge-utils \
                         sed
#--------------------------------------------------------------
sudo systemctl stop hostapd
#--------------------------------------------------------------
sudo sh -c "printf '
denyinterfaces wlan0
denyinterfaces eth0
' >> /etc/dhcpcd.conf"
#--------------------------------------------------------------
sudo brctl addbr br0
sudo brctl addif br0 eth0

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
Name=eth0

[Network]
Bridge=br0' > /etc/systemd/network/bridge-br0-slave.network"
#--------------------------------------------------------------
sudo systemctl restart systemd-networkd
#--------------------------------------------------------------
sudo sh -c "printf 'interface=wlan0
interface=wlan0
bridge=br0
#driver=nl80211
ssid=%s
hw_mode=g
channel=7
wmm_enabled=0
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wpa=2
wpa_passphrase=%s
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP' $ssid $wpa_passphrase > /etc/hostapd/hostapd.conf"
#--------------------------------------------------------------
sudo systemctl unmask hostapd
sudo systemctl enable hostapd
sudo systemctl start hostapd
#EOF

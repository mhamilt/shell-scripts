#!/bin/bash
#----------------------------------------------------------
read -p 'Username: (.e.g. username@university_domain)' USERNAME
read -sp 'Password: ' PASSWORD
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
#EOF

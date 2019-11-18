#!/bin/bash
#----------------------------------------------------------
# test bash if
INPUTMATCH=0
while [[ $INPUTMATCH -eq 0 ]]; do
  read -p 'Username: (.e.g. username@university_domain): ' USERNAME
  read -p 'Confirm Username: (.e.g. username@university_domain): ' CONFIRMUSERNAME

  if [[ "$USERNAME" == "$CONFIRMUSERNAME" ]]; then
    INPUTMATCH=1
  else
    printf 'Usernames did not match\n'
  fi
done

INPUTMATCH=0
while [[ $INPUTMATCH -eq 0 ]]; do
  read -sp 'Password: ' PASSWORD
  printf '\n'
  read -sp 'Confirm Password: ' CONFIRMPASSWORD

  if [[ "$PASSWORD" == "$CONFIRMPASSWORD" ]]; then
    INPUTMATCH=1
  else
    printf 'Passwords did not match\n'
  fi
done
printf '\n'
#----------------------------------------------------------
# temporary fix for WPA Enterprise on Raspbian Buster, connect Ethernet before running
sudo apt-get remove wpasupplicant -y
sudo mv -f /etc/apt/sources.list /etc/apt/sources.list.bak
sudo bash -c "echo 'deb http://raspbian.raspberrypi.org/raspbian/ stretch main contrib non-free rpi' > /etc/apt/sources.list"
sudo apt-get update
sudo apt-get install wpasupplicant -y
sudo apt-mark hold wpasupplicant
sudo cp -f /etc/apt/sources.list.bak /etc/apt/sources.list
sudo apt-get update
#----------------------------------------------------------
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
sudo systemctl restart dhcpcd
echo "you may need to reboot"

# ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
# ap_scan=1
# update_config=1
# country=GB
# network={
#    ssid="eduroam"
#    proto=RSN
#    key_mgmt=WPA-EAP
#    eap=PEAP
#    identity="UUN@DOMAIN"
#    password="PASSWORD"
#    phase1="peaplabel=0"
#    phase2="auth=MSCHAPV2"
# }


# OR

# echo -n plaintext_password_here | iconv -t utf16le | openssl md4
# ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
# ap_scan=1
# update_config=1
# country=GB
# network={
#    ssid="eduroam"
#    proto=RSN
#    key_mgmt=WPA-EAP
#    eap=PEAP
#    identity="UUN@DOMAIN"
#    password=hash:**************************************
#    phase1="peaplabel=0"
#    phase2="auth=MSCHAPV2"
# }

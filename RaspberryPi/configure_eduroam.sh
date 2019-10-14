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

sudo systemctl daemon-reload
sudo systemctl restart dhcpcd
sudo service networking restart


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

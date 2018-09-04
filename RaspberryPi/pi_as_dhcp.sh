#--------------------------------------------------------------
# Setup pi as a DHCP Server
ADDRESS='192.168.0.1'
NETMASK='255.255.255.0'
#--------------------------------------------------------------
sudo apt-get update
sudo apt-get install dnsmasq

sudo sed -i 's/iface eth0/#iface eth0/g' /etc/network/interfaces
sudo sh -c "printf '
auto eth0
iface eth0 inet static
address "%s"
netmask "%s"
' ADDRESS NETMASK >> /etc/network/interfaces"

sudo service networking restart
sudo mv /etc/dnsmask.conf /etc/dnsmask.default # make a backup of dnsmasq

sudo sh -c "printf '
interface=eth0
dhcp-range=192.168.0.2,192.168.0.254,255.255.255.0,12h
' > /etc/dnsmasq.conf"

sudo service dnsmasq restart
#--------------------------------------------------------------
#EOF

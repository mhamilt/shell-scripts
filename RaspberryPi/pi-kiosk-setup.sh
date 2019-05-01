sudo apt-get purge -y wolfram-engine \
                             scratch \
                            scratch2 \
                           nuscratch \
                            sonic-pi \
                               idle3 \
                            smartsim \
                         java-common \
                        minecraft-pi \
                        libreoffice*

sudo apt-get clean
sudo apt-get autoremove -y

sudo apt-get update
sudo apt-get upgrade -y

sudo apt-get install -y  xdotool \
                       unclutter \
                             sed \
                      libx11-dev \
                      xprintidle

cp kiosk.sh      /home/pi/kiosk.sh
cp kiosk.service /lib/systemd/system/kiosk.service

mkdir /home/pi/.config/lxsession/
mkdir /home/pi/.config/lxsession/LXDE-pi/

echo @/home/pi/kiosk.sh >> /home/pi/.config/lxsession/LXDE-pi/autostart

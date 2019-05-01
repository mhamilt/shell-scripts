# OR apt-get install chocolate-doom

cd ~

sudo apt-get update
sudo apt-get install \
     libsdl1.2debian \
     libsdl-image1.2 \
     libsdl-mixer1.2 \
 libsdl-mixer1.2-dev \
       libsdl-net1.2 \
   libsdl-net1.2-dev \
            timidity \

mkdir Doom
cd Doom

sudo wget https://www.chocolate-doom.org/downloads/3.0.0/chocolate-doom-3.0.0.tar.gz

tar -xvf chocolate-doom-3.0.0.tar.gz

cd chocolate-doom-*

./configure
make
sudo make install
cd ..
sudo wget http://www.jbserver.com/downloads/games/doom/misc/shareware/doom1.wad.zip
sudo unzip doom1.wad.zip

# FOR SETUP:
chocolate-doom-setup -iwad DOOM1.WAD
# RUN
chocolate-doom -iwad DOOM1.WAD

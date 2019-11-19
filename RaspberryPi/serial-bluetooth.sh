# ------------------------------------------------------------------------------
# Setup Bluetooth SPP
# ------------------------------------------------------------------------------
sudo apt-get update
sudo apt-get install -y \
                    sed \
                  bluez \
           python-bluez
# ------------------------------------------------------------------------------
sudo rfkill unblock all
# ------------------------------------------------------------------------------
# 2. Enable SPP on Raspberry Pi
read -p 'Bluetooth Name: (one word, no special characters): ' bluetooth_id
sudo sh -c "printf 'PRETTY_HOSTNAME=%s' $bluetooth_id >> /etc/machine-info"
sudo sed -i 's/^ExecStart=.*/& -C/' /etc/systemd/system/dbus-org.bluez.service
sudo sed -i "/^ExecStart=.*/aExecStartPost=/usr/bin/sdptool add SP" /etc/systemd/system/dbus-org.bluez.service
sudo sed -i: 's|^Exec.*toothd$| \
ExecStart=/usr/lib/bluetooth/bluetoothd -C \
ExecStartPost=/usr/bin/sdptool add SP \
ExecStartPost=/bin/hciconfig hci0 piscan \
|g' /lib/systemd/system/bluetooth.service
sudo systemctl restart bluetooth.service # Restart the service.
sudo systemctl daemon-reload # Reload the configuration file.
sudo systemctl restart bluetooth.service # Restart the service.
sudo systemctl daemon-reload # Reload the configuration file.
# ------------------------------------------------------------------------------
printf "'now run \u001b[34;1mbluetoothctl\u001b[0m and enter \u001b[1mdiscoverable on\u001b[0m\n Pair with %s\n' $bluetooth_id"

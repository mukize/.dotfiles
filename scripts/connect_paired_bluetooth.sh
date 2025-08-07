bluetoothctl devices Paired | grep "Device " | tofi | grep -oE '([0-9a-fA-F]{2}[:-]){5}[0-9a-fA-F]{2}'

#!/bin/bash
# Toggle the bluetooth connection with a sepcified device on/off.


# Device ID. You can use the command `bluetoothctl devices` to find out which ID you want to target.
ID=''

# number of seconds you want it to keep trying to connect.
CONNECTION_TIMEOUT=10

# You can check out /usr/share/icons for available icons.
NOTIFICATION_ICON_PATH='' 


notify () {
	#
	# Sends you a Gnome desktop notification.
	#
	notify-send $ID --hint int:transient:1 -i $NOTIFICATION_ICON_PATH $1
}

connectBluetooth () {
	#
	# Try to connect for $CONNECTION_TIMEOUT seconds.
	#
	while [ $SECONDS -lt $end ]; do
		if [ $(hcitool con | wc -l) -eq 2 ]; then
			break
		else
			bluetoothctl connect "$ID"
		fi
	done

	if [ $(hcitool con | wc -l) -eq 2 ]; then
		notify "Connected!"
	else
		notify "Failed to connect :( Please try again."
	fi
}

disconnectBluetooth () {
	#
	# Disconnect.
	#
	bluetoothctl disconnect "$ID"
	notify "Disconnected."
}

# Set a timeout of 10 seconds. connectBluetooth will keep trying to connect for this long.
end=$((SECONDS+$CONNECTION_TIMEOUT))

if [ $(hcitool con | wc -l) -eq 1 ]; then
	notify "Connecting..."
	connectBluetooth
else
	notify "Disconnecting..."
	disconnectBluetooth
fi

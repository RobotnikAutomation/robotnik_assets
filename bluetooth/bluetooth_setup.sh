#!/bin/sh

if [ $# -eq 0 ]
then
echo "No arguments supplied, using hostname"
hostname="true"
else
hostname="false"
name_full=$1
echo $name_full
echo $hostname
fi

# mac_default_address="00:1A:7D:DA:71:13"
mac_default_address=$(hcitool dev | grep hci0 | awk '{print $2}')
apt-get install libbluetooth-dev
if [ ! -d "bdaddr" ];
then
    git clone https://github.com/thxomas/bdaddr
fi

cd bdaddr

if [ ! -f "bdaddr" ];
then
    make
fi
if [ "$hostname" = true ]
then
hostname_comp=$(hostnamectl | grep 'hostname')
name_full=$(echo -n $hostname_comp | tail -c 14)
fi

sn=$(echo -n $name_full | tail -c 8)
robot_name=$(echo -n $name_full | head -c 5)
echo $robot_name

if [ "${robot_name}" = "ther0" ];
then
number_to_add=00:00:
elif [ "${robot_name}" = "shl00" ];
then 
number_to_add=00:05:
elif [ "${robot_name}" = "sxlsk" ];
then 
number_to_add=00:10:
elif [ "${robot_name}" = "rbwch" ];
then 
number_to_add=00:15:
elif [ "${robot_name}" = "cmp00" ];
then 
number_to_add=00:20:
elif [ "${robot_name}" = "shrp0" ];
then 
number_to_add=00:25:
elif [ "${robot_name}" = "shrxl" ];
then 
number_to_add=00:30:
elif [ "${robot_name}" = "rout0" ];
then 
number_to_add=00:35:
elif [ "${robot_name}" = "sxls0" ];
then 
number_to_add=00:40:
elif [ "${robot_name}" = "rbcar" ];
then 
number_to_add=00:45:
elif [ "${robot_name}" = "ther1" ];
then 
number_to_add=00:50:
elif [ "${robot_name}" = "ther4" ];
then 
number_to_add=00:55:
elif [ "${robot_name}" = "kevn1" ];
then 
number_to_add=00:60:
else
echo "invalid hostname, aborting"
exit 1
fi
new_mac="${number_to_add}$(echo "$sn" | sed 's/\(..\)\(..\)\(..\)\(..\)/\1:\2:\3:\4/')"

bluetooth_device=$(hcitool dev | grep "${mac_default_address}")
hci=$(echo -n $bluetooth_device | head -c 4)
echo ${hci}

if [ ! -z "$hci"  ];
then
sudo ./bdaddr -i ${hci} ${new_mac}
rm -rf bbaddr
else
	echo "bluetooth could not be found"
    exit 2
fi

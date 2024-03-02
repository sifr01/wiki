This was tested on the raspiOS version 2020-08. It is assuming you have a CLI connection to your pi, eg. by ssh (if headless, you will need this: echo hi > /boot/ssh).

First things first, change your password to anything but raspberry!  
`passwd`  

Update and upgrade your pi:  
`sudo apt update && sudo apt upgrade -y`  

Install the necessary software:  
`sudo apt install hostapd dnsmasq libqmi-utils udhcpc`  
  
***
  
Is wlan currently blocked?  
`sudo rfkill list`  
If so, unblock it by running:  
`sudo rfkill unblock wlan`  
Check to see if its unblocked now:  
`sudo rfkill list`  
  
Make sure dhcpcd doesnt try to assign wlan0 an IP. Leave it to dnsmasq and /etc/network/interfaces!  
`sudo echo 'denyinterfaces wlan0' >> /etc/dhcpcd.conf`  

Add this at the end of `/etc/network/interfaces`  
`auto lo`  
`iface lo inet loopback`  

`auto wwan0`  
`iface wwan0 inet dhcp`  
  
`allow-hotplug wlan0`  
`iface wlan0 inet static`  
  `address 192.168.5.1`  
  `netmask 255.255.255.0`  
  `network 192.168.5.0`  
  `broadcast 192.168.5.255`  
  
Write this in `/etc/hostapd/hostapd.conf`  
    `interface=wlan0`  
    `driver=nl80211`  
    `ssid=pi4gHAT`  
    `hw_mode=g`  
    `channel=6`  
    `ieee80211n=1`  
    `wmm_enabled=1`  
    `ht_capab=[HT40][SHORT-GI-20][DSSS_CCK-40]`  
    `macaddr_acl=0`  
    `auth_algs=1`  
    `ignore_broadcast_ssid=0`  
    `wpa=2`  
    `wpa_key_mgmt=WPA-PSK`  
    `wpa_passphrase=abetterpasswordthanthis`  
    `rsn_pairwise=CCMP`  

Make sure hostapd reads the hostapd.conf you specified:  
`sudo echo 'DAEMON_CONF="/etc/hostapd/hostapd.conf"' >> /etc/default/hostapd`  

Is hostapd masked?  
`sudo systemctl status hostapd`  
If so, run this to unmask it:  
`sudo systemctl unmask hostapd`  
Check to see if it is still masked:  
`sudo systemctl status hostapd`  
Start hostapd:  
`sudo systemctl start hostapd`  
Did it run into any errors?  
`sudo systemctl status hostapd`  
  
Now for configuring dnsmasq. First, backup the original config file:  
`sudo mv /etc/dnsmasq.conf /etc/dnsmasq.conf.bak`  
  
Now write this to `/etc/dnsmasq.conf`  
    `interface=wlan0`  
    `listen-address=192.168.5.1`  
    `bind-interfaces `  
    `server=8.8.8.8`  
    `domain-needed`  
    `bogus-priv`  
    `dhcp-range=192.168.5.100,192.168.5.200,24h`  
  
Reboot the system to apply any and all changes and then you should be able to connect through the hotspot:  
`sudo reboot`  

***

Enable port forwarding:  
`sudo echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.conf`  

Now you need to setup forwarding of packets between your two interfaces, on my pi I have wwan0 and wlan0:  
`sudo iptables -A FORWARD -i wwan0 -o wlan0 -m state --state RELATED,ESTABLISHED -j ACCEPT`  
`sudo iptables -A FORWARD -i wlan0 -o wwan0 -j ACCEPT`  
`sudo iptables -t nat -A POSTROUTING -o wwan0 -j MASQUERADE`  
  
This will save your iptables rules:  
`sudo sh -c "iptables-save > /etc/iptables.ipv4.nat"`  

To make sure your iptables rules persists after a reboot, at the end of `/etc/rc.local` but before `exit 0`, add:  
`sudo iptables-restore < /etc/iptables/rules.v4`
  
Now test it out by rebooting:  
`sudo reboot`  
  
Check whether your iptables rules persisted despite the reboot:  
`sudo iptables -L -v`  
`sudo iptables -L -v -t nat`  
  
***

Now youre ready to connect your 4g pi HAT to your cell tower. I found embeddedpi.com very helpful for their documentation for this section - see [here](https://embeddedpi.com/documentation/3g-4g-modems/raspberry-pi-sierra-wireless-mc7304-modem-qmi-interface-setup) and [here](https://embeddedpi.com/documentation/3g-4g-modems/raspberry-pi-sierra-wireless-mc7455-modem-raw-ip-qmi-interface-setup).  
  
**Part 1: Set kernel driver into raw-ip mode**  
Modem wwan interfaces need to be brought down in order to do this:  
`sudo ip link set dev wwan0 down`  
`sudo echo 'Y' | sudo tee /sys/class/net/wwan0/qmi/raw_ip`  
`sudo ip link set dev wwan0 up`  
  
Check whether this worked. This command should return: Y  
`cat /sys/class/net/wwan0/qmi/raw_ip`  

**Part 2: Prepare qmi**  
`sudo qmicli -d /dev/cdc-wdm0 --dms-get-operating-mode`  
`sudo qmicli -d /dev/cdc-wdm0 --dms-set-operating-mode='online'`  
`sudo qmicli -d /dev/cdc-wdm0 --dms-get-operating-mode`  
  
`sudo qmicli -d /dev/cdc-wdm0 --nas-get-signal-strength`  
`sudo qmicli -d /dev/cdc-wdm0 --nas-get-home-network`  
  
**Part 3: Connect to Vodafone**  
`sudo qmicli -d /dev/cdc-wdm0 --device-open-net="net-raw-ip|net-no-qos-header" --wds-start-network="apn='pp.vodafone.co.uk',ip-type=4" --client-no-release-cid`  
Issues I had with this step are documented [here](https://www.raspberrypi.org/forums/viewtopic.php?f=36&t=224355&start=75#p1748769) and [here](https://www.raspberrypi.org/forums/viewtopic.php?p=1374909#p1450784).
  
**Part 4: ask the vodafone DHCP server for an IP**  
`sudo udhcpc -i wwan0`  
  
Check whether your pi has an internet connection  
`ping 1.1.1.1`  
  
If you got this far, congrats!
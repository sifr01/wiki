1. `lsof -P -i -n`

2. To find a listener on a port:
`netstat -tln`


#### Do not use the following on any device that does not belong to you:
3. Check your firewall externally using the following commands

Brief scan of ports:

`nmap -Pn 192.168.1.1`

Longer scan of ports and services:

`nmap -sV 192.168.1.1`

4. Find your IP address on the network

`ip add`

5. View other devices connected on your LAN:
```
sudo apt install net-tools
arp
```
or

`sudo nmap -sn 192.168.1.0/24`

6. View open ports on devices in your LAN:

`sudo nmap 192.168.1.0/24`
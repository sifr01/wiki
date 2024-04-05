
`lsof -P -i -n`

To find a listener on a port:
`netstat -tln`


#### Do not use the following on any device that does not belong to you
Check your firewall externally using the following commands

Brief scan of ports:

`nmap -Pn 192.168.1.1`

Longer scan of ports and services:

`nmap -sV 192.168.1.1`
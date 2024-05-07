#### Increase Wifi Signal Strength(Tx-Power)

check out wireless card default tx-power:
`iwconfig wlan0`	  
(the default tx-power of my wireless card is 20 dBm)

```
ifconfig wlan0 down
iw reg set BO
ifconfig wlan0 up
```

check tx power
`iwconfig wlan0`

OR alternate way to directly set txpower

```
iwconfig wlan0 txpower 30
```

[see this for troubleshooting](https://askubuntu.com/questions/819830/sudo-iw-reg-get-still-shows-country-00-after-updating-etc-default-crda)
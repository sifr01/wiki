#Increase Wifi Signal Strength(Tx-Power)

iwconfig wlan0	  #check our wireless card default tx-power:
#(the default tx-power of my wireless card is 20 dBm)

ifconfig wlan0 down
iw reg set BO
ifconfig wlan0 up

iwconfig wlan0			  #check tx power

#OR:
#iwconfig wlan0 txpower 30	  #alternate way to directly set txpower

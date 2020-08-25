# DHCP-Flooder
The script makes DHCP requests using random mac addresses with the aim of causing IP address starvation for other hosts in the network.
Works for Class C Private IP adresses (Targeted at Debian based distros)

```console
root@pc:~# chmod +x dhcp-starver.sh
root@pc:~# ./dhcp-flooder.sh <interface>
```

#!/bin/sh -x
IP_ADDRESS=$(ifconfig | grep -E 'inet.[0-9]' | grep -v '127.0.0.1' | awk '{ print $2}')

cd /usr/local

git clone https://github.com/rembo10/headphones.git

cd headphones

cp init-scripts/init.freebsd /usr/local/etc/rc.d/headphones
chmod 555 /usr/local/etc/rc.d/headphones

pw user add _sabnzbd -c _sabnzbd -u 710 -d /nonexistent -s /usr/bin/nologin
chown -R _sabnzbd:_sabnzbd /usr/local/headphones

ln -sf /usr/local/bin/python2.7 /usr/local/bin/python

sysrc headphones_enable=YES

# start and stop the service so a config.ini is created
service headphones start
# lets give headphones 15 secs to startup
sleep 15
service headphones stop


sed -i' ' -e s:'http_host =.*:http_host = 0.0.0.0:g' config.ini

service headphones start

echo -e "Headphones now installed.\n" > /root/PLUGIN_INFO
echo -e "\nGo to $IP_ADDRESS:8181\n" >> /root/PLUGIN_INFO
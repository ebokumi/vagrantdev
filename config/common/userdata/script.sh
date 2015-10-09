#!/bin/bash


echo "Configuring required services " | tee -a  /tmp/sainsburys.log

systemctl enable etcd
systemctl start etcd

if [ `hostname | head -c 9` == "appserver" ];
then
  echo "Starting AppServer services " | tee -a  /tmp/sainsburys.log
  systemctl stop nginx
  systemctl disable nginx
  systemctl enable app
  systemctl start app
  systemctl enable sidekick
  systemctl start sidekick
else
  echo "Starting WebServer services " | tee -a  /tmp/sainsburys.log
  mkdir -p  /etc/nginx/sites-backup
  cp  /etc/nginx/sites-enabled/default /etc/nginx/sites-backup
  chmod 755 /usr/bin/confd
  systemctl stop app
  systemctl disable app
  systemctl enable nginx
  systemctl start nginx
  systemctl enable watchdog
  systemctl start watchdog
fi

echo "Configuring required services : Completed " | tee -a  /tmp/sainsburys.log


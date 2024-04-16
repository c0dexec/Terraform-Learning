#!/bin/bash
sudo su
apt update && apt install apache2 -qqy
echo $(hostname) > /var/www/html/index.html
service apache2 start
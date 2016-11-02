#!/bin/bash

### --- shell 更新脚本 --- ###
read -p "Please input deploy file name  (deploy): " deployname
mkdir -p /mnt/shell/$deployname/config/web/
cp `pwd`/nginx/deploy/deploy.sh /mnt/shell/$deployname/$deployname.sh
chmod +x /mnt/shell/$deployname/$deployname.sh
sed -i "s#/alidata/www/deploy#$deploypath#" /mnt/shell/$deployname/$deployname.sh
sed -i "s#/mnt/shell/deploy/config/#/mnt/shell/$deployname/config/#" /mnt/shell/$deployname/$deployname.sh


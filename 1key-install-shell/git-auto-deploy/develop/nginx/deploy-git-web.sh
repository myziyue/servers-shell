#!/bin/bash

### --- 后去内网发布IP地址 --- ###
deployip=`/sbin/ifconfig -a|grep inet|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|tr -d "addr:" | head -1`
gitdeploy=/alidata/www/git-deploy
mkdir -p $gitdeploy
chown -R $webuser. $gitdeploy
cp -rf `pwd`/nginx/deploy/git-deploy.conf /alidata/server/nginx/conf/vhosts/
sed -i "s#server_name localhost#server_name $deployip#" /alidata/server/nginx/conf/vhosts/git-deploy.conf

### --- PHP发布脚本 --- ###
deployname='deploy'
read -p "Please input deploy file name  (deploy.php/deploy.sh): " deployname
cp `pwd`/nginx/deploy/deploy.php $gitdeploy/$deployname.php
chown -R $webuser. $gitdeploy
sed -i "s#deploy-git-#$deployname-git-#" $gitdeploy/$deployname.php
sed -i "s#/mnt/shell/deploy/deploy.sh#/mnt/shell/$deployname/$deployname.sh#" $gitdeploy/$deployname.php

allowip='10.161.171.124'
read -p "Please input GitLab Server innet ip:" allowip
if [ allowip == '' ];then
    allowip='10.161.171.124'
fi
sed -i "s#127.0.0.1#$allowip#" $gitdeploy/$deployname.php

# generate token string
MATRIX="0123456789abcdefghijklmnopqrstuvwxyz"
LENGTH="32"
while [ "${n:=1}" -le "$LENGTH" ]
do
        PASS="$PASS${MATRIX:$(($RANDOM%${#MATRIX})):1}"
        let n+=1
done
sed -i "s#tokenstr#$PASS#" $gitdeploy/$deployname.php

### --- shell 更新脚本 --- ###
mkdir -p /mnt/shell/$deployname/config/web/
cp `pwd`/nginx/deploy/deploy.sh /mnt/shell/$deployname/$deployname.sh
chmod +x /mnt/shell/$deployname/$deployname.sh
sed -i "s#/alidata/www/deploy#$deploypath#" /mnt/shell/$deployname/$deployname.sh
sed -i "s#/mnt/shell/deploy/config/#/mnt/shell/$deployname/config/#" /mnt/shell/$deployname/$deployname.sh

/etc/init.d/nginx reload

echo "GitLab Web Hooks : http://$deployip/$deployname.php?token=$PASS"
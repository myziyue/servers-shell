#!/bin/bash

WEB_PATH='/opt/web/www.abc.com'
SH_PATH='/mnt/shell/www.abc.com'
DATE=`date +%Y%m%d-%s`
BACKUP_PATH='/opt/backup/www.abc.com_'$DATE
WEB_USER='www'
WEB_USERGROUP='www'

echo "Start deployment ..."

read -p  "Backup source code (y/n, default 'n'):" backup
if [ "$backup" == 'y' ];then
	echo "Start backup ..."
	mkdir -p $BACKUP_PATH
	cp -arf $WEB_PATH/* $BACKUP_PATH/
	echo "OK"
fi

cd $WEB_PATH

if [ "$1" == '' ];then
	svn up
else
	svn up -r "$1"
fi

cp -rf $SH_PATH/conf/*.php $WEB_PATH/config/
chown -R $WEB_USER:$WEB_GROUP $WEB_PATH

echo "Deployment finish"

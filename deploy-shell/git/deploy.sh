#!/bin/bash

WEB_PATH='/mnt/www/www.abc.com'
DEPLOY_PATH='/mnt/deploy/www.abc.com'
SH_PATH='/mnt/shell/www.abc.com'
WEB_USER='www'
WEB_USERGROUP='www'

echo "Start deployment"
cd $DEPLOY_PATH
if [ "$1" != '' ];then
    git reset --hard $1
    git clean -f
    git checkout master
else
    echo "pulling source code..."
    git reset --hard origin/master
    git clean -f
    git pull
    git checkout master
fi

echo "changing config file"
cp $SH_PATH/config/*.php $DEPLOY_PATH/config/

echo "removing other file"
rm -rf $DEPLOY_PATH/.idea  $DEPLOY_PATH/.project $DEPLOY_PATH/.settings $DEPLOY_PATH/.buildpath $DEPLOY_PATH/.gitignore $DEPLOY_PATH/Web/.htaccess $DEPLOY_PATH/Cache/*

echo "changing permissions..."
chown -R $WEB_USER:$WEB_USERGROUP $WEB_PATH/ $DEPLOY_PATH/

echo "Start web1 Synchronous ...."
# rsync file
rsync  -avzP --password-file=/etc/rsyncd/rsyncd.password --exclude-from=/etc/rsyncd/rsyncd.exclude.list $DEPLOY_PATH/ www@192.168.0.2::abc > /dev/null
rm -rf $WEB_PATH/Cache/*
echo "web1 Synchronous completion";

echo "Finished."

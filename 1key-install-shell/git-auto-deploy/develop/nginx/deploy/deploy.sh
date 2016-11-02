#!/bin/bash
 
WEB_PATH='/alidata/www/deploy'
WEB_USER='www'
WEB_USERGROUP='www'
 
echo "Start deployment"
cd $WEB_PATH

echo "pulling source code..."
git reset --hard origin/develop
git clean -f
git pull
git checkout develop

echo "changing config file"
cp /mnt/shell/deploy/config/*.php $WEB_PATH/

echo "removing other file"
rm -rf $WEB_PATH/.idea  $WEB_PATH/.project $WEB_PATH/.settings $WEB_PATH/.buildpath $WEB_PATH/.gitignore
#rm -rf $WEB_PATH/Application/Runtime/*

echo "changing permissions..."
chown -R $WEB_USER:$WEB_USERGROUP $WEB_PATH
echo "Finished."

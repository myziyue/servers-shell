#!/bin/sh

# mysql dump cmd
MysqlDump=/alidata/server/mysql/bin/mysqldump
# mysql data back
DATE=`date +%Y%m%d`
# back dir
BackDir=/mnt/dbback/$DATE
# back File name
BackFile=db.sql
# gzip back file name
GZBackFile=db-$DATE.tar.gz
# log file name
LogFile=$BackDir/db-$DATE.log
# mysql user and password
username=root
passwd=L8ka65#1

mkdir -p $BackDir

echo "-------------------------------------------" >> $LogFile 
echo $(date +"%y-%m-%d %H:%M:%S") >> $LogFile 
echo "-------------------------------------------" >> $LogFile 

cd $BackDir

$MysqlDump --quick --all-databases --flush-logs --delete-master-logs --lock-all-tables -u$username -p$passwd > $BackFile 2>&1

echo "Dump Done" >> $LogFile

tar czvf $GZBackFile $BackFile >> $LogFile 2>&1 

echo "-----------------------------------------" >> $LogFile
echo "[$GZBackFile]Backup Success!" >> $LogFile 
echo "-----------------------------------------" >> $LogFile
rm -rf $BackFile ./daily/

chmod -R 600 $BackDir

echo "Backup Done!" >> $LogFile

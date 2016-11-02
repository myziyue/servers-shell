#!/bin/sh

# mysql admin cmd
MysqlAdmin=/alidata/server/mysql/bin/mysqladmin
# mysql data back
DATE=`date +%Y%m%d`
# back dir
BackDir=/mnt/dbback/$DATE/daily
# data dir
DataDir=/alidata/server/mysql/data
# gzip back file name
GZBackFile=daily-$DATE.tar.gz
#GZ dir
GZDir=/mnt/dbback/$DATE
LogFile=$GZDir/daily-$DATE.log
# mysql user and password
username=root
passwd=L8ka65#1

mkdir -p $BackDir

echo "-------------------------------------------" >> $LogFile 
echo $(date +"%y-%m-%d %H:%M:%S") >> $LogFile 
echo "-------------------------------------------" >> $LogFile 

cd $DataDir

$MysqlAdmin flush-logs -u$username -p$passwd

#FileList
FileList=`cat mysql-bin.index`
# Counter file number
COUNTER=0

for file in $FileList
do
	COUNTER=`expr $COUNTER + 1`
done

NextNum=0

for file in $FileList
do
	base=`basename $file`
	NextNum=`expr $NextNum + 1`
	if [ $NextNum -eq $COUNTER ]
	then
		echo "Skip lastest" >> $LogFile
	else
		dest=$BackDir/$base
		if(test -e $dest)
		then
			echo "Skip exist $base" >> $LogFile
		else
			echo "Copying $base" >> $LogFile
			cp $base $BackDir
		fi
	fi
done
echo "-----------------------------------------" >> $LogFile
cd $BackDir

tar czvf $GZDir/$GZBackFile * >> $LogFile 2>&1
echo "-----------------------------------------" >> $LogFile
echo "[$GZBackFile]Backup Success!" >> $LogFile 
echo "-----------------------------------------" >> $LogFile
cd $GZDir

rm -rf $BackDir

chmod -R 600 $GZDir 

echo "Backup mysql binlog ok" >> $LogFile

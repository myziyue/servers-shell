#!/usr/bin/env bash

# 允许登陆用户列表
allowLoginUserLists=`cat /etc/passwd | grep -v /sbin/nologin | cut -d : -f 1`
# sshd的配置文件
sshd_config='/etc/ssh/sshd_config'
sshd_config_bak='/etc/ssh/sshd_config_'`date +%Y%m%d-%s`

cp $sshd_config $sshd_config_bak

allowUserLogin(){
    allowLoginUserList=""
    read -p "Please input allow Login user list(`echo $allowLoginUserLists`): " allowLoginUserList
    while [ "$allowLoginUserList" == "" ]
    do
        allowLoginUserList=""
        read -p "Please input allow Login user list(`echo $allowLoginUserLists`): " allowLoginUserList
    done
    tmp=""
    read -p "Are you sure you want to add '$allowLoginUserList' ? Input yes or no: " tmp
    while [ "$tmp" != "yes" ] && [ "$tmp" != "no" ]
    do
        tmp=""
        read -p "Are you sure you want to add '$allowLoginUserList' ? Input yes or no: " tmp
    done

    if [ "$tmp" == "yes" ];then
        sed -i 's/AllowUsers/#AllowUsers/' $sshd_config
        echo "AllowUsers ${allowLoginUserList//,/ }" >> $sshd_config
    else
        allowUserLogin
    fi
}
# 端口数据
port=22
read -p "Please input sshd Listen Port(default: 22): " port
tmp=`echo $port|sed 's/[0-9]//g'`
while [ -n "${tmp}" ]
do
    port=22
    read -p "Please input sshd Listen Port(default: 22): " port
    tmp=`echo $port|sed 's/[0-9]//g'`
done
if [ "$port" == "" ];then
    port=22
fi

# 是否允许root用户登陆
isAllowRootLogin=no
read -p "Allow root user to remotely Login, input yes or no (default: no): " isAllowRootLogin
while [ "$isAllowRootLogin" != "yes" ] && [ "$isAllowRootLogin" != "no" ]
do
    isAllowRootLogin=no
    read -p "Allow root user to remotely Login, input yes or no (default: no): " isAllowRootLogin
done

# 允许登陆用户
allowUserLogin

# 替换ssh配置项
sed -i "s/#Port 22/Port $port/" $sshd_config
sed -i 's/#Protocol 2/Protocol 2/' $sshd_config
sed -i "s/#PermitRootLogin yes/PermitRootLogin $isAllowRootLogin/" $sshd_config
sed -i 's/#PermitEmptyPasswords no/PermitEmptyPasswords no/' $sshd_config
sed -i 's/#MaxAuthTries 6/MaxAuthTries 3/' $sshd_config

/etc/init.d/sshd reload

echo "Success"
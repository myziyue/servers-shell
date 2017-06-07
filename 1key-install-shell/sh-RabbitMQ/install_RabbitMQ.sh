#!/usr/bin/env bash

CPU_NUM=$(cat /proc/cpuinfo | grep processor | wc -l)
ROOT_PATH=`pwd`

echo "Install dependency packages of Erlang ..."
yum -y install make gcc gcc-c++ kernel-devel m4 ncurses-devel openssl openssl-devel xmlto zip unzip

if [ ! -f compat-readline5-5.2-17.1.el6.x86_64.rpm ]; then
    wget ftp://ftp.pbone.net/mirror/ftp.centos.org/6.8/os/x86_64/Packages/compat-readline5-5.2-17.1.el6.x86_64.rpm
fi
rpm -ivh compat-readline5-5.2-17.1.el6.x86_64.rpm

if [ ! -f compat-readline5-5.2-17.1.el6.x86_64.rpm ]; then
    wget ftp://ftp.pbone.net/mirror/ftp.centos.org/6.8/os/x86_64/Packages/compat-readline5-5.2-17.1.el6.x86_64.rpm
fi
rpm -ivh compat-readline5-5.2-17.1.el6.x86_64.rpm

if [ ! -f socat-1.7.2.3-1.el6.x86_64.rpm ];then
    wget ftp://ftp.is.co.za/mirror/fedora.redhat.com/epel/6/x86_64/socat-1.7.2.3-1.el6.x86_64.rpm
fi
rpm -ivh socat-1.7.2.3-1.el6.x86_64.rpm
echo "OK"

echo "Download Erlang package ..."
if [ ! -f erlang-solutions-1.0-1.noarch.rpm ];then
  wget https://packages.erlang-solutions.com/erlang-solutions-1.0-1.noarch.rpm
fi
rpm -Uvh erlang-solutions-1.0-1.noarch.rpm
rpm --import https://packages.erlang-solutions.com/rpm/erlang_solutions.asc
yum -y install erlang
echo "OK"

echo "Install RabbitMQ ..."
rpm --import https://www.rabbitmq.com/rabbitmq-release-signing-key.asc
if [ ! -f rabbitmq-server-3.6.6-1.el6.noarch.rpm ];then
	wget http://www.rabbitmq.com/releases/rabbitmq-server/v3.6.6/rabbitmq-server-3.6.6-1.el6.noarch.rpm
fi
rpm -ivh rabbitmq-server-3.6.6-1.el6.noarch.rpm
echo "OK"

/etc/init.d/rabbitmq-server start

echo "Configure RabbitMQ ..."
cp rabbitmq.config /etc/rabbitmq/

/usr/sbin/rabbitmqctl add_vhost /default
/usr/sbin/rabbitmqctl add_vhost /com.vipbcw.mq

/usr/sbin/rabbitmqctl add_user vipbcw Bcw@Vip#1105

/usr/sbin/rabbitmqctl set_user_tags vipbcw administrator

/usr/sbin/rabbitmqctl  set_permissions -p /com.vipbcw.mq vipbcw '.*' '.*' '.*'
echo "OK"

/etc/init.d/rabbitmq-server restart

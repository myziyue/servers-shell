#!/bin/bash

rm -rf redis-3.2.9/
if [ ! -f redis-3.2.9.tar.gz ];then
  wget http://download.redis.io/releases/redis-3.2.9.tar.gz
fi

tar zxvf redis-3.2.9.tar.gz
cd redis-3.2.9/src/
make install PREFIX=/usr/local/redis/

ln -s /usr/local/redis/bin/redis-benchmark /usr/bin/redis-benchmark
ln -s /usr/local/redis/bin/redis-check-aof /usr/bin/redis-check-aof
ln -s /usr/local/redis/bin/redis-check-rdb /usr/bin/redis-check-rdb
ln -s /usr/local/redis/bin/redis-cli /usr/bin/redis-cli
ln -s /usr/local/redis/bin/redis-sentinel /usr/bin/redis-sentinel
ln -s /usr/local/redis/bin/redis-server /usr/bin/redis-server

mkdir -p /var/lib/redis/
cd ../../
cp -rf config/redis.conf /usr/local/redis/
cp -rf config/redis /etc/init.d/
chmod +x /etc/init.d/redis

/etc/init.d/redis start


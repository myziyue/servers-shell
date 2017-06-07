#!/bin/bash

yum install pcre pcre-devel openssl openssl-devel -y

rm -rf nginx-1.8.1

if [ ! -f nginx-1.8.1.tar.gz ];then
  wget http://nginx.org/download/nginx-1.8.1.tar.gz
fi

tar zxvf nginx-1.8.1.tar.gz
cd nginx-1.8.1
./configure --user=www \
--group=www \
--prefix=/app/nginx1.8.1 \
--with-http_stub_status_module \
--without-http-cache \
--with-http_ssl_module \
--with-http_gzip_static_module

CPU_NUM=$(cat /proc/cpuinfo | grep processor | wc -l)
if [ $CPU_NUM -gt 1 ];then
    make -j$CPU_NUM
else
    make
fi
make install

chmod 775 /app/nginx1.8.1/logs
chown -R www:www /app/nginx1.8.1/logs

cd  ..
cp -rf ./config-nginx/* /app/nginx1.8.1/conf/
sed -i 's/worker_processes  2/worker_processes  '"$CPU_NUM"'/' /app/nginx1.8.1/conf/nginx.conf
chmod 755 /app/nginx1.8.1/sbin/nginx

mv /app/nginx1.8.1/conf/nginx /etc/init.d/
chmod +x /etc/init.d/nginx
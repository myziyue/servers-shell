#!/bin/bash
rm -rf php-5.6.30

tar zxvf php-5.6.30.tar.gz
cd php-5.6.30
./configure --prefix=/app/php5 \
--enable-opcache \
--with-config-file-path=/app/php5/etc \
--with-mysql=mysqlnd \
--with-mysqli=mysqlnd \
--with-pdo-mysql=mysqlnd \
--enable-fpm \
--enable-static \
--enable-inline-optimization \
--enable-sockets \
--enable-wddx \
--enable-zip \
--enable-calendar \
--enable-bcmath \
--enable-soap \
--enable-pcntl \
--with-zlib-dir=/app/local/zlib1.2.8 \
--with-iconv \
--with-gd \
--with-xmlrpc \
--enable-mbstring \
--without-sqlite \
--with-curl \
--enable-ftp \
--with-mcrypt=/app/local/libmcrypt2.5.8  \
--with-freetype-dir=/app/local/freetype2.7 \
--with-jpeg-dir=/app/local/jpeg.6 \
--with-png-dir=/app/local/libpng1.6.25 \
--disable-ipv6 \
--disable-debug \
--with-openssl \
--disable-maintainer-zts \
--disable-safe-mode \
--disable-fileinfo

CPU_NUM=$(cat /proc/cpuinfo | grep processor | wc -l)
if [ $CPU_NUM -gt 1 ];then
    make ZEND_EXTRA_LIBS='-liconv' -j$CPU_NUM
else
    make ZEND_EXTRA_LIBS='-liconv'
fi
make install
cd ..
mkdir -p /app/php5/log/

cp ./php-5.6.30/php.ini-production /app/php5/etc/php.ini
#adjust php.ini
sed -i 's#; extension_dir = \"\.\/\"#extension_dir = "/app/php5/lib/php/extensions/no-debug-non-zts-20131226/"#'  /app/php5/etc/php.ini
sed -i 's#extension_dir = \"\.\/\"#extension_dir = "/app/php5/lib/php/extensions/no-debug-non-zts-20131226/"#'  /app/php5/etc/php.ini
sed -i 's/post_max_size = 8M/post_max_size = 64M/g' /app/php5/etc/php.ini
sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 64M/g' /app/php5/etc/php.ini
sed -i 's/;date.timezone =/date.timezone = PRC/g' /app/php5/etc/php.ini
sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=1/g' /app/php5/etc/php.ini
sed -i 's/max_execution_time = 30/max_execution_time = 300/g' /app/php5/etc/php.ini
#adjust php-fpm
cp /app/php5/etc/php-fpm.conf.default /app/php5/etc/php-fpm.conf
sed -i 's,user = nobody,user=www,g'   /app/php5/etc/php-fpm.conf
sed -i 's,group = nobody,group=www,g'   /app/php5/etc/php-fpm.conf
sed -i 's,^pm.min_spare_servers = 1,pm.min_spare_servers = 5,g'   /app/php5/etc/php-fpm.conf
sed -i 's,^pm.max_spare_servers = 3,pm.max_spare_servers = 35,g'   /app/php5/etc/php-fpm.conf
sed -i 's,^pm.max_children = 5,pm.max_children = 100,g'   /app/php5/etc/php-fpm.conf
sed -i 's,^pm.start_servers = 2,pm.start_servers = 20,g'   /app/php5/etc/php-fpm.conf
sed -i 's,;pid = run/php-fpm.pid,pid = run/php-fpm.pid,g'   /app/php5/etc/php-fpm.conf
sed -i 's,;error_log = log/php-fpm.log,error_log = /app/php5/log/php-fpm.log,g'   /app/php5/etc/php-fpm.conf
sed -i 's,;slowlog = log/$pool.log.slow,slowlog = /app/php5/log/www.log.slow,g'   /app/php5/etc/php-fpm.conf
#self start
install -v -m755 ./php-5.6.30/sapi/fpm/init.d.php-fpm  /etc/init.d/php-fpm
/etc/init.d/php-fpm start
sleep 5
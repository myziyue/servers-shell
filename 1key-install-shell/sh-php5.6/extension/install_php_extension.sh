#!/bin/bash

#redis
rm -rf redis-2.2.7
tar -xzvf redis-2.2.7.tgz
cd redis-2.2.7
/app/php5/bin/phpize
./configure --enable-redis --with-php-config=/app/php5/bin/php-config
CPU_NUM=$(cat /proc/cpuinfo | grep processor | wc -l)
if [ $CPU_NUM -gt 1 ];then
    make -j$CPU_NUM
else
    make
fi
make install
cd ..
echo "extension=redis.so" >> /app/php5/etc/php.ini

# amqp
rm -rf amqp-1.9.0
tar zxvf amqp-1.9.0.tgz
cd amqp-1.9.0
/app/php5/bin/phpize
./configure --with-php-config=/app/php5/bin/php-config
CPU_NUM=$(cat /proc/cpuinfo | grep processor | wc -l)
if [ $CPU_NUM -gt 1 ];then
    make -j$CPU_NUM
else
    make
fi
make install
cd ..
echo "extension=amqp.so" >> /app/php5/etc/php.ini

# swoole
rm -rf swoole-2.0.7
tar zxvf swoole-2.0.7.tgz
cd swoole-2.0.7
/app/php5/bin/phpize
./configure --with-php-config=/app/php5/bin/php-config
CPU_NUM=$(cat /proc/cpuinfo | grep processor | wc -l)
if [ $CPU_NUM -gt 1 ];then
    make -j$CPU_NUM
else
    make
fi
make install
cd ..
echo "extension=swoole.so" >> /app/php5/etc/php.ini

# mongodb
rm -rf mongodb-1.2.9
tar zxvf mongodb-1.2.9.tgz
cd mongodb-1.2.9
/app/php5/bin/phpize
./configure --with-php-config=/app/php5/bin/php-config
CPU_NUM=$(cat /proc/cpuinfo | grep processor | wc -l)
if [ $CPU_NUM -gt 1 ];then
    make -j$CPU_NUM
else
    make
fi
make install
cd ..
echo "extension=mongodb.so" >> /app/php5/etc/php.ini

#zend
mkdir -p /app/php5/lib/php/extensions/no-debug-non-zts-20131226/
tar zxvf zend-loader-php5.6-linux-x86_64.tar.gz
mv ./zend-loader-php5.6-linux-x86_64/ZendGuardLoader.so /app/php5/lib/php/extensions/no-debug-non-zts-20131226/
echo "" >> /app/php5/etc/php.ini
echo "zend_extension=opcache.so" >> /app/php5/etc/php.ini
echo "opcache.enable=1" >> /app/php5/etc/php.ini
echo "opcache.memory_consumption=256" >> /app/php5/etc/php.ini
echo "opcache.max_accelerated_files=5000" >> /app/php5/etc/php.ini
echo "opcache.revalidate_freq=60" >> /app/php5/etc/php.ini
echo "opcache.interned_strings_buffer=8" >> /app/php5/etc/php.ini
echo "opcache.fast_shutdown=1" >> /app/php5/etc/php.ini
echo "opcache.save_comments=0" >> /app/php5/etc/php.ini

echo " " >> /app/php5/etc/php.ini
echo "zend_extension=/app/php5/lib/php/extensions/no-debug-non-zts-20131226/ZendGuardLoader.so" >> /app/php5/etc/php.ini
echo "zend_loader.enable=1" >> /app/php5/etc/php.ini
echo "zend_loader.disable_licensing=0" >> /app/php5/etc/php.ini
echo "zend_loader.obfuscation_level_support=3" >> /app/php5/etc/php.ini
echo "zend_loader.license_path=" >> /app/php5/etc/php.ini



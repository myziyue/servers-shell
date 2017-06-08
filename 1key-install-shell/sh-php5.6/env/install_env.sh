#!/bin/bash

CPU_NUM=$(cat /proc/cpuinfo | grep processor | wc -l)

yum install -y libtool openssl-devel pcre-devel gcc gcc-c++ libXpm-devel.x86_64 xmlrpc-c-devel libgcrypt-devel librabbitmq librabbitmq-devel

rm -rf libiconv-1.14
tar zxvf libiconv-1.14.tar.gz
cd libiconv-1.14
./configure --prefix=/app/local/libiconv1.14
if [ $CPU_NUM -gt 1 ];then
    make -j$CPU_NUM
else
    make
fi
make install
cd ..

rm -rf zlib-1.2.8
tar zxvf zlib-1.2.8.tar.gz
cd zlib-1.2.8
./configure --prefix=/app/local/zlib1.2.8
if [ $CPU_NUM -gt 1 ];then
    make CFLAGS=-fpic -j$CPU_NUM
else
    make CFLAGS=-fpic
fi
make install
cd ..

rm -rf freetype-2.7
tar zxvf freetype-2.7.tar.gz
cd freetype-2.7
./configure --prefix=/app/local/freetype2.7
if [ $CPU_NUM -gt 1 ];then
    make -j$CPU_NUM
else
    make
fi
make install
cd ..

rm -rf libpng-1.6.25
tar zxvf libpng-1.6.25.tar.gz
cd libpng-1.6.25
./configure --prefix=/app/local/libpng1.6.25
if [ $CPU_NUM -gt 1 ];then
    make CFLAGS=-fpic -j$CPU_NUM
else
    make CFLAGS=-fpic
fi
make install
cd ..

rm -rf libmcrypt-2.5.8
tar zxvf libmcrypt-2.5.8.tar.gz
cd libmcrypt-2.5.8
./configure --prefix=/app/local/libmcrypt2.5.8 --disable-posix-threads
if [ $CPU_NUM -gt 1 ];then
    make -j$CPU_NUM
else
    make
fi
make install
/sbin/ldconfig
cd libltdl/
./configure --prefix=/app/local/libltdl --enable-ltdl-install
make
make install
cd ../..


rm -rf pcre-8.39
tar zxvf pcre-8.39.tar.gz
cd pcre-8.39
./configure --prefix=/app/local/pcre8.39
if [ $CPU_NUM -gt 1 ];then
    make -j$CPU_NUM
else
    make
fi
make install
cd ..

rm -rf jpeg-6b
tar zxvf jpegsrc.v6b.tar.gz
cd jpeg-6b
if [ -e /usr/share/libtool/config.guess ];then
cp -f /usr/share/libtool/config.guess .
elif [ -e /usr/share/libtool/config/config.guess ];then
cp -f /usr/share/libtool/config/config.guess .
fi
if [ -e /usr/share/libtool/config.sub ];then
cp -f /usr/share/libtool/config.sub .
elif [ -e /usr/share/libtool/config/config.sub ];then
cp -f /usr/share/libtool/config/config.sub .
fi
./configure --prefix=/app/local/jpeg.6 --enable-shared --enable-static
mkdir -p /app/local/jpeg.6/include
mkdir /app/local/jpeg.6/lib
mkdir /app/local/jpeg.6/bin
mkdir -p /app/local/jpeg.6/man/man1
if [ $CPU_NUM -gt 1 ];then
    make -j$CPU_NUM
else
    make
fi
make install-lib
make install
cd ..

touch /etc/ld.so.conf.d/usrlib.conf
echo "/app/local/" > /etc/ld.so.conf.d/usrlib.conf
/sbin/ldconfig

echo "export PATH=$PATH:/app/local/libiconv1.14/bin" >> /etc/profile
source /etc/profile

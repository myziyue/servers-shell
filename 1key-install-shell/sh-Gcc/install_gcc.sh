#!/bin/bash

# 安装所需软件包
yum -y install glibc-devel

wget http://ftp.gnu.org/gnu/gcc/gcc-5.3.0/gcc-5.3.0.tar.gz
tar zxvf gcc-5.3.0.tar.gz
cd gcc-5.3.0/

# 安装扩展包
./contrib/download_prerequisites

#新建目录存放编译结果
mkdir gcc-build/
cd gcc-build/

#编译gcc
../configure -enable-checking=release -enable-languages=c,c++ -disable-multilib
make && make install

#更新libstdc++.so.6
cp ./prev-x86_64-unknown-linux-gnu/libstdc++-v3/src/.libs/libstdc++.so.6.0.21 /usr/lib64/
ln -sf /usr/lib64/libstdc++.so.6.0.21 /usr/lib64/libstdc++.so.6

#!/bin/bash

# 依赖库
yum -y install readline-devel gcc gcc-c++ make autoconf zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel gdbm-devel zip unzip

# 安装python
rm -rf Python-2.7.13/
if [ ! -f Python-2.7.13.tgz ];then
  wget https://www.python.org/ftp/python/2.7.13/Python-2.7.13.tgz
fi

tar zxvf Python-2.7.13.tgz
cd Python-2.7.13/
./configure --prefix=/usr/local/python2.7
make & make install

# python更新
mv  -f /usr/bin/python /usr/bin/python2.6.bak
ln -s /usr/local/python2.7/bin/python /usr/bin/python
sed -i 's/python/python2.6/' /usr/bin/yum

# 检查版本
python --version

#安装 setuptools 和 pip
if [ ! -f get-pip.py ];then
    wget https://bootstrap.pypa.io/get-pip.py
fi
python get-pip.py

# setuptools 和 pip 更新
ln -s /usr/local/python2.7/bin/easy_install /usr/bin/easy_install
ln -s /usr/local/python2.7/bin/easy_install-2.7 /usr/bin/easy_install-2.7
ln -s /usr/local/python2.7/bin/pip /usr/bin/pip
ln -s /usr/local/python2.7/bin/pip2  /usr/bin/pip2
ln -s /usr/local/python2.7/bin/pip2.7  /usr/bin/pip2.7
ln -s /usr/local/python2.7/bin/wheel  /usr/bin/wheel

#检查pip版本
pip --version

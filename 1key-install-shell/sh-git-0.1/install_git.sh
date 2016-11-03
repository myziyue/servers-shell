#!/bin/bash
yum remove -y git
yum install -y curl-devel expat-devel gettext-devel openssl-devel perl-devel zlib-devel
#安装文档选装
#yum install -y asciidoc xmlto docbook2X

#ln -s /usr/bin/db2x_docbook2texi /usr/bin/docbook2x-texi

#wget https://github.com/git/git/archive/v2.8.2.tar.gz
rm -rf git-2.8.2
tar zxvf git-2.8.2.tar.gz
cd git-2.8.2
make configure
./configure --prefix=/usr
#make all doc info
make all
#make install install-doc install-html install-info
make install

echo "Install Success "
git --version

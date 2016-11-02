#!/bin/bash
yum install -y curl-devel expat-devel gettext-devel openssl-devel perl-devel zlib-devel
#安装文档选装
yum install -y asciidoc xmlto docbook2X

ln -s /usr/bin/db2x_docbook2texi /usr/bin/docbook2x-texi

#wget https://github.com/git/git/archive/v2.7.0.tar.gz
tar zxvf git-2.7.0.tar.gz
cd git-2.7.0
make configure
./configure --prefix=/usr
make all doc info
make install install-doc install-html install-info

echo "Install Success "
git --version

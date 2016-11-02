#!/bin/bash
# install php APC extension
wget http://pecl.php.net/get/APC-3.1.13.tgz
tar zxvf APC-3.1.13.tgz
cd APC-3.1.13/
phpize
./configure
make && make install
cd ../

# 安装pygmentize插件
wget --no-check-certificate https://github.com/pypa/pip/archive/1.5.5.tar.gz
mv 1.5.5.tar.gz pip-1.5.5.tar.gz
cd pip-1.5.5/
yum install -y python python-setuptools
python setup.py install
cd ../
pip install Pygments

# download phacility project sourse code
mkdir code.demo.com
cd code.demo.com/
if [[ ! -e libphutil ]]
then
  git clone https://github.com/phacility/libphutil.git
else
  (cd libphutil && git pull --rebase)
fi

if [[ ! -e arcanist ]]
then
  git clone https://github.com/phacility/arcanist.git
else
  (cd arcanist && git pull --rebase)
fi

if [[ ! -e phabricator ]]
then
  git clone https://github.com/phacility/phabricator.git
else
  (cd phabricator && git pull --rebase)
fi

mkdir -p /ziyue/www/code.myziyue.com/
cd ..
cp -rf code.demo.com/ /ziyue/www/code.myziyue.com/
cp -rf nginx/vhosts/code.myziyue.com.conf /ziyue/server/nginx/config/vhosts/code.myziyue.com.conf
/etc/init.d/nginx reload

#!/usr/bin/env bash

# INSTALL DIRCTROY
APP_PATH=/usr/servers

# PACKAGES
NGX_OPENRESTY=https://openresty.org/download/ngx_openresty-1.9.7.2.tar.gz
NGX_CACHE_PURGE=https://github.com/FRiCKLE/ngx_cache_purge/archive/2.3.tar.gz
NGX_UPSTREAM_CHECK_MODULE=https://github.com/yaoweibin/nginx_upstream_check_module/archive/v0.3.0.tar.gz

# INSTALL
cd $APP_PATH

echo "Installing extend library ..."
yum install pcre-devel openssl-devel libreadline-dev libncurses5-dev libpcre3-dev libssl-dev perl
echo "Installing extend library ...OK"

echo "Installing LuaJIT ..."
wget $NGX_OPENRESTY
tar zxvf ngx_openresty-1.9.7.2.tar.gz
cd $APP_PATH/ngx_openresty-1.9.7.2/bundle/LuaJIT-2.1-20160108/
make
make install
echo "Installing LuaJIT ...OK"

echo "Downloading  ngx_cache_purge..."
cd $APP_PATH/ngx_openresty-1.9.7.2/bundle/
wget $NGX_CACHE_PURGE
tar zxvf 2.3.tar.gz
echo "Downloading ngx_cache_purge ... OK"

echo "Downloading  nginx_upstream_check_module..."
wget $NGX_UPSTREAM_CHECK_MODULE
tar zxvf v0.3.0.tar.gz
echo "Downloading nginx_upstream_check_module ... OK"

echo "Installing ngx_openresty ..."
cd $APP_PATH/ngx_openresty-1.9.7.2/
./configure --prefix=$APP_PATH --with-http_realip_module  --with-pcre  --with-luajit --add-module=./bundle/ngx_cache_purge-2.3/ --add-module=./bundle/nginx_upstream_check_module-0.3.0/ -j2
gmake
gmake install
echo "Downloading ngx_openresty ... OK"

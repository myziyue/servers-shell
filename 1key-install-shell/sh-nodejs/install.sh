#!/bin/bash

rm -rf node-v6.11.0-linux-x64/ node-v6.11.0-linux-x64.tar
if [ ! -f node-v6.11.0-linux-x64.tar.xz ];then
  wget https://nodejs.org/dist/v6.11.0/node-v6.11.0-linux-x64.tar.xz
fi

xz -d -k node-v6.11.0-linux-x64.tar.xz
tar xvf node-v6.11.0-linux-x64.tar

mv -f node-v6.11.0-linux-x64/ /usr/local/node-v6.11.0/

mv /usr/bin/node /usr/bin/node.bak
mv /usr/bin/npm /usr/bin/npm.bak

ln -s /usr/local/node-v6.11.0/bin/node /usr/bin/node
ln -s /usr/local/node-v6.11.0/bin/npm /usr/bin/npm

node -v
npm -v
#!/bin/bash

cd ./env/
sh install_env.sh
cd ../php/
sh install_php5.6.sh
cd ../extension/
sh install_php_extension.sh
cd ../
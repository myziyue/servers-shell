#!/bin/bash

tmp=''
read -p "Please input git repositories (ssh@github.com:demo.git) : " tmp
git clone $tmp $1
exit
#!/bin/bash

export deploypath='/var/www/website'

### ---- deploy web user ---###
echo "generate ssh private and public key file ...."
ssh-keygen

echo "Please copy this ssh pulic key to your GitLab account: \n\r"
echo "-----BEGIN CERTIFICATE-----"
echo `less ~/.ssh/id_rsa.pub`
echo "-----END CERTIFICATE-----"

tmp='no'
read -p "Are you configure your GitLab SSH KEY (yes) : " tmp
while [ "$tmp" != "yes" ]
do
  read -p "Are you configure your GitLab SSH KEY (yes) : " tmp
done

tmp='no'
read -p "Are you continue clone git repositories and configure web site file (yes/no): " tmp
if [ $tmp == 'yes' ];then
    ####---- deploy path ----####
    read -p "Please input deploy path  (/var/www/website): " deploypath
    mkdir -p $deploypath

    ### --- clone git repositories --- ###
    read -p "Please input git repositories (ssh@github.com:demo.git) : " tmp
    git clone $tmp $deploypath

    ### --- configure deploy web site ---###
    echo "Configure deploy web site....."
    sh nginx/deploy-shell.sh
fi
echo "Finish."
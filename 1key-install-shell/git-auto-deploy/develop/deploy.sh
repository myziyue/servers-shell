#!/bin/bash

export deploypath='/alidata/www/website0'

### ---- deploy web user ---###
webuser='www'
read -p "Please input web user : " webuser

### --- change passwd file ---###
cp /etc/passwd /etc/passwd.bak
sed -i 's#$webuser:x:501:501::.*:/sbin/nologin#www:x:501:501::/home/www:/bin/bash#' /etc/passwd

### --- init user home path ---###
echo /home/$webuser
mkdir -p /home/$webuser
chown -R $webuser:$webuser /home/$webuser

cp -rf user/ssh/bash_logout /home/$webuser/.bash_logout
cp -rf user/ssh/bash_profile /home/$webuser/.bash_profile
cp -rf user/ssh/bashrc /home/$webuser/.bashrc

### --- generate ssh private and public file ---###
su - $webuser  -c "sh `pwd`/user/generate_ssh_key.sh"
echo "Please copy this ssh pulic key to your GitLab account: \n\r"
echo "-----BEGIN CERTIFICATE-----"
echo `less /home/$webuser/.ssh/id_rsa.pub`
echo "-----END CERTIFICATE-----"

tmp='no'
read -p "Are you configure your GitLab SSH KEY (yes) : " tmp
while [ "$tmp" != "yes" ]
do
  read -p "Are you configure your GitLab SSH KEY (yes) : " tmp
done

####---- deploy path ----####
read -p "Please input deploy path  (/var/www/website): " deploypath
mkdir -p $deploypath

### --- clone git repositories --- ###
su - $webuser  -c "sh `pwd`/git/clone-git-repos.sh $deploypath"

### --- configure deploy web site ---###
echo "Configure deploy web site....."
sh nginx/deploy-git-web.sh

sed -i "s#$webuser:x:501:501::/home/www:/bin/bash#$webuser:x:501:501::/home/www:/sbin/nologin#" /etc/passwd

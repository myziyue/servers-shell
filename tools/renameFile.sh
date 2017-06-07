#!/usr/bin/env bash

FILE_LIST=`find . -type f -name "*DAO.php"`
DIR_NAME=`pwd`

for file in $FILE_LIST
do
    file=`echo ${file/.\/src/src}`
    file_name=`echo $(basename $file)`
    file_name=`echo ${file_name%.*}`
    new_file_name=`echo ${file_name/DAO/Dao}`
    dir_name=`echo $(dirname $file)`
    new_file=$dir_name/$new_file_name".php"
    new_file=`echo ${new_file/.\/src/src}`
    mv -f $DIR_NAME/$file $DIR_NAME/$new_file
    sed -i "s/$file_name/$new_file_name/" $DIR_NAME/$new_file
done
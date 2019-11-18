#!/bin/bash

service mysql start
echo "starting mysql"
service nginx start
echo "starting nginx"
service php7.3-fpm start
echo "starting php"
mysql < ${htdocs}/phpmyadmin/sql/create_tables.sql -u root -proot
mysql < pma_privileges.sql -u root -proot
rm pma_privileges.sql
exec "/bin/bash";

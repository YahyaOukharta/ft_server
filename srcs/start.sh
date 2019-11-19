#!/bin/bash

GREEN='\033[0;32m'
NC='\033[0m'

service mysql start

service nginx start

service php7.3-fpm start

echo -e "[ ${GREEN}ok${NC} ] Started Php"

mysql < ${htdocs}/phpmyadmin/sql/create_tables.sql -u root -proot

echo -e "[ ${GREEN}ok${NC} ] Created tables for PhpMyAdmin"

mysql < pma_privileges.sql -u root -proot

echo -e "[ ${GREEN}ok${NC} ] Added privileges for the admin user"

rm pma_privileges.sql

echo "127.0.0.1     wordpress.local" >> /etc/hosts

echo -e "[ ${GREEN}ok${NC} ] Added 'wordpress.local' hostname to /etc/hosts"

exec "/bin/bash";

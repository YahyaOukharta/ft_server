FROM debian:10

EXPOSE 80 443 3306

RUN	apt update \
	&& apt install -y gnupg lynx curl wget nginx default-mysql-server php7.3-fpm php7.3-mysql php7.3-mbstring procps less vim

#ENVIRONMENT VARIABLES :
ENV nginx_vhost /etc/nginx/sites-enabled/default
ENV php_conf	/etc/php/7.3/fpm/php.ini
ENV nginx_conf	/etc/nginx/nginx.conf
ENV htdocs 	/var/www/html

#Nginx configuration :
COPY srcs/default ${nginx_vhost}

#SSL certificate and key
COPY srcs/ssl /etc/nginx/ssl

#Small edit in php.ini 
RUN sed -i -e 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' ${php_conf}

#PhpMyAdmin configuration
RUN wget https://files.phpmyadmin.net/phpMyAdmin/4.9.1/phpMyAdmin-4.9.1-all-languages.tar.gz
RUN tar -zxvf phpMyAdmin-4.9.1-all-languages.tar.gz
RUN rm phpMyAdmin-4.9.1-all-languages.tar.gz
RUN mv phpMyAdmin-4.9.1-all-languages ${htdocs}/phpmyadmin
RUN mkdir ${htdocs}/phpmyadmin/tmp && chmod 777 ${htdocs}/phpmyadmin/  
RUN chown -R www-data:www-data ${htdocs}/phpmyadmin
COPY srcs/config.inc.php ${htdocs}/phpmyadmin/config.inc.php

#Database privileges for admin
COPY srcs/pma_privileges.sql pma_privileges.sql

#Wordpress config
ADD srcs/wordpress ${htdocs}/
RUN chmod 777 ${htdocs}
COPY srcs/start.sh /start.sh
RUN chmod 777 /start.sh

#Startup script
ENTRYPOINT ["/start.sh"]


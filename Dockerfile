FROM debian:10

EXPOSE 80 443 3306

RUN	apt update \
	&& apt install -y gnupg wget nginx default-mysql-server php7.3-fpm php7.3-mysql procps less vim

ENV nginx_vhost /etc/nginx/sites-enabled/default
ENV php_conf	/etc/php/7.3/fpm/php.ini
ENV nginx_conf	/etc/nginx/nginx.conf

COPY default ${nginx_vhost}

RUN sed -i -e 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' ${php_conf}

RUN echo "<?php phpinfo(); ?>" >> /var/www/html/index.php

RUN wget https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-all-languages.tar.gz
RUN tar -zxvf phpMyAdmin-4.9.0.1-all-languages.tar.gz
RUN mv phpMyAdmin-4.9.0.1-all-languages /var/www/html/phpmyadmin
COPY pma.conf /etc/nginx/conf.d/phpmyadmin.conf
COPY start.sh /start.sh
RUN chmod 777 /start.sh

ENTRYPOINT ["bash"]


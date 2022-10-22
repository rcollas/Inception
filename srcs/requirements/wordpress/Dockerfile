FROM	alpine:3.15 as builder

RUN	apk update && apk add \
	php8 \
	php8-phar \
	php8-fpm \
	php8-mysqli \
	php8-iconv \
	curl \
	mariadb-client

COPY	./conf/www.conf /etc/php8/php-fpm.d/

COPY	./script/config.sh /


RUN	mkdir -p /usr/share/www/html && \
	curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
	chmod +x wp-cli.phar && \
	mv wp-cli.phar /usr/bin/wp && \
	mv /usr/bin/php8 /usr/bin/php


WORKDIR	/usr/share/www/html


ENTRYPOINT ["sh", "/config.sh"]

# -F run php-fpm in foreground and -R allow us to run it as root
CMD	["php-fpm8", "-F", "-R"]

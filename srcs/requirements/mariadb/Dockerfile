FROM alpine:3.15 as builder

RUN	apk update && apk add --no-cache \
	mariadb \
	mariadb-client

COPY ./script/config.sh /

COPY ./conf/mariadb-server.cnf /etc/my.cnf.d

ENTRYPOINT ["sh", "config.sh"]

CMD ["/usr/bin/mysqld", "--user=mysql"]

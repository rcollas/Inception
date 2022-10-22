FROM alpine:3.15 as builder

RUN	apk update && apk add --no-cache \
	mariadb \
	mariadb-client

COPY ./config.sh /

COPY ./mariadb-server.cnf /etc/my.cnf.d

ENTRYPOINT ["sh", "config.sh"]

CMD ["/usr/bin/mysqld", "--user=mysql"]

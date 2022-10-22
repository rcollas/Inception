#!/bin/bash

/usr/bin/mysql start

if [ -d "/run/mysqld" ]; then
	echo "MySQL already exist"
	chown -R mysql:mysql /run/mysqld 
else
	echo "MySQL not found, creating MySQL"
	mkdir -p /run/mysqld 
	chown -R mysql:mysql /run/mysqld 
fi

if [ -d "$MARIADB_DATADIR/mysql" ]; then
	echo "MySQL data directory already exist"
	chown -R mysql:mysql $MARIADB_DATADIR
else
	echo "Creating MySQL data directory"
	chown -R mysql:mysql $MARIADB_DATADIR
	
	mysql_install_db --user=mysql --ldata=$MARIADB_DATADIR > /dev/null

	cat <<EOS > database_setup
FLUSH PRIVILEGES;
GRANT ALL ON *.* TO 'root'@'%' identified by '$MARIADB_ROOT_PASSWORD' WITH GRANT OPTION;
GRANT ALL ON *.* TO 'root'@'localhost' identified by '$MARIADB_ROOT_PASSWORD' WITH GRANT OPTION;
DROP DATABASE IF EXISTS $MARIADB_USER;
CREATE OR REPLACE DATABASE $MARIADB_DATABASE;
CREATE USER '$MARIADB_USER'@'localhost' IDENTIFIED BY '$MARIADB_PASSWORD';
CREATE USER '$MARIADB_USER'@'%' IDENTIFIED BY '$MARIADB_PASSWORD';
GRANT ALL ON $MARIADB_DATABASE.* TO '$MARIADB_USER'@'localhost' WITH GRANT OPTION;
GRANT ALL ON $MARIADB_DATABASE.* TO '$MARIADB_USER'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOS
	/usr/bin/mysqld --user=mysql --bootstrap < database_setup 
	rm -f database_setup

fi

exec "$@"

#!/bin/bash

#cd /usr/share/www/html 
#mv /wp-config.php ./

#download wp
grep wp_version wp-includes/version.php 2> /dev/null 1>&2
if [ ! "$?" -eq 0 ]; then
echo "Downloading WordPress..."
wp core download
fi

cp wp-config-sample.php wp-config.php
sed -i "s/username_here/$MARIADB_USER/g" wp-config.php
sed -i "s/password_here/$MARIADB_PASSWORD/g" wp-config.php
sed -i "s/localhost/$MARIADB_HOSTNAME/g" wp-config.php
sed -i "s/database_name_here/$MARIADB_DATABASE/g" wp-config.php

#health check
mysql --user=$MARIADB_USER \
	      --password=$MARIADB_PASSWORD \
	      --host=$MARIADB_HOSTNAME \
	      $MARIADB_DATABASE 


exit_status=$?
while [ $exit_status == 1 ]; 
do 
	echo "Waiting for database. (Retry in 10s...)"
	sleep 10 
	#mysql --user=wordpress \
	#      --password=password \
	#      --host=mariadb \
	#    wp_database 

	mysql --user=$MARIADB_USER \
	      --password=$MARIADB_PASSWORD \
	      --host=$MARIADB_HOSTNAME \
	      $MARIADB_DATABASE 
	exit_status=$?
done

#wp installation
if ! wp core is-installed; then
echo "Installing WordPress..."
wp core install --url="$WP_URL" \
		--title="$WP_TITLE" \
		--admin_name="$WP_ADMIN" \
		--admin_email="$WP_MAIL" \
		--admin_password="$WP_PASS"
fi


#wp theme
if [ ! $WP_THEME == "" ]; then
	rm -rf ./wp-content/themes/*
	wp theme install $WP_THEME --activate
fi

exec "$@"

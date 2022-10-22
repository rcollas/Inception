FROM	alpine:3.15 as builder

RUN	apk update && apk add --no-cache \
	nginx \
	openssl

RUN	openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-keyout /etc/ssl/rcollas.42.fr.key \
	-out /etc/ssl/rcollas.42.fr.crt \
	-subj "/C=FR/ST=IDF/L=Paris/O=RCE/CN=rcollas.42.fr"

RUN	sed -i "/http /a include \/etc\/nginx\/conf.d\/*.conf;" /etc/nginx/nginx.conf

RUN	mkdir -p /usr/share/www/html

COPY	rcollas.conf /etc/nginx/conf.d/

EXPOSE	443 

CMD	["nginx", "-g", "daemon off;"]

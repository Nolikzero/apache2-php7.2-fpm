# Serveur apache
FROM debian:stretch-slim

RUN usermod -u 1000 www-data && groupmod -g 1000 www-data

RUN echo 'deb http://ftp.fr.debian.org/debian/ jessie non-free' >> /etc/apt/sources.list
RUN echo 'deb-src http://ftp.fr.debian.org/debian/ jessie non-free' >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get -y install apache2 libapache2-mod-fastcgi

COPY ./sites-available/* /etc/apache2/sites-available/
RUN cd /etc/apache2/sites-enabled/ && rm 000-default.conf
RUN ln -s /etc/apache2/sites-available/* /etc/apache2/sites-enabled/

ENV APACHE_CONFDIR /etc/apache2
ENV APACHE_ENVVARS $APACHE_CONFDIR/envvars
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data

RUN set -ex \
	\
# generically convert lines like
#   export APACHE_RUN_USER=www-data
# into
#   : ${APACHE_RUN_USER:=www-data}
#   export APACHE_RUN_USER
# so that they can be overridden at runtime ("-e APACHE_RUN_USER=...")
	&& sed -ri 's/^export ([^=]+)=(.*)$/: ${\1:=\2}\nexport \1/' "$APACHE_ENVVARS" \
	\
# setup directories and permissions
	&& . "$APACHE_ENVVARS" \
	&& for dir in \
		"$APACHE_LOCK_DIR" \
		"$APACHE_RUN_DIR" \
		"$APACHE_LOG_DIR" \
		/var/www/html \
	; do \
		rm -rvf "$dir" \
		&& mkdir -p "$dir" \
		&& chown -R "$APACHE_RUN_USER:$APACHE_RUN_GROUP" "$dir"; \
	done

RUN a2dismod mpm_event && a2enmod mpm_prefork
# Change uid and gid of apache to docker user uid/gid

RUN chown -R $APACHE_RUN_USER:$APACHE_RUN_GROUP /var/lib/apache2/fastcgi
RUN chmod -R 775 /var/lib/apache2/fastcgi

EXPOSE 80

ADD apache.sh /usr/bin/apache.sh
RUN chmod +x /usr/bin/apache.sh
ENTRYPOINT apache.sh

VOLUME /var/www

RUN chown -R www-data:www-data /var/www
RUN chown -R www-data:www-data /var/lib/apache2/fastcgi
RUN chmod -R 775 /var/lib/apache2/fastcgi

WORKDIR /var/www

# Serveur apache
FROM debian:latest

RUN echo 'deb http://ftp.fr.debian.org/debian/ jessie non-free' >> /etc/apt/sources.list
RUN echo 'deb-src http://ftp.fr.debian.org/debian/ jessie non-free' >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get -y install apache2 libapache2-mod-fastcgi

COPY ./sites-available/* /etc/apache2/sites-available/
RUN rm /etc/apache2/sites-enabled/*
RUN ln -s /etc/apache2/sites-available/ /etc/apache2/sites-enabled/

# Change uid and gid of apache to docker user uid/gid

EXPOSE 80

ADD apache.sh /usr/bin/apache.sh
RUN chmod +x /usr/bin/apache.sh
ENTRYPOINT apache.sh

VOLUME /var/www

WORKDIR /var/www

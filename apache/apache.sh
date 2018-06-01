#! /bin/bash

a2enmod proxy
a2enmod proxy_fcgi
a2enmod rewrite

/usr/sbin/apache2ctl -D FOREGROUND

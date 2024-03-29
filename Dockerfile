FROM alpine:3.19
LABEL maintainer="ben.mm@franske.com"
LABEL description="Alpine based image for phpList."

# Setup apache and php
RUN apk --no-cache --update \
    add apache2 \
    curl \
    php83 \
    php83-apache2 \
    php83-gd \
    php83-gettext \
    php83-iconv \
    php83-imap \
    php83-mbstring \
    php83-mysqli \
    php83-openssl \
    php83-zip \
    php83-xml \
    php83-simplexml \
    php83-session \
    php83-curl \
    php83-xsl \
    bash \
    wget \
    runuser \
    && mkdir -p /var/www/phpList3

#Setup php command
RUN ln -s /usr/bin/php83 /usr/bin/php

RUN rm -rf /var/www/phpList3 && mkdir -p /var/www/phpList3
RUN rm -rf /etc/phplist && mkdir /etc/phplist

#Don't use git, use the released tgz file as the git repo has a bunch of development settings enabled
#RUN git clone -b release-3.6.14 https://github.com/phpList/phplist3.git /var/www/phpList3

RUN wget https://downloads.sourceforge.net/project/phplist/phplist/3.6.14/phplist-3.6.14.tgz
RUN tar zxf phplist-3.6.14.tgz
RUN mv /phplist-3.6.14/* /var/www/phpList3/
RUN rm -rf /phplist-3.6.14/
RUN chown -R apache:apache /var/www/phpList3

RUN cp /var/www/phpList3/docker/security.conf /etc/apache2/conf.d/
COPY docker-buildfiles/phplist-apache.conf /etc/apache2/conf.d/
COPY docker-buildfiles/phplist-config.php /etc/phplist/config.php
COPY docker-buildfiles/phplist-crontab /phplist-crontab
COPY docker-buildfiles/phplist-php.ini /etc/php83/conf.d/

RUN mkdir -p /var/tmp/phplistupdate && chown apache /var/tmp/phplistupdate

#Enable mod rewrite
RUN sed -i '/LoadModule rewrite_module/s/^#//g' /etc/apache2/httpd.conf

COPY docker-buildfiles/entrypoint.sh /
RUN chmod u+x /entrypoint.sh

EXPOSE 80

HEALTHCHECK CMD wget -q --no-cache --spider localhost

ENTRYPOINT ["/entrypoint.sh"]

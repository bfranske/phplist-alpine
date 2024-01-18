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
    bash \
    wget \
    && mkdir -p /var/www/phpList3

RUN rm -rf /var/www/phpList3 && mkdir -p /var/www/phpList3
RUN rm -rf /etc/phplist && mkdir /etc/phplist

#Don't use git, use the released tgz file as the git repo has a bunch of development settings enabled
#RUN git clone -b release-3.6.14 https://github.com/phpList/phplist3.git /var/www/phpList3

RUN wget https://downloads.sourceforge.net/project/phplist/phplist/3.6.14/phplist-3.6.14.tgz
RUN tar zxf phplist-3.6.14.tgz
RUN mv /phplist-3.6.14/* /var/www/phpList3/
RUN rm -rf /phplist-3.6.14/

RUN cp /var/www/phpList3/docker/security.conf /etc/apache2/conf.d/
COPY docker/alpine-apache-phplist.conf /etc/apache2/conf.d/
RUN cp /var/www/phpList3/docker/docker-phplist-config-live.php /etc/phplist/config.php
RUN cat /var/www/phpList3/docker/phplist-crontab >> /etc/crontabs/root

RUN mkdir -p /var/tmp/phplistupdate && chown apache /var/tmp/phplistupdate

#Enable mod rewrite
RUN sed -i '/LoadModule rewrite_module/s/^#//g' /etc/apache2/httpd.conf

COPY docker/alpine-entrypoint.sh /
RUN chmod u+x /alpine-entrypoint.sh

EXPOSE 80

HEALTHCHECK CMD wget -q --no-cache --spider localhost

ENTRYPOINT ["/alpine-entrypoint.sh"]

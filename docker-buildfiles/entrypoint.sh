#!/bin/bash

## entry point file, needed to be able to pass ENV vars from docker-compose.yml to the containers.

echo Initialising phpList, Please wait

exec 6>&1
exec > /usr/bin/phplist

echo '#!/bin/bash'
echo -n
echo 'exec 6>&1'
echo 'exec > /dev/null 2>&1'
printenv | sed 's/^\(.*\)$/export \1/g'
echo -n
echo 'exec 1>&6 6>&-'
echo /usr/bin/php83 /var/www/phpList3/public_html/lists/admin/index.php -c /etc/phplist/config.php \$\*

exec 1>&6 6>&-
chmod 755 /usr/bin/phplist

#Things to do only the first time this entrypoint runs
if [ ! -f /phplist-docker-data/entrypointrunonce ]; then
    # These things are only ever done once as the /phplist-docker-data/ directory persists on a docker volume

    touch /phplist-docker-data/entrypointrunonce
fi

# Things to do everytime the container is launched

## wait for the DB container, but not forever
UNCONNECTED=$(phplist | grep "Cannot connect")
COUNT=1
while [[ "$UNCONNECTED" ]] && [[ $COUNT -lt 11 ]] ; do
    echo Waiting for the Database to be available - $COUNT/10
    sleep 10;
    UNCONNECTED=$(phplist | grep "Cannot connect")
    COUNT=$(( $COUNT + 1 ))
done

if [[ "$UNCONNECTED" ]]; then
    echo Failed to find a Database to connect to
    exit;
fi

if [ "$PHPLISTINIT" = 1 ]; then
    echo "Running phpList Initialisation"
    /usr/bin/phplist -pinitialise
    /usr/bin/phplist -pinitlanguages
fi

## setup API access if enabled by environment variable, this only works after phplist setup has been done/initialization
if [ "$APIACCESS" = 1 ]; then
    echo "Enabling API Access"
    sed -i '/view: { view_response_listener: { enabled: /s/false/true/g' /var/www/phpList3/public_html/lists/base/config/config_modules.yml
    rm -rf /var/www/phpList3/public_html/lists/base/var/cache
fi

if [ "$OAUTH2_CONFIG" = 1 ]; then
    echo "Enabling OAUTH2 Cron Job"
    grep -qxF '*/5 * * * * /usr/bin/phplist -p processbouncesoauth2 -m OAuth2' /etc/crontabs/root || echo '*/5 * * * * /usr/bin/phplist -p processbouncesoauth2 -m OAuth2' >> /etc/crontabs/root
fi

cat /phplist-crontab >> /etc/crontabs/root
crond
echo $(phplist --version) READY
/usr/sbin/httpd -D FOREGROUND
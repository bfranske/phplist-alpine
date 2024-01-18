<?php

$database_host = getenv('DB_HOST');
$database_name = getenv('DB_NAME');
$database_user = getenv('DB_USER');
$database_password = getenv('DB_PASSWORD');
$mailhost = getenv('MAILHOST');
$allow_attachments = getenv('ALLOW_ATTACHMENTS');
$MANUALLY_PROCESS_BOUNCES = getenv('MANUALLY_PROCESS_BOUNCES');
$bounce_protocol = 'pop';
$bounce_mailbox_host = 'localhost';
$bounce_mailbox_user = 'popuser';
$bounce_mailbox_password = 'password';
$bounce_mailbox_port = '110/pop3/notls';
$bounce_mailbox_purge = 1;
$bounce_mailbox_purge_unprocessed = 1;
$bounce_unsubscribe_threshold = 5;
define('PHPMAILERHOST', $mailhost);
define('TEST', 0);
define('HASH_ALGO', 'sha256');
define('UPLOADIMAGES_DIR','images');
define ('MANUALLY_PROCESS_BOUNCES',$MANUALLY_PROCESS_BOUNCES);
define ('MANUALLY_PROCESS_QUEUE',0);
define('PHPMAILER_SECURE',0);
define('CHECK_REFERRER',false);
define("ALLOW_ATTACHMENTS",$allow_attachments);
define('PHPLIST_POWEREDBY_URLROOT','https://d3u7tsw7cvar0t.cloudfront.net/images');

$addonsUpdater = [
    'work' => '/var/tmp/phplistupdate',
];
$updaterConfig = [
    'work' => '/var/tmp/phplistupdate',
];
<?php

$database_host = getenv('DB_HOST');
$database_name = getenv('DB_NAME');
$database_user = getenv('DB_USER');
$database_password = getenv('DB_PASSWORD');
$mailhost = getenv('MAILHOST');
$allow_attachments = getenv('ALLOW_ATTACHMENTS');
$MANUALLY_PROCESS_BOUNCES = getenv('MANUALLY_PROCESS_BOUNCES');
if(getenv('message_envelope')){
    $message_envelope = getenv('message_envelope');
}
$bounce_protocol = getenv('bounce_protocol');
$bounce_mailbox_host = getenv('bounce_mailbox_host');
$bounce_mailbox_user = getenv('bounce_mailbox_user');
$bounce_mailbox_password = getenv('bounce_mailbox_password');
$bounce_mailbox_port = getenv('bounce_mailbox_port');
$bounce_mailbox_purge = getenv('bounce_mailbox_purge');
$bounce_mailbox_purge_unprocessed = getenv('bounce_mailbox_purge_unprocessed');
$bounce_unsubscribe_threshold = getenv('bounce_unsubscribe_threshold');
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

if(getenv('OAUTH2_CONFIG')){
    // for OAuth2 plugin
    if (isset($_GET['page']) && $_GET['page'] == 'authorise' && $_GET['pi'] == 'OAuth2') {
        ini_set('session.name', 'phpListSession');
        setcookie(
            'phpListSession',
            $_COOKIE['phpListSession'],
            ['expires' => 0, 'path' => '/', 'secure' => true, 'httponly' => true, 'samesite' => 'None']
        );
        session_start();
    }
}
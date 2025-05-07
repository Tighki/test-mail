<?php

/* Local configuration for Roundcube Webmail */

// ----------------------------------
// SQL DATABASE
// ----------------------------------
// Database connection string (DSN) for read+write operations
// Format (compatible with PEAR MDB2): db_provider://user:password@host/database
// Currently supported db_providers: mysql, pgsql, sqlite, mssql, sqlsrv, oracle
// For examples see http://pear.php.net/manual/en/package.database.mdb2.intro-dsn.php
// Note: for SQLite use absolute path (Linux): 'sqlite:////full/path/to/sqlite.db?mode=0646'
//       or (Windows): 'sqlite:///C:/full/path/to/sqlite.db'
// Note: Various drivers support various additional arguments for connection,
//       for Mysql: key, cipher, cert, capath, ca, verify_server_cert,
//       for Postgres: application_name, sslmode, sslcert, sslkey, sslrootcert, sslcrl, sslcompression, service.
//       e.g. 'mysql://roundcube:@localhost/roundcubemail?verify_server_cert=false'
$config['db_dsnw'] = 'mysql://root:php_mysql_pass@database-container/roundcube';

// ----------------------------------
// IMAP
// ----------------------------------
// The IMAP host chosen to perform the log-in.
// Leave blank to show a textbox at login, give a list of hosts
// to display a pulldown menu or set one host as string.
// Enter hostname with prefix ssl:// to use Implicit TLS, or use
// prefix tls:// to use STARTTLS.
// Supported replacement variables:
// %n - hostname ($_SERVER['SERVER_NAME'])
// %t - hostname without the first part
// %d - domain (http hostname $_SERVER['HTTP_HOST'] without the first part)
// %s - domain name after the '@' from e-mail address provided at login screen
// For example %n = mail.domain.tld, %t = domain.tld
// WARNING: After hostname change update of mail_host column in users table is
//          required to match old user data records with the new host.
$config['default_host'] = '192.168.1.45';

// ----------------------------------
// SMTP
// ----------------------------------
// SMTP server host (for sending mails).
// Enter hostname with prefix ssl:// to use Implicit TLS, or use
// prefix tls:// to use STARTTLS.
// Supported replacement variables:
// %h - user's IMAP hostname
// %n - hostname ($_SERVER['SERVER_NAME'])
// %t - hostname without the first part
// %d - domain (http hostname $_SERVER['HTTP_HOST'] without the first part)
// %z - IMAP domain (IMAP hostname without the first part)
// For example %n = mail.domain.tld, %t = domain.tld
// To specify different SMTP servers for different IMAP hosts provide an array
// of IMAP host (no prefix or port) and SMTP server e.g. ['imap.example.com' => 'smtp.example.net']
$config['smtp_server'] = '192.168.1.45';

// provide an URL where a user can get support for this Roundcube installation
$config['enable_installer'] = false;
// PLEASE DO NOT LINK TO THE ROUNDCUBE.NET WEBSITE HERE!
$config['support_url'] = '';

// This key is used for encrypting purposes, like storing of imap password
// in the session. For historical reasons it's called DES_key, but it's used
// with any configured cipher_method (see below).
// For the default cipher_method a required key length is 24 characters.
$config['des_key'] = 'MKXB3PukpBKj6mSYZEN4An5Y';

// Automatically add this domain to user names for login
// Only for IMAP servers that require full e-mail addresses for login
// Specify an array with 'host' => 'domain' values to support multiple hosts
// Supported replacement variables:
// %h - user's IMAP hostname
// %n - hostname ($_SERVER['SERVER_NAME'])
// %t - hostname without the first part
// %d - domain (http hostname $_SERVER['HTTP_HOST'] without the first part)
// %z - IMAP domain (IMAP hostname without the first part)
// For example %n = mail.domain.tld, %t = domain.tld
$config['username_domain'] = 'fltrktv.ru';


// Name your service. This is displayed on the login screen and in the window title
$config['product_name'] = 'FltrWebmail';

// ----------------------------------
// PLUGINS
// ----------------------------------
// List of active plugins (in plugins/ directory)
$config['plugins'] = [
	 'fetchmail',
	 'filters',
	 'userinfo',
	 'emoticons',
	 'newmail_notifier',
	 'reconnect'];

// the default locale setting (leave empty for auto-detection)
// RFC1766 formatted language name like en_US, de_DE, de_CH, fr_FR, pt_BR
$config['language'] = 'ru_RU';

$config['autocomplete_addressbooks'] = array('sql','ldap');

$config['ldap_public'] = array(
    'ldap' =>array (
        'name' => 'Общая адресная книга',
        'hosts' => array('openldap'),
        'sizelimit' => 600,
        'port' => 389,
        'use_tls' => false,
        'user_specific' => false,
        'base_dn' => 'ou=addressbook,dc=ramhlocal,dc=com',
        'bind_dn' => 'cn=admin,dc=ramhlocal,dc=com',//cn=admin,dc=ramhlocal,dc=com
        'bind_pass' => 'admin_pass',
        'writable' => false,
        'ldap_version' => 3,
        'search_fields' => array(
           'mail',
           'cn',
        ),
        'name_field' => 'cn',
        'email_field' => 'mail',
        'surname_field' => 'sn',
        'firstname_field' => 'givenName',
        //'organization_field'     => 'company',
        //'jobtitle_field'    => 'title',
        //'department_field'   => 'department',
        'sort' => 'sn',
        'scope' => 'sub',
        'filter' => '(&(objectClass=*))',
        //'filter' => '(&(mail=*)(|(&(objectcategory=person)(!(objectClass=computer)))(objectClass=group)))',
        'global_search' => true,
        'fuzzy_search' => true
    ),
);

$config['ldap_cache'] = 'db';
$config['ldap_cache_ttl'] = '10m';
$config['max_message_size'] = '100M';

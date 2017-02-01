# Vagrant - PHP Symfony bootstrap project

## LAMP Stack

Stack contains:
- Linux Debian 8.x Jessie
- Nginx 1.x
- PHP FPM (available versions: 5.6, 7.0, 7.1, for more look at: https://deb.sury.org/ )
- MariaDB 10.x
- Symfony 2.8

## Recomended changes in Symfony files after instalation:

1. composer.json

```json
[...]
"config": {
    "bin-dir": "bin",
    "component-dir": "web/component"
},
"extra": {
    "symfony-assets-install": "hard",
    "incenteev-parameters": {
        "file": "app/config/parameters.yml",
        "env-map": {
            "database_host": "SF2P_DATABASE_HOST",
            "database_port": "SF2P_DATABASE_PORT",
            "database_name": "SF2P_DATABASE_NAME",
            "database_user": "SF2P_DATABASE_USER",
            "database_password": "SF2P_DATABASE_PASSWORD",
            "mailer_transport": "SF2P_MAILER_TRANSPORT",
            "mailer_host": "SF2P_MAILER_HOST",
            "mailer_user": "SF2P_MAILER_USER",
            "mailer_password": "SF2P_MAILER_PASSWORD",
            "mailer_from_address": "SF2P_MAILER_FROM_ADDRESS",
            "mailer_from_name": "SF2P_MAILER_FROM_NAME",
            "upload_dir": "SF2P_UPLOAD_DIR",
            "secret": "SF2P_SECRET",
            [...]
        }
    }
}
[...]
```

2. web/app_dev.php

```php
if (isset($_SERVER['HTTP_CLIENT_IP'])
    || isset($_SERVER['HTTP_X_FORWARDED_FOR'])
    || !(in_array(@$_SERVER['REMOTE_ADDR'], array('127.0.0.1', 'fe80::1', '::1')) || php_sapi_name() === 'cli-server'
        || getenv('SYMFONY__VAGRANT') || (isset($_SERVER['SYMFONY__VAGRANT']) && $_SERVER['SYMFONY__VAGRANT']))
) {
    header('HTTP/1.0 403 Forbidden');
    exit('You are not allowed to access this file. Check '.basename(__FILE__).' for more information.');
}
```

3. app/AppKernel.php

```php
[...]
class AppKernel extends Kernel
{
    /**
     * var dirs (cache, log) path
     *
     * @var string
     */
    private $varPath;

    /**
    * {@inheritdoc}
    */
    public function __construct($environment, $debug)
    {
        $this->varPath = (
            getenv('SYMFONY__VAGRANT') || (isset($_SERVER['SYMFONY__VAGRANT']) && $_SERVER['SYMFONY__VAGRANT'])
        )
            ? '/dev/shm/www'
            : $this->getRootDir();

        parent::__construct($environment, $debug);
    }

    public function registerBundles()
    {
[...]
    public function getCacheDir()
    {
        return $this->varPath . '/cache/' . $this->environment;
    }

    public function getLogDir()
    {
        return $this->varPath . '/logs';
    }
[...]
```

4. app/phpunit.xml.dist

```xml
<?xml version="1.0" encoding="UTF-8"?>

<!-- https://phpunit.de/manual/current/en/appendixes.configuration.html -->
<phpunit xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:noNamespaceSchemaLocation="http://schema.phpunit.de/4.8/phpunit.xsd"
         backupGlobals="false"
         colors="true"
         bootstrap="autoload.php"
         backupStaticAttributes="false"
         convertErrorsToExceptions="false"
         convertNoticesToExceptions="false"
         convertWarningsToExceptions="false"
         processIsolation="false"
         stopOnFailure="false"
         syntaxCheck="false"
>
    <php>
        <ini name="error_reporting" value="-1" />
        <!-- <server name="KERNEL_DIR" value="/path/to/your/app/" /> -->
        <env name="SYMFONY_DEPRECATIONS_HELPER" value="weak" />
    </php>

    <testsuites>
        <testsuite name="Project Test Suite">
            <directory>../src/*/*Bundle/Tests</directory>
            <directory>../src/*/Bundle/*Bundle/Tests</directory>
            <directory>../src/*Bundle/Tests</directory>
        </testsuite>
    </testsuites>

    <filter>
        <whitelist addUncoveredFilesFromWhitelist="true">
            <directory suffix=".php">../src</directory>
            <exclude>
                <directory>../src/*Bundle/Resources</directory>
                <directory>../src/*Bundle/DataFixtures</directory>
                <directory>../src/*Bundle/Tests</directory>
                <directory>../src/*/*Bundle/Resources</directory>
                <directory>../src/*/*Bundle/DataFixtures</directory>
                <directory>../src/*/*Bundle/Tests</directory>
                <directory>../src/*/Bundle/*Bundle/Resources</directory>
                <directory>../src/*/Bundle/*Bundle/DataFixtures</directory>
                <directory>../src/*/Bundle/*Bundle/Tests</directory>
            </exclude>
        </whitelist>
    </filter>
</phpunit>
```

## Author:

[Aplisys Łukasz Jakubek](http://www.aplisys.pl)

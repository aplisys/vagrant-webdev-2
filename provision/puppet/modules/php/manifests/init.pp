class php {

  exec {
    'wget packages.sury.org key':
      command => 'curl -o /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg',
      path => ['/usr/bin', '/bin'];

    'php.list':
      command => 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/php.list',
      path => ['/usr/bin', '/bin'];

    'apt-get update php.list':
      command => 'apt-get update',
      path => ['/usr/bin'],
      require => [Exec['wget packages.sury.org key'], Exec['php.list']];
  }

  package { ["php${php_version}",
              "php${php_version}-fpm",
              "php${php_version}-cli",
              "php${php_version}-bcmath",
              "php${php_version}-bz2",
              "php${php_version}-curl",
              "php${php_version}-gd",
              "php${php_version}-intl",
              "php${php_version}-json",
              "php${php_version}-ldap",
              "php${php_version}-mbstring",
              "php${php_version}-mysql",
              "php${php_version}-opcache",
              "php${php_version}-pgsql",
              "php${php_version}-readline",
              "php${php_version}-sqlite3",
              "php${php_version}-xml",
              "php${php_version}-xmlrpc",
              "php${php_version}-zip",
              'php-apcu',
              'php-xdebug',
              'php-pear']:
    ensure => present,
    require => Exec['apt-get update php.list'];
  }

  service { 'php-fpm':
    ensure => running,
    require => Package["php${php_version}-fpm"],
    notify  => Service['nginx'];
  }

  file {
    "/etc/php/${php_version}/fpm":
      ensure => directory,
      require => Package["php${php_version}-fpm"];

    "/etc/php/${php_version}/fpm/php.ini":
      source  => "puppet:///modules/php/fpm-php${php_version}.ini",
      require => [
        File["/etc/php/${php_version}/fpm"],
        Package["php${php_version}-fpm"]
      ],
      notify  => Service['php-fpm'];

    "/etc/php/${php_version}/cli":
      ensure => directory,
      require => Package["php${php_version}-cli"];

    "/etc/php/${php_version}/cli/php.ini":
      source  => "puppet:///modules/php/cli-php${php_version}.ini",
      require => [
        File["/etc/php/${php_version}/cli"],
        Package["php${php_version}-cli"]
      ];
  }

  exec { 'composer-installer':
    command => 'curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/bin --filename=composer',
    path => ['/usr/bin'],
    require => Package['curl', "php${php_version}-cli"];
  }

  file { '/usr/bin/composer':
    ensure => file,
    mode => 'a+x',
    require => Exec['composer-installer'];
  }
}

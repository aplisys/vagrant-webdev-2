class php {

  file { '/etc/apt/trusted.gpg.d/php.gpg':
      ensure => present,
      source => 'https://packages.sury.org/php/apt.gpg'
  }

  exec {
    'php.list':
    command => 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/php.list',
    path => ['/usr/bin', '/bin'];
  'apt-get update php.list':
    command => 'apt-get update',
    path => ['/usr/bin'],
    require => Exec['php.list'];
  }

  package { [ "php${php_version}",
              "php${php_version}-fpm",
              "php${php_version}-cli"
            ]:
    ensure => present;
  }

  file {
    "/etc/php/${php_version}/fpm":
      ensure => directory;

    "/etc/php/${php_version}/fpm/php.ini":
      source  => "puppet:///modules/php/fpm-php${php_version}.ini",
      require => [
        File["/etc/php/${php_version}/fpm"],
        Package["php${php_version}-fpm"]
      ];

    "/etc/php/${php_version}/cli":
      ensure => directory;

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

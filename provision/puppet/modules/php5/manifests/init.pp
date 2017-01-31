class php5 {
  package { [ 'php5',
              'php5-common',
              'php5-cli',
              'libapache2-mod-php5',
              'php-pear',
              'php5-curl',
              'php5-gd',
              'php5-intl',
              'php5-json',
              'php5-mcrypt',
              'php5-mysql',
              'php5-sqlite',
              'php5-xdebug',
              'php5-xmlrpc',
              'php5-xsl',
              'php5-ldap']:
    ensure => present;
  }

  file {
    '/etc/php5/apache2':
      ensure => directory,
      before => File['/etc/php5/apache2/php.ini'];

    '/etc/php5/apache2/php.ini':
      source  => 'puppet:///modules/php5/apache2-php.ini',
      require => Package['php5'];

    '/etc/php5/cli':
      ensure => directory,
      before => File['/etc/php5/cli/php.ini'];

    '/etc/php5/cli/php.ini':
      source  => 'puppet:///modules/php5/cli-php.ini',
      require => Package['php5-cli'];
  }

  exec { 'composer-installer':
    command => 'curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/bin --filename=composer',
    path => ['/usr/bin'],
    require => Package['curl', 'php5-cli'];
  }

  file { '/usr/bin/composer':
    ensure => file,
    mode => 'a+x',
    require => Exec['composer-installer'];
  }
}

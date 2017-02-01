class composer {
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

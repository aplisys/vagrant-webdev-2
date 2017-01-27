class apache_vhosts {
  file { '/var/www':
    ensure => directory;
  }

  apache_vhosts::vhost { ['000-default.conf']: }
}

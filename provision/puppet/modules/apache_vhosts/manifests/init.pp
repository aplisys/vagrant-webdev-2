class apache_vhosts {
  file {
    '/var/www':
      ensure => directory;
    '/var/www/html':
      ensure => absent;
  }

  apache_vhosts::vhost { ['000-default.conf']: }
}

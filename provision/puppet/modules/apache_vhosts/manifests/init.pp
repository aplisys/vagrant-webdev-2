class apache_vhosts {
  file {
    '/var/www/vagrant':
      ensure => directory;
  }

  apache_vhosts::vhost { ['000-default.conf']: }
}

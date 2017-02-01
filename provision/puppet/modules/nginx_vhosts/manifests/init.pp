class nginx_vhosts {
  file {
    '/var/www/vagrant':
      ensure => directory;
  }

  nginx_vhosts::vhost { ['000-default.conf']: }
}

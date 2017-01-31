class nginx_vhosts {
  file {
    '/var/www':
      ensure => directory;
    '/var/www/html':
      ensure => absent;
  }

  nginx_vhosts::vhost { ['000-default.conf']: }
}

class nginx_vhosts {
  file { '/var/www':
    ensure => directory;
  }

  nginx_vhosts::vhost { ['000-default.conf']: }
}

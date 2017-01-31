class nginx {
  package { ['nginx']:
    ensure => present;
  }

  service { 'nginx':
    ensure => running,
    require => Package['nginx'];
  }

  file {
    '/etc/nginx/sites-enabled/default':
      ensure  => absent,
      require => Package['nginx'],
      notify  => Service['nginx'];
  }
}

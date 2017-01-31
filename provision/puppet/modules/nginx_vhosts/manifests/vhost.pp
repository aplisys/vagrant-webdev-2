define nginx_vhosts::vhost() {
  file {
    "/etc/nginx/sites-available/${name}":
      ensure  => present,
      content  => template("nginx_vhosts/${name}.erb"),
      require => Package['nginx'],
      notify  => Service['nginx'];

    "/etc/nginx/sites-enabled/${name}":
      ensure  => link,
      target  => "/etc/nginx/sites-available/${name}",
      require => Package['nginx'],
      notify  => Service['nginx'];
  }
}

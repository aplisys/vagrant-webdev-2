define apache_vhosts::vhost() {
  file {
    "/etc/apache2/sites-available/${name}":
      content  => template("apache_vhosts/${name}.erb"),
      require => Package['apache2'],
      notify  => Service['apache2'];

    "/etc/apache2/sites-enabled/${name}":
      ensure => link,
      target => "/etc/apache2/sites-available/${name}",
      notify => Service['apache2'];
  }
}

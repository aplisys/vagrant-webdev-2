class vardata {
  file {
    '/dev/shm/www':
      ensure => 'directory';
    ['/dev/shm/www/cache', '/dev/shm/www/logs']:
      ensure => 'directory',
      require => File['/dev/shm/www'];
  }

  exec {
    'setfacl -R':
      command => 'setfacl -R -m u:www-data:rwX -m u:vagrant:rwX /dev/shm/www/cache /dev/shm/www/logs',
      path => ['/usr/bin'],
      require => [Package['acl'], File['/dev/shm/www/cache', '/dev/shm/www/logs']];
    'setfacl -dR':
      command => 'setfacl -dR -m u:www-data:rwX -m u:vagrant:rwX /dev/shm/www/cache /dev/shm/www/logs',
      path => ['/usr/bin'],
      require => [Package['acl'], File['/dev/shm/www/cache', '/dev/shm/www/logs']];
  }
}

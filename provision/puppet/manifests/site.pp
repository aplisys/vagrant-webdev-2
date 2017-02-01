stage { 'pre':
  before => Stage['main']
}

class { 'baseconfig':
  stage => 'pre'
}

File {
  owner => 'root',
  group => 'root',
  mode => '0644',
}

include baseconfig, php, composer, nginx, nginx_vhosts, mariadb, vardata

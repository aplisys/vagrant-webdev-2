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

include baseconfig, php, nginx, nginx_vhosts, mariadb, vardata

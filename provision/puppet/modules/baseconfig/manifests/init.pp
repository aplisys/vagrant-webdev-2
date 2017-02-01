class baseconfig {
  exec { 'apt-get update':
    command => 'apt-get update',
    path => ['/usr/bin'];
  }

  host {
    'hostmachine':
      ip => '10.13.8.1';
    'vagrant':
      ip => '127.0.0.1',
      host_aliases => ['vagrant.dev', $project_name, "${project_name}.dev"];
  }

  package { ['tmux',
              'vim',
              'git',
              'htop',
              'curl',
              'elinks',
              'acl',
              'apt-transport-https',
              'lsb-release',
              'ca-certificates']:
    ensure => present;
  }

  file {
    '/etc/tmux.conf':
      source => 'puppet:///modules/baseconfig/tmux.conf',
      require => Package['tmux'];

    '/etc/profile.d/vagrant.sh':
      source => 'puppet:///modules/baseconfig/vagrant.sh';
  }

  ssh_authorized_key { 'lukaszjakubek@moneo' :
    ensure          => present,
    name            => 'lukaszjakubek@moneo',
    user            => 'vagrant',
    type            => 'ssh-rsa',
    key             => 'AAAAB3NzaC1yc2EAAAADAQABAAACAQDAVAuxdWiixYHwWTnAu3Qk5gtY+3NjAiMkZvGrgO/5D32LAxo4oAw8iOZxL6zj7Nzhb3zvAlcA2EJVY8O+ZgGcOPJ0fvYZgg1Kd7iB2rcZj3QuO5Xym9hTyLb1EtV0TxlTgMsamAcpnFBraZbX/dBQpwWdxMmdy2JwlTsRCRLbY+jAkV+lHQq2MThAsvymVslVOdLzyhLJ3uPxVJ2P1bHcDfYqJu3NCHJFZPyKpTZ/5TeyIIHeTr0Rdw4f0ZUSNUZ+6uhFZUof4JLxwrm99vl6RH+DS0KOOQHo6RoknJ1sgsududS+5BKlIxjfCpMa90vrQeYbM0ZTmsvlmHjrXw4up3mhNM3Q468PkO3tc39SAg1UPqFj1xJ2+Rl5FqF+v0pUN90d4mT5hlcACvOXKHxdwEyEEyAmYutGwRQxqvE8StXPnZA91WTxHaaSpWoDo9qvw9voCscvcuAwgJhBvM6+5uwgkdFfBvQLhxZ+dSDARt9/1IydvSOxAS4y2FtgpXdRTqqfE4ymkU0d2qRKl8GXU2D/QTbB9uYkib+MgdjYQZNzLbkBHzJoA3XCce+AOGsvInY7doGKdIjLUXgMEhcgDVM6kuL9bwBsIOp6miN/LMJK7xDUL1LDxtZl8JNXl3q7WccXOohgfQwmS7HOKFOKSxPVY1S7qZRU1RJuN4WcpQ==',
  }
}

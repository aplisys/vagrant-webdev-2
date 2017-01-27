class mariadb {
  package { ['mariadb-server']:
    ensure => present;
  }

  service { 'mysql':
    ensure => running,
    require => Package['mariadb-server'];
  }

  file { '/etc/mysql/my.cnf':
    source  => 'puppet:///modules/mariadb/my.cnf',
    require => Package['mariadb-server'],
    notify  => Service['mysql'];
  }

  exec {
    'set-mysql-password':
      unless  => 'mysqladmin -uroot -pvagrant status',
      command => "mysqladmin -uroot password vagrant",
      path    => ['/bin', '/usr/bin'],
      require => Service['mysql'];
    'add-users':
      command => 'mysql -u root -pvagrant -e "CREATE USER \'root\'@\'%\' IDENTIFIED BY \'vagrant\'; GRANT ALL ON *.* TO \'root\'@\'%\' WITH GRANT OPTION; FLUSH PRIVILEGES;"',
      path    => ['/bin', '/usr/bin'],
      require => Exec['set-mysql-password'];
    'add-project-user':
      unless => "mysql -u ${project_name} -p${project_name} -e \"SHOW DATABASES;\"",
      command => "mysql -u root -pvagrant -e \"CREATE USER '${project_name}'@'%' IDENTIFIED BY '${project_name}'; GRANT ALL ON \\`${project_name}\\`.* TO '${project_name}'@'%'; FLUSH PRIVILEGES;\"",
      path    => ['/bin', '/usr/bin'],
      require => Exec['set-mysql-password'];
    'add-project-database':
      unless => "mysql -u ${project_name} -p${project_name} ${project_name} -e \"SHOW TABLES;\"",
      command => "mysql -u ${project_name} -p${project_name} -e \"CREATE DATABASE \\`${project_name}\\` CHARACTER SET 'utf8mb4' COLLATE 'utf8mb4_unicode_ci';\"",
      path    => ['/bin', '/usr/bin'],
      require => Exec['add-project-user'];
  }
}

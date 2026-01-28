class profile::base {
  # require Class['profile::apt']
  file { '/srv/src':
    ensure => 'directory',
    path   => '/srv/src',
    mode   => '0755',
  }

  file { '/srv/app':
    ensure => 'directory',
    path   => '/srv/app',
    mode   => '0755',
  }
}

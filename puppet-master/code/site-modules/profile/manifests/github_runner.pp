class profile::github_runner {
  $src_path = lookup('profile::github_runner::src_path')
  $runner_version = lookup('profile::github_runner::runner_version')
  $user = lookup('profile::github_runner::user')
  $uid = lookup('profile::github_runner::user_uid')
  $gid = lookup('profile::github_runner::user_gid')
  $repo = lookup('profile::github_runner::repo')
  $register_token = lookup('profile::github_runner::register_token')
  $required_pkgs = lookup('profile::github_runner::required_pkgs')

  file { $src_path:
    ensure  => 'directory',
    owner   => $user,
    group   => $user,
    mode    => '0755',
    require => User[$user],
  }

  group { $user:
    ensure => present,
    gid    => $gid,
    system => true,
  }


  user { $user:
    ensure     => present,
    uid        => $uid,
    gid        => $gid,
    shell      => '/bin/bash',
    home       => "/home/${user}",
    managehome => true,
    system     => true,
    require    => Group[$user],
  }

  # Download the GitHub runner tarball
  file { "${src_path}/actions-runner-linux-x64-${runner_version}.tar.gz":
    ensure  => 'file',
    source  => "https://github.com/actions/runner/releases/download/v${runner_version}/actions-runner-linux-x64-${runner_version}.tar.gz",
    owner   => $user,
    group   => $user,
    mode    => '0755',
    require => File[$src_path],
  }

  exec { "extract_runner_${runner_version}":
    command => "tar -xzf ${src_path}/actions-runner-linux-x64-${runner_version}.tar.gz -C ${src_path}",
    user    => $user,
    group   => $user,
    path    => ['/usr/bin', '/bin'],
    creates => "${src_path}/config.sh",
    require => File["${src_path}/actions-runner-linux-x64-${runner_version}.tar.gz"],
    notify  => Exec['register_runner'],
  }

  package { $required_pkgs:
    ensure => installed,
  }

  exec { 'register_runner':
    command     => inline_template('./config.sh --unattended --url <%= @repo %> --token <%= @register_token %>' ),
    cwd         => $src_path,
    user        => $user,
    provider    => 'shell',
    refreshonly => true,
    require     => [
      Exec["extract_runner_${runner_version}"],
      User[$user],
      Package[$required_pkgs],
    ],
    notify      => Service['actions.runner.service'],
  }

  file { '/etc/systemd/system/actions.runner.service':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => "[Unit]
Description=GitHub Actions Runner
After=network.target

[Service]
ExecStart=${src_path}/runsvc.sh
User=${user}
WorkingDirectory=${src_path}
KillMode=process
KillSignal=SIGTERM
TimeoutStopSec=5min

[Install]
WantedBy=multi-user.target
",
    notify  => Exec['systemd-daemon-reload'],
    require => Exec['register_runner'],
  }

  service { 'actions.runner.service':
    ensure  => 'running',
    enable  => true,
    require => [
      File['/etc/systemd/system/actions.runner.service'],
      Exec['register_runner'],
      Exec['systemd-daemon-reload'],
      User[$user],
    ],
  }

  exec { 'systemd-daemon-reload':
    command     => '/bin/systemctl daemon-reload',
    refreshonly => true,
    path        => ['/bin', '/usr/bin'],
  }
}

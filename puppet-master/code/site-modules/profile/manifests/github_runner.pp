class profile::github_runner (
  String $app_path,
  String $src_path,
  String $runner_version,
  String $user,
  Integer $user_uid,
  Integer $user_gid,
  String $repository,
  String $github_token,
  Array[String] $required_pkgs,
) {
  $service_name = "actions.runner.${regsubst($repository, '/', '-', 'G')}.${facts['networking']['hostname']}.service"

  file { $src_path:
    ensure  => 'directory',
    path    => $src_path,
    owner   => $user,
    group   => $user,
    mode    => '0755',
    require => [
      User[$user],
      File['/srv/src'],
    ],
  }

  file { $app_path:
    ensure  => 'directory',
    path    => $app_path,
    owner   => $user,
    group   => $user,
    mode    => '0755',
    require => [
      User[$user],
      File['/srv/app'],
    ],
  }

  group { $user:
    ensure => present,
    gid    => $user_gid,
    system => true,
  }

  user { $user:
    ensure     => present,
    uid        => $user_uid,
    gid        => $user_gid,
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
    command => "tar -xzf ${src_path}/actions-runner-linux-x64-${runner_version}.tar.gz -C ${app_path}",
    user    => $user,
    group   => $user,
    path    => ['/usr/bin', '/bin'],
    creates => "${src_path}/config.sh",
    require => [
      File["${src_path}/actions-runner-linux-x64-${runner_version}.tar.gz"],
      File[$app_path]
    ],
    notify  => Exec['register_runner'],
  }

  package { $required_pkgs:
    ensure => installed,
    # require => Exec['apt_update'],
  }

  exec { 'register_runner':
    command     => "CONFIG_TOKEN=\$(curl -sX POST -H \"Accept: application/vnd.github+json\" -H \"Authorization: Bearer ${github_token}\" -H \"X-GitHub-Api-Version: 2022-11-28\" https://api.github.com/repos/${repository}/actions/runners/registration-token | jq -r \'.token\') && ./config.sh --unattended --url https://github.com/${repository} --token \$CONFIG_TOKEN",
    cwd         => $app_path,
    user        => $user,
    provider    => 'shell',
    refreshonly => true,
    notify      => Exec['svc_install'],
    require     => [
      Exec["extract_runner_${runner_version}"],
      User[$user],
    ],
  }

  exec { 'svc_install':
    command     => "${app_path}/svc.sh install",
    cwd         => $app_path,
    refreshonly => true,
    notify      => Service[$service_name],
    require     => [
      Exec["extract_runner_${runner_version}"],
      User[$user],
    ],
  }

  service { $service_name:
    ensure  => 'running',
    enable  => true,
    require => [
      Exec['svc_install'],
    ],
  }
}

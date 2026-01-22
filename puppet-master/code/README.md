# Puppet Code Directory

This directory contains your Puppet manifests and modules.

## Directory Structure

```
code/
└── environments/
    └── production/
        ├── manifests/
        │   └── site.pp          # Main site manifest - node definitions go here
        └── modules/             # Custom modules go here
            └── your_module/
                ├── manifests/
                ├── files/
                ├── templates/
                └── tests/
```

## Quick Start

### 1. Node Definitions (manifests/site.pp)

Define what configuration should be applied to specific nodes:

```puppet
node 'client' {
  file { '/tmp/hello.txt':
    ensure  => file,
    content => "Hello from Puppet!\n",
  }
}
```

### 2. Create a Module

```bash
cd modules/
mkdir -p myapp/{manifests,files,templates}
```

Then create `modules/myapp/manifests/init.pp`:

```puppet
class myapp {
  package { 'nginx':
    ensure => installed,
  }
  
  service { 'nginx':
    ensure  => running,
    enable  => true,
    require => Package['nginx'],
  }
}
```

Use it in site.pp:

```puppet
node 'client' {
  include myapp
}
```

## Notes

- Changes to manifests take effect immediately (no restart needed)
- The puppet agent runs every 30 seconds and will pick up changes
- Check syntax: `puppet parser validate manifests/site.pp`

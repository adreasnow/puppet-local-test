class profile::base {
  file { '/tmp/hello.txt':
    ensure  => file,
    content => "Hello from Puppet!\n",
    mode    => '0644',
  }
}

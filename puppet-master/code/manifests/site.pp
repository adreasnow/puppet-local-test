# Main site manifest
# This is where you define what should be applied to your nodes

node default {
  notify { "No configuration for ${facts['networking']['fqdn']}": }
}

node 'client' {
  include role::client
}

# Class: rjil::jiocloud::consul::bootstrapserver
#

class rjil::jiocloud::consul::bootstrapserver(
  $bootstrap_expect = 1,
  $bind_addr        = '0.0.0.0',
) {
  class { 'rjil::jiocloud::consul':
    config_hash => {
      'bind_addr'        => $bind_addr,
      'data_dir'         => '/var/lib/consul-jio',
      'log_level'        => 'INFO',
      'server'           => true,
      'bootstrap_expect' => $bootstrap_expect + 0,
      'datacenter'       => $::consul_discovery_token,
    }
  }
}

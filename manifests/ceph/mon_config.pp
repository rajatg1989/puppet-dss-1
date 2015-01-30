#
# Class: rjil::ceph::mon_config
#  Setup mon configuration for ceph storage nodes and clients except mon
#  nodes.
#  NOTE:: MON NODES WILL USE rjil::ceph::mon::mon_config
#
# [Parameters]
#   Mon_config is array of IP addresses to be configured as mons.
#   Defaults to the addresses that are A records for stmon.service.consul
#
class rjil::ceph::mon_config (
  $mon_config = split(dns_resolve('stmon.service.consul'),','),
) {

  if ! empty($mon_config) {
    ::ceph::conf::mon_config{ $mon_config: }
    $fail = false
  } else {
    $fail = true
  }

  # mon_config should be finished before any ceph::auth execution which will
  # reduce the time required for ceph setup
  Ceph::Conf::Mon_config<||> -> Ceph::Auth<||>

  runtime_fail {'monlist_empty_fail':
    fail    => $fail,
    message => 'External Mon list cannot be empty for non-mon nodes',
  }

}

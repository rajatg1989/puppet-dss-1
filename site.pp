Exec {
  path      => ["/bin/", "/sbin/", "/usr/bin/", "/usr/sbin/", "/usr/local/bin/", "/usr/local/sbin/"],
  logoutput => true
}

##
# setup ceph configuration and osds on st nodes
# These nodes wait at least one stmon to be registered in consul.
##

node /^dssst\d+/ {
  include rjil::base
  include rjil::ceph
  include rjil::ceph::mon_config
  include rjil::ceph::osd
  ensure_resource('rjil::service_blocker', 'stmon', {})
  Class['rjil::base'] -> Rjil::Service_blocker['stmon'] ->
  Class['rjil::ceph::osd']
}

##
# single leader that will be used to ensure that all mons form a single cluster.
#
# The only difference in stmon and stmonleader is that stmonleader is the node
# which starts first in the ceph cluster initialization. After that, both
# those roles will serve the same purpose.
# All ceph servers and clients (st, stmon, cp, oc nodes) except stmonleader will wait for at least
# one "stmon" service node in consul.
#
# The leader will register the service in consul with name "stmon" (or
# any other name if overridden in hiera).
#
##

node /^dssmonleader1/ {
  include rjil::base
  include rjil::ceph
  include rjil::ceph::mon
  include rjil::ceph::radosgw
  include rjil::jiocloud::consul::consul_alerts

  rjil::jiocloud::consul::service { 'stmonleader':
    port          => 6789,
    check_command => '/usr/lib/jiocloud/tests/check_ceph_mon.sh'
  }
}

##
# setup ceph osd and mon configuration on ceph Mon nodes.
# All ceph mon nodes are registered in consul as service name "stmon" (or any
# other name if overridden)
#
# stmon nodes will wait at least one "stmon" service to be up in consul before
# initialize themselves
##

node /^dssmon\d+/ {
  include rjil::base
  include rjil::ceph
  include rjil::ceph::mon
  include rjil::ceph::radosgw
  ensure_resource('rjil::service_blocker', 'stmonleader', {
  }
  )
  Class[rjil::base] -> Rjil::Service_blocker['stmonleader']
  Rjil::Service_blocker['stmonleader'] -> Class['rjil::ceph::mon::mon_config']
}

node /^httpproxy\d+/ {
  include rjil::base
  include rjil::http_proxy

  dnsmasq::conf { 'google':
    ensure  => present,
    content => 'server=8.8.8.8',
  }
  include rjil::jiocloud::vagrant::dhcp
}




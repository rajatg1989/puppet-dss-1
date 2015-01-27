#
# Class: rjil::test::ceph_radosgw
#   Adding tests for nova services
#

class rjil::test::ceph_radosgw (
  $ssl  = false,
  $port = 6000,
){

  ensure_resource('package','python-swiftclient',{})

  file { "/usr/lib/jiocloud/tests/ceph_radosgw.sh":
    content => template('rjil/tests/ceph_radosgw.sh.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }

}

#
# Define: rjil::test::ceph_osd
#   Adding tests for nova services
#

define rjil::test::ceph_osd (
  $disk = $name,
){

  file { "/usr/lib/jiocloud/tests/ceph_osd_${disk}.sh":
    content => template('rjil/tests/ceph_osd.sh.rb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }

}

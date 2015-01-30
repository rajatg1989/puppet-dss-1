#
# Class: rjil::test::cinder
#   Adding tests for cinder services
#

define rjil::test::check(
  $port       = 0,
  $address    = '127.0.0.1',
  $ssl        = false,
  $type       = 'http',
  $check_type = 'service',
) {

  include rjil::test::base

  if $check_type == 'service' {
    $test_file = "/usr/lib/jiocloud/tests/service_checks/${name}.sh"
  } elsif $check_type == 'validation' {
    $test_file = "/usr/lib/jiocloud/tests/${name}.sh"
  } else {
    fail("Invalid check_type - $check_type)")
  }

  file { $test_file:
    content => template("rjil/tests/${type}_check.sh.erb"),
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }

}

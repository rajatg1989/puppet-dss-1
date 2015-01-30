#
# Base class that sets up tests
#
class rjil::test::base(
  $nagios_base_dir = '/usr/lib/nagios/plugins',
) {

  File {
    owner => 'root',
    group => 'root',
  }

  package { 'nagios-plugins':
    ensure => present,
  }

  file { '/usr/lib/jiocloud':
    ensure => directory,
  }

  file { '/usr/lib/jiocloud/tests':
    ensure => directory,
  }

  file { '/usr/lib/jiocloud/tests/service_checks':
    ensure => 'directory',
  }

  # Add a custom nagios check for killall -0
  file { "${nagios_base_dir}/check_killall_0":
    source  => 'puppet:///modules/rjil/tests/nagios_killall_0',
    mode    => '0755',
    require => Package['nagios-plugins'],
  }

}

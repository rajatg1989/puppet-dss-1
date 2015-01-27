#
# This class is used to manage all services that should not
# be started during the initial bootstrappig package install.
#
class rjil::system::sensitive_services(
  $service_list = ['collectd']
) {

  File['/usr/sbin/policy-rc.d'] -> Package<||>
  File['/etc/sensitive_services'] -> Package<||>

  # this file can be used to override the default package policy for
  # starting services
  file { '/usr/sbin/policy-rc.d':
    source => 'puppet:///modules/rjil/package_start_policy.sh',
    mode   => '0755',
    tag    => 'package',
  }

  # This file is just for bootstrapping central services. Once this file exists,
  # the entries should be deleted from file_line resources, so the file should
  # not be updated by this resource if it already exists
  file { '/etc/sensitive_services':
    content => template('rjil/sensitive_services.erb'),
    replace => false,
    tag     => 'package',
  }

  rjil::system::sensitive_services::activator { $service_list: }

}

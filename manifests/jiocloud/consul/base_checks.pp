#
# Class: rjil::jiocloud::consul::base_checks
# Setup Validation checks for Puppet runs
#
class rjil::jiocloud::consul::base_checks(
  # default to 24 hours
  $puppet_ttl       = '1440m',
  # default to one hour
  $validation_ttl   = '60m',
) {

  rjil::jiocloud::consul::service { 'puppet':
    check_command => false,
    ttl           => $puppet_ttl,
  }

  rjil::jiocloud::consul::service { 'validation':
    check_command => false,
    ttl           => $validation_ttl,
  }

}

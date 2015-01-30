#
# Class rjil::default_manifest
#
class rjil::default_manifest {
  if ($::settings::default_manifest == './manifests') {
    $val = '/etc/puppet/manifests/site.pp'
  } else {
    $val = $::settings::default_manifest
  }

  ini_setting { 'default_manifest':
    path    => '/etc/puppet/puppet.conf',
    section => main,
    setting => default_manifest,
    value   => $val
  }
}

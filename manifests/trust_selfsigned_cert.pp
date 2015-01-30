#
# Class rjil::trust_selfsigned_cert
#

class rjil::trust_selfsigned_cert(
  $cert             = '/etc/ssl/certs/jiocloud.com.crt',
  $ssl_cert_package = 'jiocloud-ssl-certificate',
) {

  ##
  # jiocloud-ssl-certificate to be installed on all servers
  ##
  ensure_packages($ssl_cert_package)

  ##
  # Trust this self signed certificate, without this code openstack clients
  # will throw ssl errors while connecting.
  ##
  package { 'ca-certificates':
    ensure => installed,
  }

  file { '/usr/local/share/ca-certificates/selfsigned.crt':
    ensure  => link,
    source  => $cert,
    require => [Package['ca-certificates'],Package[$ssl_cert_package]],
    notify  => Exec['update-cacerts'],
  }

  exec { 'update-cacerts':
    command     => 'update-ca-certificates --fresh',
    refreshonly => true,
  }

}

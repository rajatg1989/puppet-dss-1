##
## Class rjil::system::ntp
##
class rjil::system::ntp(
  $server       = false,
  $server_array = hiera('ntp::servers'),
  $run_ntpdate  = true,
) {

  $servers = join($server_array, ' ')

  ## hiera_configs required
  ## There will be two internal ntp servers which would be used for timesync on other servers
  ## ntp servers will be sync the time from external time source (or ril time servers)
  ## ::ntp::servers - An array of ntp server IP addresses
  ##                  For ntp servers this will be external ntp server and
  ##                  For other servers these will be internal ntp servers
  ## ::ntp::udlc - to enable sync with local clock if external servers are not available.
  ##               This will be useful on internal ntp servers if in some case external servers are not
  ##               available for some time.

  include ::ntp

  if $server {
    rjil::jiocloud::consul::service { 'ntp':
      port          => 123,
      check_command => '/usr/lib/jiocloud/tests/ntp.sh',
    }
  }

  if $run_ntpdate {
    if($servers =~ /ntp.service.consul/) {
      rjil::service_blocker { 'ntp':
        before => Exec['ntpdate'],
      }
    }
    exec { "ntpdate":
      command => "/usr/sbin/ntpdate $servers",
      unless  => '/usr/bin/pkill -0 ntpd',
      before  => Package[ntp]
    }
  } else {
    if($servers =~ /ntp.service.consul/) {
      rjil::service_blocker { 'ntp':
        before => Package[ntp],
      }
    }
  }

  ##
  ## Add tests
  ## There should be better tests, for now just adding process monitor
  ##
  rjil::test {'ntp.sh':}

}

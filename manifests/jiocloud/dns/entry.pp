define rjil::jiocloud::dns::entry (
  $ip = false,
  $cname = false
) {
  include ::dnsmasq::reload

  if (!($ip or $cname)) {
    fail("DNS entry ${name} had neither IP nor CNAME specified")
  }

  if ($ip) {
    $ip_real = $ip
  } else {
    $ips = split(dns_resolve($cname),',')
    $ip_real = $ips[0]
  }

  host { $name:
    ip     => $ip_real,
    notify => Class['Dnsmasq::Reload']
  }
}

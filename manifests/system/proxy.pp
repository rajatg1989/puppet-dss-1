define rjil::system::proxy(
  $url = false
) {
  if ($url) {
    $ensure = 'present'
  } else {
    $ensure = 'absent'
  }
  file_line { "${name}-proxy":
    ensure => $ensure,
    path   => '/etc/environment',
    line   => "${name}_proxy=\"${url}\"",
    match  => "^${name}_proxy="
  }
}

#
# Used to active services. This is done by removing
# the service name line from our sensitive_services
# config file.
#
define rjil::system::sensitive_services::activator {

  Service<| title == $name |> -> File_line["sensitive_service_${name}"]

  file_line { "sensitive_service_${name}":
    ensure => absent,
    path   => '/etc/sensitive_services',
    line   => $name,
  }

}

#
# This resource blocks until an expected service is registered
# with consul. It assumes that the environment used as the
# datacenter for consul default to $::env.
#
# It assumes that the address for each service is
#
#   ${name}.service.${datacenter}.consul
#
# It also assumes that addresses will not resolve if the
# backend service does not work (do it defers ensuring
# the service is resolvable to consul)
#
define rjil::service_blocker(
  $tries      = 30,
  $try_sleep  = 20,
  $datacenter = $::consul_discovery_token,
) {

  $service_hostname = "${name}.service.${datacenter}.consul"

  dns_blocker { $service_hostname:
    try_sleep => $try_sleep,
    tries     => $tries,
  }

  Exec <| title == 'reload-consul' |> -> Rjil::Service_blocker[$name]

}

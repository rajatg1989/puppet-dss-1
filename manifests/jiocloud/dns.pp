#
# Class: rjil::jiocloud::dns
#

class rjil::jiocloud::dns(
  $entries = {}
) {
  create_resources(rjil::jiocloud::dns::entry, $entries)
}

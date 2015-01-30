#
# Class: rjil::jiocloud::consul::cron 
# Schedule a cron run for publishing consul servers on bootstrapservers
#

class rjil::jiocloud::consul::cron {

  file { "/usr/local/bin/publish-consul-servers.py":
    source => 'puppet:///modules/rjil/publish-consul-servers.py',
    mode => "0755"
  }

  cron { "publish-consul-servers":
    command => "su -c 'python /usr/local/bin/publish-consul-servers.py ${::consul_discovery_token}'"
  }
}

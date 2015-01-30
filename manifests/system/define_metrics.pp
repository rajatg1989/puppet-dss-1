define rjil::system::define_metrics(
  $instance,
  $persist,
  $persistok,
  $disks             = [],
  $disk_percent_warn = undef,
  $disk_percent_fail = undef,
  $memory_warn       = undef,
  $cpu_warn          = undef,
  $check_ttl         = '60m',
) {

  #Generate a file
  file { "/etc/collectd/conf.d/20-thresholds_$name.conf":
    content => template("rjil/collectd/thresholds-$name.conf.erb"),
    notify  => Service['collectd'],
  }
  rjil::jiocloud::consul::service { "metric_thresholds_$name":
    interval     => '60m',
    tags          => ['metrics'],
    check_command => false,
    ttl           => $check_ttl,
  }
}

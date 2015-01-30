#
# Class rjil::ceph::mon
# Purpose: Configure ceph mon
#
# == Parameters
#
# [*public_if*]
#   Public/storage access network interface. This interface is used to access
#   ceph storage from ceph clients.
#
# [*key*]
#   Ceph mon secret key. This is used to generate all other keys for different
#   users and/or services
#
# [*mon_service_name*]
#   Service name from consul dns interface.
#
# [*pools*]
#   Ceph pools to be created
#
# [*pool_pg_num*]
#   Number of placement groups per pool, default: 128.
#   Note: This is a tunable for performance.
#

class rjil::ceph::mon (
  $key,
  $public_if        = 'eth0',
  $mon_service_name = 'stmon',
  $pools            = ['volumes','backups','images'],
  $rgw_index_pools  = ['.rgw.root', '.rgw.control', '.rgw.gc', '.rgw', '.users.uid', '.rgw.buckets.index'],
  $rgw_data_pools   = ['.rgw.buckets'],
  $pool_pg_num      = 128,
  $index_pool_pg_num= 32,
  $pool_size  = 3,
  $data_pool_pg_num = 128,
) {


  ## Derive mon_addr - this is the IP address of public interface on mon node

  $mon_addr = inline_template("<%= scope.lookupvar('ipaddress_' + @public_if) %>")

  ##
  # Add mon configuration on all mon nodes.
  ##

  class { 'rjil::ceph::mon::mon_config':
    public_if       => $public_if,
    mon_service_name=> "${mon_service_name}.service.consul",
  }

  contain 'rjil::ceph::mon::mon_config'

  ##
  # Setup ceph mons
  ##

  ::ceph::mon { $::hostname:
    monitor_secret => $key,
    mon_addr       => $mon_addr,
  }

  ##
  # Add osd pools
  ##

  ::ceph::osd::pool{ $pools:
    num_pgs => $pool_pg_num,
    require => Ceph::Mon[$::hostname],
  }

  # Create rgw index pools
  ::ceph::pool{ $rgw_index_pools:
    pg_num => $index_pool_pg_num,
    pgp_num => $index_pool_pg_num,
    size => $pool_size,
    require => Ceph::Mon[$::hostname],
  }

  # Create rgw data pools
  ::ceph::pool{ $rgw_data_pools:
    pg_num => $data_pool_pg_num,
    pgp_num => $data_pool_pg_num,
    size => $pool_size,
    require => Ceph::Mon[$::hostname],
  }

  ##
  # Add ceph mon test code
  ##
  rjil::test { 'check_ceph_mon.sh': }

  #
  # ensure ceph cluster is healthy
  #
  rjil::test { 'ceph_health.py': }


  ##
  # Add consul service, use test script as check_command.
  # Note: This script need root access to be executed.
  ##

  rjil::jiocloud::consul::service { $mon_service_name:
    port          => 6789,
    check_command => '/usr/lib/jiocloud/tests/check_ceph_mon.sh'
  }

}

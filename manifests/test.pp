define rjil::test {

  include rjil::test::base

  file { "/usr/lib/jiocloud/tests/${name}":
    source => "puppet:///modules/rjil/tests/${name}",
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

}

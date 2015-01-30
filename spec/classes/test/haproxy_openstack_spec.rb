require 'spec_helper'

describe 'rjil::test::haproxy_openstack' do

  let :facts do
    {
        :operatingsystem => 'Ubuntu',
        :osfamily        => 'Debian',
        :lsbdistid       => 'ubuntu',
    }
  end 


  let :params do
    {
       'horizon_ips'            => [ '10.1.1.1', '10.1.1.2'],
       'keystone_ips'           => [ '10.1.1.1', '10.1.1.2'],
       'keystone_internal_ips'  => [ '10.1.1.1', '10.1.1.2'],
       'glance_ips'             => [ '10.1.1.1', '10.1.1.2'],
       'cinder_ips'             => [ '10.1.1.1', '10.1.1.2'],
       'nova_ips'               => [ '10.1.1.1', '10.1.1.2'],
    }
  end

  let :hiera_data do
    {
      'openstack_extras::auth_file::admin_password' => 'pass'
    }
  end

  context 'with defaults' do
    it do 
      should contain_class('rjil::test::base')
      should contain_class('keystone::client')
      should contain_class('glance::client')
      should contain_file('/usr/lib/jiocloud/tests/haproxy_openstack.sh') \
        .with_content(/keystone catalog/) \
        .with_owner('root') \
        .with_group('root') \
        .with_mode('0755')
    end

  end
end

require 'spec_helper'
require 'hiera-puppet-helper'

describe 'rjil::jiocloud::consul' do

  let :hiera_data do
    {
      'keystone::admin_token'            => '123',
    }
  end

  describe 'default resources' do
    it 'should require config_hash' do
	  expect {
        should contain_file('keystone-admin')
	  }.to raise_error(Puppet::Error, /Must pass config_hash/)
    end
  end
end

describe 'rjil::jiocloud::consul::bootstrapserver' do
  let :facts  do
    {
      :env             => 'testenv',
      :osfamily        => 'Debian',
      :operatingsystem => 'Ubuntu',
      :architecture    => 'x86_64',
      :lsbdistrelease  => '14.04',
      :consul_discovery_token => 'token'
    }
  end

  describe 'default resources' do
    it 'should configure agent as server that bootstraps' do
      should contain_class('rjil::jiocloud::consul').with({
        'config_hash' => {
          'bind_addr'        => '0.0.0.0',
          'data_dir'         => '/var/lib/consul-jio',
          'log_level'        => 'INFO',
          'server'           => true,
          'bootstrap_expect' => 1,
          'datacenter'       => 'token'
        }
      })
    end
  end
end

describe 'rjil::jiocloud::consul::server' do
  let :facts  do
    {
      :env                    => 'testenv',
	    :osfamily               => 'Debian',
	    :operatingsystem        => 'Ubuntu',
	    :architecture           => 'x86_64',
	    :lsbdistrelease         => '14.04',
	    :consul_discovery_token => 'testtoken'
    }
  end

  describe 'default resources' do
    it 'should configure agent as server' do
      should contain_class('rjil::jiocloud::consul').with({
        'config_hash' => {
          'bind_addr'        => '0.0.0.0',
          'start_join'       => ['testtoken.service.consuldiscovery.linux2go.dk'],
          'data_dir'         => '/var/lib/consul-jio',
          'log_level'        => 'INFO',
          'server'           => true,
          'datacenter'       => 'testtoken'
        }
      })
    end
  end
end

describe 'rjil::jiocloud::consul::agent' do
  let :facts  do
    {
      :env                    => 'testenv',
	    :osfamily               => 'Debian',
	    :operatingsystem        => 'Ubuntu',
	    :architecture           => 'x86_64',
	    :lsbdistrelease         => '14.04',
	    :consul_discovery_token => 'testtoken'
    }
  end

  describe 'default resources' do
    it 'should configure agent as non-server' do
      should contain_class('rjil::jiocloud::consul').with({
        'config_hash' => {
          'bind_addr'        => '0.0.0.0',
          'start_join'       => ['testtoken.service.consuldiscovery.linux2go.dk'],
          'data_dir'         => '/var/lib/consul-jio',
          'log_level'        => 'INFO',
          'server'           => false,
          'datacenter'       => 'testtoken'
        }
      })
    end
  end
end

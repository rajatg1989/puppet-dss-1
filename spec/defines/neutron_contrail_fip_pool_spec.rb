require 'spec_helper'

describe 'rjil::neutron::contrail::fip_pool' do

  let(:facts) {
    {
      :osfamily => 'Debian'
    }
  }
  
  let :default_params do
    {
      :network_name            => 'net',
      :subnet_name             => 'sn',
      :cidr                    => '1.1.1.0/24',
      :keystone_admin_password => 'pass',
    }
  end
  
  let(:title){ 'public' }

  context 'default resources' do
  
    let (:params) { default_params }
    it 'should contain default resources' do
      should contain_neutron_network('net').with({
        'ensure'          => 'present',
        'router_external' => true
      })

      should contain_neutron_subnet('sn').with({
        'ensure'       => 'present',
        'cidr'         => '1.1.1.0/24',
        'network_name' => 'net'
      })

      should contain_contrail_rt('default-domain:services:net:net').with({
        'ensure'             => 'present',
        'rt_number'          => 10000,
        'router_asn'         => 64512,
        'api_server_address' => 'real.neutron.service.consul',
        'admin_password'     => 'pass',
        'require'            => 'Neutron_network[net]',
      })

      should contain_consul_kv('neutron/floatingip_pool/status').with_value('ready').that_requires('Contrail_rt[default-domain:services:net:net]')

    end
  end

  context 'with restricted to specific tenants' do
    let(:params) { default_params.merge(
      {                                  
        :tenants => ['tenant1','tenant2'],
        :public  => false
      }
    )}

    it do
      should contain_neutron_network('net').with({
        'ensure'          => 'present'
      })

      should contain_contrail_fip_pool('public').with({
        :ensure         => 'present',
        :network_fqname => 'default-domain:services:net',
        :tenants        => ['tenant1','tenant2'],
        :require        => 'Neutron_network[net]',
      }) 
    end
  end

  context 'when public cidr has start/end set' do
    let(:params) { default_params.merge(         
      { 
        :subnet_ip_start  => '1.1.1.4',
        :subnet_ip_end    => '1.1.1.14',
      }
    )}

    it do
      should contain_neutron_subnet('sn').with({ 
        'ensure'       => 'present',    
        'cidr'         => '1.1.1.0/24', 
        'network_name' => 'net',
        'allocation_pools' => ['start=1.1.1.4,end=1.1.1.14'],
      })
    end
  end
end

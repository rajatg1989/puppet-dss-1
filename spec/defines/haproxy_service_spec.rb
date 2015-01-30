require 'spec_helper'

describe 'rjil::haproxy_service' do
  let (:facts) { {
    :operatingsystem => 'Ubuntu',
    :osfamily        => 'Debian',
    :lsbdistid       => 'ubuntu',
    :concat_basedir  => '/tmp'
  } }
  let(:title) { 'test_haproxy' }
  context 'with defaults' do
    let (:params) { { :name => 'testname', } }
    it do
      should_not contain_haproxy__listen('testname')
      should_not contain_haproxy__balancermember('testname')
      should_not contain_file('/etc/consul/testname.json')
    end
  end

  context 'with cluster_address, without listen_ports or balancer_ports' do
    let (:params) { {
      :name              => 'testname',
      :cluster_addresses => ['10.1.1.1','10.1.1.2']
    } }
    it do
      expect { should compile }.to raise_error(Puppet::Error,/Either balancer_ports or listen_ports must be provided/)
    end
  end

  context 'with cluster_address, listen_ports' do
    let (:params) { {
      :name              => 'testname',
      :cluster_addresses => ['10.1.1.1','10.1.1.2'],
      :listen_ports      => 100,
    } }

    it do
      should contain_haproxy__listen('testname').with({
        'ipaddress' => '0.0.0.0',
        'ports'     => '100',
        'mode'      => 'tcp',
        'collect_exported' => false,
      })

      should contain_haproxy__balancermember('testname').with({
        'listening_service' => 'testname',
        'ports'             => '100',
        'server_names'      => ['10.1.1.1','10.1.1.2'],
        'ipaddresses'       => ['10.1.1.1','10.1.1.2'],
      })
      should contain_file('/etc/consul/testname.json').with_content(/\"port\": 100/)
   end
  end

  context 'with cluster_address, vip, balancer_ports' do
    let (:params) { {
      :name => 'testname',
      :cluster_addresses => ['10.1.1.1','10.1.1.2'],
      :vip               => '10.1.1.100',
      :balancer_ports    => 90,
    } }
    it do
      should contain_haproxy__listen('testname').with({
        'ipaddress' => '10.1.1.100',
        'ports'     => '90',
        'mode'      => 'tcp',
        'collect_exported' => false,
      })

      should contain_haproxy__balancermember('testname').with({
        'listening_service' => 'testname',
        'ports'             => '90',
        'server_names'      => ['10.1.1.1','10.1.1.2'],
        'ipaddresses'       => ['10.1.1.1','10.1.1.2'],
      })
      should contain_file('/etc/consul/testname.json').with_content(/\"port\": 90/)
    end
  end

  context 'with cluster_address, vip, balancer_ports, listen_ports' do
    let (:params) { {
      :name => 'testname',
      :cluster_addresses => ['10.1.1.1','10.1.1.2'],
      :vip               => '10.1.1.100',
      :balancer_ports    => 90,
      :listen_ports      => 100,
    } }
    it do
      should contain_haproxy__listen('testname').with({
        'ipaddress' => '10.1.1.100',
        'ports'     => '100',
        'mode'      => 'tcp',
        'collect_exported' => false,
      })

      should contain_haproxy__balancermember('testname').with({
        'listening_service' => 'testname',
        'ports'             => '90',
        'server_names'      => ['10.1.1.1','10.1.1.2'],
        'ipaddresses'       => ['10.1.1.1','10.1.1.2'],
      })
      should contain_file('/etc/consul/testname.json').with_content(/\"port\": 100/)
    end
  end
end


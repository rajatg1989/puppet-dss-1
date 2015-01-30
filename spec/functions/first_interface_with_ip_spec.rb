require 'spec_helper'
require 'rspec-puppet'
describe 'first_interface_with_ip' do
  let :facts do
    {
      :operatingsystem  => 'Ubuntu',
      :ipaddress_vhost0 => '10.2.2.2',
      :ipaddress_eth0   => '10.1.1.1',
      :macaddress_vhost0=> '00:00:00:01',
      :macaddress_eth0  => '00:00:00:02',
      :network_vhost0   => '10.2.0.0',
      :network_eth0     => '10.1.0.0',
      :subnet_vhost0    => '255.255.0.0',
      :subnet_eth0      => '255.255.0.0',
    }
  end
  context 'with blank interface_list' do
    it do
      expect do
        should run.with_params('ipaddress','').and_return('10.1.1.1')
      end.to raise_error(ArgumentError, /interfaces cannot be empty/)
    end
  end
  context 'with interface list' do
    it do
      should run.with_params('ipaddress','eth1,vhost0').and_return('10.2.2.2')
      should run.with_params('macaddress','eth0,vhost0').and_return('00:00:00:02')
      should run.with_params('network','eth1,vhost0').and_return('10.2.0.0')
      should run.with_params('subnet','eth0,vhost0').and_return('255.255.0.0')
    end
  end
end

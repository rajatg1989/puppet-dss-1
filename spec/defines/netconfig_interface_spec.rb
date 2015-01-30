require 'spec_helper'

describe 'rjil::netconfig::interface' do

  let(:title){ 'test_interface' }

  context 'with defaults' do
    let :params do
      {
        :interface => 'eth0',
      }
    end

    it 'should configure interface with dhcp' do

      should contain_class('rjil::netconfig')

      should contain_file('/etc/network/interfaces.d/eth0.cfg.staging').with_content( <<-EOF.gsub(/^ {8}/, '')
        ##
        # MANAGED BY PUPPET
        #
        # Interface eth0
        auto eth0
        iface eth0 inet dhcp
        EOF
      ).that_notifies('Exec[network_down]')

      should contain_file('/etc/network/interfaces.d/eth0.cfg').with(
        {
          :ensure  => 'file',
          :source  => '/etc/network/interfaces.d/eth0.cfg.staging',
          :require => 'Exec[network_down]',
          :notify  => 'Exec[network_up]',
        }
      )
    end
  end

  context 'static without ip address' do
    let :params do
      {
        :interface => 'eth0',
        :method    => 'static',
      }
    end

    it 'should fail' do
      expect {
        should compile
      }.to raise_error(Puppet::Error, /ipaddress is required for static method/)
    end

  end

  context 'static without netmask' do

    let :params do
    {
      :interface => 'eth0',
      :method    => 'static',
      :ipaddress => '10.1.1.1',
    }
    end

    it 'should fail' do
      expect {
        should compile
      }.to raise_error(Puppet::Error, /netmask is required for static method/)
    end

  end

  context 'static ' do

    let :params do
      {
        :interface => 'eth0',
        :method    => 'static',
        :ipaddress => '10.1.1.1',
        :netmask   => '255.255.255.0',
        :options   => {
                        'up'   => ['do this','do this too'],
                        'down' => 'do this one'
                      }
      }
    end

    it 'should setup static interface file' do
      should contain_file('/etc/network/interfaces.d/eth0.cfg.staging') \
        .with_content(/address 10.1.1.1/)
        .with_content(/netmask 255.255.255.0/)
        .with_content(/up do this/)
        .with_content(/up do this too/)
        .with_content(/down do this one/)

      should_not contain_file('/etc/network/interfaces.d/eth0.cfg.staging') \
        .with_content(/hwaddress ether/)

      should_not contain_file('/etc/network/interfaces.d/eth0.cfg.staging') \
        .with_content(/dns-nameservers/)

      should_not contain_file('/etc/network/interfaces.d/eth0.cfg.staging') \
        .with_content(/dns-search/)

      should_not contain_file('/etc/network/interfaces.d/eth0.cfg.staging') \
        .with_content(/gateway/)

      should_not contain_file('/etc/network/interfaces.d/eth0.cfg.staging') \
        .with_content(/network/)

    end
  end
end

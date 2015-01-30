require 'spec_helper'

describe 'rjil::jiocloud' do

  let :facts do
    {
      'architecture'    => 'amd64',
      'operatingsystem' => 'Ubuntu',
      'lsbdistrelease'  => '14.04',
      'lsbdistid'       => 'Ubuntu',
      'lsbdistcodename' => 'precise',
      'osfamily'        => 'Debian',
    }
  end

  context 'consul default install' do
    it 'should install consul agent by default' do
      should contain_class('rjil::jiocloud::consul::agent')
    end
  end

  context 'with invalid consul role' do
    let :params do
      {
        'consul_role' => 'blah'
      }
    end
    it 'should fail' do
      expect do
        subject
      end.to raise_error(Puppet::Error, /consul role should be agent\|server\|bootstrapserver, not blah/)
    end
  end

  context 'puppetconf deprecation cleanup' do
    it { should contain_ini_setting('templatedir').with({
      'ensure'  => 'absent',
      'path'    => '/etc/puppet/puppet.conf',
      'section' => 'main',
      'setting' => 'templatedir',
    })}

    it { should contain_ini_setting('modulepath').with({
      'ensure'  => 'absent',
      'path'    => '/etc/puppet/puppet.conf',
      'section' => 'main',
      'setting' => 'modulepath',
    })}
 
    it { should contain_ini_setting('manifestdir').with({
      'ensure'  => 'absent',
      'path'    => '/etc/puppet/puppet.conf',
      'section' => 'main',
      'setting' => 'manifestdir',
    })}
 
  end
end

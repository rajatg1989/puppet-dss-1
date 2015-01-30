require 'spec_helper'
require 'hiera-puppet-helper'

describe 'rjil::ceph' do

  let :hiera_data do
    {
      'rjil::ceph::fsid'                => '94d178a4-cae5-43fa-b420-8ae1cfedb7dc',
      'rjil::ceph::storage_cluster_if'  => 'eth1',
      'rjil::ceph::public_if'           => 'eth0',
    }
  end

  let :facts do
    {
      'lsbdistid'       => 'ubuntu',
      'lsbdistcodename' => 'trusty',
      'osfamily'        => 'Debian',
      'interfaces'      => 'eth0,eth1',
      'network_eth0'    => '10.1.0.0',
      'network_eth1'    => '10.2.0.0',
      'netmask_eth0'    => '255.255.255.0',
      'netmask_eth1'    => '255.255.255.0',
      'concat_basedir'  => '/tmp/'
    }
  end
  context 'default resources' do
    it 'should contain default resources' do
      should contain_file('/etc/ceph')
      should contain_class('ceph::conf').with({
        'fsid'                => '94d178a4-cae5-43fa-b420-8ae1cfedb7dc',
        'auth_type'           => 'cephx',
        'cluster_network'     => '10.2.0.0/24',
        'public_network'      => '10.1.0.0/24',
        'osd_journal_type'    => 'filesystem',
        'require'             => 'File[/etc/ceph]',
      })
    end
  end
end

require 'spec_helper'
require 'hiera-puppet-helper'

describe 'rjil::ceph::osd' do

  let :hiera_data do
    {
      'rjil::ceph::mon::public_if'          => 'eth0',
      'rjil::ceph::mon::storage_cluster_if' => 'eth1',
      'rjil::ceph::mon::key'                => 'AQBXRgNSQNCMAxAA/wSNgHmHwzjnl2Rk22P4jA==',
      'rjil::ceph::osd::osds'               => ['sdb','sdc','sdd'],
      'rjil::ceph::osd::mon_key'            => 'AQBXRgNSQNCMAxAA/wSNgHmHwzjnl2Rk22P4jA==',
      'ceph::conf::fsid'                    => '94d178a4-cae5-43fa-b420-8ae1cfedb7dc',
    }
  end

  let :facts do
    {
      'lsbdistid'       => 'ubuntu',
      'lsbdistcodename' => 'trusty',
      'osfamily'        => 'Debian',
      'interfaces'      => 'eth0,eth1',
      'ipaddress_eth0'  => '10.1.0.2',
      'ipaddress_eth1'  => '10.2.0.2',
      'concat_basedir'  => '/tmp/',
      'hostname'        => 'host1',
      'blankorcephdisks' => 'sdh,sdi,sdx',
      'processorcount'  => '4',
    }
  end
  context 'with default resources' do
    it 'should contain default resources' do
      should contain_sysctl__value('vm.dirty_background_ratio').with_value(5)
      should contain_exec('cleanup_caches')
      should contain_class('ceph::osd').with({
        'public_address'  => '10.1.0.2',
        'cluster_address' => '10.2.0.2'
      })
      should contain_ceph__osd__device('/dev/sdb','/dev/sdc','/dev/sdd').with({
        'osd_journal_type'  => 'filesystem',
        'osd_journal_size'  => 10,
        'autogenerate'      => false,
      })
      should contain_ceph__key('admin')
    end
  end

  context 'with autodetect' do
    let (:params) { {'autodetect' => true } }
    it  do
      should contain_ceph__osd__device('/dev/sdh','/dev/sdi','/dev/sdx').with({
        'osd_journal_type'  => 'filesystem',
        'osd_journal_size'  => 10,
        'autogenerate'      => false,
      })
    end
  end

  context 'with autodetect and exception' do
    let (:params) { {'autodetect' => true, 'disk_exceptions' => ['sdx'] } }
    it  do
      should contain_ceph__osd__device('/dev/sdh','/dev/sdi').with({
        'osd_journal_type'  => 'filesystem',
        'osd_journal_size'  => 10,
        'autogenerate'      => false,
      })
    end
  end

  context 'with autogenerate' do
    let (:params) { {'autogenerate' => true, 'autodisk_size' => 40 } }
    it  do
      should contain_exec('make_disk_file').with_command(/dd if=\/dev\/zero of=\/var\/lib\/ceph\/disk-1 bs=4k[ \n]*count=10000000/)
      should contain_exec('attach_loop').with({
      'command' => 'losetup /dev/loop0 /var/lib/ceph/disk-1',
      'unless'  => 'losetup /dev/loop0',
      'require' => 'Exec[make_disk_file]',
      })

      should contain_ceph__osd__device('/dev/loop0').with({
        'osd_journal_type'  => 'filesystem',
        'osd_journal_size'  => 10,
        'autogenerate'      => true,
      })
    end
  end
  context 'with autodisk_size less than 10GB' do
    let (:params) { {'autogenerate' => true, 'autodisk_size' => 5 } }
    it do
     expect { should compile }.to raise_error(Puppet::Error,/Autodisk size must be at least 10GB/)
    end
  end
end

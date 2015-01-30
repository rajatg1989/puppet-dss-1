require 'spec_helper'
require 'hiera-puppet-helper'

describe 'rjil::system' do

  let :facts do
    {
      'lsbdistid'       => 'ubuntu',
      'lsbdistcodename' => 'trusty',
      'osfamily'        => 'Debian',
      'interfaces'      => 'eth0',
      'fqdn'            => 'node.local',
    }
  end

  let :hiera_data do
    {
      'rjil::system::accounts::local_users' =>
        {
          'u1' => {'realname' => 'u1', 'sshkeys' => 'ssh-dsskey'},
          'u2' => {'realname' => 'u2', 'sshkeys' => 'ssh-dsskey'},
          'u3' => {'realname' => 'u3', 'sshkeys' => 'ssh-dsskey'},
        },
      'rjil::system::accounts::active_users' => ['u2','u3'],
      'rjil::system::accounts::sudo_users' => {'admin' =>
                                                {
                                                  'users' => ['u3'],
                                                }
                                              },
      'ntp::servers' => ['server1']
    }
  end
  context 'with defaults' do
    it  do
      should contain_file('/etc/issue')
      should contain_file('/etc/issue.net')
      should contain_file('/usr/lib/jiocloud/tests/check_timezone.sh')
      should contain_file('/etc/bash_completion.d/host_complete')
      should contain_file('/etc/securetty').with_mode('0600')
      should contain_class('timezone')
      should contain_class('rjil::system::ntp')
      should contain_class('rjil::system::apt')
      should contain_class('rjil::system::accounts')
      should contain_package('molly-guard')
      should contain_package('tmpreaper')

      should contain_file_line('domain_search') \
        .with_path('/etc/resolvconf/resolv.conf.d/base') \
        .with_line('search node.consul service.consul') \
        .with_match('search .*') 

      should create_exec('resolvconf') \
        .with_subscribe('File_line[domain_search]') \
        .with_refreshonly(true) \
        .with_command('resolvconf -u')

      should contain_sysctl__value('net.ipv4.conf.all.accept_redirects').with_value(0)
      should contain_sysctl__value('net.ipv4.conf.default.accept_redirects').with_value(0)
      should contain_sysctl__value('net.ipv4.conf.all.secure_redirects').with_value(0)
      should contain_sysctl__value('net.ipv4.conf.default.secure_redirects').with_value(0)
      should contain_sysctl__value('net.ipv4.conf.default.accept_source_route').with_value(0)
      should contain_sysctl__value('net.ipv4.conf.all.send_redirects').with_value(0)
      should contain_sysctl__value('net.ipv4.conf.default.send_redirects').with_value(0)

      should contain_cron('purge_puppet_reports').with(
        {
          :command => 'tmpreaper -a  24h /var/lib/puppet/reports/node.local',
          :user    => 'root',
          :hour    => 2,
          :minute  => 0,
        }
      )
    end
  end
end

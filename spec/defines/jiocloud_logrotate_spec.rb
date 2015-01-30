require 'spec_helper'

describe 'rjil::jiocloud::logrotate' do
  let :title do
    'name'
  end
  context 'with defaults' do
    it { should contain_logrotate__rule('name').with({
      'path'          => '/var/log/name.log',
      'rotate'        => 60,
      'rotate_every'  => 'daily',
      'compress'      => true,
      'delaycompress' => true,
      'ifempty'       => false
    })}
  end
  context 'with overridden path' do
    let :params do
      {
        'logdir' => '/var/log/foo'
      }
    end
    it {should contain_logrotate__rule('name').with({
      'path'          => '/var/log/foo/name.log',
    })}
  end
  context 'with overridden path with trailing slash' do
    let :params do
      {
        'logdir' => '/var/log/foo/'
      }
    end
    it {should contain_logrotate__rule('name').with({
      'path'          => '/var/log/foo/name.log',
    })}
  end
  context 'with overridden logfile' do
    let :params do
      {
        'logfile' => '/var/log/foo/file.log'
      }
    end
    it {should contain_logrotate__rule('name').with({
      'path'          => '/var/log/foo/file.log',
    })}
  end
end

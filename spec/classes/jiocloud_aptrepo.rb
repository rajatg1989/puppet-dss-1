require 'spec_helper'

describe 'rjil::jiocloud::aptrepo' do

  let :facts do
    {
      :osfamily               => 'Debian',
      :operatingsystemrelease => '6',
      :concat_basedir         => '/dne',
    }
  end
  context 'with defaults' do
    it 'should set default resources' do
      ['/srv', '/srv/www', '/srv/www/apt'].each do |x|
        should contain_file(x).with({
          'ensure' => 'directory',
          'owner'  => 'root',
          'group'  => 'root',
          'mode'   => '0755',
        })
      end
      ['reprepro', 'apache'].each do |k|
        should contain_class(k)
      end
      should contain_apache__vhost('apt.internal.jiocloud.com').with({
        'port'    => '80',
        'docroot' => '/srv/www/apt',
      })
    end
  end
  context 'with repos' do
    let :params do
      {
        'repositories'  => {'foo' => {}, 'bar' => {}},
        'distributions' => {'1' => {'repository' => 'foo', 'origin' => '1', 'label' => 'label', 'suite' => 'suite', 'description' => 'desc'},
                            '2' => {'repository' => 'bar', 'origin' => '1', 'label' => 'label', 'suite' => 'suite', 'description' => 'desc'}},
      }
    end
    it 'should generate resources from data' do
      ['foo', 'bar'].each do |repo|
        should contain_rjil__jiocloud__aptrepo__publish(repo).with({
          'basedir' => '/var/lib/reprepro'
        })
        should contain_reprepro__repository(repo).with({
          'basedir' => '/var/lib/reprepro'
        })
      end
      should contain_reprepro__distribution('1').with({
        'repository' => 'foo',
        'origin' => '1',
        'label' => 'label',
        'suite' => 'suite',
        'description' => 'desc',
        'basedir' => '/var/lib/reprepro',
        'architectures' => 'amd64 i386',
        'components'    => 'main',
        'not_automatic' => 'No'
      })
      should contain_reprepro__distribution('2').with({
        'repository' => 'bar',
        'origin' => '1',
        'label' => 'label',
        'suite' => 'suite',
        'description' => 'desc',
        'basedir' => '/var/lib/reprepro',
        'architectures' => 'amd64 i386',
        'components'    => 'main',
        'not_automatic' => 'No'
      })
    end
  end
end

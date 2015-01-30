require 'spec_helper'

describe 'rjil::system::apt' do

  let :facts do
    {
      'lsbdistid'       => 'ubuntu',
      'lsbdistcodename' => 'trusty',
      'osfamily'        => 'Debian',
    }
  end

  it { should contain_class('apt') }

  it 'should contain all repos' do
    should contain_apt__source('puppetlabs').with(
      'location' => 'http://apt.puppetlabs.com',
      'repos'    => 'main',
      'key'      => '4BD6EC30'
    )
  end

  it 'should not configure a proxy' do
    should contain_file('/etc/apt/apt.conf.d/90proxy').with({
      'ensure' => 'absent'
    })
  end

  describe 'with proxy set' do
    let :params do
      {
        'proxy' => 'http://1.2.3.4:5678/'
      }
    end
    it { should contain_file('/etc/apt/apt.conf.d/90proxy').with({ 'content' => 'Acquire::Http::Proxy "http://1.2.3.4:5678/";' }) }
  end

  describe "with enable_puppetlabs set to false" do
    let :params do
      {
        'enable_puppetlabs' => false
      }
    end
    it { should_not contain_apt__source('puppetlabs') }
  end

  describe 'with override repo' do
    let :params do
      {
        'override_repo' => 'http://foo/tar.tgz'
      }
    end
    it 'should contain override resources' do
      ['/var/lib/jiocloud', '/var/lib/jiocloud/overrides'].each do |x|
        should contain_file(x).with_ensure('directory')
      end
      should contain_archive('/var/lib/jiocloud/overrides/repo.tgz').with({
        'source'       => 'http://foo/tar.tgz',
        'extract'      => true,
        'extract_path' => '/var/lib/jiocloud/overrides',
        'creates'      => '/var/lib/jiocloud/overrides/Packages',
        'before'       => 'Apt::Source[overrides]',
      })
      should contain_apt__source('overrides').with({
        'location'    => 'file:/var/lib/jiocloud/overrides',
        'release'     => './',
        'repos'       => '',
        'include_src' => false,
      })
    end
  end

end

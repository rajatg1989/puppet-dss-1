require 'spec_helper'

describe 'rjil::jiocloud::aptrepo::publish' do
  let :params do
    {
      'basedir' => '/tmp'
    }
  end
  let :title do
    'name'
  end
  it 'should create default resources' do
    should contain_file('/srv/www/apt/name').with({
      'ensure' => 'directory',
      'owner'  => 'root',
      'group'  => 'root',
      'mode'   => '0755',
    })
    should contain_file('/srv/www/apt/name/dists').with({
      'ensure' => 'link',
      'target' => '/tmp/name/dists'
    })
    should contain_file('/srv/www/apt/name/pool').with({
      'ensure' => 'link',
      'target' => '/tmp/name/pool'
    })
  end
end

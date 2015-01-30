require 'spec_helper'

describe 'rjil::jiocloud::consul::service' do

  let :title do
    'foo'
  end

  describe 'with defaults' do
    it 'should contain defaults' do
      should contain_file('/etc/consul').with_ensure('directory')
      should contain_file('/etc/consul/foo.json').with({
        'ensure'  => 'present',
        'content' =>
'{
  "service": {
    "name": "foo",
    "port": 0,
    "tags": [

    ],
    "check": {
      "script": "/usr/lib/jiocloud/tests/service_checks/foo.sh",
      "interval": "10s"
    }
  }
}
'
      })
    end
  end
  describe 'when setting ttl' do
    it { should contain_file('/etc/consul/foo.json').with({
        'ensure'  => 'present',
        'content' =>
'{
  "service": {
    "name": "foo",
    "port": 0,
    "tags": [

    ],
    "check": {
      "script": "/usr/lib/jiocloud/tests/service_checks/foo.sh",
      "interval": "10s"
    }
  }
}
'
    })}

  end

end

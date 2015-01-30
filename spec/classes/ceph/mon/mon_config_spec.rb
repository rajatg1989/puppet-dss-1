require 'spec_helper'

describe 'rjil::ceph::mon::mon_config' do
  let(:facts) {
    {
      :osfamily       => 'Debian',
      :hostname       => 'host1',
      :ipaddress_eth0 => '1.1.1.1',
      :concat_basedir  => '/tmp',
    }
  }

  context 'default resources' do
    let(:params) { { :mon_service_name => 'google-public-dns-a.google.com' } }
    it 'should contain default resources' do
      should contain_ceph__conf__mon_config('host1').with({
        'mon_addr' => '1.1.1.1'
      })
      should contain_ceph__conf__mon_config('8.8.8.8')
    end
  end
end

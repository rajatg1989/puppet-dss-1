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

  let(:params) { { :mon_service_name => 'google-public-dns-a.google.com' } }

  context 'default resources' do
    it 'should contain default resources' do
      should contain_ceph__conf__mon_config('8.8.8.8')
    end
  end
end

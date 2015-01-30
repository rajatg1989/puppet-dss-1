require 'spec_helper'

describe 'rjil::test::ceph_radosgw' do
  let :params do
    {
      'port'      => 6000,
      'ssl'       => false,
    }
  end

  let :hiera_data do
    {
    }
  end

  context 'with defaults' do
    it do 
      should contain_package('python-swiftclient')
    end

    it do
      should contain_file('/usr/lib/jiocloud/tests/ceph_radosgw.sh') \
        .with_content(/swift upload/) \
        .with_owner('root') \
        .with_group('root') \
        .with_mode('0755')
    end
  end

end

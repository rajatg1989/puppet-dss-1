require 'spec_helper'

describe 'rjil::test::glance' do
  let :params do
    {
      'api_address'      => '127.0.0.1',
      'registry_address' => '127.0.0.1',
      'ssl'              => false,
    }
  end

  let :hiera_data do
    {
      'openstack_extras::auth_file::admin_password' => 'pass'
    }
  end

  context 'with defaults' do
    it do
      should contain_class('rjil::test::base')
    end

    it do
      should contain_file('/usr/lib/jiocloud/tests/glance.sh') \
        .with_content(/glance image-list/) \
        .with_owner('root') \
        .with_group('root') \
        .with_mode('0755')
    end

    it do
      should contain_file('/usr/lib/jiocloud/tests/glance-api.sh') \
        .with_ensure('absent')
    end

  end
end

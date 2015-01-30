require 'spec_helper'

describe 'rjil::test::compute::rbd' do
  context "with defaults" do
    let :params do
      {
        :cinder_rbd_secret_uuid => 'secret'
      }
    end
    it do
      should contain_file('/usr/lib/jiocloud/tests/cinder-secret.sh') \
        .with_content(/virsh -q secret-get-value/)
        .with_owner('root') \
        .with_group('root') \
        .with_mode('0755')
    end
  end
end

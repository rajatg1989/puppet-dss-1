require 'spec_helper'

describe 'rjil::test::cinder' do

  describe 'default resources' do
    
    let :hiera_data do
      {
        'openstack_extras::auth_file::admin_password' => 'pass'
      }
    end

    it 'should contain default resources' do
      should contain_class('rjil::test::base')
      should contain_file('/usr/lib/jiocloud/tests/cinder-api.sh') \
        .with_source('puppet:///modules/rjil/tests/cinder-api.sh') \
        .with_owner('root') \
        .with_group('root') \
        .with_mode('0755')

      should contain_file('/usr/lib/jiocloud/tests/cinder-scheduler.sh') \
        .with_source('puppet:///modules/rjil/tests/cinder-scheduler.sh') \
        .with_owner('root') \
        .with_group('root') \
        .with_mode('0755')

      should contain_file('/usr/lib/jiocloud/tests/cinder-volume.sh') \
        .with_source('puppet:///modules/rjil/tests/cinder-volume.sh') \
        .with_owner('root') \
        .with_group('root') \
        .with_mode('0755')

      should contain_file('/usr/lib/jiocloud/tests/cinder-backup.sh') \
        .with_source('puppet:///modules/rjil/tests/cinder-backup.sh') \
        .with_owner('root') \
        .with_group('root') \
        .with_mode('0755')
    end
  end
end

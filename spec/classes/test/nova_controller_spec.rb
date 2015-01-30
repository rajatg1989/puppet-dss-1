require 'spec_helper'

describe 'rjil::test::nova_controller' do

  let :hiera_data do
    {
      'openstack_extras::auth_file::admin_password' => 'pass'
    }   
  end 

  context "default" do
    it do
      should contain_rjil__test('nova-api.sh')
      should contain_rjil__test('nova-scheduler.sh')
      should contain_rjil__test('nova-conductor.sh')
      should contain_rjil__test('nova-cert.sh')
      should contain_rjil__test('nova-vncproxy.sh')
      should contain_rjil__test('nova-consoleauth.sh')
    end
  end
end

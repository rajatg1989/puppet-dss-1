require 'spec_helper'

describe 'rjil::test::contrail_vrouter' do
  
  context 'when configured by default' do
    let :params do
      {
        'vrouter_interface' => 'vhost0',
        'vgw_interface'     => 'vgw1',
        'vgw_enabled'       => false,
      }
    end
    it do
      should contain_file('/usr/lib/jiocloud/tests/contrail_vrouter.sh') \
        .with_content(/curl http:\/\/localhost:8085 | grep agent.xml/) \
        .with_owner('root') \
        .with_group('root') \
        .with_mode('0755')
    end
  end

  context 'with virtual gw enabled' do
    let :params do 
      { 
        'vgw_enabled' => true
      }
    end
    it do
      should contain_file('/usr/lib/jiocloud/tests/contrail_vgw.sh') \
        .with_content(/curl http:\/\/localhost:8085\/Snh_Inet4UcRouteReq/) \
        .with_owner('root') \
        .with_group('root') \
        .with_mode('0755')
    end
  end
end



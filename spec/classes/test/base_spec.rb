require 'spec_helper'

describe 'rjil::test::base' do

  describe 'default resources' do
    it 'should contain default resources' do
      should contain_file('/usr/lib/jiocloud').with_ensure('directory')
      should contain_file('/usr/lib/jiocloud/tests').with_ensure('directory')
      should contain_file('/usr/lib/nagios/plugins/check_killall_0').with(
        {
          'source'  => 'puppet:///modules/rjil/tests/nagios_killall_0',
          'mode'    => '0755',
          'require' => 'Package[nagios-plugins]',
        }
      )
      should contain_package('nagios-plugins')
    end
  end
end

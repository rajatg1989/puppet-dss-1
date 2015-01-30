require 'spec_helper'

describe 'rjil::jiocloud::consul::base_checks' do

  it 'should configure base checks' do
    should contain_rjil__jiocloud__consul__service('puppet').with({
      'check_command' => false,
      'ttl'           => '1440m'
    })
    should contain_rjil__jiocloud__consul__service('validation').with({
      'check_command' => false,
      'ttl'           => '60m'
    })
  end
end

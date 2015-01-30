require 'spec_helper'

describe 'rjil::test::compute' do
  context "Rjil Compute tests" do
    it do
      should contain_rjil__test('nova-compute.sh')
    end
  end
end

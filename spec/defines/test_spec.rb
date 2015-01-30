require 'spec_helper'

describe 'rjil::test' do
  let :facts do
    {
      :operatingsystem => 'Ubuntu',
      :osfamily        => 'Debian',
      :lsbdistid       => 'ubuntu',
    }
  end


  let (:title)  { 'foo' }

  context 'with defaults' do
    let :params do
      {
        :name =>  'foo'
      }
    end

    it do
      should contain_file('/usr/lib/jiocloud/tests/foo') \
        .with_source('puppet:///modules/rjil/tests/foo') \
        .with_owner('root') \
        .with_group('root') \
        .with_mode('0755')
    end
  end
end


require 'spec_helper'

describe 'rjil::test::check' do

  let :facts do
    {
      :operatingsystem  => 'Ubuntu',
      :osfamily         => 'Debian',
      :lsbdistid        => 'ubuntu',
    }
  end

  let(:title) { 'fooservice' }

  context 'with http running on 8080' do
    let :params do
      { 
        :name    => 'fooservice',
        :port    => 8080,
        :address => '127.0.0.1',
        :ssl     => false,
        :type    => 'http',
      }
    end
 
    it do
      should contain_class('rjil::test::base')
      should contain_file('/usr/lib/jiocloud/tests/service_checks/fooservice.sh') \
        .with_content(/check_http -H 127.0.0.1 -p 8080/) \
        .with_owner('root') \
        .with_group('root') \
        .with_mode('0755')
    end
  end

end

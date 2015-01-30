require 'spec_helper'

describe 'rjil::service_blocker' do
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
          :name       => 'foo',
          :tries      => 30,
          :try_sleep  => 20,
          :datacenter => 'bar',
        }
      end

      it do
        should contain_Dns_blocker('foo.service.bar.consul') \
          .with_try_sleep('20') \
          .with_tries('30')
      end

    end
end

